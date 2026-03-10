import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_reports_service.dart'
    show AdminReportsService, DailyChartPoint, OrdersByStatusPoint;
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AdminReportsView extends StatefulWidget {
  const AdminReportsView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  static const List<int> _daysOptions = [7, 14, 30];
  int _selectedDays = 7;
  late Future<_ReportsSnapshot> _reportsFuture;

  AdminReportsService get _reportsService => getIt<AdminReportsService>();

  @override
  void initState() {
    super.initState();
    _reportsFuture = _loadReports(_selectedDays);
  }

  Future<_ReportsSnapshot> _loadReports(int days) async {
    final results = await Future.wait<dynamic>([
      _reportsService.getTotalRevenue(),
      _reportsService.getOrderCount(),
      _reportsService.getUserCount(),
      _reportsService.getProductCount(),
      _reportsService.getDailyChartData(days),
      _reportsService.getOrdersByStatus(),
    ]);
    return _ReportsSnapshot(
      totalRevenue: results[0] as double,
      orderCount: results[1] as int,
      userCount: results[2] as int,
      productCount: results[3] as int,
      dailyChartData: results[4] as List<DailyChartPoint>,
      ordersByStatus: results[5] as List<OrdersByStatusPoint>,
    );
  }

  void _onDaysChanged(int? days) {
    if (days == null || days == _selectedDays) return;
    setState(() {
      _selectedDays = days;
      _reportsFuture = _loadReports(days);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          'Reports',
          color: OsmeaColors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => widget.goRoute(AdminRoutes.dashboard),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _reportsFuture = _loadReports(_selectedDays);
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: context.paddingNormal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OsmeaComponents.row(
                children: [
                  OsmeaComponents.text(
                    'Period:',
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: OsmeaColors.black,
                        ),
                  ),
                  OsmeaComponents.sizedBox(width: 12),
                  DropdownButton<int>(
                    value: _selectedDays,
                    items: _daysOptions
                        .map((d) => DropdownMenuItem(value: d, child: Text('Last $d days')))
                        .toList(),
                    onChanged: _onDaysChanged,
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 16),
              FutureBuilder<_ReportsSnapshot>(
                future: _reportsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return OsmeaComponents.center(
                      child: OsmeaComponents.loading(
                        type: LoadingType.circularFade,
                        size: 36,
                        color: OsmeaColors.black,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return OsmeaComponents.center(
                      child: OsmeaComponents.text(
                        '${resources.errorPrefix}${snapshot.error}',
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                      ),
                    );
                  }
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStatsGrid(context, data, resources),
                      OsmeaComponents.sizedBox(height: 24),
                      if (data.dailyChartData.isNotEmpty) ...[
                        OsmeaComponents.text(
                          resources.last7DaysRevenueOrders,
                          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: OsmeaColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        OsmeaComponents.sizedBox(height: 8),
                        _buildDailyTable(context, data.dailyChartData, resources),
                        OsmeaComponents.sizedBox(height: 24),
                      ],
                      if (data.ordersByStatus.isNotEmpty) ...[
                        OsmeaComponents.text(
                          resources.orderStatuses,
                          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: OsmeaColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        OsmeaComponents.sizedBox(height: 8),
                        _buildOrdersByStatusList(context, data.ordersByStatus),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, _ReportsSnapshot data, dynamic resources) {
    return BlocBuilder<CurrencyCubit, String>(
      builder: (context, currency) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: resources.totalRevenue,
                    value: PriceHelper.format(
                      data.totalRevenue,
                      currency,
                      Localizations.localeOf(context).toString(),
                    ),
                    icon: Icons.monetization_on,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: resources.totalOrders,
                    value: data.orderCount.toString(),
                    icon: Icons.shopping_cart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: resources.totalUsers,
                    value: data.userCount.toString(),
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: resources.totalProducts,
                    value: data.productCount.toString(),
                    icon: Icons.inventory_2,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: OsmeaColors.black, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: OsmeaComponents.text(
                  title,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          OsmeaComponents.text(
            value,
            textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: OsmeaColors.black,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTable(
    BuildContext context,
    List<DailyChartPoint> data,
    dynamic resources,
  ) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: BlocBuilder<CurrencyCubit, String>(
        builder: (context, currency) {
          return Table(
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: OsmeaColors.silver.withOpacity(0.2)),
                children: [
                  _tableCell(context, 'Date', isHeader: true),
                  _tableCell(context, 'Revenue', isHeader: true),
                  _tableCell(context, resources.ordersShort, isHeader: true),
                ],
              ),
              ...data.map((e) => TableRow(
                    children: [
                      _tableCell(context, DateFormat('d MMM y').format(e.day)),
                      _tableCell(context, PriceHelper.format(e.revenue, currency, Localizations.localeOf(context).toString())),
                      _tableCell(context, e.orderCount.toString()),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _tableCell(BuildContext context, String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: OsmeaComponents.text(
        text,
        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isHeader ? OsmeaColors.black : OsmeaColors.thunder,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
            ),
      ),
    );
  }

  Widget _buildOrdersByStatusList(BuildContext context, List<OrdersByStatusPoint> data) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: data
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OsmeaComponents.text(
                        e.status,
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.black),
                      ),
                      OsmeaComponents.text(
                        '${e.count}',
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: OsmeaColors.black,
                            ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _ReportsSnapshot {
  final double totalRevenue;
  final int orderCount;
  final int userCount;
  final int productCount;
  final List<DailyChartPoint> dailyChartData;
  final List<OrdersByStatusPoint> ordersByStatus;

  _ReportsSnapshot({
    required this.totalRevenue,
    required this.orderCount,
    required this.userCount,
    required this.productCount,
    required this.dailyChartData,
    required this.ordersByStatus,
  });
}
