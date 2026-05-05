import 'package:groveman/groveman.dart';
import 'package:groveman_sentry/src/log_extensions.dart';
import 'package:meta/meta.dart';
import 'package:sentry/sentry.dart';

/// {@template sentry_tree}
/// [Tree] that sends your logs to the Sentry.
///
/// ```dart
/// void main() {
///   Groveman.plantTree(SentryTree());
/// }
/// ```
/// {@endtemplate}
class SentryTree extends Tree with IdentifierTree {
  /// Log levels that will be sent for the sentry.
  final List<LogLevel> _logLevels;
  Hub _hub = HubAdapter();

  /// Sets a mock [Hub] for testing purposes.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setMockHub(Hub mockHub) => _hub = mockHub;

  /// The default log levels are [LogLevel.info], [LogLevel.warning],
  /// [LogLevel.error], and [LogLevel.fatal] if there is a [error]
  /// then it's sent using `captureEvent`, otherwise, with `addBreadcrumb`.
  SentryTree({List<LogLevel>? logLevels})
      : _logLevels = logLevels ??
            [
              LogLevel.info,
              LogLevel.warning,
              LogLevel.error,
              LogLevel.fatal,
            ],
        assert(logLevels?.isNotEmpty ?? true, 'must have at least one level');

  @override
  void log(LogRecord logRecord) {
    final logLevel = logRecord.level;

    if (_logLevels.contains(logLevel)) {
      if (logRecord.error != null) {
        _hub.captureEvent(
          logRecord.toEvent,
          stackTrace: logRecord.stackTrace,
        );
      } else {
        _hub.addBreadcrumb(logRecord.toBreadcrumb);
      }
    }
  }

  @override
  void setUser(UserIdentifier userIdentifier) => _hub.configureScope((scope) {
        scope.setUser(SentryUser(
          id: userIdentifier.id,
          username: userIdentifier.username,
          email: userIdentifier.email,
          ipAddress: userIdentifier.ipAddress,
          geo: SentryGeo(
            city: userIdentifier.geo?.city,
            countryCode: userIdentifier.geo?.countryCode,
            region: userIdentifier.geo?.region,
          ),
          name: userIdentifier.name,
          data: userIdentifier.data,
        ));
      });

  @override
  void clearUser() => _hub.configureScope((scope) => scope.setUser(null));

  @override
  void setIdentifiers({
    Map<String, dynamic>? context,
    Map<String, Object>? tags,
  }) {
    assert(
      tags?.values
              .every((v) => v is int || v is num || v is String || v is bool) ??
          true,
      'Sentry tags only support primitive values (int, num, String, bool)',
    );

    _hub.configureScope((scope) {
      context?.forEach(scope.setContexts);
      tags?.forEach((key, value) => scope.setTag(key, value.toString()));
    });

    if (tags case final tags?) {
      this.tags.addAll(tags);
    }

    if (context case final context?) {
      this.context.addAll(context);
    }
  }

  @override
  void clearIdentifiers({
    List<String>? contextKeys,
    List<String>? tagKeys,
  }) {
    _hub.configureScope((scope) {
      contextKeys?.forEach(scope.removeContexts);
      tagKeys?.forEach(scope.removeTag);
    });
    tagKeys?.forEach(tags.remove);
    contextKeys?.forEach(context.remove);
  }

  @override
  void clearAll() {
    _hub.configureScope((scope) {
      scope.setUser(null);
      tags.forEach((key, _) => scope.removeTag(key));
      context.forEach((key, _) => scope.removeContexts(key));
    });
    tags.clear();
    context.clear();
  }
}
