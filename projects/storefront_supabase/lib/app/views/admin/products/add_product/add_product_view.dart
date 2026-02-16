import 'dart:io';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/models/brand.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:storefront_supabase/app/views/admin/products/add_product/states.dart';
import 'package:storefront_supabase/app/views/admin/products/add_product/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AddProductView
    extends MasterViewCubit<AddProductViewModel, AddProductState> {
  AddProductView({
    super.key,
    required super.goRoute,
    super.arguments = const {'init': true},
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
  }) : super(
          coreAppBar: (context, viewModel) {
            final resources = context.resources;
            final productId = arguments['productId'] as String?;
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(
                productId == null ? resources.addNewProduct : resources.editProduct,
                color: OsmeaColors.black,
              ),
              backgroundColor: OsmeaColors.white,
              foregroundColor: OsmeaColors.black,
              variant: AppBarVariant.primary,
              leading: OsmeaComponents.iconButton(
                onPressed: () => goRoute('/admin/products'),
                icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
              ),
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
    final resources = context.resources;
    final productId = arguments['productId'] as String?;
    final isEditMode = productId != null;

    if (state is AddProductLoading || state is AddProductInitial) {
      return OsmeaComponents.center(
        child: OsmeaComponents.loading(
        type: LoadingType.circularFade,
        size: 36,
        color: OsmeaColors.black,
      ),
      );
    }

    if (state is AddProductError) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OsmeaComponents.text(
              state.message,
              textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(color: OsmeaColors.black),
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.button(
              text: resources.retry,
              onPressed: () => initialContent(viewModel, context),
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
            ),
          ],
        ),
      );
    }
    if (state is AddProductSubmitting) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OsmeaComponents.loading(
              type: LoadingType.circularFade,
              size: 36,
              color: OsmeaColors.black,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              isEditMode ? resources.savingChanges : resources.addingProduct,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
            ),
          ],
        ),
      );
    }

    if (state is AddProductSuccess) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: OsmeaColors.forestHeart, size: 50),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              isEditMode
                  ? resources.productUpdatedSuccess
                  : resources.productAddedSuccess,
              textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(color: OsmeaColors.black),
            ),
            OsmeaComponents.sizedBox(height: 16),
            if (!isEditMode)
              OsmeaComponents.button(
                text: resources.addAnotherProduct,
                onPressed: () => initialContent(viewModel, context),
                backgroundColor: OsmeaColors.black,
                textColor: OsmeaColors.white,
              ),
            OsmeaComponents.button(
              text: resources.goToProducts,
              onPressed: () => goRoute('/admin/products'),
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
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
            context.snackbarError(listenState.errorMessage!);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: viewModel.formKey,
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(context, viewModel, state.image, state.existingImageUrl),
                OsmeaComponents.sizedBox(height: 24),
                _buildTextField(context, viewModel.nameController, resources.productName),
                OsmeaComponents.sizedBox(height: 16),
                _buildTextField(context, viewModel.descriptionController, resources.description,
                    maxLines: 5),
                OsmeaComponents.sizedBox(height: 16),
                _buildTextField(context, viewModel.priceController, resources.price,
                    keyboardType: TextInputType.number),
                OsmeaComponents.sizedBox(height: 16),
                _buildTextField(context, viewModel.skuController, resources.sku),
                OsmeaComponents.sizedBox(height: 16),
                _buildTextField(context, viewModel.stockController, resources.stockQuantity,
                    keyboardType: TextInputType.number),
                OsmeaComponents.sizedBox(height: 24),
                
                // --- CATEGORY HIERARCHY ---
                _buildCategoryHierarchy(context, viewModel, state),
                
                OsmeaComponents.sizedBox(height: 16),
                
                // --- DYNAMIC SIZE/AGE SELECTOR ---
                _buildDynamicSizeSelector(context, viewModel, state),

                OsmeaComponents.sizedBox(height: 16),
                OsmeaComponents.row(
                  children: [
                    OsmeaComponents.expanded(
                      child: _buildSafeDropdown<Brand>(
                        context,
                        resources.brand,
                        state.brands,
                        (b) => b.name,
                        state.selectedBrand,
                        viewModel.onBrandChanged,
                      ),
                    ),
                    OsmeaComponents.iconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddBrandDialog(context, viewModel),
                    ),
                  ],
                ),
                OsmeaComponents.sizedBox(height: 32),
                OsmeaComponents.button(
                  text: isEditMode ? resources.saveChanges : resources.addProduct,
                  onPressed: () => viewModel.submitProduct(productId: productId),
                  fullWidth: true,
                  backgroundColor: OsmeaColors.black,
                  textColor: OsmeaColors.white,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return OsmeaComponents.center(child: OsmeaComponents.text(resources.unexpectedError));
  }

  Widget _buildCategoryHierarchy(BuildContext context, AddProductViewModel viewModel, AddProductLoaded state) {
    final resources = context.resources;
    final rootCats = viewModel.getRootCategories(state.allCategories);
    final subCats = viewModel.getSubCategories(state.allCategories, state.selectedRootCategory?.id);
    final leafCats = viewModel.getSubCategories(state.allCategories, state.selectedSubCategory?.id);

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSafeDropdown<Category>(
          context,
          resources.mainCategory,
          rootCats,
          (c) => c.name,
          state.selectedRootCategory,
          viewModel.onRootCategoryChanged,
        ),
        if (state.selectedRootCategory != null && subCats.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: 16),
          _buildSafeDropdown<Category>(
            context,
            resources.subCategory,
            subCats,
            (c) => c.name,
            state.selectedSubCategory,
            viewModel.onSubCategoryChanged,
          ),
        ],
        if (state.selectedSubCategory != null && leafCats.isNotEmpty) ...[
          OsmeaComponents.sizedBox(height: 16),
          _buildSafeDropdown<Category>(
            context,
            resources.specificCategory,
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
    final resources = context.resources;
    List<String> options = [];
    String label = '';

    if (viewModel.isShoeCategory) {
      options = viewModel.shoeSizes;
      label = resources.selectShoeSizes;
    } else if (viewModel.isFashionCategory) {
      options = viewModel.clothingSizesAndAges;
      label = resources.selectSizeAgeGroups;
    } else {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          label,
          textStyle: OsmeaTextStyle.titleSmall(context).copyWith(color: OsmeaColors.black),
        ),
        OsmeaComponents.sizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: options.map((option) {
            final isSelected = state.selectedSizesOrAges.contains(option);
            return FilterChip(
              label: OsmeaComponents.text(
                option,
                textStyle: OsmeaTextStyle.labelLarge(context).copyWith(color: OsmeaColors.black),
              ),
              selected: isSelected,
              onSelected: (_) => viewModel.toggleSizeOrAge(option),
              selectedColor: OsmeaColors.silver.withOpacity(0.4),
              checkmarkColor: OsmeaColors.black,
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
    T? effectiveValue;
    if (selectedItem != null) {
      try {
        effectiveValue = items.firstWhere((item) => item == selectedItem);
      } catch (e) {
        effectiveValue = null;
      }
    }

    return DropdownButtonFormField<T>(
      // ignore: deprecated_member_use
      value: effectiveValue,
      dropdownColor: OsmeaColors.white,
      style: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: OsmeaColors.silver),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: OsmeaColors.black, width: 1.5),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: OsmeaComponents.text(
            itemToString(item),
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (items.isNotEmpty && value == null) {
          return '${context.resources.pleaseSelectA}$label';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker(BuildContext context, AddProductViewModel viewModel,
      File? localImage, String? existingImageUrl) {
    final resources = context.resources;
    Widget imageWidget;
    if (localImage != null) {
      imageWidget = Image.file(localImage, fit: BoxFit.cover);
    } else if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
      imageWidget = Image.network(existingImageUrl, fit: BoxFit.cover);
    } else {
      imageWidget = Icon(Icons.image, size: 50, color: OsmeaColors.pewter);
    }

    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: OsmeaColors.pewter),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.button(
            text: resources.pickImage,
            onPressed: viewModel.pickImage,
            variant: ButtonVariant.outlined,
            backgroundColor: OsmeaColors.white,
            textColor: OsmeaColors.black,
            borderColor: OsmeaColors.black,
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
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      hint: label,
      maxLines: maxLines,
      keyboardType: keyboardType ?? TextInputType.text,
      variant: TextFieldVariant.outlined,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${context.resources.pleaseEnterA}$label';
        }
        return null;
      },
      focusColor: OsmeaColors.black,
      borderColor: OsmeaColors.silver,
      textColor: OsmeaColors.black,
    );
  }

  void _showAddBrandDialog(BuildContext context, AddProductViewModel viewModel) {
    final resources = context.resources;
    final brandNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: OsmeaColors.white,
          title: OsmeaComponents.text(
            resources.addNewBrandTitle,
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(color: OsmeaColors.black),
          ),
          content: OsmeaComponents.textField(
            controller: brandNameController,
            hint: resources.enterBrandName,
            label: resources.enterBrandName,
            textColor: OsmeaColors.black,
            labelColor: OsmeaColors.black,
            hintColor: OsmeaColors.pewter,
            borderColor: OsmeaColors.silver,
            fullWidth: true,
          ),
          actions: [
            OsmeaComponents.textButton(
              text: resources.cancel,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            OsmeaComponents.button(
              text: resources.save,
              onPressed: () {
                if (brandNameController.text.isNotEmpty) {
                  viewModel.addNewBrand(brandNameController.text);
                  Navigator.of(dialogContext).pop();
                }
              },
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
            ),
          ],
        );
      },
    );
  }
}
