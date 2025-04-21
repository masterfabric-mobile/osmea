import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 📋 For clipboard operations

/// 🔗 API URL Display Widget
/// 🎨 A modern, visually rich component to display API endpoints
/// 📋 Features copy-to-clipboard functionality with visual feedback
class ApiUrlDisplay extends StatefulWidget {
  final String url; // 🌐 The API URL to display
  final VoidCallback? onCopy; // 📲 Optional callback when URL is copied

  // 🏗️ Constructor with required URL parameter
  const ApiUrlDisplay({
    super.key,
    required this.url,
    this.onCopy,
  });

  @override
  State<ApiUrlDisplay> createState() => _ApiUrlDisplayState();
}

/// 🔄 State class for API URL Display
/// ✨ Handles animations, hover effects and copy operations
class _ApiUrlDisplayState extends State<ApiUrlDisplay>
    with SingleTickerProviderStateMixin {
  // 🎭 Mixin for animation capabilities

  bool _isHovering = false; // 🖱️ Tracks mouse hover state
  bool _isCopied = false; // 📋 Tracks if URL was recently copied
  late AnimationController _controller; // 🎬 Controls the copy animation
  late Animation<double> _animation; // 📈 Defines how animation progresses

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCopy() {
    if (widget.url.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.url));
      setState(() {
        _isCopied = true;
      });
      _controller.forward(from: 0.0);

      // Reset copied status after animation
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _isCopied = false;
          });
        }
      });

      if (widget.onCopy != null) {
        widget.onCopy!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEmpty = widget.url.isEmpty;

    // Get available width to adapt UI
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Adaptive width constraints - ensure we always have enough space
    final double maxWidth = isSmallScreen
        ? screenWidth * 0.6
        : screenWidth > 1200
            ? 500
            : 400;

    // Determine colors based on theme
    final containerBgColor = _isCopied
        ? colorScheme.secondaryContainer
        : _isHovering
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);

    final borderColor = _isCopied
        ? colorScheme.secondary
        : _isHovering
            ? colorScheme.primary
            : colorScheme.outline.withValues(alpha: 0.3);

    final iconColor = _isCopied ? colorScheme.secondary : colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minWidth: 100, // Add minimum width
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 2 : 4,
            vertical: isSmallScreen ? 1 : 2,
          ),
          decoration: BoxDecoration(
            color: containerBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: isEmpty ? null : _handleCopy,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 8 : 10, // Increased padding
                  horizontal: isSmallScreen ? 12 : 16, // Increased padding
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Left icon changes based on state - hide on very small screens
                    if (!isSmallScreen || screenWidth > 400)
                      ScaleTransition(
                        scale: _animation,
                        child: Icon(
                          _isCopied ? Icons.check_circle : Icons.api_rounded,
                          size: isSmallScreen ? 16 : 20, // Increased size
                          color: iconColor,
                        ),
                      ),
                    if (!isSmallScreen || screenWidth > 400)
                      SizedBox(
                          width: isSmallScreen ? 6 : 10), // Increased spacing

                    // URL content - always visible
                    Flexible(
                      child: _buildUrlText(
                          isEmpty, theme, colorScheme, isSmallScreen),
                    ),

                    SizedBox(
                        width: isSmallScreen ? 6 : 10), // Increased spacing

                    // Right icon for copy action
                    Icon(
                      _isCopied ? Icons.check : Icons.copy_rounded,
                      size: isSmallScreen ? 16 : 18, // Increased size
                      color: iconColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlText(bool isEmpty, ThemeData theme, ColorScheme colorScheme,
      bool isSmallScreen) {
    if (isEmpty) {
      return Text(
        'API URL',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          fontSize: 14, // Increased font size
        ),
      );
    }

    // Use Text with ellipsis instead of FittedBox for better reliability
    return Text(
      widget.url,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: isSmallScreen ? 13 : 15, // Increased font size
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0,
      ),
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      maxLines: 1,
    );
  }
}
