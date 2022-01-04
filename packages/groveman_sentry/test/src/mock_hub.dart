import 'package:sentry/sentry.dart';

class MockHub implements Hub {
  List<AddBreadcrumbCall> addBreadcrumbCalls = [];
  List<EventCall> eventCalls = [];

  @override
  void addBreadcrumb(Breadcrumb crumb, {dynamic hint}) {
    addBreadcrumbCalls.add(AddBreadcrumbCall(crumb, hint));
  }

  // The following methods and properties are not needed for the tests.
  @override
  void bindClient(SentryClient client) {
    throw UnimplementedError();
  }

  @override
  Hub clone() {
    throw UnimplementedError();
  }

  @override
  Future<void> close() async {}

  @override
  void configureScope(void Function(Scope) callback) {}

  @override
  bool get isEnabled => throw UnimplementedError();

  @override
  SentryId get lastEventId => throw UnimplementedError();

  @override
  Future<SentryId> captureEvent(
    SentryEvent event, {
    dynamic stackTrace,
    dynamic hint,
    ScopeCallback? withScope,
  }) {
    eventCalls.add(
      EventCall(
        event,
        stackTrace: stackTrace,
        hint: hint,
        withScope: withScope,
      ),
    );
    return Future.value(SentryId.newId());
  }

  @override
  Future<SentryId> captureException(
    dynamic throwable, {
    dynamic stackTrace,
    dynamic hint,
    ScopeCallback? withScope,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SentryId> captureMessage(
    String? message, {
    SentryLevel? level,
    String? template,
    List? params,
    dynamic hint,
    ScopeCallback? withScope,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SentryId> captureTransaction(SentryTransaction transaction) {
    throw UnimplementedError();
  }

  @override
  Future<void> captureUserFeedback(SentryUserFeedback userFeedback) {
    throw UnimplementedError();
  }

  @override
  ISentrySpan? getSpan() {
    throw UnimplementedError();
  }

  @override
  void setSpanContext(
    dynamic throwable,
    ISentrySpan span,
    String transaction,
  ) {}

  @override
  ISentrySpan startTransaction(
    String name,
    String operation, {
    String? description,
    bool? bindToScope,
    Map<String, dynamic>? customSamplingContext,
  }) {
    throw UnimplementedError();
  }

  @override
  ISentrySpan startTransactionWithContext(
    SentryTransactionContext transactionContext, {
    Map<String, dynamic>? customSamplingContext,
    bool? bindToScope,
  }) {
    throw UnimplementedError();
  }
}

class AddBreadcrumbCall {
  final Breadcrumb crumb;
  final dynamic hint;

  AddBreadcrumbCall(this.crumb, this.hint);
}

class EventCall {
  final SentryEvent sentryEvent;
  final dynamic stackTrace;
  final dynamic hint;
  final ScopeCallback? withScope;
  EventCall(
    this.sentryEvent, {
    this.stackTrace,
    this.hint,
    this.withScope,
  });
}
