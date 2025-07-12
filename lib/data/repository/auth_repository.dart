import 'package:adiloka/services/api_service.dart';
import 'package:adiloka/data/models/request/login_request.dart';
import 'package:adiloka/data/models/response/login_response.dart';

class AuthRepository {
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await ApiService.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }
}
