import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';

abstract class AdminDashboardState {}

class AdminDashboardInitialState extends AdminDashboardState {}

class AdminDashboardLoadingState extends AdminDashboardState {}

class AdminDashboardErrorState extends AdminDashboardState {
  final String message;
  AdminDashboardErrorState(this.message);
}

class AdminDashboardLoadedState extends AdminDashboardState {
  final int userCount;
  final int productCount;
  final int orderCount;
  final double totalRevenue;
  final List<Order> recentOrders;
  final List<AppUser> recentUsers;

  AdminDashboardLoadedState({
    required this.userCount,
    required this.productCount,
    required this.orderCount,
    required this.totalRevenue,
    required this.recentOrders,
    required this.recentUsers,
  });
}
