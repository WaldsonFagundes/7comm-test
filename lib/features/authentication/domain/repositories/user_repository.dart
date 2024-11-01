import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> logIn({
    required String userName,
    required String password,
  });

  Future<Either<Failure, String>> recoverySecret({
    required String userName,
    required String password,
    required String code,
  });
}
