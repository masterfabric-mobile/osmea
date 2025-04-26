import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/styles/app_theme.dart';

class ResponsePanel extends StatefulWidget {
  final Map<String, dynamic>? responseData;
  final bool loading;

  const ResponsePanel({
    super.key,
    this.responseData,
    this.loading = false,
  });

  @override
  State<ResponsePanel> createState() => _ResponsePanelState();
}

class _ResponsePanelState extends State<ResponsePanel> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apiTheme = theme.extension<ApiExplorerThemeExtension>();

    // Use theme colors instead of hardcoded values
    final codeBackground =
        apiTheme?.codeBackground ?? theme.colorScheme.surfaceDim;
    final codeText = apiTheme?.codeText ?? theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Response header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.data_object,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Response',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              if (widget.responseData != null) _buildStatusBadge(context),
              const Spacer(),
              if (widget.responseData != null)
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  tooltip: 'Copy Response',
                  onPressed: () {
                    // Format the JSON with proper indentation
                    final jsonString = const JsonEncoder.withIndent('  ')
                        .convert(widget.responseData);

                    // Copy to clipboard
                    Clipboard.setData(ClipboardData(text: jsonString));

                    // Show feedback to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Response copied to clipboard',
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        width: 230,
                        backgroundColor: apiTheme?.codeBackground ??
                            theme.colorScheme
                                .primaryContainer, // Use more modern purple color
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),

        // Response content
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: codeBackground,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: widget.loading
                ? const Center(child: CircularProgressIndicator())
                : widget.responseData == null
                    ? _buildEmptyState(context)
                    : _buildResponseContent(context, codeText),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    bool hasError = widget.responseData?.containsKey('error') ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: hasError ? theme.colorScheme.error : theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        hasError ? 'Error' : 'Success',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: hasError
              ? theme.colorScheme.onError
              : theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code,
            size: 40,
            // Fix deprecated withOpacity
            color: theme.colorScheme.onSurface
                .withValues(alpha: 153), // 0.6 * 255 = 153
          ),
          const SizedBox(height: 16),
          Text(
            'Send a request to see the response',
            style: TextStyle(
              // Fix deprecated withOpacity
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 179), // 0.7 * 255 = 179
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseContent(BuildContext context, Color textColor) {
    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(widget.responseData ?? {});

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SelectableText(
        prettyJson,
        style: TextStyle(
          fontFamily: 'JetBrains Mono', // Monospace font for code
          color: textColor,
          fontSize: 14,
          height: 1.5, // Improved line height for readability
        ),
      ),
    );
  }
}
