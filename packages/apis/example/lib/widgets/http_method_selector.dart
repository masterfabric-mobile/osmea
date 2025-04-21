import 'package:flutter/material.dart';
import 'package:example/styles/app_theme.dart';

class HttpMethodSelector extends StatelessWidget {
  final List<String> methods;
  final String? selectedMethod;
  final Function(String) onMethodSelected;

  const HttpMethodSelector({
    super.key,
    required this.methods,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine layout based on available width
        final double availableWidth = constraints.maxWidth;

        // For very small screens, use compact view
        if (availableWidth < 350) {
          return _buildCompactSelector(context);
        }

        // For medium screens, use scrollable view
        if (availableWidth < 500) {
          return _buildScrollableSelector(context);
        }

        // For larger screens, use segmented control
        return _buildSegmentedSelector(context);
      },
    );
  }

  // Extra compact selector for very small screens
  Widget _buildCompactSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.brightness == Brightness.dark
            ? Color(0xFF2A2A2A)
            : Color(0xFFF0F0F0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMethod,
          isExpanded: true,
          borderRadius: BorderRadius.circular(8),
          padding: EdgeInsets.symmetric(horizontal: 12),
          icon: Icon(Icons.arrow_drop_down),
          items: methods.map((method) {
            final methodStyle = AppTheme.getMethodStyle(method, context);

            return DropdownMenuItem<String>(
              value: method,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    methodStyle.iconData,
                    color: methodStyle.textColor,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    method,
                    style: TextStyle(
                      color: methodStyle.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onMethodSelected(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSegmentedSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Color(0xFF2A2A2A)
            : Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: methods.map((method) {
          final isSelected = method == selectedMethod;
          final methodStyle = AppTheme.getMethodStyle(method, context);

          return Expanded(
            child: GestureDetector(
              onTap: () => onMethodSelected(method),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? methodStyle.backgroundColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? methodStyle.borderColor
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        methodStyle.iconData,
                        color: isSelected
                            ? methodStyle.textColor
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        method,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? methodStyle.textColor
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Scrollable selector for medium screens
  Widget _buildScrollableSelector(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: methods.length,
        itemBuilder: (context, index) {
          final method = methods[index];
          final isSelected = method == selectedMethod;
          final methodStyle = AppTheme.getMethodStyle(method, context);

          return Padding(
            padding: EdgeInsets.only(
              right: index < methods.length - 1 ? 8 : 0,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onMethodSelected(method),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? methodStyle.backgroundColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? methodStyle.borderColor
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      methodStyle.iconData,
                      color: isSelected
                          ? methodStyle.textColor
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                      size: 16, // Slightly smaller for better fit
                    ),
                    SizedBox(width: 4), // Smaller spacing
                    Text(
                      method,
                      style: TextStyle(
                        fontSize: 13, // Slightly smaller font
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? methodStyle.textColor
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
