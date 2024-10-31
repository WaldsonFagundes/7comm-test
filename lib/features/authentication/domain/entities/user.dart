import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String password;
  final String? secret;

  const User({
    required this.username,
    required this.password,
    this.secret,
  });

  @override
  List<Object?> get props => [
        username,
        password,
        secret,
      ];
}
