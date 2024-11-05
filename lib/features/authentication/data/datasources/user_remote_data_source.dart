// Project imports:
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  //POST: /auth/login
  Future<UserModel> logIn({
    required String userName,
    required String password,
    required String secret,
  });

  //POST: /auth/recovery-secret
  Future<String> recoverySecret({
    required String userName,
    required String password,
    required String code,
  });
}
