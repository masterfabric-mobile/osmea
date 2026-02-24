// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tiny_plates/app/views/view_home/models/home_view_model.dart'
    as _i643;
import 'package:tiny_plates/app/views/view_onboarding/models/onboarding_view_model.dart'
    as _i173;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i643.HomeViewModel>(() => _i643.HomeViewModel());
    gh.factory<_i173.OnboardingViewModel>(() => _i173.OnboardingViewModel());
    return this;
  }
}
