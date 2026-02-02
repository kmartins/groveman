import 'package:groveman/groveman.dart';
import 'package:test/test.dart';

void main() {
  group('UserIdentifier', () {
    test(
        'given an id, '
        'when UserIdentifier is created, '
        'then it should have the id', () {
      final user = UserIdentifier(id: '123');
      expect(user.id, '123');
    });

    test(
        'given a username, '
        'when UserIdentifier is created, '
        'then it should have the username', () {
      final user = UserIdentifier(username: 'groveman');
      expect(user.username, 'groveman');
    });

    test(
        'given an email, '
        'when UserIdentifier is created, '
        'then it should have the email', () {
      final user = UserIdentifier(email: 'groveman@example.com');
      expect(user.email, 'groveman@example.com');
    });

    test(
        'given an ipAddress, '
        'when UserIdentifier is created, '
        'then it should have the ipAddress', () {
      final user = UserIdentifier(ipAddress: '127.0.0.1');
      expect(user.ipAddress, '127.0.0.1');
    });

    test(
        'given no required fields, '
        'when UserIdentifier is created, '
        'then it should throw an AssertionError', () {
      expect(() => UserIdentifier(), throwsA(isA<AssertionError>()));
    });

    test(
        'given all fields, '
        'when UserIdentifier is created, '
        'then all fields should be stored correctly', () {
      final geo = UserGeoIdentifier(
        city: 'New York',
        countryCode: 'US',
        region: 'NY',
      );
      final data = {'key': 'value'};
      final user = UserIdentifier(
        id: '123',
        username: 'groveman',
        email: 'groveman@example.com',
        ipAddress: '127.0.0.1',
        name: 'Groveman',
        geo: geo,
        data: data,
      );

      expect(user.id, '123');
      expect(user.username, 'groveman');
      expect(user.email, 'groveman@example.com');
      expect(user.ipAddress, '127.0.0.1');
      expect(user.name, 'Groveman');
      expect(user.geo, geo);
      expect(user.data, data);
    });

    test(
        'given a data map, '
        'when UserIdentifier is created, '
        'then the data map should be copied', () {
      final data = {'key': 'value'};
      final user = UserIdentifier(id: '123', data: data);

      data['key'] = 'new_value';
      expect(user.data!['key'], 'value');
    });
  });

  group('UserGeoIdentifier', () {
    test(
        'given all fields, '
        'when UserGeoIdentifier is created, '
        'then all fields should be stored correctly', () {
      final geo = UserGeoIdentifier(
        city: 'New York',
        countryCode: 'US',
        region: 'NY',
      );

      expect(geo.city, 'New York');
      expect(geo.countryCode, 'US');
      expect(geo.region, 'NY');
    });

    test(
        'given no fields, '
        'when UserGeoIdentifier is created, '
        'then all fields should be null', () {
      final geo = UserGeoIdentifier();

      expect(geo.city, isNull);
      expect(geo.countryCode, isNull);
      expect(geo.region, isNull);
    });
  });
}
