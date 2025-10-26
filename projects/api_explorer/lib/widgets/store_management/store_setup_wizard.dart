import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apis/apis.dart';
import 'package:core/core.dart';
import '../../services/handlers/woocommerce/auth_handlers/jwt_auth_test_handler.dart';
import '../../services/handlers/woocommerce/auth_handlers/user_signup_handler.dart';
import '../../services/handlers/woocommerce/auth_handlers/send_reset_password_handler.dart';

class StoreSetupWizard extends StatefulWidget {
  final Function(StoreConfiguration)? onStoreAdded;
  final bool isInitialSetup;
  final StoreConfiguration? existingStore;
  final bool forceReset;

  const StoreSetupWizard({
    super.key,
    this.onStoreAdded,
    this.isInitialSetup = true,
    this.existingStore,
    this.forceReset = false,
  });

  @override
  State<StoreSetupWizard> createState() => _StoreSetupWizardState();

  static Future<StoreConfiguration?> show(BuildContext context,
      {Function(StoreConfiguration)? onStoreAdded,
      bool isInitialSetup = false,
      StoreConfiguration? existingStore,
      bool forceReset = false}) async {
    return showDialog<StoreConfiguration>(
      context: context,
      barrierDismissible: false,
      barrierColor: OsmeaColors.transparent,
      builder: (BuildContext context) {
        return StoreSetupWizard(
          onStoreAdded: onStoreAdded,
          isInitialSetup: isInitialSetup,
          existingStore: existingStore,
          forceReset: forceReset,
        );
      },
    );
  }

  static Future<bool> shouldShow() async {
    try {
      final currentStore = await WizardHelper.getCurrentStore();
      return currentStore == null;
    } catch (e) {
      return true; // Show wizard if there's an error
    }
  }
}

