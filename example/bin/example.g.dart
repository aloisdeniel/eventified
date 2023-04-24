// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// EventifiedGenerator
// **************************************************************************

abstract class ExampleEvent {
  const ExampleEvent();

  factory ExampleEvent.hello({
    required bool world,
    String? name,
  }) = HelloExampleEvent;

  factory ExampleEvent.world(String name) = WorldExampleEvent;

  EventMetadata get $metadata;
}

class HelloExampleEvent extends ExampleEvent {
  HelloExampleEvent({
    required this.world,
    this.name,
  });

  final bool world;

  final String? name;

  @override
  late final EventMetadata $metadata = EventMetadata('Hello', {
    'hello': world,
    if (name != null) 'Name': name,
  });
}

class WorldExampleEvent extends ExampleEvent {
  WorldExampleEvent(this.name);

  final String name;

  @override
  late final EventMetadata $metadata = EventMetadata('world', {
    'world': name,
  });
}

class StreamedExample implements Example {
  final StreamController<ExampleEvent> _stream =
      StreamController<ExampleEvent>.broadcast();

  @override
  void hello({
    required bool world,
    String? name,
  }) =>
      _stream.add(
        HelloExampleEvent(
          world: world,
          name: name,
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

abstract class ExampleNoInvokerEvent {
  const ExampleNoInvokerEvent();

  factory ExampleNoInvokerEvent.hello({
    required bool world,
    String? name,
  }) = HelloExampleNoInvokerEvent;

  factory ExampleNoInvokerEvent.world(String name) = WorldExampleNoInvokerEvent;

  EventMetadata get $metadata;
}

class HelloExampleNoInvokerEvent extends ExampleNoInvokerEvent {
  HelloExampleNoInvokerEvent({
    required this.world,
    this.name,
  });

  final bool world;

  final String? name;

  @override
  late final EventMetadata $metadata = EventMetadata('Hello', {
    'hello': world,
    if (name != null) 'Name': name,
  });
}

class WorldExampleNoInvokerEvent extends ExampleNoInvokerEvent {
  WorldExampleNoInvokerEvent(this.name);

  final String name;

  @override
  late final EventMetadata $metadata = EventMetadata('world', {
    'world': name,
  });
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

abstract class ExampleNoMetadataEvent {
  const ExampleNoMetadataEvent();

  factory ExampleNoMetadataEvent.hello({
    required bool world,
    String? name,
  }) = HelloExampleNoMetadataEvent;

  factory ExampleNoMetadataEvent.world(String name) =
      WorldExampleNoMetadataEvent;
}

class HelloExampleNoMetadataEvent extends ExampleNoMetadataEvent {
  HelloExampleNoMetadataEvent({
    required this.world,
    this.name,
  });

  final bool world;

  final String? name;
}

class WorldExampleNoMetadataEvent extends ExampleNoMetadataEvent {
  WorldExampleNoMetadataEvent(this.name);

  final String name;
}

class StreamedExampleNoMetadata implements ExampleNoMetadata {
  final StreamController<ExampleNoMetadataEvent> _stream =
      StreamController<ExampleNoMetadataEvent>.broadcast();

  @override
  void hello({
    required bool world,
    String? name,
  }) =>
      _stream.add(
        HelloExampleNoMetadataEvent(
          world: world,
          name: name,
        ),
      );
  @override
  void world(String name) => _stream.add(
        WorldExampleNoMetadataEvent(
          name,
        ),
      );
  Stream<ExampleNoMetadataEvent> get stream => _stream.stream;
  void dispose() => _stream.close();
}
