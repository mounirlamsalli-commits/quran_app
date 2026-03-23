// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:quran_app/features/quran/data/datasources/quran_remote_datasource.dart'
    as _i560;
import 'package:quran_app/features/quran/data/repositories/quran_repository_impl.dart'
    as _i641;
import 'package:quran_app/features/quran/domain/repositories/quran_repository.dart'
    as _i164;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i560.QuranRemoteDataSource>(
        () => _i560.QuranRemoteDataSourceImpl());
    gh.lazySingleton<_i164.QuranRepository>(
        () => _i641.QuranRepositoryImpl(gh<_i560.QuranRemoteDataSource>()));
    return this;
  }
}
