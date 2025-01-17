// ignore_for_file: invalid_use_of_internal_member

import 'package:sentry/sentry.dart';
import 'package:sentry/src/metrics/metric.dart';
import 'package:sentry/src/metrics/metrics_aggregator.dart';
import 'package:sentry/src/metrics/metrics_api.dart';
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
  Future<SentryId> captureTransaction(
    SentryTransaction transaction, {
    SentryTraceContextHeader? traceContext,
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
    // TODO: implement clone
    throw UnimplementedError();
  }

  @override
  // TODO: implement options
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
    // TODO: implement startTransaction
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
    // TODO: implement startTransactionWithContext
    throw UnimplementedError();
  }

  @override
  SentryProfilerFactory? profilerFactory;

  @override
  Future<SentryId> captureMetrics(Map<int, Iterable<Metric>> metricsBuckets) {
    // TODO: implement captureMetrics
    throw UnimplementedError();
  }

  @override
  // TODO: implement metricsAggregator
  MetricsAggregator? get metricsAggregator {
    throw UnimplementedError();
  }

  @override
  // TODO: implement metricsApi
  MetricsApi get metricsApi => throw UnimplementedError();

  @override
  // TODO: implement scope
  Scope get scope => throw UnimplementedError();

  @override
  Future<SentryId> captureFeedback(
    SentryFeedback feedback, {
    Hint? hint,
    ScopeCallback? withScope,
  }) {
    // TODO: implement captureFeedback
    throw UnimplementedError();
  }

  @override
  // ignore: deprecated_member_use
  Future<void> captureUserFeedback(SentryUserFeedback userFeedback) {
    // TODO: implement captureUserFeedback
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
