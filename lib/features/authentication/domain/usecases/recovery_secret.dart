import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dev_test/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class RecoverySecret extends UseCase<String, RecoverySecretParams> {

  final UserRepository repository;

  RecoverySecret({required this.repository});


  @override
  Future<Either<Failure, String>> call(RecoverySecretParams params) async {
    return await repository.recoverySecret(code: params.code);
  }
}


class RecoverySecretParams extends Equatable {
  final String code;

  const RecoverySecretParams({required this.code,});

  @override
  List<Object?> get props => [code];
}