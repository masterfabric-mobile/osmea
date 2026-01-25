import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_orders_response.dart';

/// Order Detail States
abstract class OrderDetailState {}

class OrderDetailInitialState extends OrderDetailState {}

class OrderDetailLoadingState extends OrderDetailState {}

class OrderDetailLoadedState extends OrderDetailState {
  final DetailedUserOrder order;

  OrderDetailLoadedState({
    required this.order,
  });
}

class OrderDetailErrorState extends OrderDetailState {
  final String message;

  OrderDetailErrorState({required this.message});
}
