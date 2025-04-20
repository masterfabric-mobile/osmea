import 'package:flutter/material.dart';
import 'package:example/services/api_service_registry.dart';

class ControlPanel extends StatelessWidget {
  final ApiCategory? selectedCategory;
  final String? selectedSubcategory; // Add subcategory selection
  final ApiService? selectedService;
  final String? selectedMethod;
  final bool loading;
  final Function(ApiCategory) onCategorySelected;
  final Function(String)
      onSubcategorySelected; // Add callback for subcategory selection
  final Function(ApiService) onServiceSelected;
  final Function(String) onMethodSelected;
  final Function() onExecute;
  final Map<String, TextEditingController> controllers;

  const ControlPanel({
    super.key,
    required this.selectedCategory,
    this.selectedSubcategory, // Make it optional or provide a default
    required this.selectedService,
    required this.selectedMethod,
    required this.loading,
    required this.onCategorySelected,
    required this.onSubcategorySelected, // Add this parameter
    required this.onServiceSelected,
    required this.onMethodSelected,
    required this.onExecute,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategorySelector(context),
          if (selectedCategory != null) ...[
            const SizedBox(height: 24),
            _buildSubcategorySelector(context), 
          ],
          if (selectedCategory != null && selectedSubcategory != null) ...[
            const SizedBox(height: 24),
            _buildServiceSelector(context),
          ],
          if (selectedService != null) ...[
            const SizedBox(height: 24),
            _buildMethodSelector(context),
          ],
          if (selectedService != null &&
              selectedMethod != null &&
              selectedService!.requiredFields.containsKey(selectedMethod)) ...[
            const SizedBox(height: 24),
            _buildParameterFields(context),
          ],
          const SizedBox(height: 24),
          _buildExecuteButton(context),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'API Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<ApiCategory>(
            value: selectedCategory,
            isExpanded: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.category),
              hintText: 'Select API Category',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            items: ApiServiceRegistry.categories.map((category) {
              return DropdownMenuItem<ApiCategory>(
                value: category,
                child: Text(
                  category.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
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

  // Updated method to build the subcategory selector as a dropdown
  Widget _buildSubcategorySelector(BuildContext context) {
    final categoryName = ApiServiceRegistry.getCategoryName(selectedCategory!);
    final subcategories =
        ApiServiceRegistry.getSubcategoriesByCategory(selectedCategory!);

    if (subcategories.isEmpty) {
      return const SizedBox.shrink(); // No subcategories, don't show selector
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$categoryName Subcategories',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedSubcategory,
            isExpanded: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.subdirectory_arrow_right),
              hintText: 'Select Subcategory',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            items: subcategories.map((subcategory) {
              return DropdownMenuItem<String>(
                value: subcategory,
                child: Text(
                  subcategory,
                  style: const TextStyle(fontWeight: FontWeight.w500),
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

  Widget _buildServiceSelector(BuildContext context) {
    // Update to filter by both category and subcategory
    final services = selectedSubcategory != null
        ? ApiServiceRegistry.getBySubcategory(
            selectedCategory!, selectedSubcategory!)
        : ApiServiceRegistry.getByCategory(selectedCategory!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${selectedSubcategory ?? selectedCategory?.displayName ?? ""} Services',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final service = services[index];
              final isSelected = service == selectedService;

              return ListTile(
                selected: isSelected,
                selectedTileColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                title: Text(service.name),
                subtitle: Text(
                  service.supportedMethods.join(', '),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: () => onServiceSelected(service),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMethodSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HTTP Method',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: selectedService!.supportedMethods.map((method) {
            final isSelected = method == selectedMethod;
            final methodColors = {
              'GET': Colors.green.shade700,
              'POST': Colors.blue.shade700,
              'PUT': Colors.amber.shade700,
              'DELETE': Colors.red.shade700,
            };
            final color = methodColors[method] ?? colorScheme.primary;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(method),
                selected: isSelected,
                onSelected: (_) => onMethodSelected(method),
                selectedColor: color,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildParameterFields(BuildContext context) {
    final fields = selectedService!.requiredFields[selectedMethod!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Parameters',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...fields.map((field) {
          // Create controller if it doesn't exist
          if (!controllers.containsKey(field.name)) {
            controllers[field.name] = TextEditingController();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextField(
              controller: controllers[field.name],
              decoration: InputDecoration(
                labelText: field.label,
                hintText: field.hint,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExecuteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            (selectedService != null && selectedMethod != null && !loading)
                ? onExecute
                : null,
        child: loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Processing...'),
                ],
              )
            : const Text('Execute Request'),
      ),
    );
  }
}
