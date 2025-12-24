import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/views/admin/products/add_product/states.dart';
import 'package:storefront_supabase/app/views/admin/products/add_product/view_model.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

class AddProductView
    extends MasterViewCubit<AddProductViewModel, AddProductState> {
  AddProductView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
  }) : super(
          coreAppBar: (context, viewModel) {
            final l10n = AppLocalizations.of(context)!;
            final productId = arguments['productId'] as String?;
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(
                  productId == null ? l10n.addNewProduct : l10n.editProduct),
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
    final l10n = AppLocalizations.of(context)!;
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
              text: l10n.retry,
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
            Text(isEditMode ? l10n.savingChanges : l10n.addingProduct),
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
                ? l10n.productUpdatedSuccess
                : l10n.productAddedSuccess),
            const SizedBox(height: 16),
            if (!isEditMode)
              OsmeaComponents.button(
                text: l10n.addAnotherProduct,
                onPressed: () => initialContent(viewModel, context),
              ),
            OsmeaComponents.button(
              text: l10n.goToProducts,
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
                _buildTextField(context, viewModel.nameController, l10n.productName),
                const SizedBox(height: 16),
                _buildTextField(context, viewModel.descriptionController, l10n.description,
                    maxLines: 5),
                const SizedBox(height: 16),
                _buildTextField(context, viewModel.priceController, l10n.price,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(context, viewModel.skuController, l10n.sku),
                const SizedBox(height: 16),
                _buildTextField(context, viewModel.stockController, l10n.stockQuantity,
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
                        context,
                        l10n.brand,
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
                  text: isEditMode ? l10n.saveChanges : l10n.addProduct,
                  onPressed: () => viewModel.submitProduct(productId: productId),
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(child: Text(l10n.unexpectedError));
  }

  Widget _buildCategoryHierarchy(BuildContext context, AddProductViewModel viewModel, AddProductLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    final rootCats = viewModel.getRootCategories(state.allCategories);
    final subCats = viewModel.getSubCategories(state.allCategories, state.selectedRootCategory?.id);
    final leafCats = viewModel.getSubCategories(state.allCategories, state.selectedSubCategory?.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSafeDropdown<Category>(
          context,
          l10n.mainCategory,
          rootCats,
          (c) => c.name,
          state.selectedRootCategory,
          viewModel.onRootCategoryChanged,
        ),
        if (state.selectedRootCategory != null && subCats.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSafeDropdown<Category>(
            context,
            l10n.subCategory,
            subCats,
            (c) => c.name,
            state.selectedSubCategory,
            viewModel.onSubCategoryChanged,
          ),
        ],
        if (state.selectedSubCategory != null && leafCats.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSafeDropdown<Category>(
            context,
            l10n.specificCategory,
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
    final l10n = AppLocalizations.of(context)!;
    List<String> options = [];
    String label = '';

    if (viewModel.isShoeCategory) {
      options = viewModel.shoeSizes;
      label = l10n.selectShoeSizes;
    } else if (viewModel.isFashionCategory) {
      options = viewModel.clothingSizesAndAges;
      label = l10n.selectSizeAgeGroups;
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
    BuildContext context,
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
          return '${AppLocalizations.of(context)!.pleaseSelectA}$label';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker(BuildContext context, AddProductViewModel viewModel,
      File? localImage, String? existingImageUrl) {
    final l10n = AppLocalizations.of(context)!;
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
            text: l10n.pickImage,
            onPressed: viewModel.pickImage,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
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
          return '${AppLocalizations.of(context)!.pleaseEnterA}$label';
        }
        return null;
      },
    );
  }

  void _showAddBrandDialog(BuildContext context, AddProductViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    final brandNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.addNewBrandTitle),
          content: TextField(
            controller: brandNameController,
            decoration: InputDecoration(hintText: l10n.enterBrandName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (brandNameController.text.isNotEmpty) {
                  viewModel.addNewBrand(brandNameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }
}