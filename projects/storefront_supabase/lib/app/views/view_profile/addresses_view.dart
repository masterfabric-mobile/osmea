import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/models/user_address.dart';
import 'package:storefront_supabase/app/views/view_profile/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_profile/models/profile_view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AddressesView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  AddressesView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.myAddresses,
              textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                fontWeight: FontWeight.w600,
                color: OsmeaColors.black,
              ),
            ),
            variant: AppBarVariant.primary,
            backgroundColor: OsmeaColors.white,
            foregroundColor: OsmeaColors.black,
            elevation: 0,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
              backgroundColor: OsmeaColors.transparent,
            ),
          ),
        );

  @override
  void initialContent(ProfileViewModel viewModel, BuildContext context) {
    viewModel.loadUserAddresses();
  }

  @override
  Widget viewContent(
      BuildContext context, ProfileViewModel viewModel, ProfileState state) {
    final resources = context.resources;
    if (state is ProfileLoading) {
      return OsmeaComponents.center(
        child: OsmeaComponents.loading(
          type: LoadingType.circularFade,
          size: 48,
          color: OsmeaColors.black,
        ),
      );
    }

    if (state is ProfileAuthenticated) {
      // Always reload addresses when viewContent is called (when navigating back)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadUserAddresses();
      });
      return _AddressesContent(viewModel: viewModel);
    }
    return OsmeaComponents.center(
      child: OsmeaComponents.text(
        resources.loginToManageAddresses,
        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
      ),
    );
  }
}

class _AddressesContent extends StatefulWidget {
  final ProfileViewModel viewModel;

  const _AddressesContent({required this.viewModel});

  @override
  State<_AddressesContent> createState() => _AddressesContentState();
}

