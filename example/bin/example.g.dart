// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// EventifiedGenerator
// **************************************************************************

sealed class ExampleEvent {
  const ExampleEvent();

  factory ExampleEvent.hello({
    required bool world,
    String? name,
    int withDefault,
  }) = HelloExampleEvent;

  factory ExampleEvent.world(String name) = WorldExampleEvent;
}

class HelloExampleEvent extends ExampleEvent {
  const HelloExampleEvent({
    required this.world,
    this.name,
    this.withDefault = 42,
  });

  final bool world;

  final String? name;

  final int withDefault;

  @override
  String toString() => '''HelloExampleEvent(
  world : $world,
  name : $name,
  withDefault : $withDefault,
)''';
}

class WorldExampleEvent extends ExampleEvent {
  const WorldExampleEvent(this.name);

  final String name;

  @override
  String toString() => '''WorldExampleEvent(
  name : $name,
)''';
}

class StreamedExample implements Example {
  final StreamController<ExampleEvent> _stream =
      StreamController<ExampleEvent>.broadcast();

  @override
  void hello({
    required bool world,
    String? name,
    int withDefault = 42,
  }) =>
      _stream.add(
        HelloExampleEvent(
          world: world,
          name: name,
          withDefault: withDefault,
        ),
      );

  @override
  void world(String name) => _stream.add(
        WorldExampleEvent(
          name,
        ),
      );

  Stream<ExampleEvent> get stream => _stream.stream;

  void dispose() => _stream.close();
}

extension ExampleInvokeExtension on Example {
  void invoke(ExampleEvent event) {
    if (event is HelloExampleEvent) {
      return hello(
        world: event.world,
        name: event.name,
        withDefault: event.withDefault,
      );
    }
    if (event is WorldExampleEvent) {
      return world(
        event.name,
      );
    }
    throw Exception('Unsupported event');
  }
}

sealed class ExampleWithMetadataEvent {
  const ExampleWithMetadataEvent();

  factory ExampleWithMetadataEvent.hello({
    required bool world,
    String? name,
  }) = HelloExampleWithMetadataEvent;

  factory ExampleWithMetadataEvent.world(String name) =
      WorldExampleWithMetadataEvent;

  EventMetadata get $metadata;
}

class HelloExampleWithMetadataEvent extends ExampleWithMetadataEvent {
  HelloExampleWithMetadataEvent({
    required this.world,
    this.name,
  });

  final bool world;

  final String? name;

  @override
  late final EventMetadata $metadata = EventMetadata('hello', {
    'world': world,
    if (name != null) 'name': name,
  });

  @override
  String toString() => '''HelloExampleWithMetadataEvent(
  world : $world,
  name : $name,
)''';
}

class WorldExampleWithMetadataEvent extends ExampleWithMetadataEvent {
  WorldExampleWithMetadataEvent(this.name);

  final String name;

  @override
  late final EventMetadata $metadata = EventMetadata('world', {
    'name': name,
  });

  @override
  String toString() => '''WorldExampleWithMetadataEvent(
  name : $name,
)''';
}

class StreamedExampleWithMetadata implements ExampleWithMetadata {
  final StreamController<ExampleWithMetadataEvent> _stream =
      StreamController<ExampleWithMetadataEvent>.broadcast();

  @override
  void hello({
    required bool world,
    String? name,
  }) =>
      _stream.add(
        HelloExampleWithMetadataEvent(
          world: world,
          name: name,
        ),
      );

  @override
  void world(String name) => _stream.add(
        WorldExampleWithMetadataEvent(
          name,
        ),
      );

  Stream<ExampleWithMetadataEvent> get stream => _stream.stream;

  void dispose() => _stream.close();
}

extension ExampleWithMetadataInvokeExtension on ExampleWithMetadata {
  void invoke(ExampleWithMetadataEvent event) {
    if (event is HelloExampleWithMetadataEvent) {
      return hello(
        world: event.world,
        name: event.name,
      );
    }
    if (event is WorldExampleWithMetadataEvent) {
      return world(
        event.name,
      );
    }
    throw Exception('Unsupported event');
  }
}

sealed class ExampleCustomMetadataEvent {
  const ExampleCustomMetadataEvent();

  factory ExampleCustomMetadataEvent.hello({
    required bool world,
    String? name,
  }) = HelloExampleCustomMetadataEvent;

  factory ExampleCustomMetadataEvent.world(String name) =
      WorldExampleCustomMetadataEvent;

  EventMetadata get $metadata;
}

