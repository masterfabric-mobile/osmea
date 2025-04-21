import 'package:flutter/material.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:example/widgets/http_method_selector.dart';
import 'package:example/widgets/section_title_widget.dart';
import 'package:example/widgets/service_selector_widget.dart';
import 'package:example/widgets/execute_button_widget.dart';

class ControlPanel extends StatelessWidget {
  final ApiCategory? selectedCategory;
  final String? selectedSubcategory;
  final ApiService? selectedService;
  final String? selectedMethod;
  final bool loading;
  final Function(ApiCategory) onCategorySelected;
  final Function(String) onSubcategorySelected;
  final Function(ApiService) onServiceSelected;
  final Function(String) onMethodSelected;
  final Function() onExecute;
  final Map<String, TextEditingController> controllers;

  const ControlPanel({
    super.key,
    required this.selectedCategory,
    this.selectedSubcategory,
    required this.selectedService,
    required this.selectedMethod,
    required this.loading,
    required this.onCategorySelected,
    required this.onSubcategorySelected,
    required this.onServiceSelected,
    required this.onMethodSelected,
    required this.onExecute,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size to adapt layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    // Adjust padding based on screen size
    final padding = isSmallScreen ? 12.0 : 20.0;
    final spacing = isSmallScreen ? 16.0 : 24.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleWidget(
            title: 'API Configuration',
            icon: Icons.category_rounded,
          ),
          SizedBox(height: isSmallScreen ? 12 : 20),
          _buildCategorySelector(context),
          if (selectedCategory != null) ...[
            SizedBox(height: spacing),
            _buildSubcategorySelector(context),
          ],
          if (selectedCategory != null && selectedSubcategory != null) ...[
            SizedBox(height: spacing),
            ServiceSelectorWidget(
              category: selectedCategory!,
              subcategory: selectedSubcategory,
              selectedService: selectedService,
              onServiceSelected: onServiceSelected,
            ),
          ],
          if (selectedService != null) ...[
            SizedBox(height: spacing),
            _buildMethodSelector(context),
          ],
          if (selectedService != null &&
              selectedMethod != null &&
              selectedService!.requiredFields.containsKey(selectedMethod)) ...[
            SizedBox(height: spacing),
            _buildParameterFields(context),
          ],
          SizedBox(height: spacing),
          ExecuteButtonWidget(
            selectedMethod: selectedMethod,
            loading: loading,
            canExecute:
                selectedService != null && selectedMethod != null && !loading,
            onExecute: onExecute,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontSize: isSmallScreen ? 13 : null,
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonFormField<ApiCategory>(
            value: selectedCategory,
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.folder_rounded,
                color: colorScheme.primary,
              ),
              hintText: 'Select API Category',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            menuMaxHeight: 350, // Limit menu height for small screens
            dropdownColor: colorScheme.surface,
            isDense: isSmallScreen, // Compact on small screens
            borderRadius: BorderRadius.circular(12),
            items: ApiServiceRegistry.categories.map((category) {
              return DropdownMenuItem<ApiCategory>(
                value: category,
                child: Text(
                  category.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onCategorySelected(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubcategorySelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    ApiServiceRegistry.getCategoryName(selectedCategory!);
    final subcategories =
        ApiServiceRegistry.getSubcategoriesByCategory(selectedCategory!);

    if (subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subcategory',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedSubcategory,
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.subdirectory_arrow_right_rounded,
                color: colorScheme.primary,
              ),
              hintText: 'Select Subcategory',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            dropdownColor: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            items: subcategories.map((subcategory) {
              return DropdownMenuItem<String>(
                value: subcategory,
                child: Text(
                  subcategory,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onSubcategorySelected(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMethodSelector(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HTTP Method',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        HttpMethodSelector(
          methods: selectedService!.supportedMethods,
          selectedMethod: selectedMethod,
          onMethodSelected: onMethodSelected,
        ),
      ],
    );
  }

  Widget _buildParameterFields(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fields = selectedService!.requiredFields[selectedMethod!] ?? [];
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    // Smaller spacing on small screens
    final bottomSpacing = isSmallScreen ? 12.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: 'Parameters',
          icon: Icons.input_rounded,
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        ...fields.map((field) {
          // Create controller if it doesn't exist
          if (!controllers.containsKey(field.name)) {
            controllers[field.name] = TextEditingController();
          }

          return Padding(
            padding: EdgeInsets.only(bottom: bottomSpacing),
            child: TextField(
              controller: controllers[field.name],
              decoration: InputDecoration(
                labelText: field.label,
                hintText: field.hint,
                prefixIcon: Icon(
                  Icons.text_fields_rounded,
                  color: colorScheme.primary.withValues(alpha: 0.7),
                  size: isSmallScreen ? 16 : 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: isSmallScreen
                    ? EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                    : null,
              ),
              // Use smaller font on smaller screens
              style: isSmallScreen ? TextStyle(fontSize: 14) : null,
            ),
          );
        }),
      ],
    );
  }
}
