import 'package:flutter_dev_test/core/error/execeptions.dart';
import 'package:flutter_dev_test/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/features/authentication/data/datasources/user_remote_data_source.dart';
import 'package:flutter_dev_test/features/authentication/data/models/user_model.dart';
import 'package:flutter_dev_test/features/authentication/data/repositories/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_respository_impl_test.mocks.dart';


@GenerateNiceMocks([MockSpec<UserRemoteDataSource>()])
void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tUserName = 'test_user';
  const tPassword = 'test_password';
  const tSecret = 'test_secret';
  const tUser = UserModel(userName: tUserName, secret: tSecret);
  const tCode = 'recovery_code';

  group('logIn', () {
    test('should return User when the login is successful', () async {
      when(mockRemoteDataSource.logIn(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        secret: anyNamed('secret'),
      )).thenAnswer((_) async => tUser);

      final result = await repository.logIn(userName: tUserName, password: tPassword, secret: tSecret);

      expect(result, const Right(tUser));
      verify(mockRemoteDataSource.logIn(userName: tUserName, password: tPassword, secret: tSecret));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return UnauthorizedFailure when there is an UnauthorizedException', () async {
      when(mockRemoteDataSource.logIn(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        secret: anyNamed('secret'),
      )).thenThrow(UnauthorizedException());

      final result = await repository.logIn(userName: tUserName, password: tPassword, secret: tSecret);

      expect(result, const Left(UnauthorizedFailure()));
    });

    test('should return SecretNotFoundFailure when there is a SecretNotFoundException', () async {
      when(mockRemoteDataSource.logIn(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        secret: anyNamed('secret'),
      )).thenThrow(SecretNotFoundException());

      final result = await repository.logIn(userName: tUserName, password: tPassword, secret: tSecret);

      expect(result, const Left(SecretNotFoundFailure()));
    });

    test('should return UnknownErrorFailure on UnknownErrorException', () async {
      when(mockRemoteDataSource.logIn(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        secret: anyNamed('secret'),
      )).thenThrow(UnknownErrorException());

      final result = await repository.logIn(userName: tUserName, password: tPassword, secret: tSecret);

      expect(result, const Left(UnknownErrorFailure()));
    });
  });

  group('recoverySecret', () {
    test('should return secret string when the recovery is successful', () async {
      when(mockRemoteDataSource.recoverySecret(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        code: anyNamed('code'),
      )).thenAnswer((_) async => tSecret);

      final result = await repository.recoverySecret(userName: tUserName, password: tPassword, code: tCode);

      expect(result, const Right(tSecret));
      verify(mockRemoteDataSource.recoverySecret(userName: tUserName, password: tPassword, code: tCode));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return UnauthorizedFailure when there is an UnauthorizedException', () async {
      when(mockRemoteDataSource.recoverySecret(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        code: anyNamed('code'),
      )).thenThrow(UnauthorizedException());

      final result = await repository.recoverySecret(userName: tUserName, password: tPassword, code: tCode);

      expect(result, const Left(UnauthorizedFailure()));
    });

    test('should return UserNotFoundFailure when there is a UserNotFoundException', () async {
      when(mockRemoteDataSource.recoverySecret(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        code: anyNamed('code'),
      )).thenThrow(UserNotFoundException());

      final result = await repository.recoverySecret(userName: tUserName, password: tPassword, code: tCode);

      expect(result, const Left(UserNotFoundFailure()));
    });

    test('should return UnknownErrorFailure on UnknownErrorException', () async {
      when(mockRemoteDataSource.recoverySecret(
        userName: anyNamed('userName'),
        password: anyNamed('password'),
        code: anyNamed('code'),
      )).thenThrow(UnknownErrorException());

      final result = await repository.recoverySecret(userName: tUserName, password: tPassword, code: tCode);

      expect(result, const Left(UnknownErrorFailure()));
    });
  });
}
