import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:adiloka/data/repository/auth_repository.dart';
import 'package:adiloka/data/models/request/login_request.dart';
import 'package:adiloka/data/models/request/register_request.dart';
import 'package:adiloka/data/models/response/register_response.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await repository.login(
        LoginRequest(email: event.email, password: event.password),
      );
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure('Login gagal: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await repository.register(
        RegisterRequest(
          nama: event.nama,
          email: event.email,
          password: event.password,
        ),
      );
      emit(RegisterSuccess(response.message)); // Gunakan state baru
    } catch (e) {
      emit(AuthFailure('Registrasi gagal: ${e.toString()}'));
    }
  }
}
