import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';

/// Orders History States
abstract class OrdersHistoryState {}

class OrdersHistoryInitialState extends OrdersHistoryState {}

class OrdersHistoryLoadingState extends OrdersHistoryState {}

class OrdersHistoryLoadedState extends OrdersHistoryState {
  final List<UserOrder> orders;
  final UserProfile? userProfile;

  OrdersHistoryLoadedState({
    required this.orders,
    this.userProfile,
  });
}

class OrdersHistoryErrorState extends OrdersHistoryState {
  final String message;

  OrdersHistoryErrorState({required this.message});
}
