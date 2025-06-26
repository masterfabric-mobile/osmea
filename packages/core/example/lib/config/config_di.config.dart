// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example/views/view_home/home_view_model.dart' as _i1030;
import 'package:example/views/view_ocr_cheque/ocr_cheque_view_model.dart'
    as _i734;
import 'package:example/views/view_splash/splash_view_model.dart' as _i671;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

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
    gh.factory<_i734.OcrChequeViewModel>(() => _i734.OcrChequeViewModel());
    gh.factory<_i671.SplashViewModel>(() => _i671.SplashViewModel());
    gh.factory<_i1030.HomeViewModel>(() => _i1030.HomeViewModel());
    return this;
  }
}
