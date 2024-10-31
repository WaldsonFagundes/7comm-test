import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userName;
  final String password;
  final String? secret;

  const User({
    required this.userName,
    required this.password,
    this.secret,
  });

  @override
  List<Object?> get props => [
        userName,
        password,
        secret,
      ];
}
