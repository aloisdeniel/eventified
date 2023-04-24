import 'dart:async';

import 'package:eventified/eventified.dart';

part 'example.g.dart';

void main(List<String> args) {
  final streamed = StreamedExample();

  streamed.stream.listen((event) {
    print(
        '${event.$metadata.name} : ${event.$metadata.arguments.entries.join(', ')}');
  });

  streamed
    ..hello(world: false, name: 'Jeff')
    ..world('john');
}

@eventified
abstract class Example {
  @Event('Hello')
  void hello({
    required bool world,
    @EventArgument('Name') String? name,
  });

  void world(String name);
}

@Eventified(invoker: false)
abstract class ExampleNoInvoker {
  @Event('Hello')
  void hello({
    required bool world,
    @EventArgument('Name') String? name,
  });

  void world(String name);
}

@Eventified(invoker: false, metadata: false)
abstract class ExampleNoMetadata {
  void hello({
    required bool world,
    String? name,
  });

  void world(String name);
}
