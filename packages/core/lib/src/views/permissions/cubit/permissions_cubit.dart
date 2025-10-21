import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/helper/permission_handler_helper/permission_handler_helper.dart';
import 'package:core/src/helper/permission_handler_helper/models/permission_models.dart';
import 'permissions_state.dart';

class PermissionsCubit extends BaseViewModelCubit<PermissionsState> {
  PermissionsCubit() : super(const PermissionsState());

  final PermissionHandlerHelper _permissionHelper = PermissionHandlerHelper.instance;

  Future<void> initialize({String? previousRoute}) async {
    coreDebugPrint('🔍 [PermissionsCubit] initialize called');
    stateChanger(state.copyWith(status: PermissionsStatus.loading, previousRoute: previousRoute));
    try {
      final Map<AppPermission, bool> map = {
        AppPermission.storage: false,
        AppPermission.camera: false,
        AppPermission.microphone: false,
        AppPermission.locationWhenInUse: false,
        AppPermission.photos: false,
        AppPermission.notifications: false,
        AppPermission.contacts: false,
        AppPermission.calendar: false,
      };

      for (final p in map.keys) {
        final status = await _permissionHelper.getPermissionStatus(p);
        map[p] = status.isGranted;
      }

      coreDebugPrint('🔍 [PermissionsCubit] Loaded ${map.length} permissions');
      stateChanger(state.copyWith(status: PermissionsStatus.ready, permissionStates: map));
    } catch (e) {
      coreDebugPrint('🔴 [PermissionsCubit] Error in initialize: $e');
      stateChanger(state.copyWith(status: PermissionsStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> toggle(AppPermission permission) async {
    if (state.status == PermissionsStatus.updating) return;
    stateChanger(state.copyWith(status: PermissionsStatus.updating));
    try {
      final current = Map<AppPermission, bool>.from(state.permissionStates);
      final isOn = current[permission] ?? false;

      if (!isOn) {
        await _permissionHelper.clearSoftPermission(permission);
        await _permissionHelper.requestPermission(permission);
        final newStatus = await _permissionHelper.getPermissionStatus(permission);
        current[permission] = newStatus.isGranted;
      } else {
        await _permissionHelper.setSoftPermission(permission, false);
        await _permissionHelper.clearPermissionCache(permission);
        current[permission] = false;
      }

      stateChanger(state.copyWith(status: PermissionsStatus.ready, permissionStates: current));
    } catch (e) {
      coreDebugPrint('Permissions toggle error: $e');
      stateChanger(state.copyWith(status: PermissionsStatus.error, errorMessage: e.toString()));
    }
  }
}


