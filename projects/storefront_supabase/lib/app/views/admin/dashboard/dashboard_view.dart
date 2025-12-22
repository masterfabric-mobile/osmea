import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';

import 'models/states.dart';
import 'models/view_model.dart';

class AdminDashboardView
    extends MasterViewCubit<AdminDashboardViewModel, AdminDashboardState> {
  AdminDashboardView(
      {super.key,
      super.arguments = const {'init': true},
      required super.goRoute})
      : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text('Admin Dashboard'),
            variant: AppBarVariant.primary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            leading: OsmeaComponents.iconButton(
              onPressed: () => goRoute('/profile'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );

  @override
  void initialContent(AdminDashboardViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(BuildContext context, AdminDashboardViewModel viewModel, AdminDashboardState state) {
    if (state is AdminDashboardLoadingState || state is AdminDashboardInitialState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminDashboardErrorState) {
      return Center(child: Text(state.message));
    }

    if (state is AdminDashboardLoadedState) {
      return RefreshIndicator(
        onRefresh: viewModel.initial,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(context, state),
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Recent Orders'),
              const SizedBox(height: 8),
              _buildRecentOrders(context, state.recentOrders),
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'New Users'),
              const SizedBox(height: 8),
              _buildRecentUsers(context, state.recentUsers),
            ],
          ),
        ),
      );
    }

    return const Center(child: Text('An unexpected error occurred.'));
  }

  Widget _buildStatsGrid(BuildContext context, AdminDashboardLoadedState state) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'en_US');
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(context, 'Total Revenue', formatCurrency.format(state.totalRevenue), Icons.monetization_on, Colors.green),
            _buildStatCard(context, 'Total Orders', state.orderCount.toString(), Icons.shopping_cart, Colors.orange),
            _buildStatCard(context, 'Total Users', state.userCount.toString(), Icons.people, Colors.blue),
            _buildStatCard(context, 'Total Products', state.productCount.toString(), Icons.inventory_2, Colors.purple),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildRecentOrders(BuildContext context, List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No recent orders.'));
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: orders.map((order) {
          return ListTile(
            title: Text('Order #${order.orderNumber}'),
            subtitle: Text(order.user?.fullName ?? 'Guest'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(NumberFormat.simpleCurrency(locale: 'en_US').format(order.total)),
                Text(order.status, style: TextStyle(color: _getStatusColor(order.status))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentUsers(BuildContext context, List<AppUser> users) {
    if (users.isEmpty) {
      return const Center(child: Text('No new users.'));
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: users.map((user) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                  ? Text(user.fullName?.substring(0, 1) ?? '?')
                  : null,
            ),
            title: Text(user.username != null
                ? '${user.fullName ?? 'Unnamed'} (@${user.username})'
                : user.fullName ?? 'Unnamed User'),
            subtitle: Text('Joined ${DateFormat.yMMMd().format(user.createdAt)}'),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
