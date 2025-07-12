import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterSubmitted extends AuthEvent {
  final String nama;
  final String email;
  final String password;

  RegisterSubmitted({
    required this.nama,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [nama, email, password];
}
