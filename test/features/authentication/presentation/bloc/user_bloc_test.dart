// Imports
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/core/error/failures.dart';
import 'package:flutter_dev_test/features/authentication/domain/entities/user.dart';
import 'package:flutter_dev_test/features/authentication/domain/usecases/login.dart';
import 'package:flutter_dev_test/features/authentication/domain/usecases/recovery_secret.dart';
import 'package:flutter_dev_test/features/authentication/presentation/bloc/user_bloc.dart';
import 'package:flutter_dev_test/features/authentication/presentation/bloc/user_event.dart';
import 'package:flutter_dev_test/features/authentication/presentation/bloc/user_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_bloc_test.mocks.dart';


@GenerateNiceMocks([MockSpec<LogIn>(), MockSpec<RecoverySecret>()])
void main() {
  late UserBloc bloc;
  late MockLogIn mockLogIn;
  late MockRecoverySecret mockRecoverySecret;

  setUp(() {
    mockLogIn = MockLogIn();
    mockRecoverySecret = MockRecoverySecret();
    bloc = UserBloc(login: mockLogIn, recoverySecret: mockRecoverySecret);
  });

  const tUserName = 'test_user';
  const tPassword = 'test_password';
  const tSecret = 'test_secret';
  const tUser = User(userName: tUserName, secret: tSecret);
  const tCode = 'recovery_code';

  group('LogInEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [SecretMissingState] when secret is empty',
      build: () => bloc,
      act: (bloc) => bloc.add(const LogInEvent(userName: tUserName, password: tPassword, secret: '')),
      expect: () => [const SecretMissingState()],
    );

    blocTest<UserBloc, UserState>(
      'should emit [LoadingState, LoginSuccess] when login is successful',
      build: () {
        when(mockLogIn(any)).thenAnswer((_) async => const Right(tUser));
        return bloc;
      },
      act: (bloc) => bloc.add(const LogInEvent(userName: tUserName, password: tPassword, secret: tSecret)),
      expect: () => [LoadingState(), LoginSuccess()],
    );

    blocTest<UserBloc, UserState>(
      'should emit [LoadingState, FailureState] with UnauthorizedFailure on unauthorized error',
      build: () {
        when(mockLogIn(any)).thenAnswer((_) async => const Left(UnauthorizedFailure(message: 'Unauthorized')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LogInEvent(userName: tUserName, password: tPassword, secret: tSecret)),
      expect: () => [LoadingState(), const FailureState(message: 'Unauthorized')],
    );
  });

  group('RecoverySecretEvent', () {
    blocTest<UserBloc, UserState>(
      'should emit [LoadingState, SecretLoadedState] when recovery is successful',
      build: () {
        when(mockRecoverySecret(any)).thenAnswer((_) async => const Right(tSecret));
        return bloc;
      },
      act: (bloc) => bloc.add(const RecoverySecretEvent(userName: tUserName, password: tPassword, code: tCode)),
      expect: () => [LoadingState(), const SecretLoadedState(secret: tSecret)],
    );

    blocTest<UserBloc, UserState>(
      'should emit [LoadingState, FailureState] with UserNotFoundFailure on user not found error',
      build: () {
        when(mockRecoverySecret(any)).thenAnswer((_) async => const Left(UserNotFoundFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const RecoverySecretEvent(userName: tUserName, password: tPassword, code: tCode)),
      expect: () => [LoadingState(), const FailureState(message: 'Usuário não encontrado.')],
    );

    blocTest<UserBloc, UserState>(
      'should emit [LoadingState, FailureState] with UnknownErrorFailure on unknown error',
      build: () {
        when(mockRecoverySecret(any)).thenAnswer((_) async => Left(UnknownErrorFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const RecoverySecretEvent(userName: tUserName, password: tPassword, code: tCode)),
      expect: () => [LoadingState(), const FailureState(message: 'Erro desconhecido.')],
    );
  });
}
