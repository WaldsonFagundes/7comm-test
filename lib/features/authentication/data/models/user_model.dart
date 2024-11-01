import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userName,
    super.secret,
  });

  static const String _valueKeySecret = 'totp_secret';
  static const String _valueKeyUserName = 'username';

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      secret: map[_valueKeySecret],
      userName: map[_valueKeyUserName],
    );
  }
}
