/*
 * Product Detail Error Widget
 * ---------------------------
 * Minimalist black & white error widget for product detail view.
 * Clean, simple, and consistent with app design.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Minimalist error widget for product detail view
class ProductDetailErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProductDetailErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  /// Checks if error indicates product not found
  bool _isProductNotFound(String errorMessage) {
    final lowerMessage = errorMessage.toLowerCase();
    return lowerMessage.contains('not found') ||
        lowerMessage.contains('404') ||
        lowerMessage.contains('product not found') ||
        lowerMessage.contains('does not exist');
  }

  @override
  Widget build(BuildContext context) {
    final isNotFound = _isProductNotFound(message);
    final configHelper = AssetConfigHelper();
    final backgroundColor = _parseColor(
      configHelper.getString(
        'error_handling_configuration.background_color',
        '#FFFFFF',
      ),
    );

    return OsmeaComponents.container(
      color: backgroundColor,
      child: OsmeaComponents.center(
        child: OsmeaComponents.singleChildScrollView(
          padding: context.paddingHigh,
          child: OsmeaComponents.column(
            mainAxisAlignment: context.centerMain,
            crossAxisAlignment: context.crossCenter,
            children: [
              // Simple icon
              _buildErrorIcon(
                context,
                isNotFound ? Icons.search_off : Icons.error_outline,
              ),
              
              OsmeaComponents.sizedBox(height: context.spacing32),
              
              // Error message
              OsmeaComponents.text(
                message,
                textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                  color: _getTextColor(context),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
              
              OsmeaComponents.sizedBox(height: context.spacing48),
              
              // Retry button (hide if product not found)
              if (!isNotFound) ...[
                _buildRetryButton(context),
                OsmeaComponents.sizedBox(height: context.spacing12),
              ],
              
              // Go back button
              _buildGoBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds error icon with config colors
  Widget _buildErrorIcon(BuildContext context, IconData iconData) {
    final configHelper = AssetConfigHelper();
    final iconColor = _parseColor(
      configHelper.getString(
        'error_handling_configuration.icon_color',
        '#000000',
      ),
    );
    final borderColor = _parseColor(
      configHelper.getString(
        'error_handling_configuration.icon_border_color',
        '#000000',
      ),
    );

    return OsmeaComponents.container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: OsmeaComponents.center(
        child: Icon(
          iconData,
          size: 40,
          color: iconColor,
        ),
      ),
    );
  }

  /// Gets text color from config
  Color _getTextColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'error_handling_configuration.text_color',
        '#000000',
      ),
    );
  }

  /// Builds retry button with config colors
  Widget _buildRetryButton(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final backgroundColor = _parseColor(
      configHelper.getString(
        'error_handling_configuration.retry_button_background',
        '#000000',
      ),
    );
    final textColor = _parseColor(
      configHelper.getString(
        'error_handling_configuration.retry_button_text_color',
        '#FFFFFF',
      ),
    );

    return OsmeaComponents.button(
      text: context.t.productDetailView.error.tryAgain,
      onPressed: onRetry,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      fullWidth: true,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  /// Builds go back button with config colors
  Widget _buildGoBackButton(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final textColor = _parseColor(
      configHelper.getString(
        'error_handling_configuration.go_back_button_text_color',
        '#000000',
      ),
    );

    return OsmeaComponents.button(
      text: context.t.productDetailView.error.goBack,
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go('/home');
        }
      },
      variant: ButtonVariant.ghost,
      size: ButtonSize.large,
      fullWidth: true,
      textColor: textColor,
    );
  }

  /// Parses color string to Color
  Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 8) {
        final alpha = int.parse(hex.substring(0, 2), radix: 16);
        final red = int.parse(hex.substring(2, 4), radix: 16);
        final green = int.parse(hex.substring(4, 6), radix: 16);
        final blue = int.parse(hex.substring(6, 8), radix: 16);
        return Color.fromARGB(alpha, red, green, blue);
      }
      if (hex.length == 6) {
        final red = int.parse(hex.substring(0, 2), radix: 16);
        final green = int.parse(hex.substring(2, 4), radix: 16);
        final blue = int.parse(hex.substring(4, 6), radix: 16);
        return Color.fromRGBO(red, green, blue, 1.0);
      }
      return OsmeaColors.black;
    } catch (e) {
      debugPrint('⚠️ Error parsing color: $colorString - $e');
      return OsmeaColors.black;
    }
  }
}
