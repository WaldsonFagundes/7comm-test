// Package imports:
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}


class SecretNotFoundFailure extends Failure {
  const SecretNotFoundFailure() : super(message: 'Secret não encontrado.');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super(message: 'Usuário não encontrado.');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String? message}) : super(message: message ?? 'Não autorizado.');
}

class UnknownErrorFailure extends Failure {
  const UnknownErrorFailure() : super(message: 'Erro desconhecido.');
}

class InvalidPasswordFailure extends Failure {
  const InvalidPasswordFailure() : super(message: 'Senha inválida.');
}

class InvalidRecoveryCodeFailure extends Failure {
  const InvalidRecoveryCodeFailure() : super(message: 'Código de recuperação inválido.');
}
