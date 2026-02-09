/*
 * Cart Empty Widget
 * -----------------
 * Widget that handles empty cart state by navigating to empty view.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Widget shown when cart is empty
class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Assuming route structure is similar, but checking if empty routes are defined in supabase project.
      // app_routes.dart for supabase project seems to have /empty/... routes logic or uses a different EmptyView approach?
      // Looking at previous context, app_routes.dart in supabase project was partially shown but didn't explicitly show /empty/:type route like woo.
      // However, `empty_view_configuration` is present in app_config.json for Supabase project.
      // Let's assume we can navigate to a generic empty page or use the same pattern.
      // If /empty/cart route doesn't exist, we might need to add it or use a fallback.
      // For now, I will use the same route as Woo, assuming routes are or will be aligned.
      // If not, I should probably implement EmptyView in Supabase project or navigate to Home.
      
      // Checking Supabase app_routes.dart (from memory of file structure):
      // It has /cart route.
      // It doesn't seem to have /empty/:type.
      // I should probably just show the empty state inline if route doesn't exist, or push to home.
      // But adhering to "UI structure of Woo", I should try to match it.
      // Let's implement an inline empty view here if route navigation is risky, 
      // OR better, create the EmptyView route in Supabase project if missing (I can't edit routes easily without seeing full file).
      // Actually, standard practice in this migration is to copy UI.
      // Woo uses: context.go('/empty/cart?actionPath=/home');
      
      // Let's assume I should stick to UI components first.
      // If I can't verify route exists, I will render the empty UI here directly to be safe.
      // Woo's `EmptyView` is likely a shared component or specific view. 
      // Let's render OsmeaComponents.emptyState here directly if we can, or just redirect to home.
      
      // Re-reading Woo `CartEmptyWidget`:
      // `context.go('/empty/cart?actionPath=/home');`
      // `return context.emptySizedBox;`
      
      // I will implement a basic empty state UI here instead of redirecting to a potentially non-existent route.
      // This is safer.
    });
    
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: OsmeaColors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: 24),
          OsmeaComponents.text(
            'Your cart is empty',
            textStyle: OsmeaTextStyle.headlineSmall(
              context,
            ).copyWith(color: OsmeaColors.black, fontWeight: FontWeight.w500),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            'Add some products to get started',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.pewter),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 32),
          OsmeaComponents.button(
            onPressed: () {
              if (context.mounted) {
                context.go('/home');
              }
            },
            backgroundColor: OsmeaColors.black,
            textColor: OsmeaColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            text: 'Start Shopping',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
