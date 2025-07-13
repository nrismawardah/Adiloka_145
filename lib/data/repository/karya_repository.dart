import 'package:dio/dio.dart';
import 'package:adiloka/data/models/response/karya_response.dart';
import 'package:adiloka/services/api_service.dart';

class KaryaRepository {
  Future<List<KaryaModel>> fetchKaryaList() async {
    final response = await ApiService.dio.get('/karya');
    final data = response.data as List;
    return data.map((json) => KaryaModel.fromJson(json)).toList();
  }
}
