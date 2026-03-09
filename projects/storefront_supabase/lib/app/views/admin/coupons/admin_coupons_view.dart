import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/views/admin/coupons/models/module/states.dart';
import 'package:storefront_supabase/app/views/admin/coupons/models/coupons_view_model.dart';

class AdminCouponsView extends MasterViewCubit<AdminCouponsViewModel, AdminCouponsState> {
  AdminCouponsView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
  }) : super(
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              'Coupons', // Localize later
              color: OsmeaColors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: OsmeaColors.white,
            foregroundColor: OsmeaColors.black,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.go('/admin/dashboard'),
              icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
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
      return OsmeaComponents.center(
        child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        size: 36,
        color: OsmeaColors.black,
      ),
      );
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
          padding: context.paddingNormal,
          itemCount: state.coupons.length,
          itemBuilder: (context, index) {
            final coupon = state.coupons[index];
            return OsmeaComponents.basicCard(
              margin: EdgeInsets.only(bottom: context.spacing12),
              customContent: OsmeaComponents.listItem(
                onTap: () => context.go('/admin/coupons/edit/${coupon.id}'),
                title: OsmeaComponents.text(
                  coupon.code,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      '${coupon.discountType == 'percentage' ? '%' : '\$'}${coupon.discountValue} Off',
                    ),
                    if (coupon.expiryDate != null)
                      OsmeaComponents.text(
                        'Expires: ${DateFormat.yMMMd().format(coupon.expiryDate!)}',
                        textStyle: TextStyle(color: OsmeaColors.slate, fontSize: 12),
                      ),
                    OsmeaComponents.text(
                      'Status: ${coupon.isActive ? "Active" : "Inactive"}',
                      textStyle: TextStyle(
                        color: coupon.isActive ? OsmeaColors.black : OsmeaColors.pewter,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                trailing: OsmeaComponents.iconButton(
                  icon: const Icon(Icons.delete_outline, color: OsmeaColors.black),
                  onPressed: () => _confirmDelete(context, viewModel, coupon.id),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: OsmeaColors.black,
          foregroundColor: OsmeaColors.white,
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
            Icon(Icons.confirmation_number_outlined, size: 64, color: OsmeaColors.pewter),
            const SizedBox(height: 16),
            const Text('No coupons found'),
            const SizedBox(height: 24),
            OsmeaComponents.button(
              text: 'Add Coupon',
              onPressed: () => goRoute('/admin/coupons/add'),
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminCouponsViewModel viewModel, String id) {
    OsmeaComponents.showPopup(
      context: context,
      title: 'Delete Coupon',
      child: OsmeaComponents.text('Are you sure you want to delete this coupon?'),
      footer: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OsmeaComponents.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            variant: ButtonVariant.ghost,
          ),
          OsmeaComponents.sizedBox(width: 12),
          OsmeaComponents.textButton(
            text: 'Delete',
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteCoupon(id);
            },
            variant: ButtonVariant.danger,
          ),
        ],
      ),
    );
  }
}
