import 'package:groveman/groveman.dart';
import 'package:meta/meta.dart';

/// A mixin for [Tree] that provides user identification and context data.
mixin IdentifierTree<User extends UserIdentifier> on Tree {
  /// Additional context information.
  @protected
  @visibleForTesting
  Map<String, dynamic> context = {};

  /// Custom tags for categorization.
  @protected
  @visibleForTesting
  Map<String, Object> tags = {};

  /// Sets the user identification.
  void setUser(User userIdentifier);

  /// Sets custom context and tags.
  void setIdentifiers({
    Map<String, dynamic> context = const {},
    Map<String, Object> tags = const {},
  });

  /// Clears the current user.
  void clearUser();

  /// Clears specific context and tag keys.
  void clearIdentifiers({
    List<String> contextKeys = const [],
    List<String> tagKeys = const [],
  });

  /// Clears all user and identification data.
  ///
  /// If [isReset] is true, resets to the default state.
  void clearAll({bool isReset = false});
}

/// Describes the current user associated with the application, such as the
/// currently signed in user.
class UserIdentifier {
  /// You should provide at least one of [id], [email], [ipAddress], [username]
  UserIdentifier({
    this.id,
    this.username,
    this.email,
    this.ipAddress,
    this.geo,
    this.name,
    Map<String, dynamic>? data,
  })  : assert(id != null ||
            username != null ||
            email != null ||
            ipAddress != null),
        data = data == null ? null : Map.from(data);

  /// A unique identifier of the user.
  final String? id;

  /// The username of the user.
  final String? username;

  /// The email address of the user.
  final String? email;

  /// The IP of the user.
  final String? ipAddress;

  /// Any other user context information that may be helpful.
  ///
  /// These keys are stored as extra information but not specifically processed
  /// by Sentry.
  final Map<String, dynamic>? data;

  /// Approximate geographical location of the end user or device.
  ///
  /// The geolocation is automatically inferred by Sentry.io if the [ipAddress] is set.
  /// Sentry however doesn't collect the [ipAddress] automatically because it is PII.
  /// The geo location will currently not be synced to the native layer, if available.
  // See https://github.com/getsentry/sentry-dart/issues/1065
  final UserGeoIdentifier? geo;

  /// Human readable name of the user.
  final String? name;
}

/// Geographical location of the end user or device.
final class UserGeoIdentifier {
  /// Geographical location of the end user or device.
  const UserGeoIdentifier({this.city, this.countryCode, this.region});

  /// Human readable city name.
  final String? city;

  /// Two-letter country code (ISO 3166-1 alpha-2).
  final String? countryCode;

  /// Human readable region name or code.
  final String? region;
}
