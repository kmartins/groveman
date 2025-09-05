// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:sentry/sentry.dart';
import 'package:sentry/src/profiling.dart';

class MockHub implements Hub {
  List<AddBreadcrumbCall> addBreadcrumbCalls = [];
  List<EventCall> eventCalls = [];

  @override
  Future<void> addBreadcrumb(Breadcrumb crumb, {dynamic hint}) async =>
      addBreadcrumbCalls.add(AddBreadcrumbCall(crumb, hint));

  // The following methods and properties are not needed for the tests.
  @override
  void bindClient(SentryClient client) {
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
  Hub clone() {
    throw UnimplementedError();
  }

  @override
  SentryOptions get options => throw UnimplementedError();

  @override
  ISentrySpan startTransaction(
    String name,
    String operation, {
    String? description,
    DateTime? startTimestamp,
    bool? bindToScope,
    bool? waitForChildren,
    Duration? autoFinishAfter,
    bool? trimEnd,
    OnTransactionFinish? onFinish,
    Map<String, dynamic>? customSamplingContext,
  }) {
    throw UnimplementedError();
  }

  @override
  ISentrySpan startTransactionWithContext(
    SentryTransactionContext transactionContext, {
    Map<String, dynamic>? customSamplingContext,
    DateTime? startTimestamp,
    bool? bindToScope,
    bool? waitForChildren,
    Duration? autoFinishAfter,
    bool? trimEnd,
    OnTransactionFinish? onFinish,
  }) {
    throw UnimplementedError();
  }

  @override
  SentryProfilerFactory? profilerFactory;

  @override
  Scope get scope => throw UnimplementedError();

  @override
  Future<SentryId> captureFeedback(
    SentryFeedback feedback, {
    Hint? hint,
    ScopeCallback? withScope,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> captureLog(SentryLog log) {
    throw UnimplementedError();
  }

  @override
  void generateNewTrace() {}

  @override
  Map<Type, List<Function>> get lifecycleCallbacks =>
      throw UnimplementedError();

  @override
  void registerSdkLifecycleCallback<T extends SdkLifecycleEvent>(
      SdkLifecycleCallback<T> callback) {}

  @override
  void removeSdkLifecycleCallback<T extends SdkLifecycleEvent>(
      SdkLifecycleCallback<T> callback) {}

  @override
  Future<SentryId> captureException(dynamic throwable,
      {Object? stackTrace,
      Hint? hint,
      SentryMessage? message,
      ScopeCallback? withScope}) {
    throw UnimplementedError();
  }

  @override
  Future<SentryId> captureTransaction(SentryTransaction transaction,
      {SentryTraceContextHeader? traceContext, Hint? hint}) {
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
