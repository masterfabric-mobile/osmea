import 'package:flutter/material.dart';
import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
import 'package:storefront_supabase/app/models/order.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

import 'models/module/states.dart';
import 'models/dashboard_view_model.dart';

class AdminDashboardView
    extends MasterViewCubit<AdminDashboardViewModel, AdminDashboardState> {
  AdminDashboardView({
    super.key,
    super.arguments = const {'init': true},
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
           title: OsmeaComponents.text(
             context.resources.adminDashboard,
             color: OsmeaColors.black,
           ),
           variant: AppBarVariant.primary,
           backgroundColor: OsmeaColors.white,
           foregroundColor: OsmeaColors.black,
           leading: OsmeaComponents.iconButton(
             onPressed: () => goRoute(AdminRoutes.profile),
             icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
           ),
         ),
       );

  @override
  void initialContent(AdminDashboardViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    AdminDashboardViewModel viewModel,
    AdminDashboardState state,
  ) {
    final resources = context.resources;
    if (state is AdminDashboardLoadingState ||
        state is AdminDashboardInitialState) {
      return OsmeaComponents.center(
        child: OsmeaComponents.loading(
          type: LoadingType.circularFade,
          size: 36,
          color: OsmeaColors.black,
        ),
      );
    }

    if (state is AdminDashboardErrorState) {
      return OsmeaComponents.center(
        child: OsmeaComponents.text(
          state.message,
          textStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: OsmeaColors.black),
        ),
      );
    }

    if (state is AdminDashboardLoadedState) {
      return RefreshIndicator(
        onRefresh: viewModel.initial,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: context.paddingNormal,
          children: [
            _buildStatsGrid(context, state),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionHeader(context, 'Quick access'),
            OsmeaComponents.sizedBox(height: 8),
            _buildQuickAccessCard(context, resources),
            OsmeaComponents.sizedBox(height: 24),
            if (state.dailyChartData.isNotEmpty) ...[
              _buildSectionHeader(context, resources.last7DaysRevenueOrders),
              OsmeaComponents.sizedBox(height: 8),
              _buildScrollableChart(
                context,
                minWidth: 480,
                minHeight: 360,
                child: _buildDailyChart(context, state),
              ),
              OsmeaComponents.sizedBox(height: 24),
            ],
            if (state.ordersByStatus.isNotEmpty) ...[
              _buildSectionHeader(context, resources.orderStatuses),
              OsmeaComponents.sizedBox(height: 8),
              _buildScrollableChart(
                context,
                minWidth: 340,
                minHeight: 280,
                child: _buildOrdersByStatusChart(context, state),
              ),
              OsmeaComponents.sizedBox(height: 24),
            ],
            if (state.dailyUserCounts.isNotEmpty) ...[
              _buildSectionHeader(context, resources.last7DaysNewUsers),
              OsmeaComponents.sizedBox(height: 8),
              _buildScrollableChart(
                context,
                minWidth: 300,
                minHeight: 220,
                child: _buildMiniBarChart(
                  context,
                  title: resources.dailyNewUsers,
                  values: state.dailyUserCounts,
                  maxValue: state.dailyUserCounts.fold(
                    0,
                    (a, b) => a > b ? a : b,
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(height: 24),
            ],
            if (state.dailyProductCounts.isNotEmpty) ...[
              _buildSectionHeader(context, resources.last7DaysNewProducts),
              OsmeaComponents.sizedBox(height: 8),
              _buildScrollableChart(
                context,
                minWidth: 300,
                minHeight: 220,
                child: _buildMiniBarChart(
                  context,
                  title: resources.dailyNewProducts,
                  values: state.dailyProductCounts,
                  maxValue: state.dailyProductCounts.fold(
                    0,
                    (a, b) => a > b ? a : b,
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(height: 24),
            ],
            _buildSectionHeader(context, resources.recentOrders),
            OsmeaComponents.sizedBox(height: 8),
            _buildRecentOrders(context, state.recentOrders),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionHeader(context, resources.newUsers),
            OsmeaComponents.sizedBox(height: 8),
            _buildRecentUsers(context, state.recentUsers),
          ],
        ),
      );
    }

    return OsmeaComponents.center(
      child: OsmeaComponents.text(
        resources.unexpectedError,
        textStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: OsmeaColors.black),
      ),
    );
  }

  Widget _buildQuickAccessCard(BuildContext context, dynamic resources) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        children: [
          _buildQuickAccessTile(context, icon: Icons.inventory_2_outlined, title: resources.products, onTap: () => goRoute(AdminRoutes.products)),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildQuickAccessTile(context, icon: Icons.category_outlined, title: resources.categories, onTap: () => goRoute(AdminRoutes.categories)),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildQuickAccessTile(context, icon: Icons.shopping_bag_outlined, title: resources.orders, onTap: () => goRoute(AdminRoutes.orders)),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildQuickAccessTile(context, icon: Icons.people_outline, title: resources.users, onTap: () => goRoute(AdminRoutes.users)),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildQuickAccessTile(context, icon: Icons.confirmation_number_outlined, title: resources.coupons, onTap: () => goRoute(AdminRoutes.coupons)),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildQuickAccessTile(context, icon: Icons.settings_outlined, title: resources.adminSettings, onTap: () => goRoute(AdminRoutes.settings)),
          Divider(height: 1, color: OsmeaColors.silver.withOpacity(0.4)),
          _buildQuickAccessTile(context, icon: Icons.settings_suggest_outlined, title: 'App config', subtitle: 'View app_config.json', onTap: () => goRoute(AdminRoutes.appConfig)),
        ],
      ),
    );
  }

  Widget _buildQuickAccessTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: OsmeaColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: OsmeaComponents.row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: OsmeaColors.black, size: 22),
              OsmeaComponents.sizedBox(width: 16),
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.text(
                      title,
                      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      OsmeaComponents.sizedBox(height: 2),
                      OsmeaComponents.text(
                        subtitle,
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: OsmeaColors.slate,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: OsmeaColors.thunder, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AdminDashboardLoadedState state,
  ) {
    final resources = context.resources;
    return BlocBuilder<CurrencyCubit, String>(
      builder: (context, currency) {
        return OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OsmeaComponents.row(
              children: [
                Expanded(
                  child: _buildStatCardWithChart(
                    context,
                    title: resources.totalRevenue,
                    value: PriceHelper.format(
                      state.totalRevenue,
                      currency,
                      Localizations.localeOf(context).toString(),
                    ),
                    icon: Icons.monetization_on,
                    color: OsmeaColors.black,
                    chartValues: state.dailyChartData
                        .map((e) => e.revenue)
                        .toList(),
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: _buildStatCardWithChart(
                    context,
                    title: resources.totalOrders,
                    value: state.orderCount.toString(),
                    icon: Icons.shopping_cart,
                    color: OsmeaColors.black,
                    chartValues: state.dailyChartData
                        .map((e) => e.orderCount.toDouble())
                        .toList(),
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.row(
              children: [
                Expanded(
                  child: _buildStatCardWithChart(
                    context,
                    title: resources.totalUsers,
                    value: state.userCount.toString(),
                    icon: Icons.people,
                    color: OsmeaColors.black,
                    chartValues: state.dailyUserCounts
                        .map((e) => e.toDouble())
                        .toList(),
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: _buildStatCardWithChart(
                    context,
                    title: resources.totalProducts,
                    value: state.productCount.toString(),
                    icon: Icons.inventory_2,
                    color: OsmeaColors.black,
                    chartValues: state.dailyProductCounts
                        .map((e) => e.toDouble())
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCardWithChart(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required List<double> chartValues,
  }) {
    final hasChart = chartValues.isNotEmpty;
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(12.0),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.row(
            children: [
              Icon(icon, color: color, size: 20),
              OsmeaComponents.sizedBox(width: 8),
              Expanded(
                child: OsmeaComponents.text(
                  title,
                  textStyle: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: OsmeaColors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 6),
          SizedBox(
            height: 32,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: OsmeaComponents.text(
                value,
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: OsmeaColors.black,
                ),
                maxLines: 1,
              ),
            ),
          ),
          if (hasChart) ...[
            OsmeaComponents.sizedBox(height: 6),
            ClipRect(
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: 28,
                width: double.infinity,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: chartValues.fold(0.0, (a, b) => a > b ? a : b) + 1,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: chartValues.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value,
                            color: color,
                            width: 6,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2),
                            ),
                          ),
                        ],
                        showingTooltipIndicators: [],
                      );
                    }).toList(),
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatAxisValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}k';
    }
    return value.toInt().toString();
  }

  /// Wraps a chart so it has at least [minWidth]. On narrow screens, the chart can be scrolled horizontally with a visible scrollbar.
  Widget _buildScrollableChart(
    BuildContext context, {
    required double minWidth,
    double? minHeight,
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > minWidth
            ? constraints.maxWidth
            : minWidth;
        final needHorizontal =
            constraints.maxWidth.isFinite && constraints.maxWidth < minWidth;
        final needVertical =
            minHeight != null &&
            constraints.maxHeight.isFinite &&
            constraints.maxHeight < minHeight;
        Widget content = child;
        if (needVertical) {
          content = SizedBox(
            height: constraints.maxHeight,
            child: _ChartScrollbar(
              scrollDirection: Axis.vertical,
              minExtent: minHeight,
              child: content,
            ),
          );
        }
        if (needHorizontal) {
          content = _ChartScrollbar(
            scrollDirection: Axis.horizontal,
            minExtent: width,
            child: content,
          );
        }
        return content;
      },
    );
  }

  Widget _buildDailyChart(
    BuildContext context,
    AdminDashboardLoadedState state,
  ) {
    final list = state.dailyChartData;
    if (list.isEmpty) return const SizedBox.shrink();
    final maxRevenue = list
        .map((e) => e.revenue)
        .fold(0.0, (a, b) => a > b ? a : b);
    final maxY = (maxRevenue > 0 ? maxRevenue * 1.15 : 10.0).clamp(
      10.0,
      double.infinity,
    );

    return BlocBuilder<CurrencyCubit, String>(
      builder: (context, currency) {
        const chartHeight = 220.0;
        const bottomReserved = 52.0;
        const topPadding = 24.0;
        const leftReserved = 56.0;
        final totalChartHeight = chartHeight + bottomReserved + topPadding;

        return OsmeaComponents.container(
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: OsmeaColors.silver.withOpacity(0.4)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.text(
                  context.resources.dailyRevenue,
                  textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: OsmeaColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                OsmeaComponents.sizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final chartWidth =
                        (constraints.maxWidth.isFinite &&
                            constraints.maxWidth > 0)
                        ? constraints.maxWidth
                        : 480.0;
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: chartWidth,
                        minHeight: totalChartHeight + 24,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: SizedBox(
                            width: chartWidth,
                            height: totalChartHeight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: ClipRect(
                                clipBehavior: Clip.hardEdge,
                                child: BarChart(
                                  BarChartData(
                                    minY: 0,
                                    maxY: maxY,
                                    alignment: BarChartAlignment.spaceAround,
                                    barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        getTooltipColor: (group) =>
                                            OsmeaColors.black,
                                        fitInsideHorizontally: true,
                                        fitInsideVertically: true,
                                        tooltipPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                        tooltipMargin: 10,
                                        maxContentWidth: 130,
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
                                              final p = list[group.x];
                                              return BarTooltipItem(
                                                '${PriceHelper.format(p.revenue, currency, Localizations.localeOf(context).toString())}\n${p.orderCount} ${context.resources.ordersShort}',
                                                Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color:
                                                              OsmeaColors.white,
                                                          fontSize: 12,
                                                        ) ??
                                                    const TextStyle(
                                                      color: OsmeaColors.white,
                                                      fontSize: 12,
                                                    ),
                                              );
                                            },
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: bottomReserved,
                                          getTitlesWidget: (value, meta) {
                                            final i = value.toInt();
                                            if (i >= 0 && i < list.length) {
                                              final p = list[i];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                child: OsmeaComponents.column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    OsmeaComponents.text(
                                                      DateFormat(
                                                        'd/M',
                                                      ).format(p.day),
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                color:
                                                                    OsmeaColors
                                                                        .black,
                                                                fontSize: 11,
                                                              ),
                                                    ),
                                                    OsmeaComponents.sizedBox(
                                                      height: 2,
                                                    ),
                                                    OsmeaComponents.text(
                                                      '${p.orderCount} ${context.resources.ordersShort}',
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                color:
                                                                    OsmeaColors
                                                                        .thunder,
                                                                fontSize: 10,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                          interval: 1,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: leftReserved,
                                          getTitlesWidget: (value, meta) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: OsmeaComponents.text(
                                                _formatAxisValue(value),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: OsmeaColors.black,
                                                      fontSize: 10,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      horizontalInterval: maxY > 0
                                          ? (maxY / 4).clamp(
                                              1.0,
                                              double.infinity,
                                            )
                                          : 1,
                                      getDrawingHorizontalLine: (value) =>
                                          FlLine(
                                            color: OsmeaColors.silver
                                                .withOpacity(0.2),
                                            strokeWidth: 1,
                                          ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        left: BorderSide(
                                          color: OsmeaColors.silver.withOpacity(
                                            0.6,
                                          ),
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: OsmeaColors.silver.withOpacity(
                                            0.6,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    barGroups: List.generate(list.length, (i) {
                                      final p = list[i];
                                      return BarChartGroupData(
                                        x: i,
                                        barRods: [
                                          BarChartRodData(
                                            toY: p.revenue.clamp(0.0, maxY),
                                            color: OsmeaColors.black,
                                            width:
                                                (chartWidth /
                                                        list.length *
                                                        0.42)
                                                    .clamp(12.0, 26.0),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(4),
                                                ),
                                          ),
                                        ],
                                        showingTooltipIndicators: [0],
                                      );
                                    }),
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniBarChart(
    BuildContext context, {
    required String title,
    required List<int> values,
    required int maxValue,
  }) {
    if (values.isEmpty) return const SizedBox.shrink();
    final maxY = (maxValue > 0 ? maxValue * 1.1 : 1).toDouble();
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            title,
            textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: OsmeaColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i >= 0 && i < values.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: OsmeaComponents.text(
                              '${i + 1}. ${context.resources.dayAbbr}',
                              textStyle: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: OsmeaColors.black,
                                    fontSize: 10,
                                  ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) => OsmeaComponents.text(
                        value.toInt().toString(),
                        textStyle: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: OsmeaColors.black, fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: OsmeaColors.silver.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: values
                    .asMap()
                    .entries
                    .map(
                      (e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.toDouble(),
                            color: OsmeaColors.black,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
                            ),
                          ),
                        ],
                        showingTooltipIndicators: [],
                      ),
                    )
                    .toList(),
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(BuildContext context, Color color, String label) {
    return OsmeaComponents.row(
      children: [
        OsmeaComponents.container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        OsmeaComponents.sizedBox(width: 6),
        OsmeaComponents.text(
          label,
          textStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: OsmeaColors.black),
        ),
      ],
    );
  }

  Widget _buildOrdersByStatusChart(
    BuildContext context,
    AdminDashboardLoadedState state,
  ) {
    final list = state.ordersByStatus;
    if (list.isEmpty) return const SizedBox.shrink();

    final colors = [
      OsmeaColors.black,
      OsmeaColors.eclipse,
      OsmeaColors.shark,
      OsmeaColors.thunder,
      OsmeaColors.slate,
    ];

    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 36,
                    sections: List.generate(list.length, (i) {
                      final p = list[i];
                      return PieChartSectionData(
                        value: p.share * 100,
                        title: '${p.count}',
                        color: colors[i % colors.length],
                        radius: 52,
                        titleStyle: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(
                              color: OsmeaColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                      );
                    }),
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ),
          ),
          OsmeaComponents.sizedBox(width: 20),
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: list.asMap().entries.map((e) {
                final i = e.key;
                final p = e.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildChartLegend(
                    context,
                    colors[i % colors.length],
                    '${p.status}: ${p.count}',
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return OsmeaComponents.text(
      title,
      textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: OsmeaColors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context, List<Order> orders) {
    final resources = context.resources;
    if (orders.isEmpty) {
      return OsmeaComponents.center(
        child: OsmeaComponents.text(
          resources.noRecentOrders,
          textStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: OsmeaColors.black),
        ),
      );
    }
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        children: orders.map((order) {
          return OsmeaComponents.listItem(
            title: OsmeaComponents.text(
              '${resources.orderNumber}${order.orderNumber}',
              textStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: OsmeaColors.black),
            ),
            subtitle: OsmeaComponents.text(
              order.user?.username ?? order.user?.fullName ?? resources.guest,
              textStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: OsmeaColors.black),
            ),
            trailing: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<CurrencyCubit, String>(
                  builder: (context, currency) {
                    return OsmeaComponents.text(
                      PriceHelper.format(
                        order.total,
                        currency,
                        Localizations.localeOf(context).toString(),
                      ),
                      textStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: OsmeaColors.black),
                    );
                  },
                ),
                OsmeaComponents.text(
                  order.status,
                  textStyle: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: OsmeaColors.black),
                ),
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
      return OsmeaComponents.center(
        child: OsmeaComponents.text(
          resources.noNewUsers,
          textStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: OsmeaColors.black),
        ),
      );
    }
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: OsmeaComponents.column(
        children: users.map((user) {
          final displayName =
              user.username ?? user.fullName ?? user.email ?? 'User';
          final initial = displayName.isNotEmpty
              ? displayName.substring(0, 1).toUpperCase()
              : '?';
          return OsmeaComponents.listItem(
            leading: OsmeaComponents.avatar(
              size: ComponentSize.medium,
              imageUrl: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                  ? user.avatarUrl
                  : null,
              text: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                  ? initial
                  : null,
              backgroundColor:
                  (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                  ? OsmeaColors.black
                  : null,
            ),
            title: OsmeaComponents.text(
              displayName,
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: OsmeaColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: OsmeaComponents.text(
              '${resources.joined} ${DateFormat.yMMMd().format(user.createdAt)}',
              textStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: OsmeaColors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Horizontal scroll with a visible scrollbar (rules: OsmeaColors).
class _ChartScrollbar extends StatefulWidget {
  const _ChartScrollbar({
    required this.scrollDirection,
    required this.minExtent,
    required this.child,
  });

  final Axis scrollDirection;
  final double minExtent;
  final Widget child;

  @override
  State<_ChartScrollbar> createState() => _ChartScrollbarState();
}

class _ChartScrollbarState extends State<_ChartScrollbar> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal = widget.scrollDirection == Axis.horizontal;
    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all(true),
          thickness: MaterialStateProperty.all(8),
          radius: const Radius.circular(4),
          thumbColor: MaterialStateProperty.all(
            OsmeaColors.black.withOpacity(0.5),
          ),
          trackColor: MaterialStateProperty.all(
            OsmeaColors.silver.withOpacity(0.2),
          ),
        ),
      ),
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        thickness: 8,
        radius: const Radius.circular(4),
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: widget.scrollDirection,
          physics: const BouncingScrollPhysics(),
          child: isHorizontal
              ? SizedBox(width: widget.minExtent, child: widget.child)
              : SizedBox(height: widget.minExtent, child: widget.child),
        ),
      ),
    );
  }
}
