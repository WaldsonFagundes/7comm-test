// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/recovery_secret.dart';
import 'user_event.dart';
import 'user_state.dart';

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
    if (event.secret.isEmpty) {
      emit(const SecretMissingState());
      return;
    }

    emit(LoadingState());
    final failureOrUser = await login(LogInParams(
      userName: event.userName,
      password: event.password,
      secret: event.secret,
    ));

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
        return LoginSuccess();
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
