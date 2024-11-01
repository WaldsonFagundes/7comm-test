import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userName;
  final String? secret;

  const User({
    required this.userName,
    this.secret,
  });

  @override
  List<Object?> get props => [
        userName,
        secret,
      ];
}
