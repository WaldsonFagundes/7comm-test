import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> signIn({
    required String userName,
    required String password,
  });

  Future<Either<Failure, User>> recoverySecret({
    required String code,
  });
}
