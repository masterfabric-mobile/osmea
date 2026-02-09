import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/app/views/view_home/models/states.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class FilterSheetWidget extends StatefulWidget {
  final SupabaseHomeViewModel viewModel;
  final SupabaseHomeLoadedState state;

  const FilterSheetWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  State<FilterSheetWidget> createState() => _FilterSheetWidgetState();
}

class _FilterSheetWidgetState extends State<FilterSheetWidget> {
  // Local state for filters before applying
  late Set<int> _selectedBrandIds;
  Category? _selectedCategory;
  // TODO: Add price range if needed

  @override
  void initState() {
    super.initState();
    _selectedBrandIds = Set.from(widget.state.selectedBrandIds);
    _selectedCategory = widget.state.selectedRootCategory;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final rootCategories = widget.state.allCategories.where((c) => c.parentId == null).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.text(
                    resources.filter,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedBrandIds.clear();
                        _selectedCategory = null;
                      });
                    },
                    child: OsmeaComponents.text(resources.clear, color: OsmeaColors.black),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // --- Categories ---
                  OsmeaComponents.text(
                    resources.categories,
                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: rootCategories.map((category) {
                      final isSelected = _selectedCategory?.id == category.id;
                      return FilterChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                        selectedColor: OsmeaColors.black,
                        checkmarkColor: OsmeaColors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? OsmeaColors.white : OsmeaColors.black,
                        ),
                        backgroundColor: OsmeaColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: OsmeaColors.platinum),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // --- Brands ---
                  OsmeaComponents.text(
                    resources.brands,
                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Using a more compact grid/wrap layout for brands instead of long list
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.state.allBrands.map((brand) {
                      final isSelected = _selectedBrandIds.contains(brand.id);
                      return FilterChip(
                        label: Text(brand.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedBrandIds.add(brand.id);
                            } else {
                              _selectedBrandIds.remove(brand.id);
                            }
                          });
                        },
                        selectedColor: OsmeaColors.black,
                        checkmarkColor: OsmeaColors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? OsmeaColors.white : OsmeaColors.black,
                        ),
                        backgroundColor: OsmeaColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: OsmeaColors.platinum),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Footer Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                boxShadow: [
                  BoxShadow(
                    color: OsmeaColors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: OsmeaComponents.button(
                text: resources.apply, // "Uygula" / "Apply"
                onPressed: () {
                  // Apply filters
                  widget.viewModel.fetchProducts(
                    selectedBrandIds: _selectedBrandIds,
                    selectedRoot: _selectedCategory,
                    applyFilter: true, // Force new fetch with filters
                  );
                  Navigator.pop(context);
                },
                fullWidth: true,
                backgroundColor: OsmeaColors.black,
                textColor: OsmeaColors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
