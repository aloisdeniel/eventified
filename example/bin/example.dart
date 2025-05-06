import 'dart:async';

import 'package:eventified/eventified.dart';

part 'example.g.dart';

void main(List<String> args) {
  final streamed = StreamedExample();

  /// Listen for events.
  streamed.stream.listen((event) {
    print(event);
  });

  /// Call methods to trigger corresponding events.
  streamed
    ..hello(world: false, name: 'Jeff')
    ..world('john');

  /// Closes the underlying stream.
  streamed.dispose();
}

@eventified
abstract class Example {
  void hello({
    required bool world,
    String? name,
    int withDefault = 42,
  });

  void world(String name);
}

@Eventified(metadata: true)
abstract class ExampleWithMetadata {
  void hello({
    required bool world,
    String? name,
  });

  void world(String name);
}

@Eventified(metadata: true)
abstract class ExampleCustomMetadata {
  @Event(metadata: 'Hello')
  void hello({
    required bool world,
    @EventArgument(metadata: 'Name') String? name,
  });

  void world(String name);
}

@Eventified(invoker: false)
abstract class ExampleNoInvoker {
  void hello({
    required bool world,
    String? name,
  });

  void world(String name);
}

@Eventified(
  baseEvent: 'MyEvent',
  invoker: false,
)
abstract class ExampleCustomEventNames {
  @Event(name: 'HelloEvent')
  void hello({
    required bool world,
    String? name,
  });

  @Event(name: 'WorldEvent')
  void world(String name);
}
