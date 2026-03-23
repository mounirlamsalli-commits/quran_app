import 'package:dio/dio.dart';

class SearchRemoteDataSource {
  final Dio dio;
  SearchRemoteDataSource(this.dio);

  Future<List<Map<String, dynamic>>> searchQuran(String query) async {
    final response = await dio.get(
      'https://api.quran.com/api/v4/search',
      queryParameters: {
        'q': query,
        'size': 30,
        'language': 'ar',
      },
    );
    final results = response.data['data']['matches'] as List;
    return results.cast<Map<String, dynamic>>();
  }
}
