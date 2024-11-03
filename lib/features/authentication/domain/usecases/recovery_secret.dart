import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dev_test/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class RecoverySecret extends UseCase<String, RecoverySecretParams> {
  final UserRepository repository;

  RecoverySecret({required this.repository});

  @override
  Future<Either<Failure, String>> call(RecoverySecretParams params) async {
    return await repository.recoverySecret(
      userName: params.userName,
      password: params.password,
      code: params.code,
    );
  }
}

class RecoverySecretParams extends Equatable {
  final String userName;
  final String password;
  final String code;

  const RecoverySecretParams({
    required this.userName,
    required this.password,
    required this.code,
  });

  @override
  List<Object?> get props => [
        userName,
        password,
        code,
      ];
}
