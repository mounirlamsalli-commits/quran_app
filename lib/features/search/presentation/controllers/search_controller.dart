import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/search_remote_datasource.dart';

final searchProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final dio = Dio();
  final ds = SearchRemoteDataSource(dio);
  return await ds.searchQuran(query);
});