class _StoreSetupWizardState extends State<StoreSetupWizard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentStep = 0;
  String? _selectedPlatform;
  String _currentTab = 'store'; // For WooCommerce tab navigation

  // Regex patterns for validation
  static final RegExp _storeNameRegex = RegExp(r'^[a-zA-Z0-9\s\-_]{2,50}$');
  static final RegExp _shopifyTokenRegex = RegExp(r'^shpat_[a-fA-F0-9]+$');
  static final RegExp _apiVersionRegex = RegExp(r'^\d{4}-\d{2}$');
  static final RegExp _wooCommerceApiVersionRegex = RegExp(r'^v[0-9]+$');
  static final RegExp _shopifyUrlRegex = RegExp(
      r'^[a-zA-Z0-9\-]+\.myshopify\.com$|^https?://[a-zA-Z0-9\-]+\.myshopify\.com/?$');
  static final RegExp _wooCommerceUrlRegex =
      RegExp(r'^https?://[a-zA-Z0-9\-\.:]+(?:\.[a-zA-Z]{2,}|:\d+)/?.*$');
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_\-\.@]{3,50}$');
  // No password regex - backend handles all validation
  // We only check if password is not empty
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  // WooCommerce Customer Auth regex patterns
  static final RegExp _authEndpointRegex = RegExp(r'^[a-zA-Z0-9_\-\./]+$');

  // Validation error messages
  String? _storeNameError;
  String? _accessTokenError;
  String? _apiVersionError;
  String? _storeUrlError;
  String? _usernameError;
  String? _passwordError;

  // WooCommerce Customer Auth validation errors
  String? _customerEmailError;
  String? _customerPasswordError;
  String? _authEndpointError;

  // Authentication testing state
  bool _isTestingAuth = false;
  bool _isSigningUp = false;
  bool _isResettingPassword = false;
  String? _authTestResult;
  String? _resetPasswordResult;

  // Controllers for form fields
  final _storeNameController = TextEditingController();
  final _accessTokenController = TextEditingController();
  final _apiVersionController = TextEditingController();
  final _storeUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // WooCommerce Customer Auth Controllers
  final _customerEmailController = TextEditingController();
  final _customerPasswordController = TextEditingController();
  final _authEndpointController = TextEditingController();

  // Sign up fields (Postman parameters only)
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupAuthKeyController = TextEditingController();
  
  // Reset password email field
  final _resetPasswordEmailController = TextEditingController();

  // Password visibility states
  bool _isAccessTokenVisible = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _selectedPlatform = 'shopify';
    _initializeAnimations();
    _loadExistingConfiguration();

    // For editing existing store, start from step 1 (configuration step)
    if (widget.existingStore != null) {
      _currentStep = 1;
      _loadExistingStoreData();
    } else if (widget.forceReset) {
      // Force restart from beginning and clear saved state
      _currentStep = 0;
      _clearWizardStep();
    } else if (widget.isInitialSetup) {
      _restoreWizardStep(); // Restore previous step
    } else {
      // Reset to first step for new store addition
      _currentStep = 0;
    }

    _setupAutoFillListeners();
  }

  void _setupAutoFillListeners() {
    // Auto-fill store URL for Shopify when store name changes
    _storeNameController.addListener(() {
      if (_selectedPlatform == 'shopify') {
        final storeName = _storeNameController.text.trim();
        if (storeName.isNotEmpty) {
          // Remove any existing .myshopify.com and create clean URL
          final cleanStoreName = storeName
              .toLowerCase()
              .replaceAll(
                  RegExp(r'[^a-z0-9\-]'), '') // Remove invalid characters
              .replaceAll(
                  RegExp(r'-+'), '-') // Replace multiple dashes with single
              .replaceAll(
                  RegExp(r'^-|-$'), ''); // Remove leading/trailing dashes

          if (cleanStoreName.isNotEmpty &&
              !cleanStoreName.endsWith('.myshopify.com')) {
            _storeUrlController.text = '$cleanStoreName.myshopify.com';
            debugPrint(
                '🔧 Auto-generated Store URL: ${_storeUrlController.text}');
          }
        }
      }
      // Update tab states when store name changes
      if (mounted) setState(() {});
    });

    // Add listeners to WooCommerce store configuration fields to update tab states
    _storeUrlController.addListener(() {
      if (mounted) setState(() {});
    });

    _usernameController.addListener(() {
      if (mounted) setState(() {});
    });

    _passwordController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  // Step persistence methods
  Future<void> _saveWizardStep() async {
    try {
      final storage = LocalStorageHelper();
      await storage.init();
      await storage.setItem('wizard_current_step', _currentStep.toString());
      await storage.setItem(
          'wizard_selected_platform', _selectedPlatform ?? '');
      debugPrint(
          '✅ Wizard step saved: $_currentStep using Core LocalStorageHelper');
    } catch (e) {
      debugPrint('❌ Error saving wizard step: $e');
    }
  }

  Future<void> _restoreWizardStep() async {
    try {
      final storage = LocalStorageHelper();
      await storage.init();
      final savedStepString = await storage.getItem('wizard_current_step');
      final savedPlatform = await storage.getItem('wizard_selected_platform');

      if (savedStepString != null) {
        final savedStep = int.tryParse(savedStepString);
        if (savedStep != null && savedStep >= 0 && savedStep <= 2) {
          setState(() {
            _currentStep = savedStep;
            if (savedPlatform != null && savedPlatform.isNotEmpty) {
              _selectedPlatform = savedPlatform;
            }
          });
          debugPrint(
              '✅ Wizard step restored: $_currentStep using Core LocalStorageHelper');
        }
      }
    } catch (e) {
      debugPrint('❌ Error restoring wizard step: $e');
    }
  }

  Future<void> _clearWizardStep() async {
    try {
      final storage = LocalStorageHelper();
      await storage.init();
      await storage.removeItem('wizard_current_step');
      await storage.removeItem('wizard_selected_platform');
      debugPrint('✅ Wizard state cleared using Core LocalStorageHelper');
    } catch (e) {
      debugPrint('❌ Error clearing wizard step: $e');
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  Future<void> _loadExistingConfiguration() async {
    try {
      final currentStore = await WizardHelper.getCurrentStore();
      if (currentStore != null) {
        setState(() {
          _selectedPlatform = currentStore.platform;
          _apiVersionController.text = currentStore.apiVersion;
        });
      } else {
        // Set default values for new stores
        _apiVersionController.text = '2025-07';
      }
    } catch (e) {
      debugPrint('❌ Error loading existing configuration: $e');
      // Set default values on error
      _apiVersionController.text = '2025-07';
    }
  }

  void _loadExistingStoreData() {
    if (widget.existingStore == null) return;

    final store = widget.existingStore!;
    setState(() {
      _selectedPlatform = store.platform;
      _storeNameController.text = store.displayName;
      _apiVersionController.text = store.apiVersion;

      if (store.platform == 'shopify') {
        _accessTokenController.text = store.shopifyAccessToken ?? '';
        _storeUrlController.text = store.storeUrl ?? '';
      } else if (store.platform == 'woocommerce') {
        _storeUrlController.text = store.storeUrl ?? '';
        _usernameController.text = store.username ?? '';
        _passwordController.text = store.password ?? '';
        _authEndpointController.text = store.authEndpoint ?? '';
      }
    });

    debugPrint('✅ Existing store data loaded: ${store.displayName}');
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (_currentStep == 1 && !_validateForm()) {
        return;
      }
      debugPrint('✅ Moving to next step: ${_currentStep + 1}');
      setState(() {
        _currentStep++;
      });
      _saveWizardStep(); // Save step when moving forward
      debugPrint('✅ Current step updated to: $_currentStep');
    } else {
      debugPrint('⚠️ Already at last step: $_currentStep');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      debugPrint('✅ Moving to previous step: ${_currentStep - 1}');
      setState(() {
        _currentStep--;
      });
      _saveWizardStep(); // Save step when moving backward
      debugPrint('✅ Current step updated to: $_currentStep');
    } else {
      debugPrint('⚠️ Already at first step: $_currentStep');
    }
  }

  /// Check for duplicate store name in real-time during form validation
  void _checkDuplicateNameInRealTime() {
    // Only check for duplicates when adding new store (not editing)
    if (widget.existingStore != null) return;

    try {
      final storeService = StoreManagementService();
      storeService.refreshStores().then((_) {
        final existingStores = storeService.allStores;
        final newStoreName = _storeNameController.text.trim();

        final duplicateName = existingStores.any((store) =>
            store.displayName.toLowerCase() == newStoreName.toLowerCase());

        if (duplicateName && mounted) {
          setState(() {
            _storeNameError = 'A store with this name already exists';
          });
        }
      });
    } catch (e) {
      debugPrint('❌ Error checking duplicate name in real-time: $e');
    }
  }

  /// Show warning when trying to access Customer Authentication without completing Store Configuration
  Widget _buildStoreConfigurationWarning() {
    if (_selectedPlatform != 'woocommerce' ||
        _currentTab != 'store' ||
        _isStoreConfigurationComplete()) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing24),
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.amberFlame.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.amberFlame.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: OsmeaColors.amberFlame,
            size: 24,
          ),
          OsmeaComponents.sizedBox(width: 12),
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Complete Store Configuration First',
                  textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.amberFlame,
                  ),
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'Please fill in all required store configuration fields below. Once completed, the Customer Authentication tab will become available.',
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    color: OsmeaColors.steel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Check if store configuration is complete
  bool _isStoreConfigurationComplete() {
    if (_selectedPlatform != 'woocommerce') {
      return true; // Only check for WooCommerce
    }

    return _storeNameController.text.trim().isNotEmpty &&
        _storeUrlController.text.trim().isNotEmpty &&
        _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  /// Test WooCommerce JWT Authentication
  Future<void> _testAuthentication() async {
    if (_customerEmailController.text.isEmpty ||
        _customerPasswordController.text.isEmpty) {
      setState(() {
        _authTestResult = 'Please enter customer email and password first';
      });
      return;
    }

    setState(() {
      _isTestingAuth = true;
      _authTestResult = null;
    });

    try {
      debugPrint('🔐 Testing WooCommerce JWT authentication...');

      // Get brand name from current store configuration or use store name
      final brandName = await WizardHelper.getBrandNameForAuth();
      final effectiveBrandName =
          brandName.isNotEmpty ? brandName : _storeNameController.text.trim();

      // Use the JWT Auth Test Handler
      final handler = JwtAuthTestHandler();

      // Get password as raw string and convert safely
      final rawPassword = _customerPasswordController.text;
      final safePassword = _convertPasswordToSafeString(rawPassword);

      final params = {
        'brand_name': effectiveBrandName,
        'username': _customerEmailController.text.trim(),
        'password': safePassword,
      };

      final result = await handler.handleRequest('POST', params);

      if (result['status'] == 'success') {
        // Extract JWT token from response
        final tokenInfo = result['token_info'] as Map<String, dynamic>?;
        final jwtToken = tokenInfo?['jwt'] as String? ??
            tokenInfo?['access_token'] as String?;

        if (jwtToken != null && jwtToken.isNotEmpty) {
          debugPrint('🔑 JWT token received: ${jwtToken.substring(0, 20)}...');
        }

        setState(() {
          _authTestResult = jwtToken != null && jwtToken.isNotEmpty
              ? '✅ Authentication successful! JWT token received and saved to local storage.\n\n🔑 JWT Token:\n$jwtToken'
              : '✅ Authentication successful! JWT token received and saved to local storage.';
        });
        debugPrint('✅ JWT authentication test successful');
      } else {
        setState(() {
          _authTestResult = '❌ Authentication failed: ${result['message']}';
        });
        debugPrint('❌ JWT authentication test failed: ${result['message']}');
      }
    } catch (e) {
      setState(() {
        _authTestResult = '❌ Authentication error: ${e.toString()}';
      });
      debugPrint('❌ JWT authentication test error: $e');
    } finally {
      setState(() {
        _isTestingAuth = false;
      });
    }
  }

  /// Sign up new user using WooCommerce auth
  Future<void> _signUpUser() async {
    if (_signupEmailController.text.isEmpty ||
        _signupPasswordController.text.isEmpty ||
        _signupAuthKeyController.text.isEmpty) {
      setState(() {
        _authTestResult =
            'Please fill in email, password and AUTH_KEY for sign up';
      });
      return;
    }

    setState(() {
      _isSigningUp = true;
      _authTestResult = null;
    });

    try {
      debugPrint('📝 Starting user sign up...');

      // Get brand name from current store configuration or use store name
      final brandName = await WizardHelper.getBrandNameForAuth();
      final effectiveBrandName =
          brandName.isNotEmpty ? brandName : _storeNameController.text.trim();

      // Use the User Sign Up Handler
      final handler = UserSignUpHandler();

      // Get password as raw string and convert safely
      final rawPassword = _signupPasswordController.text;
      final safePassword = _convertPasswordToSafeString(rawPassword);

      final params = <String, String>{
        'rest_route': '/$effectiveBrandName-auth-login/v1/users',
        'email': _signupEmailController.text.trim(),
        'password': safePassword,
        'AUTH_KEY': _signupAuthKeyController.text.trim(),
      };

      final result = await handler.handleRequest('POST', params);

      if (result['status'] == 'success') {
        setState(() {
          _authTestResult =
              '✅ User sign up successful!\n\n👤 User created:\n${result['user_data']}';
        });
        debugPrint('✅ User sign up successful');

        // Clear sign up form
        _signupEmailController.clear();
        _signupPasswordController.clear();
        _signupAuthKeyController.clear();
      } else {
        setState(() {
          _authTestResult = '❌ Sign up failed: ${result['message']}';
        });
        debugPrint('❌ User sign up failed: ${result['message']}');
      }
    } catch (e) {
      setState(() {
        _authTestResult = '❌ Sign up error: ${e.toString()}';
      });
      debugPrint('❌ User sign up error: $e');
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

  /// Check if a store with the same configuration already exists
  /// Returns a tuple: (isDuplicate, duplicateType, duplicateValue)
  Future<(bool, String, String)> _checkForDuplicateStore() async {
    try {
      final storeService = StoreManagementService();
      await storeService.refreshStores();
      final existingStores = storeService.allStores;

      final newStoreName = _storeNameController.text.trim();
      final newStoreUrl = _storeUrlController.text.trim();
      final newPlatform = _selectedPlatform!;
      final currentStoreId = widget.existingStore?.id;

      // Check for duplicate store name (excluding current store when editing)
      final duplicateName = existingStores.any((store) =>
          store.displayName.toLowerCase() == newStoreName.toLowerCase() &&
          store.id != currentStoreId);

      if (duplicateName) {
        return (true, 'name', newStoreName);
      }

      // Check for duplicate store URL (for same platform, excluding current store)
      if (newStoreUrl.isNotEmpty) {
        final duplicateUrl = existingStores.any((store) =>
            store.platform == newPlatform &&
            store.storeUrl?.toLowerCase() == newStoreUrl.toLowerCase() &&
            store.id != currentStoreId);

        if (duplicateUrl) {
          return (true, 'URL', newStoreUrl);
        }
      }

      // Check for duplicate Shopify store name (myshopify.com, excluding current store)
      if (newPlatform == 'shopify' && newStoreUrl.isNotEmpty) {
        final shopifyStoreName = newStoreUrl.replaceAll('.myshopify.com', '');
        final duplicateShopifyName = existingStores.any((store) =>
            store.platform == 'shopify' &&
            store.storeUrl?.contains(shopifyStoreName) == true &&
            store.id != currentStoreId);

        if (duplicateShopifyName) {
          return (true, 'Shopify store', shopifyStoreName);
        }
      }

      return (false, '', '');
    } catch (e) {
      debugPrint('❌ Error checking for duplicate stores: $e');
      return (false, '', ''); // Allow if we can't check
    }
  }

  Future<void> _completeSetup() async {
    debugPrint('🔧 _completeSetup called - START');

    if (!_validateForm()) {
      debugPrint('❌ Form validation failed');
      _showErrorMessage('Please complete all required fields correctly');
      return;
    }

    // Only check for duplicate store when adding new store (not editing)
    if (widget.existingStore == null) {
      final (isDuplicate, duplicateType, duplicateValue) =
          await _checkForDuplicateStore();
      if (isDuplicate) {
        debugPrint(
            '❌ Duplicate store detected: $duplicateType - $duplicateValue');
        String errorMessage;
        switch (duplicateType) {
          case 'name':
            errorMessage =
                'A store with the name "$duplicateValue" already exists. Please use a different name.';
            break;
          case 'URL':
            errorMessage =
                'A store with the URL "$duplicateValue" already exists. Please use a different URL.';
            break;
          case 'Shopify store':
            errorMessage =
                'A Shopify store with the name "$duplicateValue" already exists. Please use a different store name.';
            break;
          default:
            errorMessage =
                'A store with this configuration already exists. Please use different values.';
        }
        _showErrorMessage(errorMessage);
        return;
      }
    }

    debugPrint('✅ Form validation passed');

    try {
      // begin setup
      debugPrint('🔧 Creating StoreConfiguration...');

      final config = StoreConfiguration(
        id: widget.existingStore?.id, // Use existing ID when editing
        storeName: _storeNameController.text.trim(),
        displayName: _storeNameController.text.trim(),
        platform: _selectedPlatform!,
        shopifyAccessToken: _selectedPlatform == 'shopify'
            ? _accessTokenController.text.trim()
            : null,
        apiVersion: _apiVersionController.text.trim(),
        storeUrl: _selectedPlatform == 'shopify'
            ? _storeUrlController.text.trim()
            : _selectedPlatform == 'woocommerce'
                ? _storeUrlController.text.trim()
                : null,
        username: _selectedPlatform == 'woocommerce'
            ? _usernameController.text.trim()
            : null,
        password: _selectedPlatform == 'woocommerce'
            ? _convertPasswordToSafeString(_passwordController.text)
            : null,
        // WooCommerce Customer Auth fields
        authEndpoint: _selectedPlatform == 'woocommerce' &&
                _authEndpointController.text.isNotEmpty
            ? _authEndpointController.text.trim()
            : null,
        isActive: widget.existingStore?.isActive ?? true,
        isDefault: widget.existingStore?.isDefault ?? true,
        createdAt: widget.existingStore?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      debugPrint('🔧 _completeSetup called');
      debugPrint('🔧 _selectedPlatform: $_selectedPlatform');
      debugPrint('🔧 Config created: ${config.toJson()}');

      // Use updateStore for existing stores, addStore for new stores
      final bool success;
      if (widget.existingStore != null) {
        debugPrint('🔧 Calling WizardHelper.updateStore...');
        success = await WizardHelper.updateStore(config);
        debugPrint('🔧 WizardHelper.updateStore result: $success');
      } else {
        debugPrint('🔧 Calling WizardHelper.addStore...');
        success = await WizardHelper.addStore(config);
        debugPrint('🔧 WizardHelper.addStore result: $success');
      }

      if (success) {
        debugPrint('🔧 Configuration saved successfully');

        // Notify parent about the store (new or updated)
        widget.onStoreAdded?.call(config);

        // Reinitialize networks after configuration
        try {
          debugPrint('🔧 Reinitializing networks...');
          await _reinitializeNetworks(config);
          debugPrint('✅ Networks reinitialized successfully');
        } catch (e) {
          debugPrint('⚠️ Network reinitialization warning: $e');
          // Continue with success flow even if network reinitialization fails
          // The store configuration was saved successfully
        }

        if (mounted) {
          // Show success message with store information
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: OsmeaComponents.column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    widget.existingStore != null
                        ? '✅ Store configuration updated successfully!'
                        : '✅ Store configuration saved successfully!',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: 4),
                  OsmeaComponents.text(
                    '${config.platform.toUpperCase()}: ${config.displayName}',
                    textStyle: OsmeaTextStyle.captionMedium(context),
                  ),
                  OsmeaComponents.text(
                    'You can now explore APIs for this platform',
                    textStyle: OsmeaTextStyle.captionMedium(context),
                  ),
                ],
              ),
              backgroundColor: OsmeaColors.forestHeart,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Wait a bit for the message to be visible, then close
          await Future.delayed(const Duration(milliseconds: 1000));

          if (mounted) {
            Navigator.of(context).pop(config);
          }
        }
      } else {
        debugPrint('❌ Failed to save configuration');
        if (mounted) {
          _showErrorMessage('Failed to save configuration');
        }
      }
    } catch (e) {
      debugPrint('❌ Error in _completeSetup: $e');
      if (mounted) {
        _showErrorMessage('Error: $e');
      }
    } finally {
      // end setup
      debugPrint('🔧 _completeSetup completed');
    }
  }

  Future<void> _reinitializeNetworks(StoreConfiguration config) async {
    try {
      if (config.platform == 'shopify') {
        // Reinitialize Shopify network
        ApiNetwork.updateStoreName(config.storeName);
        if (config.shopifyAccessToken != null) {
          ApiNetwork.updateShopifyAccessToken(config.shopifyAccessToken!);
        }
        ApiNetwork.updateApiVersion(config.apiVersion);
        debugPrint('✅ Shopify network reinitialized');
      } else if (config.platform == 'woocommerce') {
        // Reinitialize WooCommerce network - wrapped in try-catch to handle potential errors
        try {
          if (config.storeUrl != null) {
            WooNetwork.updateStoreUrl(config.storeUrl!);
          }
          if (config.username != null) {
            WooNetwork.updateUsername(config.username!);
          }
          if (config.password != null) {
            WooNetwork.updatePassword(config.password!);
          }
          WooNetwork.updateApiVersion(config.apiVersion);
          debugPrint('✅ WooCommerce network reinitialized');
        } catch (wooError) {
          debugPrint(
              '⚠️ WooCommerce network reinitialization failed: $wooError');
          // Don't rethrow - just log the error and continue
        }
      }
    } catch (e) {
      debugPrint('⚠️ Network reinitialization warning: $e');
      // Don't rethrow the error - just log it as a warning
      // The store configuration was still saved successfully
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: OsmeaComponents.text(message),
          backgroundColor: OsmeaColors.slate,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  bool _validateForm() {
    setState(() {
      _storeNameError = null;
      _accessTokenError = null;
      _apiVersionError = null;
      _storeUrlError = null;
      _usernameError = null;
      _passwordError = null;
      _authEndpointError = null;
    });

    bool isValid = true;

    // Store name validation
    if (_storeNameController.text.isEmpty) {
      _storeNameError = 'Store name is required';
      isValid = false;
    } else if (!_storeNameRegex.hasMatch(_storeNameController.text)) {
      _storeNameError =
          'Store name must be 2-50 characters, alphanumeric with spaces, hyphens, underscores';
      isValid = false;
    } else {
      // Check for duplicate store name in real-time
      _checkDuplicateNameInRealTime();
    }

    if (_selectedPlatform == 'shopify') {
      // Shopify access token validation
      if (_accessTokenController.text.isEmpty) {
        _accessTokenError = 'Access token is required';
        isValid = false;
      } else if (!_shopifyTokenRegex.hasMatch(_accessTokenController.text)) {
        _accessTokenError =
            'Invalid Shopify token format. Must start with shpat_ followed by hex characters';
        isValid = false;
      }

      // API version validation
      if (_apiVersionController.text.isEmpty) {
        _apiVersionError = 'API version is required';
        isValid = false;
      } else if (!_apiVersionRegex.hasMatch(_apiVersionController.text)) {
        _apiVersionError =
            'API version must be in YYYY-MM format (e.g., 2025-07)';
        isValid = false;
      }

      // Store URL validation
      if (_storeUrlController.text.isEmpty) {
        _storeUrlError = 'Store name is required';
        isValid = false;
      } else if (!_shopifyUrlRegex.hasMatch(_storeUrlController.text)) {
        _storeUrlError = 'Invalid Shopify store name (e.g., mystore)';
        isValid = false;
      }
    } else if (_selectedPlatform == 'woocommerce') {
      // WooCommerce store URL validation
      if (_storeUrlController.text.isEmpty) {
        _storeUrlError = 'Store URL is required';
        isValid = false;
      } else if (!_wooCommerceUrlRegex.hasMatch(_storeUrlController.text)) {
        _storeUrlError =
            'Invalid URL format (e.g., http://localhost:8000 or https://yourstore.com)';
        isValid = false;
      }

      // Username validation
      if (_usernameController.text.isEmpty) {
        _usernameError = 'Username is required';
        isValid = false;
      } else if (!_usernameRegex.hasMatch(_usernameController.text)) {
        _usernameError =
            'Username must be 3-50 characters, alphanumeric with special chars';
        isValid = false;
      }

      // Password validation - only check if not empty, backend handles the rest
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
        isValid = false;
      } else {
        // Convert password to safe string (preserves all characters)
        final safePassword =
            _convertPasswordToSafeString(_passwordController.text);
        if (safePassword.isEmpty) {
          _passwordError = 'Password cannot be empty after processing';
          isValid = false;
        }
        // No regex validation - backend handles all password rules
      }

      // API version validation for WooCommerce
      if (_apiVersionController.text.isEmpty) {
        _apiVersionError = 'API version is required';
        isValid = false;
      } else if (!_wooCommerceApiVersionRegex
          .hasMatch(_apiVersionController.text)) {
        _apiVersionError = 'API version must be in format v3, v2, etc.';
        isValid = false;
      }
    }

    // Customer Authentication validation (only for WooCommerce)
    if (_selectedPlatform == 'woocommerce' && _currentTab == 'customer') {
      // Customer Email validation
      if (_customerEmailController.text.isEmpty) {
        _customerEmailError = 'Customer email is required';
        isValid = false;
      } else if (!_emailRegex.hasMatch(_customerEmailController.text)) {
        _customerEmailError = 'Please enter a valid email address';
        isValid = false;
      }

      // Customer Password validation - only check if not empty, backend handles the rest
      if (_customerPasswordController.text.isEmpty) {
        _customerPasswordError = 'Customer password is required';
        isValid = false;
      } else {
        // Convert password to safe string (preserves all characters)
        final safePassword =
            _convertPasswordToSafeString(_customerPasswordController.text);
        if (safePassword.isEmpty) {
          _customerPasswordError = 'Password cannot be empty after processing';
          isValid = false;
        }
        // No regex validation - backend handles all password rules
      }

      // Auth Endpoint validation
      if (_authEndpointController.text.isEmpty) {
        _authEndpointError = 'Authentication endpoint is required';
        isValid = false;
      } else if (!_authEndpointRegex.hasMatch(_authEndpointController.text)) {
        _authEndpointError = 'Invalid endpoint format';
        isValid = false;
      }
    }

    if (!isValid) {
      setState(() {});
    }

    return isValid;
  }

  /// 🔐 Convert raw password to safe string for API transmission
  /// Handles special characters and ensures proper encoding
  String _convertPasswordToSafeString(String rawPassword) {
    try {
      // Only remove dangerous null characters and control characters (0x00-0x1F, 0x7F)
      // Keep ALL other characters including special chars, unicode, emojis, etc.
      final cleanedPassword = rawPassword.replaceAll(
          RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');

      // Ensure the password is not empty after cleaning
      if (cleanedPassword.isEmpty) {
        throw Exception('Password cannot be empty after cleaning');
      }

      // Convert to string and trim whitespace
      final safePassword = cleanedPassword.trim();

      // Validate that the password contains at least one character
      if (safePassword.isEmpty) {
        throw Exception('Password cannot be empty');
      }

      debugPrint(
          '🔐 Password converted safely: ${safePassword.length} characters (preserves all special chars)');
      return safePassword;
    } catch (e) {
      debugPrint('❌ Error converting password: $e');
      // Return the original password as fallback, but log the error
      return rawPassword.trim();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _storeNameController.dispose();
    _accessTokenController.dispose();
    _apiVersionController.dispose();
    _storeUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _customerEmailController.dispose();
    _customerPasswordController.dispose();
    _authEndpointController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupAuthKeyController.dispose();
    _resetPasswordEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          if (_currentStep == 0 && _selectedPlatform != null) {
            _nextStep();
            return KeyEventResult.handled;
          } else if (_currentStep == 1 && _validateForm()) {
            _nextStep();
            return KeyEventResult.handled;
          } else if (_currentStep == 2) {
            _completeSetup();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Dialog(
                  backgroundColor: OsmeaColors.transparent,
                  child: OsmeaComponents.container(
                    // Responsive sizing using MediaQuery
                    width: MediaQuery.of(context).size.width > 600
                        ? 500.0 // 500px on larger screens
                        : MediaQuery.of(context).size.width *
                            0.95, // 95% width on small screens
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height *
                          0.85, // 85% height
                      minHeight: 500.0,
                      minWidth: 300.0,
                    ),
                    decoration: BoxDecoration(
                      color: OsmeaColors.white,
                      borderRadius: context.borderRadiusNormal,
                      boxShadow: [
                        BoxShadow(
                          color: OsmeaColors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: OsmeaComponents.column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        OsmeaComponents.container(
                          width: double.infinity,
                          padding: context.paddingNormal,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                OsmeaColors.nordicBlue,
                                OsmeaColors.eclipse
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(context.radiusNormal),
                              topRight: Radius.circular(context.radiusNormal),
                            ),
                          ),
                          child: OsmeaComponents.row(
                            children: [
                              OsmeaComponents.container(
                                padding: context.paddingLow,
                                decoration: BoxDecoration(
                                  color:
                                      OsmeaColors.white.withValues(alpha: 0.2),
                                  borderRadius: context.borderRadiusNormal,
                                ),
                                child: Icon(
                                  Icons.store,
                                  color: OsmeaColors.white,
                                  size: context.iconSizeNormal,
                                ),
                              ),
                              OsmeaComponents.sizedBox(
                                  width: context.spacing16),
                              OsmeaComponents.text(
                                widget.existingStore != null
                                    ? 'Edit Store'
                                    : widget.isInitialSetup
                                        ? 'Store Setup Wizard'
                                        : 'Add New Store',
                                textStyle: OsmeaTextStyle.displayMedium(context)
                                    .copyWith(
                                  color: OsmeaColors.white,
                                ),
                              ),
                              OsmeaComponents.spacer(),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  Icons.close,
                                  color: OsmeaColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Step indicator
                        OsmeaComponents.container(
                          padding: context.paddingNormal,
                          child: _buildStepIndicator(),
                        ),

                        // Content
                        OsmeaComponents.expanded(
                          child: OsmeaComponents.singleChildScrollView(
                            padding: context.horizontalPaddingNormal,
                            child: _buildStepContent(),
                          ),
                        ),

                        // Bottom navigation
                        OsmeaComponents.container(
                          padding: context.paddingNormal,
                          child: _buildNavigationButtons(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepIndicator() {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return OsmeaComponents.container(
          margin: EdgeInsets.symmetric(horizontal: context.spacing8),
          child: OsmeaComponents.row(
            children: [
              OsmeaComponents.container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? OsmeaColors.forestHeart
                      : isActive
                          ? OsmeaColors.nordicBlue
                          : OsmeaColors.silver,
                  shape: BoxShape.circle,
                ),
                child: OsmeaComponents.center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          color: OsmeaColors.white,
                          size: 20,
                        )
                      : OsmeaComponents.text(
                          '${index + 1}',
                          textStyle:
                              OsmeaTextStyle.bodyMedium(context).copyWith(
                            color: OsmeaColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (index < 2)
                OsmeaComponents.container(
                  width: 60,
                  height: 2,
                  margin: EdgeInsets.symmetric(horizontal: context.spacing8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? OsmeaColors.forestHeart
                        : OsmeaColors.silver,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPlatformSelectionStep();
      case 1:
        return _buildConfigurationStep();
      case 2:
        return _buildReviewStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTabBar() {
    if (_selectedPlatform != 'woocommerce') {
      return const SizedBox.shrink();
    }

    final tabs = WizardHelper.getWooCommerceTabs();
    final tabNames = WizardHelper.getPlatformTabNames('woocommerce');

    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing24),
      padding: EdgeInsets.all(context.spacing6),
      decoration: BoxDecoration(
        color: OsmeaColors.ash.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OsmeaColors.steel.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.steel.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: OsmeaComponents.row(
        children: tabs.map((tab) {
          final isActive = _currentTab == tab;
          final tabName = tabNames[tab] ?? tab;
          final isCustomerTab = tab == 'customer';
          final isStoreConfigComplete = _isStoreConfigurationComplete();
          final isTabDisabled = isCustomerTab && !isStoreConfigComplete;

          // Define tab icons with proper styling
          IconData tabIcon;
          if (tab == 'store') {
            tabIcon = Icons.store_mall_directory_outlined;
          } else if (tab == 'customer') {
            tabIcon = Icons.person_outline_rounded;
          } else {
            tabIcon = Icons.settings_outlined;
          }

          return OsmeaComponents.expanded(
            child: OsmeaComponents.container(
              margin: EdgeInsets.symmetric(horizontal: context.spacing4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Opacity(
                  opacity: isTabDisabled ? 0.5 : 1.0,
                  child: OsmeaComponents.button(
                    text: tabName,
                    variant:
                        isActive ? ButtonVariant.primary : ButtonVariant.ghost,
                    size: ButtonSize
                        .small, // Changed from medium to small for smaller text
                    icon: Icon(
                      tabIcon,
                      size: 18, // Reduced icon size to match smaller text
                      color: isTabDisabled
                          ? OsmeaColors.steel.withValues(alpha: 0.4)
                          : isActive
                              ? Colors.white
                              : OsmeaColors.steel.withValues(alpha: 0.8),
                    ),
                    onPressed: () {
                      // Check if trying to access Customer Authentication without completing Store Configuration
                      if (tab == 'customer' &&
                          !_isStoreConfigurationComplete()) {
                        // Don't switch tab, stay on store configuration
                        return;
                      }

                      setState(() {
                        _currentTab = tab;
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlatformSelectionStep() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Choose Your Platform',
          textStyle: OsmeaTextStyle.titleLarge(context),
          color: OsmeaColors.steel,
        ),
        OsmeaComponents.sizedBox(height: context.spacing16),
        OsmeaComponents.text(
          'Select the e-commerce platform you want to connect with:',
          textStyle: OsmeaTextStyle.bodyLarge(context),
          color: OsmeaColors.steel.withValues(alpha: 0.7),
        ),
        OsmeaComponents.sizedBox(height: context.spacing32),

        // Platform options
        OsmeaComponents.row(
          children: [
            OsmeaComponents.expanded(
              child: _buildPlatformOption(
                'shopify',
                'Shopify',
                'Connect to your Shopify store',
                Icons.shopping_bag_rounded,
                OsmeaColors.nordicBlue,
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing16),
            OsmeaComponents.expanded(
              child: _buildPlatformOption(
                'woocommerce',
                'WooCommerce',
                'Connect to your WooCommerce store',
                Icons.shopping_cart_checkout_rounded,
                OsmeaColors.forestHeart,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlatformOption(
    String platform,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedPlatform == platform;

    return OsmeaComponents.container(
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : OsmeaColors.white,
        border: Border.all(
          color: isSelected ? color : OsmeaColors.silver,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: context.borderRadiusNormal,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPlatform = platform;
            _currentTab = 'store'; // Reset to store tab when platform changes
            // Reset form when platform changes
            _storeNameController.clear();
            _accessTokenController.clear();
            _storeUrlController.clear();
            _usernameController.clear();
            _passwordController.clear();
            _authEndpointController.clear();

            // Set default API version based on platform
            if (platform == 'shopify') {
              _apiVersionController.text = '2025-07';
            } else if (platform == 'woocommerce') {
              _apiVersionController.text = 'v3';
              _authEndpointController.text = 'wc-auth/v1';
            }
          });
        },
        borderRadius: context.borderRadiusNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OsmeaComponents.container(
              padding: context.paddingNormal,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.1),
                borderRadius: context.borderRadiusNormal,
              ),
              child: Icon(
                icon,
                size: 48,
                color: isSelected ? color : color.withValues(alpha: 0.7),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              title,
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : OsmeaColors.steel,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              description,
              textStyle: OsmeaTextStyle.bodyMedium(context),
              color: isSelected
                  ? color.withValues(alpha: 0.8)
                  : OsmeaColors.steel.withValues(alpha: 0.7),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationStep() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Configure Your Store',
          textStyle: OsmeaTextStyle.titleLarge(context),
          color: OsmeaColors.steel,
        ),
        OsmeaComponents.sizedBox(height: context.spacing16),
        OsmeaComponents.text(
          'Enter your store details and credentials:',
          textStyle: OsmeaTextStyle.bodyLarge(context),
          color: OsmeaColors.steel.withValues(alpha: 0.7),
        ),
        OsmeaComponents.sizedBox(height: context.spacing32),

        // Tab bar for WooCommerce
        _buildTabBar(),

        // Content based on current tab
        if (_currentTab == 'store') ...[
          // Warning for incomplete store configuration (shown only on store tab)
          _buildStoreConfigurationWarning(),
          _buildStoreConfiguration(),
        ] else if (_currentTab == 'customer') ...[
          _buildCustomerAuthentication(),
        ],
      ],
    );
  }

  Widget _buildStoreConfiguration() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store name
        _buildTextField(
          controller: _storeNameController,
          label: 'Store Name',
          hint: 'Enter a unique name for your store',
          errorText: _storeNameError,
          icon: Icons.store,
        ),

        OsmeaComponents.sizedBox(height: context.spacing24),

        if (_selectedPlatform == 'shopify') ...[
          // Shopify access token
          _buildTextField(
            controller: _accessTokenController,
            label: 'Access Token',
            hint: 'Enter your Shopify access token (shpat_...)',
            errorText: _accessTokenError,
            icon: Icons.key,
            isAccessToken: true,
          ),
        ] else if (_selectedPlatform == 'woocommerce') ...[
          // WooCommerce store URL
          _buildTextField(
            controller: _storeUrlController,
            label: 'Store URL',
            hint: 'e.g., https://yourstore.com or http://localhost:8000',
            errorText: _storeUrlError,
            icon: Icons.link,
          ),

          OsmeaComponents.sizedBox(height: context.spacing24),

          // WooCommerce username
          _buildTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Enter your WooCommerce username',
            errorText: _usernameError,
            icon: Icons.person,
          ),

          OsmeaComponents.sizedBox(height: context.spacing24),

          // WooCommerce password
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your WooCommerce password',
            errorText: _passwordError,
            icon: Icons.lock,
            isPassword: true,
          ),
        ],

        OsmeaComponents.sizedBox(height: context.spacing24),

        // API version
        _buildTextField(
          controller: _apiVersionController,
          label: 'API Version',
          hint: _selectedPlatform == 'shopify'
              ? 'API version in YYYY-MM format'
              : 'API version (e.g., v3)',
          errorText: _apiVersionError,
          icon: Icons.api,
          keyboardType: _selectedPlatform == 'shopify'
              ? TextInputType.datetime
              : TextInputType.text,
        ),

        // Reset Password Button for WooCommerce
        if (_selectedPlatform == 'woocommerce') ...[
          OsmeaComponents.sizedBox(height: context.spacing24),
          _buildResetPasswordButton(),
        ],
      ],
    );
  }

  Widget _buildCustomerAuthentication() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Customer Authentication Setup',
          textStyle: OsmeaTextStyle.titleMedium(context),
          color: OsmeaColors.steel,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.text(
          'Configure JWT-based customer authentication for your WooCommerce store:',
          textStyle: OsmeaTextStyle.bodyMedium(context),
          color: OsmeaColors.steel.withValues(alpha: 0.7),
        ),
        OsmeaComponents.sizedBox(height: context.spacing24),

        // Customer Email
        _buildTextField(
          controller: _customerEmailController,
          label: 'Customer Email',
          hint: 'Enter customer email for JWT authentication',
          errorText: _customerEmailError,
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),

        OsmeaComponents.sizedBox(height: context.spacing24),

        // Customer Password
        _buildTextField(
          controller: _customerPasswordController,
          label: 'Customer Password',
          hint: 'Enter customer password for JWT authentication',
          errorText: _customerPasswordError,
          icon: Icons.lock,
          isPassword: true,
        ),

        OsmeaComponents.sizedBox(height: context.spacing24),

        // Auth Endpoint
        _buildTextField(
          controller: _authEndpointController,
          label: 'Authentication Endpoint',
          hint: 'e.g., wc-auth/v1 or wp-json/custom-auth/v1',
          errorText: _authEndpointError,
          icon: Icons.api,
        ),

        OsmeaComponents.sizedBox(height: context.spacing24),

        // Test Authentication Button
        OsmeaComponents.button(
          text: _isTestingAuth
              ? 'Testing Authentication...'
              : 'Test Authentication',
          onPressed: _isTestingAuth ? null : _testAuthentication,
          variant: ButtonVariant.primary,
          size: ButtonSize.medium,
          icon: _isTestingAuth
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      OsmeaColors.white,
                    ),
                  ),
                )
              : Icon(Icons.security),
        ),

        OsmeaComponents.sizedBox(height: context.spacing16),

        // Authentication Test Result
        if (_authTestResult != null)
          OsmeaComponents.container(
            padding: context.paddingNormal,
            decoration: BoxDecoration(
              color: _authTestResult!.startsWith('✅')
                  ? OsmeaColors.forestHeart.withValues(alpha: 0.1)
                  : OsmeaColors.red.withValues(alpha: 0.1),
              borderRadius: context.borderRadiusNormal,
              border: Border.all(
                color: _authTestResult!.startsWith('✅')
                    ? OsmeaColors.forestHeart.withValues(alpha: 0.3)
                    : OsmeaColors.red.withValues(alpha: 0.3),
              ),
            ),
            child: OsmeaComponents.row(
              children: [
                Icon(
                  _authTestResult!.startsWith('✅')
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  color: _authTestResult!.startsWith('✅')
                      ? OsmeaColors.forestHeart
                      : OsmeaColors.red,
                  size: 24,
                ),
                OsmeaComponents.sizedBox(width: context.spacing16),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.text(
                    _authTestResult!,
                    textStyle: OsmeaTextStyle.bodyMedium(context),
                    color: _authTestResult!.startsWith('✅')
                        ? OsmeaColors.forestHeart
                        : OsmeaColors.red,
                  ),
                ),
              ],
            ),
          ),

        OsmeaComponents.sizedBox(height: context.spacing24),

        // Sign Up Section
        OsmeaComponents.container(
          padding: context.paddingNormal,
          decoration: BoxDecoration(
            color: OsmeaColors.blue.withValues(alpha: 0.05),
            borderRadius: context.borderRadiusNormal,
            border: Border.all(
              color: OsmeaColors.blue.withValues(alpha: 0.2),
            ),
          ),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: OsmeaColors.blue,
                    size: 24,
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing12),
                  OsmeaComponents.text(
                    'Create New User Account',
                    textStyle: OsmeaTextStyle.titleLarge(context),
                    color: OsmeaColors.blue,
                  ),
                ],
              ),

              OsmeaComponents.sizedBox(height: context.spacing16),

              // Sign up form fields (Postman parameters)
              OsmeaComponents.textField(
                controller: _signupEmailController,
                label: 'Email *',
                hint: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
              ),

              OsmeaComponents.sizedBox(height: context.spacing16),

              OsmeaComponents.textField(
                controller: _signupPasswordController,
                label: 'Password *',
                hint: 'Enter password',
                obscureText: true,
              ),

              OsmeaComponents.sizedBox(height: context.spacing16),

              OsmeaComponents.textField(
                controller: _signupAuthKeyController,
                label: 'AUTH_KEY *',
                hint: 'Enter authentication key',
              ),

              OsmeaComponents.sizedBox(height: context.spacing16),

              // Sign Up Button
              OsmeaComponents.button(
                text: _isSigningUp ? 'Creating Account...' : 'Create Account',
                onPressed: _isSigningUp ? null : _signUpUser,
                variant: ButtonVariant.secondary,
                size: ButtonSize.medium,
                icon: _isSigningUp
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            OsmeaColors.white,
                          ),
                        ),
                      )
                    : Icon(Icons.person_add),
              ),
            ],
          ),
        ),

        OsmeaComponents.sizedBox(height: context.spacing24),

        // Info message
        OsmeaComponents.container(
          padding: context.paddingNormal,
          decoration: BoxDecoration(
            color: OsmeaColors.forestHeart.withValues(alpha: 0.1),
            borderRadius: context.borderRadiusNormal,
            border: Border.all(
              color: OsmeaColors.forestHeart.withValues(alpha: 0.3),
            ),
          ),
          child: OsmeaComponents.row(
            children: [
              Icon(
                Icons.info_outline,
                color: OsmeaColors.forestHeart,
                size: 24,
              ),
              OsmeaComponents.sizedBox(width: context.spacing16),
              OsmeaComponents.expanded(
                child: OsmeaComponents.text(
                  'This configuration enables JWT-based customer authentication. Make sure your WooCommerce store has the JWT Authentication plugin installed and configured.',
                  textStyle: OsmeaTextStyle.bodyMedium(context),
                  color: OsmeaColors.forestHeart,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? errorText,
    required IconData icon,
    bool isPassword = false,
    bool isAccessToken = false,
    TextInputType? keyboardType,
  }) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          label,
          textStyle: OsmeaTextStyle.labelLarge(context).copyWith(
            fontWeight: FontWeight.w600,
            color: OsmeaColors.steel,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          controller: controller,
          hint: hint,
          prefixIcon: Icon(icon),
          suffixIcon: _buildVisibilityToggle(isPassword, isAccessToken),
          variant: TextFieldVariant.outlined,
          size: TextFieldSize.medium,
          fullWidth: true,
          obscureText: _shouldObscureText(isPassword, isAccessToken),
          keyboardType: keyboardType,
          errorText: errorText,
        ),
      ],
    );
  }

  Widget? _buildVisibilityToggle(bool isPassword, bool isAccessToken) {
    if (!isPassword && !isAccessToken) return null;

    bool isVisible = isPassword ? _isPasswordVisible : _isAccessTokenVisible;
    onToggle() {
      setState(() {
        if (isPassword) {
          _isPasswordVisible = !_isPasswordVisible;
        } else if (isAccessToken) {
          _isAccessTokenVisible = !_isAccessTokenVisible;
        }
      });
    }

    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility_off : Icons.visibility,
        color: OsmeaColors.steel.withValues(alpha: 0.6),
      ),
      onPressed: onToggle,
    );
  }

  bool _shouldObscureText(bool isPassword, bool isAccessToken) {
    if (isPassword) return !_isPasswordVisible;
    if (isAccessToken) return !_isAccessTokenVisible;
    return false;
  }

  Widget _buildReviewStep() {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Review Your Configuration',
          textStyle: OsmeaTextStyle.titleLarge(context),
          color: OsmeaColors.steel,
        ),
        OsmeaComponents.sizedBox(height: context.spacing16),
        OsmeaComponents.text(
          'Please review your store configuration before proceeding:',
          textStyle: OsmeaTextStyle.bodyLarge(context),
          color: OsmeaColors.steel.withValues(alpha: 0.7),
        ),
        OsmeaComponents.sizedBox(height: context.spacing32),

        // Configuration summary
        OsmeaComponents.container(
          padding: context.paddingNormal,
          decoration: BoxDecoration(
            color: OsmeaColors.ash.withValues(alpha: 0.1),
            borderRadius: context.borderRadiusNormal,
            border: Border.all(
              color: OsmeaColors.silver.withValues(alpha: 0.3),
            ),
          ),
          child: OsmeaComponents.column(
            children: [
              _buildReviewItem(
                  'Platform', _getPlatformDisplayName(_selectedPlatform ?? '')),
              _buildReviewItem('Store URL', _storeUrlController.text.trim()),
              _buildReviewItem('Store Name', _storeNameController.text.trim()),
              if (_selectedPlatform == 'shopify') ...[
                _buildReviewItem(
                    'Access Token', _accessTokenController.text.trim()),
              ] else if (_selectedPlatform == 'woocommerce') ...[
                _buildReviewItem('Username', _usernameController.text.trim()),
                _buildReviewItem('Password', '••••••••'),
                if (_authEndpointController.text.isNotEmpty) ...[
                  _buildReviewItem(
                      'Auth Endpoint', _authEndpointController.text.trim()),
                ],
              ],
              _buildReviewItem(
                  'API Version', _apiVersionController.text.trim()),
            ],
          ),
        ),

        OsmeaComponents.sizedBox(height: context.spacing24),

        // Info message
        OsmeaComponents.container(
          padding: context.paddingNormal,
          decoration: BoxDecoration(
            color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
            borderRadius: context.borderRadiusNormal,
            border: Border.all(
              color: OsmeaColors.nordicBlue.withValues(alpha: 0.3),
            ),
          ),
          child: OsmeaComponents.row(
            children: [
              Icon(
                Icons.info_outline,
                color: OsmeaColors.nordicBlue,
                size: 24,
              ),
              OsmeaComponents.sizedBox(width: context.spacing16),
              OsmeaComponents.expanded(
                child: OsmeaComponents.text(
                  'Your store credentials will be securely stored and used only for API requests. You can modify or remove them later from the store management section.',
                  textStyle: OsmeaTextStyle.bodyMedium(context),
                  color: OsmeaColors.nordicBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return OsmeaComponents.container(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing12,
        horizontal: context.spacing16,
      ),
      child: OsmeaComponents.row(
        children: [
          OsmeaComponents.text(
            '$label:',
            textStyle: OsmeaTextStyle.labelMedium(context).copyWith(
              fontWeight: FontWeight.w600,
              color: OsmeaColors.steel,
            ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing16),
          OsmeaComponents.expanded(
            child: OsmeaComponents.text(
              value,
              textStyle: OsmeaTextStyle.bodyMedium(context),
              color: OsmeaColors.steel.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _getPlatformDisplayName(String platform) {
    switch (platform) {
      case 'shopify':
        return 'Shopify';
      case 'woocommerce':
        return 'WooCommerce';
      default:
        return 'Unknown Platform';
    }
  }

  /// 📧 Build Reset Password Section for WooCommerce
  Widget _buildResetPasswordButton() {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing20),
      decoration: BoxDecoration(
        color: OsmeaColors.crystalBay.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.steel.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          OsmeaComponents.row(
            children: [
              Icon(
                Icons.password_outlined,
                color: OsmeaColors.nordicBlue,
                size: 20,
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.text(
                'Password Reset',
                textStyle: OsmeaTextStyle.titleSmall(context),
                color: OsmeaColors.nordicBlue,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          
          OsmeaComponents.sizedBox(height: context.spacing8),
          
          // Description
          OsmeaComponents.text(
            'Send a password reset email to any user. No authentication required.',
            textStyle: OsmeaTextStyle.bodySmall(context),
            color: OsmeaColors.steel.withValues(alpha: 0.8),
          ),
          
          OsmeaComponents.sizedBox(height: context.spacing16),
          
          // Store Name field
          _buildTextField(
            controller: _storeNameController,
            label: 'Store Name',
            hint: 'Enter store name',
            errorText: null,
            icon: Icons.store,
          ),
          
          OsmeaComponents.sizedBox(height: context.spacing16),
          
          // Store URL field
          _buildTextField(
            controller: _storeUrlController,
            label: 'Store URL',
            hint: 'Enter store URL (e.g., https://yourstore.com)',
            errorText: null,
            icon: Icons.link,
            keyboardType: TextInputType.url,
          ),
          
          OsmeaComponents.sizedBox(height: context.spacing16),
          
          // Email field for reset password
          _buildTextField(
            controller: _resetPasswordEmailController,
            label: 'User Email Address',
            hint: 'Enter the email address for password reset',
            errorText: null,
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          
          OsmeaComponents.sizedBox(height: context.spacing16),
          
          // Reset Password Button
          SizedBox(
            width: double.infinity,
            child: OsmeaComponents.button(
              text: _isResettingPassword 
                  ? 'Sending Reset Email...' 
                  : 'Send Reset Password Email',
              variant: ButtonVariant.primary,
              size: ButtonSize.medium,
              onPressed: _isResettingPassword ? null : _sendResetPasswordEmail,
            ),
          ),
          
          // Reset password result message
          if (_resetPasswordResult != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing12),
            Container(
              padding: EdgeInsets.all(context.spacing12),
              decoration: BoxDecoration(
                color: _resetPasswordResult!.contains('✅') 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _resetPasswordResult!.contains('✅')
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                ),
              ),
              child: OsmeaComponents.row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _resetPasswordResult!.contains('✅') 
                        ? Icons.check_circle 
                        : Icons.error,
                    color: _resetPasswordResult!.contains('✅')
                        ? Colors.green
                        : Colors.red,
                    size: 20,
                  ),
                  OsmeaComponents.sizedBox(width: 8),
                  Expanded(
                    child: OsmeaComponents.text(
                      _resetPasswordResult!,
                      textStyle: OsmeaTextStyle.bodySmall(context),
                      color: _resetPasswordResult!.contains('✅')
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 📧 Send Reset Password Email
  Future<void> _sendResetPasswordEmail() async {
    // Validate all required fields
    final storeName = _storeNameController.text.trim();
    final storeUrl = _storeUrlController.text.trim();
    final email = _resetPasswordEmailController.text.trim();

    if (storeName.isEmpty) {
      setState(() {
        _resetPasswordResult = '❌ Please enter a store name';
      });
      return;
    }

    if (storeUrl.isEmpty) {
      setState(() {
        _resetPasswordResult = '❌ Please enter a store URL';
      });
      return;
    }

    if (email.isEmpty) {
      setState(() {
        _resetPasswordResult = '❌ Please enter an email address';
      });
      return;
    }

    // Email validation
    if (!_emailRegex.hasMatch(email)) {
      setState(() {
        _resetPasswordResult = '❌ Please enter a valid email address';
      });
      return;
    }

    // Store URL validation
    if (!_wooCommerceUrlRegex.hasMatch(storeUrl)) {
      setState(() {
        _resetPasswordResult = '❌ Please enter a valid store URL (e.g., https://yourstore.com)';
      });
      return;
    }

    setState(() {
      _isResettingPassword = true;
      _resetPasswordResult = null;
    });

    try {
      debugPrint('📧 Starting reset password process...');
      debugPrint('📧 Store Name: $storeName');
      debugPrint('📧 Store URL: $storeUrl');
      debugPrint('📧 Email: $email');
      
      // Configure WooNetwork for this request
      WooNetwork.updateStoreUrl(storeUrl);
      WooNetwork.updateStoreName(storeName);
      WooNetwork.updateApiVersion('v1'); // Default version for reset password
      
      debugPrint('📧 WooNetwork configured with URL: ${WooNetwork.baseUrl}');
      
      final handler = SendResetPasswordHandler();
      final response = await handler.handleRequest('POST', {
        'email': email,
        'brand_name': storeName,
      });

      setState(() {
        _isResettingPassword = false;
        if (response['status'] == 'success') {
          _resetPasswordResult = '✅ Reset password email sent successfully! Please check your inbox.';
          // Clear the email field after successful send
          _resetPasswordEmailController.clear();
        } else {
          _resetPasswordResult = '❌ ${response['message'] ?? 'Failed to send reset password email'}';
        }
      });

      debugPrint('📧 Reset password result: ${response['status']}');
      
    } catch (e) {
      setState(() {
        _isResettingPassword = false;
        _resetPasswordResult = '❌ Error occurred while sending reset email: ${e.toString()}';
      });
      debugPrint('❌ Reset password error: $e');
    }
  }

  Widget _buildNavigationButtons() {
    return OsmeaComponents.row(
      children: [
        if (_currentStep > 0)
          OsmeaComponents.expanded(
            child: OsmeaComponents.button(
              text: 'Previous',
              variant: ButtonVariant.outlined,
              size: ButtonSize.large,
              onPressed: _previousStep,
            ),
          ),
        if (_currentStep > 0)
          OsmeaComponents.sizedBox(width: context.spacing16),
        OsmeaComponents.expanded(
          child: OsmeaComponents.button(
            text: _currentStep == 2 ? 'Complete Setup' : 'Next',
            variant: ButtonVariant.primary,
            size: ButtonSize.large,
            onPressed: _currentStep == 2 ? _completeSetup : _nextStep,
          ),
        ),
      ],
    );
  }
}
