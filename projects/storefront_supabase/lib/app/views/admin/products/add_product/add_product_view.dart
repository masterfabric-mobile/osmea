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
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text('Add New Product'),
            variant: AppBarVariant.primary,
          ),
        );

  @override
  void initialContent(AddProductViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
      BuildContext context, AddProductViewModel viewModel, AddProductState state) {
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
              onPressed: viewModel.initial,
            ),
          ],
        ),
      );
    }
     if (state is AddProductSubmitting) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Adding Product...'),
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
            const Text('Product Added Successfully!'),
            const SizedBox(height: 16),
            OsmeaComponents.button(
              text: 'Add Another Product',
              onPressed: viewModel.initial,
            ),
             OsmeaComponents.button(
              text: 'Go to products',
              onPressed: ()=> goRoute('/admin/products'),
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
                _buildImagePicker(context, viewModel, state.image),
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
                if (state.categories.isEmpty)
                  _buildDisabledDropdown('Category',
                      'No categories found. Please add a category first.')
                else
                  _buildDropdown<Category>(
                    'Category',
                    state.categories,
                    (c) => c.name,
                    viewModel.selectedCategory,
                    viewModel.onCategoryChanged,
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown<Brand>(
                        'Brand',
                        state.brands,
                        (b) => b.name,
                        viewModel.selectedBrand,
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
                  text: 'Add Product',
                  onPressed: viewModel.submitProduct,
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

  Widget _buildImagePicker(
      BuildContext context, AddProductViewModel viewModel, File? image) {
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
            child: image != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(image, fit: BoxFit.cover))
                : const Icon(Icons.image, size: 50, color: Colors.grey),
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
      value: selectedItem,
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
