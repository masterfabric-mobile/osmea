import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/views/admin/coupons/models/states.dart';
import 'package:storefront_supabase/app/views/admin/coupons/models/view_model.dart';

class AdminCouponsView extends MasterViewCubit<AdminCouponsViewModel, AdminCouponsState> {
  AdminCouponsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              'Coupons', // Localize later
              color: Colors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.go('/admin/dashboard'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );

  @override
  void initialContent(AdminCouponsViewModel viewModel, BuildContext context) {
    viewModel.fetchCoupons();
  }

  @override
  Widget viewContent(
      BuildContext context, AdminCouponsViewModel viewModel, AdminCouponsState state) {
    if (state is AdminCouponsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminCouponsError) {
      return OsmeaComponents.center(child: OsmeaComponents.text(state.message));
    }

    if (state is AdminCouponsLoaded) {
      if (state.coupons.isEmpty) {
        return _buildEmptyState(context);
      }

      return OsmeaComponents.scaffold(
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.coupons.length,
          itemBuilder: (context, index) {
            final coupon = state.coupons[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${coupon.discountType == 'percentage' ? '%' : '\$'}${coupon.discountValue} Off'),
                    if (coupon.expiryDate != null)
                      Text('Expires: ${DateFormat.yMMMd().format(coupon.expiryDate!)}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('Status: ${coupon.isActive ? "Active" : "Inactive"}',
                        style: TextStyle(color: coupon.isActive ? Colors.green : Colors.red, fontSize: 12)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.black),
                  onPressed: () => _confirmDelete(context, viewModel, coupon.id),
                ),
                onTap: () => context.go('/admin/coupons/edit/${coupon.id}'),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () => context.go('/admin/coupons/add'),
          child: const Icon(Icons.add),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(BuildContext context) {
    return OsmeaComponents.scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.confirmation_number_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No coupons found'),
            const SizedBox(height: 24),
            OsmeaComponents.button(
              text: 'Add Coupon',
              onPressed: () => goRoute('/admin/coupons/add'),
              backgroundColor: Colors.black,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminCouponsViewModel viewModel, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Coupon'),
        content: const Text('Are you sure you want to delete this coupon?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              viewModel.deleteCoupon(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
