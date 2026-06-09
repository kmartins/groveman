/// Represents an analytics event.
abstract class AnalyticsEvent {
  /// The name of the event.
  String get eventName;

  /// The properties associated with the event.
  Map<String, dynamic>? get properties => null;
}
