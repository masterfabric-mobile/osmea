// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core/src/helper/common_logger_helper/abstract/common_logger.dart'
    as _i481;
import 'package:core/src/helper/common_logger_helper/common_logger_helper.dart'
    as _i674;
import 'package:core/src/views/account/cubit/account_cubit.dart' as _i111;
import 'package:core/src/views/auth/cubit/auth_cubit.dart' as _i651;
import 'package:core/src/views/empty_view/cubit/empty_view_cubit.dart' as _i905;
import 'package:core/src/views/error_handling/cubit/error_handling_cubit.dart'
    as _i183;
import 'package:core/src/views/image_detail/cubit/image_detail_cubit.dart'
    as _i508;
import 'package:core/src/views/info_bottom_sheet/cubit/info_bottom_sheet_cubit.dart'
    as _i754;
import 'package:core/src/views/loading/cubit/loading_cubit.dart' as _i525;
import 'package:core/src/views/onboarding/cubit/onboarding_cubit.dart' as _i182;
import 'package:core/src/views/permissions/cubit/permissions_cubit.dart'
    as _i874;
import 'package:core/src/views/search/cubit/search_cubit.dart' as _i925;
import 'package:core/src/views/splash/cubit/splash_cubit.dart' as _i33;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

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
    final commonLoggerModule = _$CommonLoggerModule();
    gh.factory<_i674.CommonLogger>(() => commonLoggerModule.commonLogger);
    gh.factory<_i905.EmptyViewCubit>(() => _i905.EmptyViewCubit());
    gh.factory<_i183.ErrorHandlingCubit>(() => _i183.ErrorHandlingCubit());
    gh.factory<_i508.ImageDetailCubit>(() => _i508.ImageDetailCubit());
    gh.factory<_i754.InfoBottomSheetCubit>(() => _i754.InfoBottomSheetCubit());
    gh.factory<_i525.LoadingViewCubit>(() => _i525.LoadingViewCubit());
    gh.factory<_i182.OnboardingCubit>(() => _i182.OnboardingCubit());
    gh.factory<_i874.PermissionsCubit>(() => _i874.PermissionsCubit());
    gh.factory<_i33.SplashCubit>(() => _i33.SplashCubit());
    gh.singleton<_i974.Logger>(() => commonLoggerModule.logger);
    gh.singleton<_i651.AuthCubit>(() => _i651.AuthCubit());
    gh.singleton<_i481.ICommonLogger>(
        () => _i674.CommonLogger(logger: gh<_i974.Logger>()));
    gh.factory<_i111.AccountCubit>(() => _i111.AccountCubit(
          authCubit: gh<_i651.AuthCubit>(),
          getUsersMeCallback: gh<_i111.GetUsersMeCallback>(),
        ));
    gh.factory<_i925.SearchCubit>(() => _i925.SearchCubit(
          maxHistoryItems: gh<int>(),
          minQueryLength: gh<int>(),
          debounceDuration: gh<Duration>(),
          initialHistory: gh<List<String>>(),
        ));
    return this;
  }
}

class _$CommonLoggerModule extends _i674.CommonLoggerModule {}
