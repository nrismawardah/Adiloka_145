import 'dart:io';
import 'package:dio/dio.dart';
import 'package:adiloka/data/models/response/karya_response.dart';
import 'package:adiloka/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class KaryaRepository {
  Future<List<KaryaModel>> fetchKaryaList() async {
    final response = await ApiService.dio.get('/karya');
    print('🔍 Response dari /karya: ${response.data}');

    final data = response.data;

    if (data is List) {
      return data.map((json) => KaryaModel.fromJson(json)).toList();
    } else {
      throw Exception('Expected a list, got ${data.runtimeType}');
    }
  }

  Future<void> createKarya({
    required String judul,
    required String deskripsi,
    required int kategoriId,
    required int daerahId,
    required String filePath,
    required double latitude,
    required double longitude,
  
  }) async {
    String extension = filePath.split('.').last.toLowerCase();
    String mimeType = extension == 'png' ? 'png' : 'jpeg';

    final file = await MultipartFile.fromFile(
      filePath,
      filename: 'upload.$extension',
      contentType: MediaType('image', mimeType),
    );

    final formData = FormData.fromMap({
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori_id': kategoriId,
      'daerah_id': daerahId,
      'lokasi': '$latitude,$longitude',
      'foto': file,
    });

    // AMBIL TOKEN dari SharedPreferences (asumsinya kamu simpan saat login)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
      'token',
    ); // atau 'access_token' sesuai penyimpananmu

    if (token == null) throw Exception('Token tidak ditemukan');

    print('📦 Token yang dipakai untuk upload: $token');
    await ApiService.dio.post(
      '/karya',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}
