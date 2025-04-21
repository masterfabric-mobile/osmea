import 'package:flutter/material.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:example/styles/app_theme.dart';

/// 📋 Service Selector Widget
/// 🔍 Displays list of available API services
/// ✅ Highlights currently selected service
class ServiceSelectorWidget extends StatelessWidget {
  /// 📁 Current category filter
  final ApiCategory category;

  /// 📂 Optional subcategory filter
  final String? subcategory;

  /// ✓ Currently selected service
  final ApiService? selectedService;

  /// 🔄 Callback when a service is selected
  final Function(ApiService) onServiceSelected;

  /// 🏗️ Constructor with required parameters
  const ServiceSelectorWidget({
    super.key,
    required this.category,
    this.subcategory,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 🔍 Filter services by category and subcategory
    final services = subcategory != null
        ? ApiServiceRegistry.getBySubcategory(category, subcategory!)
        : ApiServiceRegistry.getByCategory(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // 🎨 Use theme colors for container background
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (context, index) => Divider(
                height: 1, thickness: 1, color: colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              return _ServiceListItem(
                service: services[index],
                isSelected: services[index] == selectedService,
                onTap: onServiceSelected,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 🔍 Individual service list item
class _ServiceListItem extends StatelessWidget {
  final ApiService service;
  final bool isSelected;
  final Function(ApiService) onTap;

  const _ServiceListItem({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(service),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              // 📌 Service icon - either API or selected indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.surfaceContainerHighest,
                ),
                child: Center(
                  child: Icon(
                    isSelected ? Icons.check_rounded : Icons.api_rounded,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // 📝 Service details - name and method tags
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 🏷️ Method tags in a row
                    Wrap(
                      spacing: 6,
                      children: service.supportedMethods.map((method) {
                        final methodStyle =
                            AppTheme.getMethodStyle(method, context);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: methodStyle.backgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            method,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: methodStyle.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
