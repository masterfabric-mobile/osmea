import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

/// Cart app bar widget following OSMEA standards
class CartAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: OsmeaComponents.text(
        'Shopping Cart',
        color: OsmeaColors.thunder,
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      backgroundColor: OsmeaColors.paperWhite,
      elevation: 0,
      foregroundColor: OsmeaColors.thunder,
      leading: OsmeaComponents.iconButton(
        onPressed: () => context.go('/home'),
        icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
      ),
      actions: [
        // Clear cart button
        OsmeaComponents.iconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Clear cart feature coming soon!'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          icon: Icon(Icons.clear_all, color: OsmeaColors.thunder),
          tooltip: 'Clear Cart',
        ),
      ],
    );
  }
}




