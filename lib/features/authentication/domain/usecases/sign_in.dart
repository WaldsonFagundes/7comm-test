import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dev_test/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignIn extends UseCase<User, SignInParams> {

  final UserRepository repository;

  SignIn({required this.repository});

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signIn(
        userName: params.userName, password: params.password);
  }
}


class SignInParams extends Equatable {
  final String userName;
  final String password;

  const SignInParams({required this.userName, required this.password,});

  @override
  List<Object?> get props => [userName, password,];
}