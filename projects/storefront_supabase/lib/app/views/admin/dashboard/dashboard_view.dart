import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

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
            title: OsmeaComponents.text(
              context.resources.adminDashboard,
              color: Colors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
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
    final resources = context.resources;
    if (state is AdminDashboardLoadingState || state is AdminDashboardInitialState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminDashboardErrorState) {
      return OsmeaComponents.center(child: OsmeaComponents.text(state.message));
    }

    if (state is AdminDashboardLoadedState) {
      return RefreshIndicator(
        onRefresh: viewModel.initial,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(context, state),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionHeader(context, resources.recentOrders),
              OsmeaComponents.sizedBox(height: 8),
              _buildRecentOrders(context, state.recentOrders),
              OsmeaComponents.sizedBox(height: 24),
              _buildSectionHeader(context, resources.newUsers),
              OsmeaComponents.sizedBox(height: 8),
              _buildRecentUsers(context, state.recentUsers),
            ],
          ),
        ),
      );
    }

    return OsmeaComponents.center(child: OsmeaComponents.text(resources.unexpectedError));
  }

  Widget _buildStatsGrid(BuildContext context, AdminDashboardLoadedState state) {
    final resources = context.resources;
    // final formatCurrency = NumberFormat.simpleCurrency(locale: 'en_US'); // locale should be dynamic -- Removing this line as per PriceHelper usage
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocBuilder<CurrencyCubit, String>(
          builder: (context, currency) {
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                    context,
                    resources.totalRevenue,
                    PriceHelper.format(state.totalRevenue, currency,
                        Localizations.localeOf(context).toString()),
                    Icons.monetization_on,
                    Colors.green),
                _buildStatCard(context, resources.totalOrders,
                    state.orderCount.toString(), Icons.shopping_cart, Colors.orange),
                _buildStatCard(context, resources.totalUsers,
                    state.userCount.toString(), Icons.people, Colors.blue),
                _buildStatCard(
                    context,
                    resources.totalProducts,
                    state.productCount.toString(),
                    Icons.inventory_2,
                    Colors.purple),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16.0),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OsmeaComponents.text(
              title,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: OsmeaComponents.text(
                value,
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return OsmeaComponents.text(
      title,
      textStyle: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildRecentOrders(BuildContext context, List<Order> orders) {
    final resources = context.resources;
    if (orders.isEmpty) {
      return OsmeaComponents.center(child: OsmeaComponents.text(resources.noRecentOrders));
    }
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        children: orders.map((order) {
          return OsmeaComponents.listItem(
            title: OsmeaComponents.text('${resources.orderNumber}${order.orderNumber}'),
            subtitle: OsmeaComponents.text(order.user?.fullName ?? resources.guest),
            trailing: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<CurrencyCubit, String>(
                  builder: (context, currency) {
                    return OsmeaComponents.text(PriceHelper.format(order.total,
                        currency, Localizations.localeOf(context).toString()));
                  },
                ),
                OsmeaComponents.text(order.status, textStyle: TextStyle(color: _getStatusColor(order.status))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentUsers(BuildContext context, List<AppUser> users) {
    final resources = context.resources;
    if (users.isEmpty) {
      return OsmeaComponents.center(child: OsmeaComponents.text(resources.noNewUsers));
    }
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        children: users.map((user) {
          return OsmeaComponents.listItem(
            leading: OsmeaComponents.avatar(
              size: ComponentSize.medium,
              imageUrl: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) ? user.avatarUrl : null,
              text: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                  ? (user.fullName?.substring(0, 1) ?? '?')
                  : null,
            ),
            title: OsmeaComponents.text(user.username != null
                ? '${user.fullName ?? resources.unnamed} (@${user.username})'
                : user.fullName ?? resources.unnamedUser),
            subtitle: OsmeaComponents.text('${resources.joined} ${DateFormat.yMMMd().format(user.createdAt)}'),
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
