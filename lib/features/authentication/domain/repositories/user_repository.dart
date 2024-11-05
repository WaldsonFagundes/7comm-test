// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> logIn({
    required String userName,
    required String password,
    required String secret,
  });

  Future<Either<Failure, String>> recoverySecret({
    required String userName,
    required String password,
    required String code,
  });
}
