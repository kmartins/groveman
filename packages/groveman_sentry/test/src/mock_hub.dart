// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:sentry/sentry.dart';
import 'package:sentry/src/profiling.dart';

class MockHub implements Hub {
  List<AddBreadcrumbCall> addBreadcrumbCalls = [];
  List<EventCall> eventCalls = [];
  final MockScope _scope = MockScope();

  MockScope get mockScope => _scope;

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
  void configureScope(void Function(Scope) callback) {
    callback(_scope);
  }

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
  Scope get scope => _scope;

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
  Future<SentryId> captureException(
    dynamic throwable, {
    Object? stackTrace,
    Hint? hint,
    SentryMessage? message,
    ScopeCallback? withScope,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SentryId> captureTransaction(
    SentryTransaction transaction, {
    SentryTraceContextHeader? traceContext,
    Hint? hint,
  }) {
    throw UnimplementedError();
  }

  @override
  void removeAttribute(String key) {
    throw UnimplementedError();
  }

  @override
  void setAttributes(Map<String, SentryAttribute> attributes) {
    throw UnimplementedError();
  }

  @override
  Future<void> captureMetric(SentryMetric metric) {
    throw UnimplementedError();
  }

  @override
  Future<void> captureSpan(SentrySpanV2 span) {
    throw UnimplementedError();
  }

  @override
  RecordingSentrySpanV2? getActiveSpan() {
    throw UnimplementedError();
  }

  @override
  SentrySpanV2 startIdleSpan(
    String name, {
    Duration idleTimeout = const Duration(seconds: 3),
    Duration finalTimeout = const Duration(seconds: 30),
    bool trimIdleSpanEndTimestamp = true,
    Map<String, SentryAttribute>? attributes,
    DateTime? startTimestamp,
  }) {
    throw UnimplementedError();
  }

  @override
  SentrySpanV2 startInactiveSpan(
    String name, {
    Map<String, SentryAttribute>? attributes,
    SentrySpanV2? parentSpan = const UnsetSentrySpanV2(),
    DateTime? startTimestamp,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<T> startSpan<T>(
    String name,
    Future<T> Function(SentrySpanV2 span) callback, {
    Map<String, SentryAttribute>? attributes,
    SentrySpanV2? parentSpan = const UnsetSentrySpanV2(),
    DateTime? startTimestamp,
  }) {
    throw UnimplementedError();
  }

  @override
  T startSpanSync<T>(
    String name,
    T Function(SentrySpanV2 span) callback, {
    Map<String, SentryAttribute>? attributes,
    SentrySpanV2? parentSpan = const UnsetSentrySpanV2(),
    DateTime? startTimestamp,
  }) {
    throw UnimplementedError();
  }
}

class MockScope extends Scope {
  MockScope() : super(SentryOptions());

  @override
  SentryUser? user;
  @override
  final Map<String, String> tags = {};
  final Map<String, dynamic> context = {};

  @override
  Future<void> setUser(SentryUser? user) async {
    this.user = user;
  }

  @override
  Future<void> setTag(String key, String value) async {
    tags[key] = value;
  }

  @override
  Future<void> removeTag(String key) async {
    tags.remove(key);
  }

  @override
  Future<void> setContexts(String key, dynamic value) async {
    context[key] = value;
  }

  @override
  Future<void> removeContexts(String key) async {
    context.remove(key);
  }

  @override
  Future<void> clear() async {
    user = null;
    tags.clear();
    context.clear();
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
