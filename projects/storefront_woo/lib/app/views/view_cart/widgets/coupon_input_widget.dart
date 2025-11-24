/*
 * Coupon Input Widget
 * -------------------
 * Widget for entering and applying coupon codes.
 * Uses OsmeaComponents.textField's built-in TextFieldCubit for state management.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';

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
                return OsmeaComponents.textButton(
                  text: 'Apply',
                  onPressed: () => _applyCoupon(context, state.currentValue),
                  size: ButtonSize.small,
                  variant: ButtonVariant.primary,
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
      // OsmeaComponents.textField'ın kendi oluşturduğu TextFieldCubit'e eriş
      final cubit = context.read<TextFieldCubit>();
      cubit.clear();
    }
  }
}
