import 'package:adiloka/data/models/response/register_response.dart';
import 'package:adiloka/services/api_service.dart';
import 'package:adiloka/data/models/request/login_request.dart';
import 'package:adiloka/data/models/response/login_response.dart';
import 'package:adiloka/data/models/request/register_request.dart';

class AuthRepository {
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await ApiService.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await ApiService.dio.post(
      '/auth/register',
      data: request.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }
}
