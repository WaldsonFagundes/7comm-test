// Imports
import 'dart:convert';
import 'package:flutter_dev_test/core/error/execeptions.dart';
import 'package:flutter_dev_test/features/authentication/data/datasources/user_remote_data_source_impl.dart';
import 'package:flutter_dev_test/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'user_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = UserRemoteDataSourceImpl(client: mockHttpClient);
  });

  const tUserName = 'test_user';
  const tPassword = 'test_password';
  const tSecret = 'PUGZM4XGSWCN3UFLDAF2J7KRMHQ5SRYA';
  const tCode = 'test_code';

  group('logIn', () {
    test('should return UserModel when login is successful (status code 200)',
        () async {
      const url = 'http://10.0.2.2:5000/auth/login';
      const tUserModel = UserModel(userName: tUserName, secret: tSecret);
      final responseJson =
          jsonEncode({'username': tUserName, 'totp_secret': tSecret});

      when(mockHttpClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await dataSource.logIn(
          userName: tUserName, password: tPassword, secret: tSecret);

      expect(result, tUserModel);
    });

    test('should throw UnauthorizedException when the status code is 401',
        () async {
      const url = 'http://10.0.2.2:5000/auth/login';
      when(mockHttpClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      final call = dataSource.logIn;

      expect(
          () => call(userName: tUserName, password: tPassword, secret: tSecret),
          throwsA(isA<UnauthorizedException>()));
    });
  });

  group('recoverySecret', () {
    test('should return a secret when recovery is successful (status code 200)',
        () async {
      const url = 'http://10.0.2.2:5000/auth/recovery-secret';
      final responseJson = jsonEncode({'totp_secret': tSecret});

      when(mockHttpClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await dataSource.recoverySecret(
          userName: tUserName, password: tPassword, code: tCode);

      expect(result, tSecret);
    });

    test('should throw UnauthorizedException when the status code is 401',
        () async {
      const url = 'http://10.0.2.2:5000/auth/recovery-secret';
      when(mockHttpClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response(jsonEncode({'message': 'Unauthorized'}), 401));

      final call = dataSource.recoverySecret;

      expect(() => call(userName: tUserName, password: tPassword, code: tCode),
          throwsA(isA<UnauthorizedException>()));
    });

    test('should throw UserNotFoundException when the status code is 404',
        () async {
      const url = 'http://10.0.2.2:5000/auth/recovery-secret';
      when(mockHttpClient.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.recoverySecret;

      expect(() => call(userName: tUserName, password: tPassword, code: tCode),
          throwsA(isA<UserNotFoundException>()));
    });
  });
}
