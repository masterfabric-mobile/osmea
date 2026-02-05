import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:storefront_woo/app/views/view_order_detail/models/module/states.dart';

@injectable
class OrderDetailViewModel
    extends BaseViewModelHydratedCubit<OrderDetailState> {
  OrderDetailViewModel() : super(OrderDetailInitialState());

  // Dependencies
  final OsmeaUsersManagerService _usersManagerService =
      GetIt.I<OsmeaUsersManagerService>();

  // Arguments holder
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Hydrated storage key
  @override
  String get id => 'order_detail_view_model_v1';

  // Public trigger functions
  Future<void> loadOrder(int orderId) => _loadOrder(orderId);

  Future<void> _loadOrder(int orderId) async {
    try {
      stateChanger(OrderDetailLoadingState());

      debugPrint('📦 OrderDetailViewModel: Loading order $orderId...');
      
      final order = await _usersManagerService.getUserOrder(orderId);

      debugPrint('✅ OrderDetailViewModel: Order loaded successfully');
      debugPrint('📦 OrderDetailViewModel: Order #${order.orderNumber}');
      debugPrint('📦 OrderDetailViewModel: Line items: ${order.lineItems?.length ?? 0}');

      stateChanger(OrderDetailLoadedState(order: order));
      
      debugPrint('✅ OrderDetailViewModel: State changed to OrderDetailLoadedState');
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading order: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      stateChanger(OrderDetailErrorState(
        message: 'Failed to load order. Please try again.',
      ));
    }
  }

  @override
  Map<String, dynamic>? toJson(OrderDetailState state) {
    // Don't persist state - always fetch fresh data from API
    return null;
  }

  @override
  OrderDetailState? fromJson(Map<String, dynamic> json) {
    // Don't restore state - always start fresh
    return OrderDetailInitialState();
  }
}
