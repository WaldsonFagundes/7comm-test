import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LogInEvent extends UserEvent {
  final String userName;
  final String password;
  final String secret;

  const LogInEvent({
    required this.userName,
    required this.password,
    required this.secret,
  });

  @override
  List<Object?> get props => [userName, password, secret];
}

class RecoverySecretEvent extends UserEvent {
  final String userName;
  final String password;
  final String code;

  const RecoverySecretEvent({
    required this.userName,
    required this.password,
    required this.code,
  });

  @override
  List<Object?> get props => [userName, password, code];
}
