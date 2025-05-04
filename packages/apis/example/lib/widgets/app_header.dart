import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Modern application header with API URL display and actions
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String apiUrl;
  final VoidCallback onUrlCopied;

  const AppHeader({
    super.key,
    required this.title,
    required this.apiUrl,
    required this.onUrlCopied,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 50,
            maxHeight: apiUrl.isEmpty ? 50 : 90,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App title row - settings icon removed
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App icon
                      Icon(
                        Icons.api_rounded,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      // App title
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      // No settings icon or spacer
                    ],
                  ),
                ),
              ),

              // API URL display - only if not empty
              if (apiUrl.isNotEmpty) _buildCompactUrlDisplay(context),
            ],
          ),
        ),
      ),
    );
  }

  // Simplified URL display with fixed height
  Widget _buildCompactUrlDisplay(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 36, // Fixed height prevents overflow
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              // Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.link_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
              // URL text - scrollable
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      apiUrl,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              // Copy button - compact
              IconButton(
                icon: Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                tooltip: 'Copy URL',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: apiUrl));
                  onUrlCopied();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(apiUrl.isEmpty ? 50 : 90);
}
