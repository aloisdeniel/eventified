import 'package:eventified/eventified.dart';

@eventified
abstract class Example {
  @Event(metadata: 'Hello')
  void hello({
    required bool world,
    @EventArgument(metadata: 'Name') String? name,
  });

  void world(String name);
}
