// Imports
import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/core/error/failures.dart';
import 'package:flutter_dev_test/features/authentication/domain/repositories/user_repository.dart';
import 'package:flutter_dev_test/features/authentication/domain/usecases/recovery_secret.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'recovery_secret_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
void main() {
  late RecoverySecret usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = RecoverySecret(repository: mockUserRepository);
  });

  const tUserName = 'user123@test.com';
  const tPassword = 'test_password';
  const tCode = 'recovery_code';
  const tSecret = 'test_totp_secret';

  const tParams = RecoverySecretParams(
    userName: tUserName,
    password: tPassword,
    code: tCode,
  );

  void setUpMockSuccess() {
    when(mockUserRepository.recoverySecret(
      userName: anyNamed('userName'),
      password: anyNamed('password'),
      code: anyNamed('code'),
    )).thenAnswer((_) async => const Right(tSecret));
  }

  void setUpMockFailure() {
    when(mockUserRepository.recoverySecret(
      userName: anyNamed('userName'),
      password: anyNamed('password'),
      code: anyNamed('code'),
    )).thenAnswer((_) async => const Left(UnknownErrorFailure()));
  }

  void verifyCall() {
    verify(mockUserRepository.recoverySecret(
      userName: tUserName,
      password: tPassword,
      code: tCode,
    )).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  }

  test('should return the Secret when recovery is successful', () async {
    setUpMockSuccess();

    final result = await usecase(tParams);

    expect(result, const Right(tSecret));
    verifyCall();
  });

  test('should return Failure when recovery fails', () async {
    setUpMockFailure();

    final result = await usecase(tParams);

    expect(result, const Left(UnknownErrorFailure()));
    verifyCall();
  });
}
