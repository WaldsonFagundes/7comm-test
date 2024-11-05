// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../domain/entities/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class InitialState extends UserState {}

class LoadingState extends UserState {}

class LoginSuccess extends UserState {}

class UserLoadedState extends UserState {
  final User? user;

  const UserLoadedState({this.user});

  @override
  List<Object?> get props => [user];
}

class SecretLoadedState extends UserState {
  final String secret;

  const SecretLoadedState({required this.secret});

  @override
  List<Object?> get props => [secret];
}

class FailureState extends UserState {
  final String? message;

  const FailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SecretMissingState extends UserState {
  const SecretMissingState();

  @override
  List<Object?> get props => [];
}
