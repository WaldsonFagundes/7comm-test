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
      userName: map[_valueKeyUserName],
      secret: map[_valueKeySecret],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      _valueKeyUserName: userName,
      _valueKeySecret: secret,
    };
  }

  UserModel copyWith({
    String? userName,
    String? secret,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      secret: secret ?? this.secret,
    );
  }

}