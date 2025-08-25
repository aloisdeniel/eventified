import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:eventified/eventified.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart' as gen;

class EventifiedGenerator extends gen.GeneratorForAnnotation<Eventified> {
  static const packageName = 'eventified';

  static const gen.TypeChecker eventifiedAnnotiationType =
      gen.TypeChecker.typeNamed(
    Eventified,
    inPackage: packageName,
  );

  static const gen.TypeChecker eventAnnotationType = gen.TypeChecker.typeNamed(
    Event,
    inPackage: packageName,
  );

  static const gen.TypeChecker eventArgumentAnnotationType =
      gen.TypeChecker.typeNamed(
    EventArgument,
    inPackage: packageName,
  );

  @override
  dynamic generateForAnnotatedElement(
    Element element,
    gen.ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is ClassElement) {
      final withInvoker = annotation.read('invoker').boolValue;
      final withMetadata = annotation.read('metadata').boolValue;

      final result = LibraryBuilder();
      final baseEvent = generateBaseEvent(element, withMetadata);
      final eventClasses = <Class>[];
      for (final method in element.methods.where((m) => m.isPublic)) {
        if (method.returnType is! VoidType) {
          throw Exception('Functions must have a return type of void');
        }
        eventClasses.add(generateEvent(baseEvent, method, withMetadata));
      }

      result.body.add(baseEvent.build());
      result.body.addAll(eventClasses);
      result.body.add(generateStreamedImpl(baseEvent, element));
      if (withInvoker) {
        result.body.add(generateInvokeExtension(baseEvent, element));
      }

      final emitter = DartEmitter();
      var code = '${result.build().accept(emitter)}'.replaceAll(
        RegExp(r'(?!late )final EventMetadata \$metadata'),
        'late final EventMetadata \$metadata',
      );

      return code;
    }
  }

  ClassBuilder generateBaseEvent(ClassElement element, bool withMetadata) {
    final name = () {
      final annotation = eventifiedAnnotiationType.firstAnnotationOf(element);
      if (annotation != null) {
        final customName = annotation.getField('baseEvent')?.toStringValue();
        if (customName != null) return customName;
      }
      return '${element.name!}Event';
    }();

    final result = ClassBuilder()
      ..name = name
      ..sealed = true;

    result.constructors.add(Constructor((b) => b..constant = true));

    if (withMetadata) {
      result.methods.add(
        Method(
          (b) => b
            ..name = '\$metadata'
            ..type = MethodType.getter
            ..returns = refer('EventMetadata'),
        ),
      );
    }

    return result;
  }

  String createEventName(ClassBuilder baseEvent, MethodElement method) {
    final annotation = eventAnnotationType.firstAnnotationOf(method);
    if (annotation != null) {
      final customName = annotation.getField('name')?.toStringValue();
      if (customName != null) return customName;
    }

    final name = method.name!;
    final suffix = baseEvent.name!;

    return ReCase(name).pascalCase + suffix;
  }

  Class generateEvent(
      ClassBuilder baseEvent, MethodElement method, bool withMetadata) {
    final name = method.name;
    final suffix = baseEvent.name!;
    final result = ClassBuilder()
      ..name = createEventName(baseEvent, method)
      ..extend = refer(suffix);

    final constructor = ConstructorBuilder()..constant = !withMetadata;

    final baseFactory = ConstructorBuilder()
      ..name = name
      ..redirect = refer(result.name!)
      ..factory = true;

    for (var parameter in method.formalParameters) {
      result.fields.add(
        Field(
          (b) => b
            ..name = parameter.name
            ..type = refer(parameter.type.getDisplayString(withNullability: true))
            ..modifier = FieldModifier.final$,
        ),
      );
      if (parameter.isNamed) {
        baseFactory.optionalParameters.add(
          Parameter(
            (b) => b
              ..name = parameter.name!
              ..named = parameter.isNamed
              ..required = parameter.isRequired
              ..type = refer(parameter.type.getDisplayString(withNullability: true)),
          ),
        );
        constructor.optionalParameters.add(Parameter(
          (b) => b
            ..name = parameter.name!
            ..named = parameter.isNamed
            ..required = parameter.isRequired
            ..defaultTo = parameter.hasDefaultValue
                ? Code(parameter.defaultValueCode ?? '')
                : null
            ..toThis = true,
        ));
      } else if (parameter.isOptional) {
        baseFactory.optionalParameters.add(
          Parameter(
            (b) => b
              ..name = parameter.name!
              ..type = refer(parameter.type.getDisplayString(withNullability: true)),
          ),
        );
        constructor.optionalParameters.add(Parameter(
          (b) => b
            ..name = parameter.name!
            ..defaultTo = parameter.hasDefaultValue
                ? Code(parameter.defaultValueCode ?? '')
                : null
            ..toThis = true,
        ));
      } else {
        baseFactory.requiredParameters.add(
          Parameter(
            (b) => b
              ..name = parameter.name!
              ..type = refer(parameter.type.getDisplayString(withNullability: true)),
          ),
        );
        constructor.requiredParameters.add(Parameter(
          (b) => b
            ..name = parameter.name!
            ..defaultTo = parameter.hasDefaultValue
                ? Code(parameter.defaultValueCode ?? '')
                : null
            ..toThis = true,
        ));
      }
    }

    // Metadata
    if (withMetadata) {
      final metadataArguments = StringBuffer('{');

      for (var parameter in method.formalParameters) {
        final metadataName = () {
          final annotation =
              eventArgumentAnnotationType.firstAnnotationOf(parameter);
          if (annotation != null) {
            return annotation.getField('metadata')?.toStringValue() ?? name;
          }
          return parameter.name;
        }();
        if (parameter.type.nullabilitySuffix == NullabilitySuffix.question) {
          metadataArguments.write('if(${parameter.name} != null)');
        }

        metadataArguments.write('\'$metadataName\' : ${parameter.name} ,');
      }

      metadataArguments.write('}');

      final metadataName = () {
        final annotation = eventAnnotationType.firstAnnotationOf(method);
        if (annotation != null) {
          return annotation.getField('metadata')?.toStringValue() ?? name;
        }
        return name;
      }();

      result.fields.add(
        Field(
          (b) => b
            ..annotations.add(const CodeExpression(Code("override")))
            ..name = '\$metadata'
            ..modifier = FieldModifier.final$
            ..type = refer('EventMetadata')
            ..assignment =
                Code('EventMetadata(\'$metadataName\', $metadataArguments)')
            ..late = true
          ,
        ),
      );
    }

    // toString
    final toStringBody = StringBuffer();
    toStringBody.write("'''");
    toStringBody.write(result.name!);
    toStringBody.writeln('(');
    for (var field in result.fields.build()) {
      if (field.name != '\$metadata') {
        toStringBody.write('  ');
        toStringBody.write(field.name);
        toStringBody.write(' : \$');
        toStringBody.write(field.name);
        toStringBody.writeln(',');
      }
    }
    toStringBody.write(')');
    toStringBody.write("'''");

    result.methods.add(
      Method(
        (b) => b
          ..annotations.add(const CodeExpression(Code("override")))
          ..name = 'toString'
          ..returns = refer('String')
          ..lambda = true
          ..body = Code(toStringBody.toString()),
      ),
    );

    baseEvent.constructors.add(baseFactory.build());
    result.constructors.add(constructor.build());
    return result.build();
  }

  Class generateStreamedImpl(ClassBuilder baseEvent, ClassElement element) {
    final result = ClassBuilder()
      ..name = 'Streamed${element.name}'
      ..implements.add(refer(element.name!));

    for (final method in element.methods.where((m) => m.isPublic)) {
      final impl = MethodBuilder()
        ..name = method.name
        ..annotations.add(const CodeExpression(Code("override")))
        ..lambda = true
        ..returns = refer(
          method.returnType.getDisplayString(withNullability: true),
        );

      final body = StringBuffer();

      body.write('_stream.add(');
      body.write(createEventName(baseEvent, method));
      body.write('(');

      for (var parameter in method.formalParameters) {
        final name = parameter.name!;
        if (parameter.isNamed) {
          body.write('$name : $name,');
          impl.optionalParameters.add(
            Parameter(
              (b) => b
                ..name = name
                ..named = parameter.isNamed
                ..required = parameter.isRequired
                ..defaultTo = parameter.hasDefaultValue
                    ? Code(parameter.defaultValueCode ?? '')
                    : null
                ..type = refer(parameter.type.getDisplayString(withNullability: true)),
            ),
          );
        } else if (parameter.isOptional) {
          body.write('$name,');
          impl.optionalParameters.add(
            Parameter(
              (b) => b
                ..name = name
                ..defaultTo = parameter.hasDefaultValue
                    ? Code(parameter.defaultValueCode ?? '')
                    : null
                ..type = refer(parameter.type.getDisplayString(withNullability: true)),
            ),
          );
        } else {
          body.write('$name,');
          impl.requiredParameters.add(
            Parameter(
              (b) => b
                ..name = name
                ..type = refer(parameter.type.getDisplayString(withNullability: true)),
            ),
          );
        }
      }
      body.write('),)');
      impl.body = Code(body.toString());
      result.methods.add(impl.build());
    }

    result.fields.add(
      Field(
        (b) => b
          ..name = '_stream'
          ..type = refer('StreamController<${baseEvent.name}>')
          ..modifier = FieldModifier.final$
          ..assignment =
              Code('StreamController<${baseEvent.name}>.broadcast()'),
      ),
    );

    result.methods.add(
      Method(
        (b) => b
          ..name = 'stream'
          ..returns = refer('Stream<${baseEvent.name}>')
          ..type = MethodType.getter
          ..lambda = true
          ..body = Code('_stream.stream'),
      ),
    );

    result.methods.add(
      Method(
        (b) => b
          ..name = 'dispose'
          ..returns = refer('void')
          ..lambda = true
          ..body = Code('_stream.close()'),
      ),
    );

    return result.build();
  }

  Extension generateInvokeExtension(
      ClassBuilder baseEvent, ClassElement element) {
    final result = ExtensionBuilder()
      ..name = '${element.name}InvokeExtension'
      ..on = refer(element.name!);

    final body = StringBuffer();

    for (final method in element.methods.where((m) => m.isPublic)) {
      body.write('if(event is ');
      body.write(createEventName(baseEvent, method));
      body.write(') {');
      body.write('return ');
      body.write(method.name);
      body.write('(');

      for (var parameter in method.formalParameters) {
        if (parameter.isNamed) {
          final name = parameter.name!;
          body.write('$name : event.$name,');
        } else {
          body.write('event.${parameter.name},');
        }
      }
      body.write(');');
      body.write('}');
    }
    body.write('throw Exception(\'Unsupported event\');');

    result.methods.add(
      Method(
        (b) => b
          ..name = 'invoke'
          ..returns = refer('void')
          ..body = Code(body.toString())
          ..requiredParameters.add(
            Parameter(
              (b) => b
                ..name = 'event'
                ..type = refer(baseEvent.name!),
            ),
          ),
      ),
    );

    return result.build();
  }
}
