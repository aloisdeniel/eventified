# Eventified

Transform method calls to a stream of events.

## Getting started

Add these dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  eventified: 

dev_dependencies:
  build_runner:
  eventified_generator: 
```

## Usage

### 1. Declaring methods

Start by declaring a class which defines a set of public methods, with a set of arguments. Annotate this class with the `@eventified` annotation.

Add a `part 'example.g.dart';` declaration at the top of your file.

> The return type of the methods must be `void`.

```dart
import 'package:eventified/eventified.dart';

part 'example.g.dart';

@eventified
abstract class Example {
  void hello({
    required bool world,
    String? name,
  });

  void world(String name);
}
```

### 2. Generate event classes and the stream implementation.

Run the build runner in your project by running this command line:

```sh
dart run build_runner build
```

> If you are using flutter, use `flutter pub run build_runner build` instead.


### 3. Use implementation

```dart
/// Create an instance from the `Streamed` generated implementation. 
final streamed = StreamedExample();

/// Listen for events from the `stream`.
streamed.stream.listen((event) {
print(event);
});

/// Call methods to trigger corresponding events.
streamed
..hello(world: false, name: 'Jeff')
..world('john');

/// The previous calls prints this to console :
///
/// HelloExampleEvent(
///   world : false,
///   name : Jeff,
/// )
/// WorldExampleEvent(
///   name : john,
/// )

/// Closes the underlying stream.
streamed.dispose();
```

## Advanced usage

The generated classes and behaviours can be customized with annotations.

### Custom event names

You can set a `baseEvent` name, and specific event names.


```dart
@Eventified(baseEvent: 'MyEvent')
abstract class ExampleCustomEventNames {
  @Event(name: 'HelloEvent')
  void hello({
    required bool world,
    String? name,
  });

  @Event(name: 'WorldEvent')
  void world(String name);
}
```

### Add metadata

You can generate a `$metadata` property which allows to reflects the event and its arguments at runtime. This might be particularly useful for serialization purpose.

```dart
@Eventified(metadata: true)
abstract class Example {
  void hello({
    required bool world,
    String? name,
  });

  void world(String name);
}
```

The metadata keys can also be customized independently with `Event` and `EventArgument` annotations.

```dart
@Eventified(metadata: true)
abstract class Example {
  @Event(metadata: 'Hello')
  void hello({
    required bool world,
    @EventArgument(metadata: 'Name') String? name,
  });

  void world(String name);
}
```

## Examples

See [the example project](https://github.com/aloisdeniel/eventified/tree/main/example).