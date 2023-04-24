const eventified = Eventified();

class Eventified {
  const Eventified({
    this.invoker = true,
    this.metadata = false,
    this.baseEvent,
  });

  /// Add an invoker implementation that allows to call methods from an
  /// implementation by sending events.
  final bool invoker;

  /// Generate a `$metadata`property for events.
  final bool metadata;

  /// The name of the base event class.
  ///
  /// Defaults to `<class name>Event`.
  final String? baseEvent;
}

class Event {
  const Event({this.name, this.metadata});

  /// The name of the generated event class.
  final String? name;

  /// The key of the event metadata.
  final String? metadata;
}

class EventArgument {
  const EventArgument({this.metadata});

  /// The key of the event argument metadata.
  final String? metadata;
}

class EventMetadata {
  const EventMetadata(
    this.name, [
    this.arguments = const <String, dynamic>{},
  ]);

  final String name;
  final Map<String, dynamic> arguments;
}
