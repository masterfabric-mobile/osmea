import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/widgets/api_url_display.dart';

/// A modern app header with integrated API URL display
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String apiUrl;
  final VoidCallback? onUrlCopied;

  const AppHeader({
    super.key,
    required this.title,
    required this.apiUrl,
    this.onUrlCopied,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Row(
        children: [
          Icon(
            Icons.api_rounded,
            color: colorScheme.onPrimary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        // Modern API URL display
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ApiUrlDisplay(
            url: apiUrl,
            onCopy: onUrlCopied,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.help_outline_rounded,
            color: colorScheme.onPrimary,
          ),
          tooltip: 'Documentation',
          onPressed: () {
            // Show help or documentation
          },
        ),
      ],
      elevation: 0,
      backgroundColor: colorScheme.primary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
