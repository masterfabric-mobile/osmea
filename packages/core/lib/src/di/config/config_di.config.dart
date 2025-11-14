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
import 'package:core/src/views/image_detail/cubit/image_detail_cubit.dart'
    as _i508;
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
    gh.factory<_i508.ImageDetailCubit>(() => _i508.ImageDetailCubit());
    gh.singleton<_i481.ICommonLogger>(
        () => _i674.CommonLogger(logger: gh<_i974.Logger>()));
    return this;
  }
}

class _$CommonLoggerModule extends _i674.CommonLoggerModule {}
