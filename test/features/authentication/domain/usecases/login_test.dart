import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/core/error/failures.dart';
import 'package:flutter_dev_test/features/authentication/domain/entities/user.dart';
import 'package:flutter_dev_test/features/authentication/domain/repositories/user_repository.dart';
import 'package:flutter_dev_test/features/authentication/domain/usecases/login.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'login_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
void main() {
  late LogIn usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = LogIn(repository: mockUserRepository);
  });

  const tUser = User(
    userName: 'test_username',
    secret: 'test_totp',
  );
  const tParams = LogInParams(
    userName: 'user123@test.com',
    secret: 'test_totp',
    password: 'test_password',
  );

  void setUpMockSuccess() {
    when(mockUserRepository.logIn(
      userName: anyNamed('userName'),
      password: anyNamed('password'),
      secret: anyNamed('secret'),
    )).thenAnswer((_) async => const Right(tUser));
  }

  void setUpMockFailure() {
    when(mockUserRepository.logIn(
      userName: anyNamed('userName'),
      password: anyNamed('password'),
      secret: anyNamed('secret'),
    )).thenAnswer((_) async => const Left(UnknownErrorFailure()));
  }

  void verifyCall() {
    verify(mockUserRepository.logIn(
      userName: tParams.userName,
      password: tParams.password,
      secret: tParams.secret,
    )).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  }

  test('should LogIn a User', () async {
    setUpMockSuccess();

    final result = await usecase(tParams);

    expect(result, const Right(tUser));
    verifyCall();
  });

  test('should return Failure when repository call is unsuccessful', () async {
    setUpMockFailure();

    final result = await usecase(tParams);

    expect(result, const Left(UnknownErrorFailure()));
    verifyCall();
  });
}