class HelloExampleCustomMetadataEvent extends ExampleCustomMetadataEvent {
  HelloExampleCustomMetadataEvent({
    required this.world,
    this.name,
  });

  final bool world;

  final String? name;

  @override
  late final EventMetadata $metadata = EventMetadata('Hello', {
    'world': world,
    if (name != null) 'Name': name,
  });

  @override
  String toString() => '''HelloExampleCustomMetadataEvent(
  world : $world,
  name : $name,
)''';
}

class WorldExampleCustomMetadataEvent extends ExampleCustomMetadataEvent {
  WorldExampleCustomMetadataEvent(this.name);

  final String name;

  @override
  late final EventMetadata $metadata = EventMetadata('world', {
    'name': name,
  });

  @override
  String toString() => '''WorldExampleCustomMetadataEvent(
  name : $name,
)''';
}

class StreamedExampleCustomMetadata implements ExampleCustomMetadata {
  final StreamController<ExampleCustomMetadataEvent> _stream =
      StreamController<ExampleCustomMetadataEvent>.broadcast();

  @override
  void hello({
    required bool world,
    String? name,
  }) =>
      _stream.add(
        HelloExampleCustomMetadataEvent(
          world: world,
          name: name,
        ),
      );

  @override
  void world(String name) => _stream.add(
        WorldExampleCustomMetadataEvent(
          name,
        ),
      );

  Stream<ExampleCustomMetadataEvent> get stream => _stream.stream;

  void dispose() => _stream.close();
}

extension ExampleCustomMetadataInvokeExtension on ExampleCustomMetadata {
  void invoke(ExampleCustomMetadataEvent event) {
    if (event is HelloExampleCustomMetadataEvent) {
      return hello(
        world: event.world,
        name: event.name,
      );
    }
    if (event is WorldExampleCustomMetadataEvent) {
      return world(
        event.name,
      );
    }
    throw Exception('Unsupported event');
  }
}

sealed class ExampleNoInvokerEvent {
  const ExampleNoInvokerEvent();

  factory ExampleNoInvokerEvent.hello({
    required bool world,
    String? name,
  }) = HelloExampleNoInvokerEvent;

  factory ExampleNoInvokerEvent.world(String name) = WorldExampleNoInvokerEvent;
}

class HelloExampleNoInvokerEvent extends ExampleNoInvokerEvent {
  const HelloExampleNoInvokerEvent({
    required this.world,
    this.name,
  });

  final bool world;

  final String? name;

  @override
  String toString() => '''HelloExampleNoInvokerEvent(
  world : $world,
  name : $name,
)''';
}

class WorldExampleNoInvokerEvent extends ExampleNoInvokerEvent {
  const WorldExampleNoInvokerEvent(this.name);

  final String name;

  @override
  String toString() => '''WorldExampleNoInvokerEvent(
  name : $name,
)''';
}

class StreamedExampleNoInvoker implements ExampleNoInvoker {
  final StreamController<ExampleNoInvokerEvent> _stream =
      StreamController<ExampleNoInvokerEvent>.broadcast();

  @override
  void hello({
    required bool world,
    String? name,
  }) =>
      _stream.add(
        HelloExampleNoInvokerEvent(
          world: world,
          name: name,
        ),
      );

  @override
  void world(String name) => _stream.add(
        WorldExampleNoInvokerEvent(
          name,
        ),
      );

  Stream<ExampleNoInvokerEvent> get stream => _stream.stream;

  void dispose() => _stream.close();
}

sealed class MyEvent {
  const MyEvent();

  factory MyEvent.hello({
    required bool world,
    String? name,
  }) = HelloEvent;

  factory MyEvent.world(String name) = WorldEvent;
}

class HelloEvent extends MyEvent {
  const HelloEvent({
    required this.world,
    this.name,
  });

  final bool world;

  final String? name;

  @override
  String toString() => '''HelloEvent(
  world : $world,
  name : $name,
)''';
}

class WorldEvent extends MyEvent {
  const WorldEvent(this.name);

  final String name;

  @override
  String toString() => '''WorldEvent(
  name : $name,
)''';
}

class StreamedExampleCustomEventNames implements ExampleCustomEventNames {
  final StreamController<MyEvent> _stream =
      StreamController<MyEvent>.broadcast();

  @override
  void hello({
    required bool world,
    String? name,
  }) =>
      _stream.add(
        HelloEvent(
          world: world,
          name: name,
        ),
      );

  @override
  void world(String name) => _stream.add(
        WorldEvent(
          name,
        ),
      );

  Stream<MyEvent> get stream => _stream.stream;

  void dispose() => _stream.close();
}
