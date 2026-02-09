/*
 * Coupon Input Widget
 * -------------------
 * Widget for entering and applying coupon codes.
 * Uses OsmeaComponents.textField's built-in TextFieldCubit for state management.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart';

/// Widget for coupon code input
class CouponInputWidget extends StatelessWidget {
  final CartViewModel viewModel;

  const CouponInputWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TextFieldCubit(onSubmitted: (value) => _applyCoupon(context, value)),
      child: OsmeaComponents.container(
        margin: EdgeInsets.symmetric(horizontal: context.spacing16),
        child: OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: BlocBuilder<TextFieldCubit, TextFieldCubitState>(
                builder: (context, state) {
                  final cubit = context.read<TextFieldCubit>();
                  return OsmeaComponents.textField(
                    controller: cubit.effectiveController,
                    hint: 'Discount code',
                    variant: TextFieldVariant.outlined,
                    size: TextFieldSize.medium,
                    prefixIcon: Icon(
                      Icons.local_offer_outlined,
                      color: OsmeaColors.pewter,
                      size: context.iconSizeSmall,
                    ),
                    onSubmitted: (value) => _applyCoupon(context, value),
                  );
                },
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            BlocBuilder<TextFieldCubit, TextFieldCubitState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () => _applyCoupon(context, state.currentValue),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing12,
                      vertical: context.spacing8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: OsmeaComponents.text(
                    'Apply',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _applyCoupon(BuildContext context, String value) {
    final couponCode = value.trim();
    if (couponCode.isNotEmpty) {
      viewModel.applyCoupon(couponCode);
      // Access the TextFieldCubit created by OsmeaComponents.textField
      final cubit = context.read<TextFieldCubit>();
      cubit.clear();
    }
  }
}
