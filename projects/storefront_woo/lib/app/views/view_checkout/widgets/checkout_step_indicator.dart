/*
 * CheckoutStepIndicator
 * ---------------------
 * A horizontal step indicator showing progress through checkout steps.
 * Steps: Address -> Shipping -> Payment -> Summary
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final CheckoutStep currentStep;
  final bool isAddressValid;
  final bool isShippingValid;
  final bool isPaymentValid;
  final Function(CheckoutStep)? onStepTapped;

  const CheckoutStepIndicator({
    super.key,
    required this.currentStep,
    this.isAddressValid = false,
    this.isShippingValid = false,
    this.isPaymentValid = false,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    return OsmeaComponents.container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing12,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(configHelper),
        border: Border(
          bottom: BorderSide(
            color: _getBorderColor(configHelper),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Step 1: Address
          Expanded(
            child: _buildStep(
              context,
              configHelper,
              step: CheckoutStep.address,
              icon: Icons.location_on_outlined,
              label: context.t.checkoutView.steps.address,
              isActive: currentStep == CheckoutStep.address,
              isCompleted: _isStepCompleted(CheckoutStep.address),
              canTap: true, // Always can go back to address
            ),
          ),
          
          // Connector 1-2
          _buildConnector(
            context,
            configHelper,
            isCompleted: _isStepCompleted(CheckoutStep.address),
          ),
          
          // Step 2: Shipping
          Expanded(
            child: _buildStep(
              context,
              configHelper,
              step: CheckoutStep.shipping,
              icon: Icons.local_shipping_outlined,
              label: context.t.checkoutView.steps.shipping,
              isActive: currentStep == CheckoutStep.shipping,
              isCompleted: _isStepCompleted(CheckoutStep.shipping),
              canTap: isAddressValid,
            ),
          ),
          
          // Connector 2-3
          _buildConnector(
            context,
            configHelper,
            isCompleted: _isStepCompleted(CheckoutStep.shipping),
          ),
          
          // Step 3: Payment
          Expanded(
            child: _buildStep(
              context,
              configHelper,
              step: CheckoutStep.payment,
              icon: Icons.payment_outlined,
              label: context.t.checkoutView.steps.payment,
              isActive: currentStep == CheckoutStep.payment,
              isCompleted: _isStepCompleted(CheckoutStep.payment),
              canTap: isAddressValid && isShippingValid,
            ),
          ),
          
          // Connector 3-4
          _buildConnector(
            context,
            configHelper,
            isCompleted: _isStepCompleted(CheckoutStep.payment),
          ),
          
          // Step 4: Summary
          Expanded(
            child: _buildStep(
              context,
              configHelper,
              step: CheckoutStep.summary,
              icon: Icons.receipt_long_outlined,
              label: context.t.checkoutView.steps.summary,
              isActive: currentStep == CheckoutStep.summary,
              isCompleted: false, // Summary is never "completed" until order is placed
              canTap: isAddressValid && isShippingValid && isPaymentValid,
            ),
          ),
        ],
      ),
    );
  }

  bool _isStepCompleted(CheckoutStep step) {
    switch (step) {
      case CheckoutStep.address:
        return isAddressValid && currentStep.index > CheckoutStep.address.index;
      case CheckoutStep.shipping:
        return isShippingValid && currentStep.index > CheckoutStep.shipping.index;
      case CheckoutStep.payment:
        return isPaymentValid && currentStep.index > CheckoutStep.payment.index;
      case CheckoutStep.summary:
        return false; // Summary step is "completed" when order is placed
    }
  }

  Widget _buildStep(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required CheckoutStep step,
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isCompleted,
    required bool canTap,
  }) {
    final activeColor = _getActiveColor(configHelper);
    final completedColor = _getCompletedColor(configHelper);
    final inactiveColor = _getInactiveColor(configHelper);
    
    final Color circleColor;
    final Color iconColor;
    final Color textColor;
    
    if (isCompleted) {
      circleColor = completedColor;
      iconColor = OsmeaColors.white;
      textColor = completedColor;
    } else if (isActive) {
      circleColor = activeColor;
      iconColor = OsmeaColors.white;
      textColor = activeColor;
    } else {
      circleColor = inactiveColor.withOpacity(0.3);
      iconColor = inactiveColor;
      textColor = inactiveColor;
    }

    return GestureDetector(
      onTap: canTap && onStepTapped != null ? () => onStepTapped!(step) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle with icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      color: iconColor,
                      size: 20,
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
            ),
          ),
          
          SizedBox(height: context.spacing4),
          
          // Label
          Text(
            label,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: textColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required bool isCompleted,
  }) {
    final activeColor = _getActiveColor(configHelper);
    final inactiveColor = _getInactiveColor(configHelper);
    
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing16),
      child: SizedBox(
        width: 24,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 2,
          decoration: BoxDecoration(
            color: isCompleted ? activeColor : inactiveColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(AssetConfigHelper configHelper) {
    return _parseColor(
      configHelper.getString(
        'checkout_view_configuration.step_indicator.background_color',
        '#FFFFFF',
      ),
    );
  }

  Color _getBorderColor(AssetConfigHelper configHelper) {
    return _parseColor(
      configHelper.getString(
        'checkout_view_configuration.step_indicator.border_color',
        '#E5E5E5',
      ),
    );
  }

  Color _getActiveColor(AssetConfigHelper configHelper) {
    return _parseColor(
      configHelper.getString(
        'checkout_view_configuration.step_indicator.active_color',
        '#000000',
      ),
    );
  }

  Color _getCompletedColor(AssetConfigHelper configHelper) {
    return _parseColor(
      configHelper.getString(
        'checkout_view_configuration.step_indicator.completed_color',
        '#4CAF50',
      ),
    );
  }

  Color _getInactiveColor(AssetConfigHelper configHelper) {
    return _parseColor(
      configHelper.getString(
        'checkout_view_configuration.step_indicator.inactive_color',
        '#9E9E9E',
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      debugPrint('⚠️ Error parsing color: $colorString');
    }
    return OsmeaColors.black;
  }
}
