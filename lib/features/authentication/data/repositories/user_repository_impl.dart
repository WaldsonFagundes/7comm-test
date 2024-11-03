import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/core/error/execeptions.dart';
import 'package:flutter_dev_test/core/error/failures.dart';
import 'package:flutter_dev_test/features/authentication/data/datasources/user_remote_data_source.dart';
import 'package:flutter_dev_test/features/authentication/domain/entities/user.dart';
import 'package:flutter_dev_test/features/authentication/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> logIn({
    required String userName,
    required String password,
    String? secret,
  }) async {
    try {
      final remoteUser = await remoteDataSource.logIn(
        userName: userName,
        password: password,
        secret: secret,
      );

      return Right(remoteUser);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on SecretNotFoundException {
      return const Left(SecretNotFoundFailure());
    } on UserNotFoundException {
      return const Left(UserNotFoundFailure());
    }  on UnknownErrorException {
      return const Left(UnknownErrorFailure());
    } catch (_) {
      return const Left(UnknownErrorFailure());
    }
  }

  @override
  Future<Either<Failure, String>> recoverySecret(
      {required String userName,
      required String password,
      required String code}) async {
    try {
      final remoteUser = await remoteDataSource.recoverySecret(
          userName: userName, password: password, code: code);

      return Right(remoteUser);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on UserNotFoundException {
      return const Left(UserNotFoundFailure());
    } on UnknownErrorException {
      return const Left(UnknownErrorFailure());
    } catch (_) {
      return const Left(UnknownErrorFailure());
    }
  }
}
