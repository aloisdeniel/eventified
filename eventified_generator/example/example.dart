import 'package:eventified/eventified.dart';

@eventified
abstract class Example {
  @Event('Hello')
  void hello({
    required bool world,
    @EventArgument('Name') String? name,
  });

  void world(String name);
}
