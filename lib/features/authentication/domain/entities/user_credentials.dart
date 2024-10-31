import 'package:equatable/equatable.dart';

class UserCredentials extends Equatable {
  final String userName;
  final String password;

  const UserCredentials({
    required this.userName,
    required this.password,
  });

  @override
  List<Object?> get props => [
        userName,
        password,
      ];
}
