import 'package:equatable/equatable.dart';
import 'package:core/src/helper/permission_handler_helper/models/permission_models.dart';

enum PermissionsStatus {
  initial,
  loading,
  ready,
  updating,
  error,
}

class PermissionsState extends Equatable {
  final PermissionsStatus status;
  final Map<AppPermission, bool> permissionStates;
  final String? previousRoute;
  final String? errorMessage;

  const PermissionsState({
    this.status = PermissionsStatus.initial,
    this.permissionStates = const {},
    this.previousRoute,
    this.errorMessage,
  });

  PermissionsState copyWith({
    PermissionsStatus? status,
    Map<AppPermission, bool>? permissionStates,
    String? previousRoute,
    String? errorMessage,
  }) {
    return PermissionsState(
      status: status ?? this.status,
      permissionStates: permissionStates ?? this.permissionStates,
      previousRoute: previousRoute ?? this.previousRoute,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, permissionStates, previousRoute, errorMessage];
}


