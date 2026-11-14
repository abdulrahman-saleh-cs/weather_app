library;

import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String errMessage;
  final String code;

  const Failure({required this.errMessage, required this.code});

  @override
  List<Object?> get props => [errMessage, code];
}