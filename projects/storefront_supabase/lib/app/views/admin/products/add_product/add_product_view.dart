import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/views/admin/products/add_product/states.dart';
import 'package:storefront_supabase/app/views/admin/products/add_product/view_model.dart';

class AddProductView
    extends MasterViewCubit<AddProductViewModel, AddProductState> {
  AddProductView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) {
            final productId = arguments['productId'] as String?;
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(
                  productId == null ? 'Add New Product' : 'Edit Product'),
              variant: AppBarVariant.primary,
            );
          },
        );

  @override
  void initialContent(AddProductViewModel viewModel, BuildContext context) {
    final productId = arguments['productId'] as String?;
    viewModel.initial(productId: productId);
  }

  @override
  Widget viewContent(
      BuildContext context, AddProductViewModel viewModel, AddProductState state) {
    final productId = arguments['productId'] as String?;
    final isEditMode = productId != null;

    if (state is AddProductLoading || state is AddProductInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AddProductError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message),
            const SizedBox(height: 16),
            OsmeaComponents.button(
              text: 'Retry',
              onPressed: () => initialContent(viewModel, context),
            ),
          ],
        ),
      );
    }
    if (state is AddProductSubmitting) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(isEditMode ? 'Saving Changes...' : 'Adding Product...'),
          ],
        ),
      );
    }

    if (state is AddProductSuccess) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 16),
            Text(isEditMode
                ? 'Product Updated Successfully!'
                : 'Product Added Successfully!'),
            const SizedBox(height: 16),
            if (!isEditMode)
              OsmeaComponents.button(
                text: 'Add Another Product',
                onPressed: () => initialContent(viewModel, context),
              ),
            OsmeaComponents.button(
              text: 'Go to products',
              onPressed: () => goRoute('/admin/products'),
            )
          ],
        ),
      );
    }

    if (state is AddProductLoaded) {
      return BlocListener<AddProductViewModel, AddProductState>(
        listener: (context, listenState) {
          if (listenState is AddProductLoaded &&
              listenState.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(listenState.errorMessage!),
                  backgroundColor: Colors.red));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(context, viewModel, state.image, state.existingImageUrl),
                const SizedBox(height: 24),
                _buildTextField(viewModel.nameController, 'Product Name'),
                const SizedBox(height: 16),
                _buildTextField(viewModel.descriptionController, 'Description',
                    maxLines: 5),
                const SizedBox(height: 16),
                _buildTextField(viewModel.priceController, 'Price',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(viewModel.skuController, 'SKU'),
                const SizedBox(height: 16),
                _buildTextField(viewModel.stockController, 'Stock Quantity',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 24),
                
                // --- CATEGORY HIERARCHY ---
                _buildCategoryHierarchy(context, viewModel, state),
                
                const SizedBox(height: 16),
                
                // --- DYNAMIC SIZE/AGE SELECTOR ---
                _buildDynamicSizeSelector(context, viewModel, state),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSafeDropdown<Brand>(
                        'Brand',
                        state.brands,
                        (b) => b.name,
                        state.selectedBrand,
                        viewModel.onBrandChanged,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddBrandDialog(context, viewModel),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                OsmeaComponents.button(
                  text: isEditMode ? 'Save Changes' : 'Add Product',
                  onPressed: () => viewModel.submitProduct(productId: productId),
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Center(child: Text('An unexpected state occurred.'));
  }

  Widget _buildCategoryHierarchy(BuildContext context, AddProductViewModel viewModel, AddProductLoaded state) {
    final rootCats = viewModel.getRootCategories(state.allCategories);
    final subCats = viewModel.getSubCategories(state.allCategories, state.selectedRootCategory?.id);
    final leafCats = viewModel.getSubCategories(state.allCategories, state.selectedSubCategory?.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSafeDropdown<Category>(
          'Main Category',
          rootCats,
          (c) => c.name,
          state.selectedRootCategory,
          viewModel.onRootCategoryChanged,
        ),
        if (state.selectedRootCategory != null && subCats.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSafeDropdown<Category>(
            'Sub Category',
            subCats,
            (c) => c.name,
            state.selectedSubCategory,
            viewModel.onSubCategoryChanged,
          ),
        ],
        if (state.selectedSubCategory != null && leafCats.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSafeDropdown<Category>(
            'Specific Category',
            leafCats,
            (c) => c.name,
            state.selectedLeafCategory,
            viewModel.onLeafCategoryChanged,
          ),
        ],
      ],
    );
  }

  Widget _buildDynamicSizeSelector(BuildContext context, AddProductViewModel viewModel, AddProductLoaded state) {
    List<String> options = [];
    String label = '';

    if (viewModel.isShoeCategory) {
      options = viewModel.shoeSizes;
      label = 'Select Shoe Sizes';
    } else if (viewModel.isFashionCategory) {
      options = viewModel.clothingSizesAndAges;
      label = 'Select Sizes / Age Groups';
    } else {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: options.map((option) {
            final isSelected = state.selectedSizesOrAges.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => viewModel.toggleSizeOrAge(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// A safer dropdown builder that ensures the selected item exists in the list.
  /// If [selectedItem] is not null but not in [items], it resets the selection to null (or handles it gracefully).
  Widget _buildSafeDropdown<T>(
    String label,
    List<T> items,
    String Function(T) itemToString,
    T? selectedItem,
    void Function(T?) onChanged,
  ) {
    // Check if the selected item is actually in the list based on object identity or equality
    T? effectiveValue;
    if (selectedItem != null) {
      try {
        effectiveValue = items.firstWhere((item) => item == selectedItem);
      } catch (e) {
        effectiveValue = null; // Item not found, reset selection
      }
    }

    return DropdownButtonFormField<T>(
      // ignore: deprecated_member_use
      value: effectiveValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemToString(item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        // Only validate if items are available (meaning selection is expected)
        if (items.isNotEmpty && value == null) {
          return 'Please select a $label';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker(BuildContext context, AddProductViewModel viewModel,
      File? localImage, String? existingImageUrl) {
    Widget imageWidget;
    if (localImage != null) {
      imageWidget = Image.file(localImage, fit: BoxFit.cover);
    } else if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
      imageWidget = Image.network(existingImageUrl, fit: BoxFit.cover);
    } else {
      imageWidget = const Icon(Icons.image, size: 50, color: Colors.grey);
    }

    return Center(
      child: Column(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
          ),
          const SizedBox(height: 8),
          OsmeaComponents.textButton(
            text: 'Pick Image',
            onPressed: viewModel.pickImage,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        return null;
      },
    );
  }

  void _showAddBrandDialog(BuildContext context, AddProductViewModel viewModel) {
    final brandNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Brand'),
          content: TextField(
            controller: brandNameController,
            decoration: const InputDecoration(hintText: "Enter brand name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (brandNameController.text.isNotEmpty) {
                  viewModel.addNewBrand(brandNameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}