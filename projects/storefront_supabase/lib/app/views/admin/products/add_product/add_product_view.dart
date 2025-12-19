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
                      child: _buildDropdown<Brand>(
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
        _buildDropdown<Category>(
          'Main Category',
          rootCats,
          (c) => c.name,
          state.selectedRootCategory,
          viewModel.onRootCategoryChanged,
        ),
        if (state.selectedRootCategory != null && subCats.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildDropdown<Category>(
            'Sub Category',
            subCats,
            (c) => c.name,
            state.selectedSubCategory,
            viewModel.onSubCategoryChanged,
          ),
        ],
        if (state.selectedSubCategory != null && leafCats.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildDropdown<Category>(
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
    if (viewModel.isShoeCategory) {
      return _buildDropdown<String>(
        'Shoe Size',
        viewModel.shoeSizes,
        (val) => val,
        state.selectedSizeOrAge,
        viewModel.onSizeOrAgeChanged,
      );
    } else if (viewModel.isFashionCategory) {
      return _buildDropdown<String>(
        'Size / Age Group',
        viewModel.clothingSizesAndAges,
        (val) => val,
        state.selectedSizeOrAge,
        viewModel.onSizeOrAgeChanged,
      );
    }
    return const SizedBox.shrink(); // Hide for Electronics, etc.
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

  Widget _buildDropdown<T>(
    String label,
    List<T> items,
    String Function(T) itemToString,
    T? selectedItem,
    void Function(T?) onChanged,
  ) {
    return DropdownButtonFormField<T>(
      initialValue: selectedItem,
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
        if (value == null) {
          return 'Please select a $label';
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

  Widget _buildDisabledDropdown(String label, String hint) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
