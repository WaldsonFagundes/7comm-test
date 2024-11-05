// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:flutter_dev_test/core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LogIn extends UseCase<User, LogInParams> {
  final UserRepository repository;

  LogIn({required this.repository});

  @override
  Future<Either<Failure, User>> call(LogInParams params) async {
    return await repository.logIn(
      userName: params.userName,
      password: params.password,
      secret: params.secret,
    );
  }
}

class LogInParams extends Equatable {
  final String userName;
  final String password;
  final String secret;

  const LogInParams({
    required this.userName,
    required this.password,
    required this.secret,
  });

  @override
  List<Object?> get props => [
        userName,
        password,
        secret,
      ];
}
