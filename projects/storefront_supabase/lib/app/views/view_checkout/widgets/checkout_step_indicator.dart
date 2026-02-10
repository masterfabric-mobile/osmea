/*
 * CheckoutStepIndicator
 * ---------------------
 * Horizontal step indicator: Address -> Shipping -> Payment -> Summary
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/views/view_checkout/models/states.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final CheckoutStep currentStep;
  final bool isAddressValid;
  final bool isShippingValid;
  final bool isPaymentValid;
  final void Function(CheckoutStep)? onStepTapped;

  const CheckoutStepIndicator({
    super.key,
    required this.currentStep,
    this.isAddressValid = false,
    this.isShippingValid = false,
    this.isPaymentValid = false,
    this.onStepTapped,
  });

  bool _completed(CheckoutStep step) {
    switch (step) {
      case CheckoutStep.address:
        return isAddressValid && currentStep.index > 0;
      case CheckoutStep.shipping:
        return isShippingValid && currentStep.index > 1;
      case CheckoutStep.payment:
        return isPaymentValid && currentStep.index > 2;
      case CheckoutStep.summary:
        return false;
    }
  }

  bool _canTap(CheckoutStep step) {
    if (step.index >= currentStep.index) return false;
    if (step == CheckoutStep.shipping) return isAddressValid;
    if (step == CheckoutStep.payment) return isAddressValid && isShippingValid;
    if (step == CheckoutStep.summary) return isAddressValid && isShippingValid && isPaymentValid;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      (CheckoutStep.address, context.resources.stepAddress, Icons.location_on_outlined),
      (CheckoutStep.shipping, context.resources.stepShipping, Icons.local_shipping_outlined),
      (CheckoutStep.payment, context.resources.stepPayment, Icons.payment_outlined),
      (CheckoutStep.summary, context.resources.stepSummary, Icons.receipt_long_outlined),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing12),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        border: Border(bottom: BorderSide(color: OsmeaColors.pewter.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0)
              Padding(
                padding: EdgeInsets.only(bottom: context.spacing16),
                child: SizedBox(
                  width: 16,
                  height: 2,
                  child: Container(
                    color: _completed(steps[i - 1].$1) ? OsmeaColors.black : OsmeaColors.pewter.withValues(alpha: 0.3),
                  ),
                ),
              ),
            Expanded(
              child: _StepChip(
                label: steps[i].$2,
                icon: steps[i].$3,
                isActive: currentStep == steps[i].$1,
                isCompleted: _completed(steps[i].$1),
                onTap: _canTap(steps[i].$1) && onStepTapped != null
                    ? () => onStepTapped!(steps[i].$1)
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _StepChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? OsmeaColors.green
        : isActive
            ? OsmeaColors.black
            : OsmeaColors.pewter;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCompleted || isActive ? color : color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check_rounded, color: OsmeaColors.white, size: 18)
                  : Icon(icon, color: isActive || isCompleted ? OsmeaColors.white : color, size: 18),
            ),
          ),
          SizedBox(height: context.spacing4),
          Text(
            label,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
