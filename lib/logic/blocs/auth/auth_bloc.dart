import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:adiloka/data/repository/auth_repository.dart';
import 'package:adiloka/data/models/request/login_request.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
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
      emit(AuthFailure('Gagal login: ${e.toString()}'));
    }
  }
}