class _AddressesContentState extends State<_AddressesContent> {
  bool _showAddForm = false;
  UserAddress? _editingAddress;
  List<UserAddress> _cachedAddresses = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load addresses when widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAddresses();
    });
  }

  Future<void> _loadAddresses() async {
    await widget.viewModel.loadUserAddresses();
    if (mounted) {
      final addresses = widget.viewModel.userAddresses;
      setState(() {
        _cachedAddresses = List.from(addresses); // Create a new list to force update
        // Clear editing address if it was deleted
        if (_editingAddress != null && !addresses.any((a) => a.id == _editingAddress!.id)) {
          _editingAddress = null;
          _showAddForm = false;
          widget.viewModel.clearAddressForm();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return BlocBuilder<ProfileViewModel, ProfileState>(
      bloc: widget.viewModel,
      buildWhen: (previous, current) {
        // Always rebuild to ensure addresses are refreshed
        return true;
      },
      builder: (context, state) {
        // Get addresses directly from viewModel - always use latest
        final addresses = widget.viewModel.userAddresses;
        
        // Update cache if addresses changed
        if (addresses.length != _cachedAddresses.length || 
            addresses.any((a) => !_cachedAddresses.any((c) => c.id == a.id)) ||
            _cachedAddresses.any((c) => !addresses.any((a) => a.id == c.id))) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _cachedAddresses = List.from(addresses);
                // Clear editing address if it was deleted
                if (_editingAddress != null && !addresses.any((a) => a.id == _editingAddress!.id)) {
                  _editingAddress = null;
                  _showAddForm = false;
                  widget.viewModel.clearAddressForm();
                }
              });
            }
          });
        }
        
        // Always use latest addresses from viewModel
        final displayAddresses = addresses;
        debugPrint('AddressesView: Building with ${displayAddresses.length} addresses');
        debugPrint('AddressesView: Cached addresses: ${_cachedAddresses.length}');
        debugPrint('AddressesView: State is ${state.runtimeType}');
        
        return OsmeaComponents.singleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing24),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Addresses List
              if (displayAddresses.isNotEmpty) ...[
                OsmeaComponents.text(
                  resources.myAddresses,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.black,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                ...displayAddresses.map((address) => _buildAddressCard(context, address)),
                OsmeaComponents.sizedBox(height: context.spacing24),
              ],

              // Add/Edit Form
              if (_showAddForm || _editingAddress != null) ...[
                OsmeaComponents.text(
                  _editingAddress != null ? 'Edit Address' : 'Add Address',
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.black,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                _buildAddressForm(context),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.row(
                  children: [
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.button(
                        text: resources.cancel,
                        variant: ButtonVariant.outlined,
                        backgroundColor: OsmeaColors.white,
                        textColor: OsmeaColors.black,
                        borderColor: OsmeaColors.black,
                        onPressed: () {
                          setState(() {
                            _showAddForm = false;
                            _editingAddress = null;
                            widget.viewModel.clearAddressForm();
                          });
                        },
                      ),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing12),
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.button(
                        text: _editingAddress != null ? resources.save : 'Add Address',
                        variant: ButtonVariant.primary,
                        backgroundColor: OsmeaColors.black,
                        textColor: OsmeaColors.white,
                        onPressed: () => _handleSaveAddress(context),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Add Address Button
                OsmeaComponents.button(
                  text: 'Add Address',
                  variant: ButtonVariant.outlined,
                  backgroundColor: OsmeaColors.white,
                  textColor: OsmeaColors.black,
                  borderColor: OsmeaColors.black,
                  splashColor: OsmeaColors.transparent,
                  hoverColor: OsmeaColors.transparent,
                  onPressed: () {
                    setState(() {
                      _showAddForm = true;
                      _editingAddress = null;
                      widget.viewModel.clearAddressForm();
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(BuildContext context, UserAddress address) {
    final resources = context.resources;
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing12),
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault ? OsmeaColors.black : OsmeaColors.silver,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.label != null && address.label!.isNotEmpty) ...[
                      OsmeaComponents.text(
                        address.label!,
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: OsmeaColors.black,
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing4),
                    ],
                    if (address.isDefault) ...[
                      OsmeaComponents.container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: OsmeaColors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: OsmeaComponents.text(
                          'Default',
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing8),
                    ],
                    OsmeaComponents.text(
                      _formatAddress(address),
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    if (address.phone != null && address.phone!.isNotEmpty) ...[
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.text(
                        '${resources.phoneNumber}: ${address.phone}',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.pewter,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              OsmeaComponents.column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OsmeaComponents.iconButton(
                    onPressed: () {
                      setState(() {
                        _editingAddress = address;
                        _showAddForm = true; // Show form when editing
                        widget.viewModel.populateAddressForm(address);
                      });
                    },
                    icon: Icon(Icons.edit, color: OsmeaColors.black, size: 20),
                    backgroundColor: OsmeaColors.transparent,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  OsmeaComponents.iconButton(
                    onPressed: () => _handleDeleteAddress(context, address),
                    icon: Icon(Icons.delete_outline, color: OsmeaColors.black, size: 20),
                    backgroundColor: OsmeaColors.transparent,
                  ),
                ],
              ),
            ],
          ),
          if (!address.isDefault) ...[
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.button(
              text: 'Set as Default',
              variant: ButtonVariant.ghost,
              backgroundColor: OsmeaColors.transparent,
              textColor: OsmeaColors.black,
              padding: EdgeInsets.symmetric(vertical: 8),
              onPressed: () => _handleSetDefault(context, address),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    final resources = context.resources;
    final viewModel = widget.viewModel;
    final configHelper = AssetConfigHelper();

    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Label (Optional)
            _buildCompactTextField(
              context,
              configHelper,
              controller: viewModel.addressLabelController,
              hint: 'Label (Optional)',
              icon: Icons.label_outline,
            ),
            SizedBox(height: context.spacing8),
            
            // Country & City row
            Row(
              children: [
                Expanded(
                  child: _buildCompactDropdown<String>(
                    context,
                    configHelper,
                    items: viewModel.countryCityMap.keys.toList(),
                    value: viewModel.addressFormSelectedCountry,
                    onChanged: (value) {
                      viewModel.setAddressFormCountry(value);
                      // Clear city when country changes
                      if (value != viewModel.addressFormSelectedCountry) {
                        viewModel.setAddressFormCity(null);
                      }
                    },
                    hint: viewModel.addressFormSelectedCountry == null 
                        ? resources.selectCountryFirst 
                        : resources.country,
                    icon: Icons.public,
                    validator: (v) => v == null ? resources.selectCountryFirst : null,
                  ),
                ),
                SizedBox(width: context.spacing8),
                Expanded(
                  child: _buildCompactDropdown<String>(
                    context,
                    configHelper,
                    items: viewModel.addressFormSelectedCountry != null
                        ? (viewModel.countryCityMap[viewModel.addressFormSelectedCountry] ?? [])
                        : [],
                    value: viewModel.addressFormSelectedCity,
                    onChanged: viewModel.setAddressFormCity,
                    hint: viewModel.addressFormSelectedCountry == null
                        ? resources.selectCountryFirst
                        : (viewModel.addressFormSelectedCity == null ? resources.selectCity : resources.city),
                    icon: Icons.location_city_outlined,
                    validator: (v) => v == null ? resources.selectCity : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing8),
            
            // Address
            _buildCompactTextField(
              context,
              configHelper,
              controller: viewModel.addressFormAddressController,
              hint: resources.addressLine1,
              icon: Icons.home_outlined,
              validator: (v) => v?.isEmpty ?? true ? resources.fillRequiredFields : null,
              maxLines: 2,
            ),
            SizedBox(height: context.spacing8),
            
            // Postal Code & Phone row
            Row(
              children: [
                Expanded(
                  child: _buildCompactTextField(
                    context,
                    configHelper,
                    controller: viewModel.addressFormPostalCodeController,
                    hint: resources.postalCode,
                    icon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: context.spacing8),
                Expanded(
                  child: _buildCompactTextField(
                    context,
                    configHelper,
                    controller: viewModel.addressFormPhoneController,
                    hint: resources.phoneNumber,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTextField(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    final bgColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_background_color',
      OsmeaColors.white,
    );
    final borderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_border_color',
      OsmeaColors.silver,
    );
    final focusedBorderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_focused_border_color',
      OsmeaColors.black,
    );
    final hintColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_hint_color',
      OsmeaColors.grayMaterial[400]!,
    );
    final iconColor = _getColorFromConfig(
      configHelper,
      'form_fields.prefix_icon_color',
      OsmeaColors.black,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: OsmeaTextStyle.bodySmall(context),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: hintColor),
        prefixIcon: Icon(icon, color: iconColor, size: 18),
        filled: true,
        fillColor: bgColor,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.spacing12,
          vertical: context.spacing10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: OsmeaColors.red[400]!, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: OsmeaColors.red[400]!, width: 1.5),
        ),
        errorStyle: OsmeaTextStyle.bodySmall(context).copyWith(
          color: OsmeaColors.red[400],
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildCompactDropdown<T>(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required List<T> items,
    required T? value,
    required ValueChanged<T?> onChanged,
    required String hint,
    required IconData icon,
    String? Function(T?)? validator,
  }) {
    final bgColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_background_color',
      OsmeaColors.white,
    );
    final borderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_border_color',
      OsmeaColors.silver,
    );
    final focusedBorderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_focused_border_color',
      OsmeaColors.black,
    );
    final hintColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_hint_color',
      OsmeaColors.grayMaterial[400]!,
    );
    final iconColor = _getColorFromConfig(
      configHelper,
      'form_fields.prefix_icon_color',
      OsmeaColors.black,
    );

    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (FormFieldState<T> field) {
        // Sync field value with current value
        if (field.value != value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              field.didChange(value);
            }
          });
        }
        
        return InputDecorator(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: hintColor),
            prefixIcon: Icon(icon, color: iconColor, size: 18),
            filled: true,
            fillColor: bgColor,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.spacing12,
              vertical: context.spacing10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: OsmeaColors.red[400]!, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: OsmeaColors.red[400]!, width: 1.5),
            ),
            errorText: field.errorText,
            errorStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.red[400],
              fontSize: 10,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value ?? field.value,
              isDense: true,
              isExpanded: true,
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: OsmeaTextStyle.bodySmall(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (T? newValue) {
                field.didChange(newValue);
                onChanged(newValue);
              },
            ),
          ),
        );
      },
    );
  }

  Color _getColorFromConfig(
    AssetConfigHelper configHelper,
    String key,
    Color defaultValue,
  ) {
    try {
      final checkoutConfig = configHelper.getObject('checkout_view_configuration');
      final colorString = checkoutConfig?[key] as String?;
      if (colorString != null && colorString.isNotEmpty) {
        if (colorString.startsWith('#')) {
          final hexString = colorString.substring(1);
          if (hexString.length == 6) {
            return Color(int.parse('FF$hexString', radix: 16));
          } else if (hexString.length == 8) {
            return Color(int.parse(hexString, radix: 16));
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load color $key: $e');
    }
    return defaultValue;
  }

  Future<void> _handleSaveAddress(BuildContext context) async {
    final resources = context.resources;
    final viewModel = widget.viewModel;

    // Validate form
    if (!(_formKey.currentState?.validate() ?? false)) {
      context.showSnackbar(
        message: resources.fillRequiredFields,
        type: SnackbarType.error,
      );
      return;
    }

    if (viewModel.addressFormAddressController.text.trim().isEmpty ||
        viewModel.addressFormSelectedCity == null ||
        viewModel.addressFormSelectedCountry == null) {
      context.showSnackbar(
        message: resources.fillRequiredFields,
        type: SnackbarType.error,
      );
      return;
    }

    final success = _editingAddress != null
        ? await viewModel.updateUserAddress(
            addressId: _editingAddress!.id,
            label: viewModel.addressLabelController.text.trim().isEmpty
                ? null
                : viewModel.addressLabelController.text.trim(),
            address: viewModel.addressFormAddressController.text.trim(),
            city: viewModel.addressFormSelectedCity,
            postalCode: viewModel.addressFormPostalCodeController.text.trim().isEmpty
                ? null
                : viewModel.addressFormPostalCodeController.text.trim(),
            country: viewModel.addressFormSelectedCountry,
            phone: viewModel.addressFormPhoneController.text.trim().isEmpty
                ? null
                : viewModel.addressFormPhoneController.text.trim(),
          )
        : await viewModel.addAddress(
            label: viewModel.addressLabelController.text.trim().isEmpty
                ? null
                : viewModel.addressLabelController.text.trim(),
            address: viewModel.addressFormAddressController.text.trim(),
            city: viewModel.addressFormSelectedCity!,
            postalCode: viewModel.addressFormPostalCodeController.text.trim().isEmpty
                ? null
                : viewModel.addressFormPostalCodeController.text.trim(),
            country: viewModel.addressFormSelectedCountry,
            phone: viewModel.addressFormPhoneController.text.trim().isEmpty
                ? null
                : viewModel.addressFormPhoneController.text.trim(),
          );

    if (success && context.mounted) {
      // Wait a bit for database to be ready
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Reload addresses to ensure UI is updated
      await _loadAddresses();
      
      // Force another reload to ensure we have the latest data
      await widget.viewModel.loadUserAddresses();
      await Future.delayed(const Duration(milliseconds: 100));
      
      setState(() {
        _showAddForm = false;
        _editingAddress = null;
        viewModel.clearAddressForm();
        // Force update cache
        _cachedAddresses = List.from(widget.viewModel.userAddresses);
      });
      
      // Verify addresses were loaded
      final addresses = widget.viewModel.userAddresses;
      debugPrint('_handleSaveAddress: After save, addresses count: ${addresses.length}');
      debugPrint('_handleSaveAddress: Cached addresses count: ${_cachedAddresses.length}');
      
      context.showSnackbar(
        message: _editingAddress != null ? resources.addressUpdated : 'Address added successfully!',
        type: SnackbarType.success,
      );
    } else if (context.mounted) {
      context.showSnackbar(
        message: 'An error occurred. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  Future<void> _handleDeleteAddress(BuildContext context, UserAddress address) async {
    final resources = context.resources;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: OsmeaColors.white,
        title: OsmeaComponents.text(
          'Delete Address',
          textStyle: OsmeaTextStyle.titleLarge(dialogContext).copyWith(
            color: OsmeaColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: OsmeaComponents.text(
          'Are you sure you want to delete this address?',
          textStyle: OsmeaTextStyle.bodyMedium(dialogContext).copyWith(
            color: OsmeaColors.black,
          ),
        ),
        actions: [
          OsmeaComponents.button(
            text: resources.cancel,
            variant: ButtonVariant.ghost,
            backgroundColor: OsmeaColors.white,
            textColor: OsmeaColors.black,
            borderColor: OsmeaColors.silver,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          OsmeaComponents.button(
            text: 'Delete',
            variant: ButtonVariant.outlined,
            backgroundColor: OsmeaColors.white,
            textColor: OsmeaColors.black,
            borderColor: OsmeaColors.black,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final deletedAddressId = address.id;
      final success = await widget.viewModel.deleteAddress(deletedAddressId);
      if (success && context.mounted) {
        // Clear editing address if it was the deleted one
        if (_editingAddress?.id == deletedAddressId) {
          setState(() {
            _editingAddress = null;
            _showAddForm = false;
            widget.viewModel.clearAddressForm();
          });
        }
        // Reload addresses to ensure UI is updated
        await _loadAddresses();
        context.showSnackbar(
          message: 'Address deleted successfully!',
          type: SnackbarType.success,
        );
      } else if (context.mounted) {
        context.showSnackbar(
          message: 'An error occurred. Please try again.',
          type: SnackbarType.error,
        );
      }
    }
  }

  Future<void> _handleSetDefault(BuildContext context, UserAddress address) async {
    final success = await widget.viewModel.setDefaultAddress(address.id);
    if (success && context.mounted) {
      // Reload addresses to ensure UI is updated
      await _loadAddresses();
      context.showSnackbar(
        message: 'Default address set successfully!',
        type: SnackbarType.success,
      );
    } else if (context.mounted) {
      context.showSnackbar(
        message: 'An error occurred. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  String _formatAddress(UserAddress address) {
    final parts = <String>[];
    if (address.address != null && address.address!.isNotEmpty) {
      parts.add(address.address!);
    }
    if (address.city != null && address.city!.isNotEmpty) {
      parts.add(address.city!);
    }
    if (address.postalCode != null && address.postalCode!.isNotEmpty) {
      parts.add(address.postalCode!);
    }
    if (address.country != null && address.country!.isNotEmpty) {
      // Normalize country display: show "Türkiye" instead of "Turkey"
      final country = address.country == 'Turkey' ? 'Türkiye' : address.country;
      parts.add(country!);
    }
    return parts.isEmpty ? 'Address' : parts.join(', ');
  }
}
