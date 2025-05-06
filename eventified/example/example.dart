import 'package:eventified/eventified.dart';

@eventified
abstract class Example {
  @Event(metadata: 'Hello')
  void hello({
    required bool world,
    @EventArgument(metadata: 'Name') String? name,
    int withDefault = 42,
  });

  void world(String name);
}
