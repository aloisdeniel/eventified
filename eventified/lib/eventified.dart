const eventified = Eventified();

typedef EventCallback<T> = void Function(T event);

class Eventified {
  const Eventified({
    this.invoker = true,
    this.metadata = true,
    this.eventSuffix,
  });

  /// Add an invoker implementation that allows to call methods from an
  /// implementation by sending an event.
  final bool invoker;

  /// Generates `$name` and `$arguments` properties for events.
  final bool metadata;

  /// The suffix added to each event class.
  ///
  /// Defaults to `<class name>Event`.
  final String? eventSuffix;
}

class Event {
  const Event(this.name);
  final String name;
}

class EventArgument {
  const EventArgument(this.name);
  final String name;
}

class EventMetadata {
  const EventMetadata(
    this.name, [
    this.arguments = const <String, dynamic>{},
  ]);

  final String name;
  final Map<String, dynamic> arguments;
}
