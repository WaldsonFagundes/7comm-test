import 'package:equatable/equatable.dart';

class Secret extends Equatable {
  final String value;

  const Secret({
    required this.value,
  });

  @override
  List<Object?> get props => [
        value,
      ];
}
