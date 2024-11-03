import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/features/authentication/domain/entities/user.dart';
import 'package:flutter_dev_test/features/authentication/domain/usecases/recovery_secret.dart';
import 'package:flutter_dev_test/features/authentication/presentation/bloc/user_event.dart';
import 'package:flutter_dev_test/features/authentication/presentation/bloc/user_state.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/login.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final LogIn login;
  final RecoverySecret recoverySecret;

  UserBloc({
    required this.login,
    required this.recoverySecret,
  }) : super(InitialState()) {
    on<LogInEvent>(_onLogin);
    on<RecoverySecretEvent>(_onRecoverySecret);
  }

  Future<void> _onLogin(LogInEvent event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final failureOrUser = await login(LogInParams(
        userName: event.userName,
        password: event.password,
        secret: event.secret));

    emit(_mapFailureOrUserToState(failureOrUser));
  }

  Future<void> _onRecoverySecret(
      RecoverySecretEvent event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final failureOrSecret = await recoverySecret(RecoverySecretParams(
        userName: event.userName, password: event.password, code: event.code));

    emit(_mapFailureOrSecretToState(failureOrSecret));
  }

  UserState _mapFailureOrUserToState(Either<Failure, User> failureOrUser) {
    return failureOrUser.fold(
      (failure) {
        return FailureState(message: failure.message);
      },
      (user) {
        return UserLoadedState(user: user);
      },
    );
  }

  UserState _mapFailureOrSecretToState(
      Either<Failure, String> failureOrSecret) {
    return failureOrSecret.fold(
      (failure) {
        return FailureState(message: failure.message);
      },
      (secret) {
        return SecretLoadedState(secret: secret);
      },
    );
  }
}
