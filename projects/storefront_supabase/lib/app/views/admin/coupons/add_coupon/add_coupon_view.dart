import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/views/admin/coupons/add_coupon/models/module/states.dart';
import 'package:storefront_supabase/app/views/admin/coupons/add_coupon/models/add_coupon_view_model.dart';

class AddCouponView extends MasterViewCubit<AddCouponViewModel, AddCouponState> {
  AddCouponView({
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
              'Manage Coupon',
              color: OsmeaColors.black,
            ),
            variant: AppBarVariant.primary,
            backgroundColor: OsmeaColors.white,
            foregroundColor: OsmeaColors.black,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.go('/admin/coupons'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );

  @override
  void initialContent(AddCouponViewModel viewModel, BuildContext context) {
    final couponId = arguments['couponId'] as String?;
    viewModel.initial(couponId: couponId);
  }

  @override
  Widget viewContent(
      BuildContext context, AddCouponViewModel viewModel, AddCouponState state) {
    
    if (state is AddCouponLoading) {
      return const Center(child: CircularProgressIndicator(color: OsmeaColors.black));
    }

    if (state is AddCouponSuccess) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: OsmeaColors.forestHeart),
            const SizedBox(height: 16),
            const Text('Coupon saved successfully!'),
            const SizedBox(height: 24),
            OsmeaComponents.button(
              text: 'Back to List',
              onPressed: () => context.go('/admin/coupons'),
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
            ),
          ],
        ),
      );
    }

    if (state is AddCouponError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: OsmeaColors.black),
            const SizedBox(height: 16),
            Text(state.message),
            const SizedBox(height: 24),
            OsmeaComponents.button(
              text: 'Retry',
              onPressed: () {
                 final couponId = arguments['couponId'] as String?;
                 viewModel.initial(couponId: couponId);
              },
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
            ),
          ],
        ),
      );
    }

    if (state is AddCouponLoaded) {
      final couponId = arguments['couponId'] as String?;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                color: OsmeaColors.silver,
                child: Text(state.errorMessage!, style: TextStyle(color: OsmeaColors.black)),
              ),

            _buildTextField(viewModel.codeController, 'Coupon Code', Icons.confirmation_number),
            const SizedBox(height: 16),
            
            // Discount Type Dropdown
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: viewModel.discountType,
              decoration: const InputDecoration(
                labelText: 'Discount Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category, color: OsmeaColors.black),
              ),
              items: const [
                DropdownMenuItem(value: 'percentage', child: Text('Percentage (%)')),
                DropdownMenuItem(value: 'fixed_amount', child: Text('Fixed Amount (\$)')),
              ],
              onChanged: (val) => viewModel.setDiscountType(val),
            ),
            const SizedBox(height: 16),

            _buildTextField(viewModel.valueController, 'Discount Value', Icons.money, keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            _buildTextField(viewModel.minPurchaseController, 'Min. Purchase (Optional)', Icons.shopping_cart_outlined, keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            _buildTextField(viewModel.usageLimitController, 'Usage Limit (Optional)', Icons.people_outline, keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            // Date Picker
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: viewModel.expiryDate ?? DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: OsmeaColors.black, // Header background color
                          onPrimary: OsmeaColors.white, // Header text color
                          onSurface: OsmeaColors.black, // Body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: OsmeaColors.black, // Button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  // Trigger UI update logic if needed, or rely on hot reload/build cycle. 
                  // Since view model stores state but doesn't emit new state for field changes (classic controller pattern),
                  // we might need setState for the date text to update or emit a new Loaded state.
                  // For simplicity in this architecture, calling setState here is easiest if we were Stateful,
                  // but we are in MasterViewCubit. The right way is emitting Loaded state or using StatefulBuilder.
                  // Let's assume view updates on tap or we force a rebuild.
                  viewModel.setExpiryDate(picked);
                  // Force rebuild to show new date (hacky but works for this structure)
                  (context as Element).markNeedsBuild();
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today, color: OsmeaColors.black),
                ),
                child: Text(
                  viewModel.expiryDate != null 
                      ? DateFormat.yMMMd().format(viewModel.expiryDate!) 
                      : 'Select Date',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Active Switch
            SwitchListTile(
              title: const Text('Is Active'),
              value: viewModel.isActive,
              // ignore: deprecated_member_use
              activeColor: OsmeaColors.black,
              onChanged: (val) {
                viewModel.toggleActive(val);
                (context as Element).markNeedsBuild();
              },
            ),

            const SizedBox(height: 32),
            OsmeaComponents.button(
              text: 'Save Coupon',
              onPressed: () => viewModel.saveCoupon(couponId: couponId),
              variant: ButtonVariant.primary,
              fullWidth: true,
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: OsmeaColors.black),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: OsmeaColors.black, width: 2),
        ),
        labelStyle: const TextStyle(color: OsmeaColors.black),
      ),
      cursorColor: OsmeaColors.black,
    );
  }
}
