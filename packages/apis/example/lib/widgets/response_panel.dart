import 'dart:convert';
import 'package:flutter/material.dart';
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
    final codeBackground = apiTheme?.codeBackground ?? const Color(0xFF141414);
    final codeText = apiTheme?.codeText ?? const Color(0xFFE0E0E0);

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
                    // Copy response
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code,
            size: 40,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 60),
          ),
          const SizedBox(height: 16),
          Text(
            'Send a request to see the response',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 180),
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
