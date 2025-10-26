// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:admin_dashboard/app/views/view_onboarding/models/onboarding_view_model.dart'
    as _i604;
import 'package:admin_dashboard/app/views/view_splash/models/splash_view_model.dart'
    as _i601;
import 'package:admin_dashboard/app/views/view_welcome/models/welcome_view_model.dart'
    as _i860;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i601.SplashViewModel>(() => _i601.SplashViewModel());
    gh.factory<_i860.WelcomeViewModel>(() => _i860.WelcomeViewModel());
    gh.factory<_i604.OnboardingViewModel>(() => _i604.OnboardingViewModel());
    return this;
  }
}
