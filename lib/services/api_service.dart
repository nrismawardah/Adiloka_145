import 'package:dio/dio.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:5000/api', // ganti sesuai baseUrl backend-mu
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
