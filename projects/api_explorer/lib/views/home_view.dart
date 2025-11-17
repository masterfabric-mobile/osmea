import 'package:api_explorer/widgets/home/modern_sidebar.dart';
import 'package:api_explorer/widgets/home/responsive_popup.dart';
import 'package:api_explorer/widgets/layout/app_header.dart';
import 'package:api_explorer/widgets/responsive_layout/responsive_content.dart';
import 'package:api_explorer/widgets/store_management/store_management_dialog.dart';
import 'package:api_explorer/widgets/store_management/store_setup_wizard.dart';
import 'package:api_explorer/widgets/password_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:apis/apis.dart';
import 'package:apis/services/store_change_notifier.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:api_explorer/services/app_state_persistence.dart';
import 'package:api_explorer/services/handlers/woocommerce/auth_handlers/get_users_me_handler.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/response/get_users_me_response.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/user_login_request.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Core state
  ApiService? _selectedService;
  String _selectedMethod = 'GET';
  Map<String, String> _parameters = {};
  String? _rawBody;
  Map<String, dynamic>? _responseData;
  bool _loading = false;
  String _currentApiUrl = '';
  bool _isDarkMode = false;
  StoreConfiguration? _selectedStore;
  StreamSubscription<StoreChangeEvent>? _storeChangeSubscription;

  // Responsive popup state
  bool _showResponsivePopup = false;
  double _previousScreenWidth = 0;
  bool _hasShownResponsivePopup = false;
  bool _isAppFullyLoaded = false;

  // Password update state
  bool _showPasswordUpdate = false;

  // WordPress user state
  GetUsersMeResponse? _currentWordPressUser;
  bool _loadingUserInfo = false;

  // Scaffold key for drawer control
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Animation controllers
  late AnimationController _sidebarAnimationController;
  late AnimationController _responseAnimationController;
  late AnimationController _themeAnimationController;
  late Animation<double> _sidebarAnimation;
  late Animation<double> _responseAnimation;
  late Animation<double> _themeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeDefaults();
    _checkAndShowConfigPopup();
    _loadCurrentStore();
    _listenToStoreChanges();
    _restoreAppState(); // Restore previous state
    _initializeCartToken(); // Initialize cart token

    // Initialize screen width for responsive popup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final screenWidth = MediaQuery.of(context).size.width;
        _previousScreenWidth = screenWidth;

        // Mark app as fully loaded after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isAppFullyLoaded = true;
            });

            // Only show popup if app is fully loaded and screen is small
            if (screenWidth < 1000 && !_hasShownResponsivePopup) {
              if (kDebugMode) {
                debugPrint(
                    '📱 App fully loaded on small screen, showing popup after delay');
              }
              // Close wizard and show popup safely
              _showResponsivePopupSafely();
            }
          }
        });
      }
    });

    // Add observer for window resize events
    WidgetsBinding.instance.addObserver(this);
  }

  // State persistence methods
  Future<void> _saveAppState() async {
    if (_selectedService != null) {
      await AppStatePersistence.saveCurrentApiQuery(
        query: _selectedService!.name,
        service: _selectedService!.name,
        method: _selectedMethod,
        parameters: _parameters,
        rawBody: _rawBody,
        currentApiUrl: _currentApiUrl,
      );
      debugPrint(
          '✅ App state saved: ${_selectedService!.name} - $_selectedMethod');
    }
  }

  Future<void> _restoreAppState() async {
    try {
      final savedState = await AppStatePersistence.loadCurrentApiQuery();
      if (savedState != null) {
        setState(() {
          _selectedMethod = savedState['method'] ?? 'GET';
          _parameters =
              Map<String, String>.from(savedState['parameters'] ?? {});
          _rawBody = savedState['rawBody'];
          _currentApiUrl = savedState['currentApiUrl'] ?? '';
        });

        // Try to restore the selected service
        final serviceName = savedState['service'];
        if (serviceName != null) {
          final services = ApiServiceRegistry.all;
          final service = services.firstWhere(
            (s) => s.name == serviceName,
            orElse: () => services.first,
          );
          setState(() {
            _selectedService = service;
          });
          debugPrint('✅ Restored service: ${service.name}');
        }

        debugPrint('✅ App state restored successfully');
      }
    } catch (e) {
      debugPrint('❌ Error restoring app state: $e');
    }
  }

  void _initializeAnimations() {
    _sidebarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _responseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _themeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _responseAnimation = CurvedAnimation(
      parent: _responseAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _themeAnimation = CurvedAnimation(
      parent: _themeAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _sidebarAnimationController.forward();
  }

  // Responsive popup methods
  void _checkScreenSizeChange(double currentWidth) {
    if (_previousScreenWidth == 0) {
      _previousScreenWidth = currentWidth;
      if (kDebugMode) {
        debugPrint('🖥️ Initial screen width: ${currentWidth}px');
      }

      // Don't show popup immediately on startup - wait for app to be fully loaded
      return;
    }

    if (kDebugMode) {
      debugPrint(
          '🔄 Screen size change: ${_previousScreenWidth}px → ${currentWidth}px');
    }

    // Only show popup if app is fully loaded and screen size decreases significantly
    if (_isAppFullyLoaded &&
        _previousScreenWidth >= 1000 &&
        currentWidth < 1000 &&
        !_hasShownResponsivePopup) {
      if (kDebugMode) {
        debugPrint('📱 Showing responsive popup (web → mobile)');
      }
      // Close wizard and show popup safely
      _showResponsivePopupSafely();
    }

    // Reset popup state if screen size increases again
    if (currentWidth >= 1000 && _hasShownResponsivePopup) {
      if (kDebugMode) {
        debugPrint('💻 Hiding responsive popup (mobile → web)');
      }
      setState(() {
        _showResponsivePopup = false;
        _hasShownResponsivePopup = false;
      });
    }

    _previousScreenWidth = currentWidth;
  }

  void _dismissResponsivePopup() {
    if (kDebugMode) {
      debugPrint('❌ Responsive popup dismissed by user');
    }
    setState(() {
      _showResponsivePopup = false;
    });
  }

  void _openWebVersion() {
    if (kDebugMode) {
      debugPrint('🌐 User chose to use web version');
    }
    _dismissResponsivePopup();

    // Show a message that web version is recommended
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'We recommend opening the web version in full screen in your browser.'),
        backgroundColor: OsmeaColors.nordicBlue,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (kDebugMode) {
        debugPrint(
            '📐 Window metrics changed, checking screen size: ${screenWidth}px');
      }
      _checkScreenSizeChange(screenWidth);
    }
  }

  void _initializeDefaults() {
    ApiNetwork.initOnRequestInterceptor(
      onRequestInInterceptor: () async {
        debugPrint('🔄 Request interceptor triggered');
      },
    );

    // Set initial URL to show the base structure
    _setInitialUrl();
  }

  void _setInitialUrl() {
    String baseUrl;
    try {
      baseUrl = ApiNetwork.baseUrl;
    } catch (e) {
      baseUrl = 'https://<STORE_NAME>.myshopify.com/admin';
    }

    setState(() {
      _currentApiUrl = '$baseUrl/api/<API_VERSION>/';
    });
  }

  Future<void> _checkAndShowConfigPopup() async {
    try {
      final currentStore = await WizardHelper.getCurrentStore();
      if (currentStore == null) {
        // No store configuration found, show setup wizard
        if (mounted) {
          _showSetupWizard();
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking configuration: $e');
    }
  }

  /// Initialize cart token by making a cart API call
  Future<void> _initializeCartToken() async {
    try {
      // Check if cart token already exists
      final existingCartToken = await WooCartTokenStorage.loadCartToken();
      if (existingCartToken != null) {
        debugPrint(
            '🛒 Cart token already exists: ${existingCartToken.cartToken}');
        return;
      }

      // Check if store is configured
      if (_selectedStore == null) {
        debugPrint(
            '⚠️ No store configured, skipping cart token initialization');
        return;
      }

      // Make cart API call to get cart token
      final cartService = GetIt.I<CartService>();
      final response = await cartService.getCart(
        apiVersion: WooNetwork.apiVersion,
      );

      debugPrint('🛒 Cart API response received: ${response.toJson()}');

      // Check if cart token was saved by interceptor
      final cartToken = await WooCartTokenStorage.loadCartToken();
      if (cartToken != null) {
        debugPrint('✅ Cart token initialized: ${cartToken.cartToken}');
      } else {
        debugPrint('⚠️ Cart token not found in response');
      }
    } catch (e) {
      debugPrint('❌ Error initializing cart token: $e');
    }
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    _responseAnimationController.dispose();
    _themeAnimationController.dispose();
    _storeChangeSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🌐 Updates the current API URL based on the selected service, method, and parameters
  void _updateApiUrl(
      ApiService service, String method, Map<String, String> params) {
    String path = '';
    String queryParams = '';

    // Check if this is a WooCommerce service
    bool isWooCommerceService =
        service.category.toString().contains('woocommerce');

    // Determine path based on service name and method using proper endpoint mapping
    switch (service.name) {
      case 'Storefront Access Token':
        if (method == 'DELETE' &&
            params.containsKey('id') &&
            params['id']!.isNotEmpty) {
          final id = params['id']!;
          path =
              '/api/${ApiNetwork.apiVersion}/storefront_access_tokens/$id.json';
        } else {
          path = '/api/${ApiNetwork.apiVersion}/storefront_access_tokens.json';
        }
        break;

      case 'Access Scope':
        path = '/api/${ApiNetwork.apiVersion}/oauth/access_scopes.json';
        break;

      // WooCommerce specific cases
      case 'WooCommerce List All Coupons':
        path = '/wp-json/wc/v3/coupons';
        break;

      default:
        // Use the endpoint from the service registry if available
        String endpoint = service.endpoint;
        if (endpoint.startsWith('/')) {
          endpoint = endpoint.substring(1); // Remove leading slash
        }

        // Handle parameter replacement for different endpoint formats
        if (isWooCommerceService) {
          // For WooCommerce: Replace {parameter} with actual values
          endpoint = endpoint.replaceAllMapped(RegExp(r'\{(\w+)\}'), (match) {
            final paramName = match.group(1)!;
            if (params.containsKey(paramName) &&
                params[paramName]!.isNotEmpty) {
              return params[paramName]!;
            }
            return '{$paramName}';
          });
        } else {
          // For Shopify: Replace :parameter with {parameter} for display
          endpoint = endpoint.replaceAllMapped(RegExp(r':(\w+)'), (match) {
            final paramName = match.group(1)!;
            if (params.containsKey(paramName) &&
                params[paramName]!.isNotEmpty) {
              return params[paramName]!;
            }
            return '{$paramName}';
          });
        }

        // For WooCommerce services, don't add Shopify-specific prefixes
        if (isWooCommerceService) {
          path = '/$endpoint';
        } else {
          path = '/api/${ApiNetwork.apiVersion}/$endpoint';
          if (!path.endsWith('.json') && method == 'GET') {
            path += '.json';
          }
        }
    }

    // Add query parameters for GET requests if there are any
    if (method == 'GET' && params.isNotEmpty) {
      // Filter out path parameters that are already in the URL
      final queryParamsMap = Map<String, String>.from(params);
      queryParamsMap.removeWhere((key, value) =>
          path.contains('{$key}') ||
          path.contains('/$value/') ||
          path.contains('/$value.'));

      if (queryParamsMap.isNotEmpty) {
        queryParams =
            '?${queryParamsMap.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';
      }
    }

    // Build the complete URL
    String baseUrl;
    try {
      if (isWooCommerceService) {
        // For WooCommerce services, use WooNetwork baseUrl
        baseUrl = WooNetwork.baseUrl;
      } else {
        // For Shopify services, use ApiNetwork baseUrl
        baseUrl = ApiNetwork.baseUrl;
      }
    } catch (e) {
      // If baseUrl throws exception due to missing store name, use placeholder format
      if (isWooCommerceService) {
        baseUrl = 'https://<YOUR_SITE>.com';
      } else {
        baseUrl = 'https://<STORE_NAME>.myshopify.com/admin';
      }
    }

    final fullUrl = baseUrl + path + queryParams;

    setState(() {
      _currentApiUrl = fullUrl;
    });
  }

  void _onServiceSelected(ApiService service) {
    setState(() {
      _selectedService = service;
      _selectedMethod = service.supportedMethods.first;
      _parameters.clear();
      _rawBody = null;
      _responseData = null;
    });
    _updateApiUrl(service, _selectedMethod, {});
    _saveAppState(); // Save state when service changes
  }

  void _onMethodChanged(String method) {
    setState(() {
      _selectedMethod = method;
      _parameters.clear();
      _rawBody = null;
    });
    if (_selectedService != null) {
      _updateApiUrl(_selectedService!, method, {});
    }
    _saveAppState(); // Save state when method changes
  }

  void _onParametersChanged(Map<String, String> parameters) {
    setState(() {
      _parameters = parameters;
    });
    if (_selectedService != null) {
      _updateApiUrl(_selectedService!, _selectedMethod, parameters);
    }
    _saveAppState(); // Save state when parameters change
  }

  void _onRawBodyChanged(String? body) {
    setState(() {
      _rawBody = body;
    });
    _saveAppState(); // Save state when raw body changes
  }

  void _toggleDrawer() {
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      _scaffoldKey.currentState?.closeDrawer();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    // Trigger theme animation
    _themeAnimationController.forward().then((_) {
      _themeAnimationController.reverse();
    });
  }

  Future<void> _sendRequest([Map<String, String>? currentParams]) async {
    if (_selectedService == null) {
      _showSnackBar('Please select an API service first', isError: true);
      return;
    }

    setState(() {
      _loading = true;
      _responseData = null;
    });

    try {
      final result = await _selectedService!.handler.handleRequest(
        _selectedMethod,
        {
          ..._parameters,
          if (_rawBody?.isNotEmpty == true) 'rawBody': _rawBody!
        },
      );

      setState(() {
        _responseData = result;
      });

      _responseAnimationController.forward();
      _showSnackBar('Request completed successfully', isError: false);
    } catch (e) {
      setState(() {
        _responseData = {"error": e.toString()};
      });
      _showSnackBar('Request failed: ${e.toString()}', isError: true);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  double _calculateDrawerWidth(double screenWidth) {
    final isWideScreen = screenWidth >= 1000;
    final isMediumScreen = screenWidth >= 800;

    if (isWideScreen) return 320;
    if (isMediumScreen) return 280;
    return 260;
  }

  void _showSnackBar(String message, {required bool isError}) {
    // Ensure the widget is mounted and the Scaffold is in the widget tree
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: OsmeaComponents.row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary, // Use dynamic onPrimary color
                  size: 20,
                ),
                OsmeaComponents.sizedBox(width: context.spacing8),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.text(message),
                ),
              ],
            ),
            backgroundColor: OsmeaColors.nordicBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: context.borderRadiusNormal,
            ),
          ),
        );
      }
    });
  }

  void _onProfileTap() {
    // Show store profile information
    if (_selectedStore != null) {
      _showStoreProfileDialog();
    } else {
      _showSnackBar('No store selected', isError: true);
    }
  }

  void _onStoreChange() {
    // Show store selector or management dialog
    _showStoreManagementDialog(context);
  }

  void _showPasswordUpdateDialog() {
    setState(() {
      _showPasswordUpdate = true;
    });
  }

  void _hidePasswordUpdateDialog() {
    setState(() {
      _showPasswordUpdate = false;
    });
  }

  void _updateApiUrlFromStore(StoreConfiguration store) {
    if (!mounted) return;

    String baseUrl = store.baseUrl;
    String apiVersion = store.apiVersion;

    setState(() {
      _currentApiUrl = '$baseUrl/api/$apiVersion/';
      _selectedStore = store; // Ensure selected store is updated
    });

    debugPrint('🔗 API URL updated automatically: $_currentApiUrl');

    // Also update the network configuration
    _updateNetworkConfiguration(store);

    // Reset selected service when switching stores
    setState(() {
      _selectedService = null;
    });
  }

  void _updateNetworkConfiguration(StoreConfiguration store) {
    try {
      if (store.platform == 'shopify') {
        // Update Shopify network configuration
        ApiNetwork.updateStoreName(store.storeName);
        ApiNetwork.updateShopifyAccessToken(store.shopifyAccessToken!);
        ApiNetwork.updateApiVersion(store.apiVersion);

        debugPrint('🔧 ApiNetwork updated with store: ${store.storeName}');
        debugPrint(
            '🔧 ApiNetwork updated with token: ${store.shopifyAccessToken}');
        debugPrint('🔧 ApiNetwork updated with version: ${store.apiVersion}');
      } else if (store.platform == 'woocommerce') {
        // Update WooCommerce network configuration
        WooNetwork.updateStoreUrl(store.storeUrl!);
        WooNetwork.updateUsername(store.username!);
        WooNetwork.updatePassword(store.password!);
        WooNetwork.updateApiVersion(store.apiVersion);

        debugPrint('🔧 WooNetwork updated with store URL: ${store.storeUrl}');
      }

      debugPrint('✅ Network configuration updated for ${store.platform}');
    } catch (e) {
      debugPrint('❌ Error updating network configuration: $e');
    }
  }

  Future<void> _loadCurrentStore() async {
    try {
      final store = await WizardHelper.getCurrentStore();
      if (store != null) {
        setState(() {
          _selectedStore = store;
        });
        _updateApiUrlFromStore(store);
      }
    } catch (e) {
      debugPrint('❌ Error loading current store: $e');
    }
  }

  void _showStoreManagementDialog(BuildContext context) {
    // Store the context before async operations
    final dialogContext = context;

    showDialog(
      context: dialogContext,
      barrierDismissible:
          false, // Prevent accidental dismissal during store switch
      builder: (BuildContext context) => StoreManagementDialog(
        storeService: StoreManagementService(),
        onStoreChanged: (store) async {
          if (!mounted) return;

          try {
            // Show loading state
            setState(() {
              _selectedStore = null;
            });

            // Update store and configurations
            await Future.delayed(
                const Duration(milliseconds: 100)); // Allow UI to update

            if (!mounted) return;
            _updateApiUrlFromStore(store);

            // Close the dialog after successful switch
            if (mounted) {
              final navContext = context;
              if (navContext.mounted && Navigator.canPop(navContext)) {
                Navigator.pop(navContext);
              }
            }
          } catch (e) {
            debugPrint('❌ Error in store management dialog: $e');
            if (mounted) {
              final errorContext = context;
              if (errorContext.mounted) {
                errorContext.toastError(
                  'Failed to switch store. Please try again.',
                  position: ToastPosition.bottom,
                );
              }
            }
          }
        },
      ),
    );
  }

  void _showStoreProfileDialog() {
    OsmeaComponents.showPopup(
      context: context,
      size: PopupSize.large, // Increased size for WordPress user info
      variant: PopupVariant.modal,
      title: 'Store Profile',
      subtitle: 'Store configuration and WordPress user details',
      backgroundColor: OsmeaColors.white,
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Icon and Name Section
          OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                  OsmeaColors.eclipse.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: context.borderRadiusNormal,
              border: Border.all(
                color: OsmeaColors.nordicBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: OsmeaComponents.row(
              children: [
                OsmeaComponents.container(
                  padding: EdgeInsets.all(context.spacing12),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.15),
                    borderRadius: context.borderRadiusMinStandard,
                  ),
                  child: Icon(
                    Icons.store_rounded,
                    color: OsmeaColors.nordicBlue,
                    size: 24,
                  ),
                ),
                OsmeaComponents.sizedBox(width: context.spacing16),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OsmeaComponents.text(
                        _selectedStore?.displayName ?? "Unknown Store",
                        variant: OsmeaTextVariant.titleMedium,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.eclipse,
                      ),
                      OsmeaComponents.text(
                        _selectedStore?.platform.toUpperCase() ??
                            "Unknown Platform",
                        variant: OsmeaTextVariant.bodySmall,
                        fontSize: 12,
                        color: OsmeaColors.nordicBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          OsmeaComponents.sizedBox(height: context.spacing20),

          // WordPress User Information Section (only for WooCommerce stores)
          if (_selectedStore?.platform == 'woocommerce') ...[
            OsmeaComponents.container(
              padding: EdgeInsets.all(context.spacing16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    OsmeaColors.deepSea.withValues(alpha: 0.1),
                    OsmeaColors.forestHeart.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: context.borderRadiusNormal,
                border: Border.all(
                  color: OsmeaColors.deepSea.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.row(
                    children: [
                      OsmeaComponents.container(
                        padding: EdgeInsets.all(context.spacing8),
                        decoration: BoxDecoration(
                          color: OsmeaColors.deepSea.withValues(alpha: 0.15),
                          borderRadius: context.borderRadiusMinStandard,
                        ),
                        child: Icon(
                          Icons.account_circle_rounded,
                          color: OsmeaColors.deepSea,
                          size: 20,
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing12),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.text(
                          'WordPress User Information',
                          variant: OsmeaTextVariant.titleSmall,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OsmeaColors.eclipse,
                        ),
                      ),
                      if (_loadingUserInfo)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                OsmeaColors.deepSea),
                          ),
                        ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  
                  if (_currentWordPressUser != null) ...[
                    _buildUserInfoRow('Name', _currentWordPressUser!.name ?? 'Unknown', Icons.person),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    _buildUserInfoRow('ID', _currentWordPressUser!.id?.toString() ?? 'Unknown', Icons.fingerprint),
                    if (_currentWordPressUser!.slug != null) ...[
                      OsmeaComponents.sizedBox(height: context.spacing8),
                      _buildUserInfoRow('Slug', _currentWordPressUser!.slug!, Icons.alternate_email),
                    ],
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    _buildUserInfoRow('Super Admin', _currentWordPressUser!.isSuperAdmin == true ? 'Yes' : 'No', 
                        _currentWordPressUser!.isSuperAdmin == true ? Icons.admin_panel_settings : Icons.person),
                  ] else if (!_loadingUserInfo) ...[
                    OsmeaComponents.container(
                      padding: EdgeInsets.all(context.spacing12),
                      decoration: BoxDecoration(
                        color: OsmeaColors.amberFlame.withValues(alpha: 0.1),
                        borderRadius: context.borderRadiusMinStandard,
                        border: Border.all(
                          color: OsmeaColors.amberFlame.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: OsmeaComponents.column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OsmeaComponents.row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: OsmeaColors.amberFlame,
                                size: 18,
                              ),
                              OsmeaComponents.sizedBox(width: context.spacing8),
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.text(
                                  'No WordPress user loaded. Please login first to get JWT token.',
                                  variant: OsmeaTextVariant.bodySmall,
                                  fontSize: 12,
                                  color: OsmeaColors.eclipse,
                                ),
                              ),
                            ],
                          ),
                          OsmeaComponents.sizedBox(height: context.spacing8),
                          // Quick Login Button
                          TextButton.icon(
                            onPressed: () => _showQuickLoginDialog(),
                            icon: Icon(
                              Icons.login,
                              size: 14,
                              color: OsmeaColors.forestHeart,
                            ),
                            label: OsmeaComponents.text(
                              'Quick Login',
                              variant: OsmeaTextVariant.bodySmall,
                              fontSize: 11,
                              color: OsmeaColors.forestHeart,
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: OsmeaColors.forestHeart.withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: context.borderRadiusMinStandard,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: context.spacing8,
                                vertical: context.spacing4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  
                  // Load User Info & Debug Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _loadingUserInfo ? null : () => _loadWordPressUserInfo(),
                          icon: Icon(
                            _loadingUserInfo ? Icons.refresh : Icons.download,
                            size: 16,
                            color: _loadingUserInfo ? OsmeaColors.silver : OsmeaColors.deepSea,
                          ),
                          label: OsmeaComponents.text(
                            _loadingUserInfo ? 'Loading...' : 'Load User Info',
                            variant: OsmeaTextVariant.bodySmall,
                            fontSize: 12,
                            color: _loadingUserInfo ? OsmeaColors.silver : OsmeaColors.deepSea,
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: _loadingUserInfo 
                                ? OsmeaColors.silver.withValues(alpha: 0.1)
                                : OsmeaColors.deepSea.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: context.borderRadiusMinStandard,
                            ),
                          ),
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing8),
                      // Debug JWT Button
                      TextButton.icon(
                        onPressed: () => _debugJWTStorage(),
                        icon: Icon(
                          Icons.bug_report,
                          size: 14,
                          color: OsmeaColors.amberFlame,
                        ),
                        label: OsmeaComponents.text(
                          'Debug JWT',
                          variant: OsmeaTextVariant.bodySmall,
                          fontSize: 10,
                          color: OsmeaColors.amberFlame,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: OsmeaColors.amberFlame.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: context.borderRadiusMinStandard,
                          ),
                          minimumSize: Size(60, 32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            OsmeaComponents.sizedBox(height: context.spacing20),
          ],

          // Store Details Section
          OsmeaComponents.container(
            padding: EdgeInsets.all(context.spacing16),
            decoration: BoxDecoration(
              color: OsmeaColors.snow,
              borderRadius: context.borderRadiusNormal,
              border: Border.all(
                color: OsmeaColors.silver.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Store Information',
                  variant: OsmeaTextVariant.titleSmall,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.eclipse,
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),

                // Status Row
                _buildInfoRow(
                  'Status',
                  _selectedStore?.isComplete == true ? "Active" : "Incomplete",
                  _selectedStore?.isComplete == true
                      ? OsmeaColors.forestHeart
                      : OsmeaColors.amberFlame,
                  Icons.circle,
                ),

                OsmeaComponents.sizedBox(height: context.spacing8),

                // Created Date Row
                if (_selectedStore?.createdAt != null)
                  _buildInfoRow(
                    'Created',
                    _selectedStore!.createdAt.toString().split('.')[0],
                    OsmeaColors.slate,
                    Icons.schedule,
                  ),

                OsmeaComponents.sizedBox(height: context.spacing8),

                // Store URL Row
                if (_selectedStore?.storeUrl != null)
                  _buildInfoRow(
                    'Store URL',
                    _selectedStore!.storeUrl!,
                    OsmeaColors.nordicBlue,
                    Icons.link,
                  ),
                OsmeaComponents.sizedBox(height: context.spacing8),

                // API Version Row
                _buildInfoRow(
                  'API Version',
                  _selectedStore?.apiVersion ?? "Unknown",
                  OsmeaColors.deepSea,
                  Icons.api,
                ),
              ],
            ),
          ),

          OsmeaComponents.sizedBox(height: context.spacing20),

          // Action Buttons
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Edit Button
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close profile dialog
                  if (_selectedStore != null) {
                    StoreSetupWizard.show(
                      context,
                      isInitialSetup: false,
                      existingStore: _selectedStore,
                      onStoreAdded: (store) {
                        setState(() {
                          _selectedStore = store;
                        });
                        _updateApiUrlFromStore(store);
                        _showSnackBar('Store updated successfully',
                            isError: false);
                      },
                    );
                  }
                },
                icon: Icon(
                  Icons.edit,
                  color: OsmeaColors.nordicBlue,
                ),
                tooltip: 'Edit Store',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label, String value, Color valueColor, IconData icon) {
    return OsmeaComponents.row(
      children: [
        Icon(
          icon,
          size: 16,
          color: OsmeaColors.slate,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        OsmeaComponents.text(
          '$label:',
          variant: OsmeaTextVariant.bodySmall,
          fontSize: 12,
          color: OsmeaColors.slate,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        OsmeaComponents.expanded(
          child: OsmeaComponents.text(
            value,
            variant: OsmeaTextVariant.bodySmall,
            fontSize: 12,
            color: valueColor,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _listenToStoreChanges() {
    try {
      _storeChangeSubscription = WizardHelper.storeChangeStream.listen(
        (event) {
          debugPrint('🔄 HomeView: Store change detected: ${event.type}');
          switch (event.type) {
            case StoreChangeType.added:
            case StoreChangeType.switched:
              if (event.data is StoreConfiguration) {
                final store = event.data as StoreConfiguration;
                setState(() {
                  _selectedStore = store;
                });
                _updateApiUrlFromStore(store);
                // Reinitialize cart token for new store
                _initializeCartToken();
              }
              break;
            case StoreChangeType.updated:
              if (event.data is StoreConfiguration) {
                final store = event.data as StoreConfiguration;
                if (store.id == _selectedStore?.id) {
                  setState(() {
                    _selectedStore = store;
                  });
                  _updateApiUrlFromStore(store);
                }
              }
              break;
            case StoreChangeType.deleted:
              // Handle store deletion - refresh page to update UI
              debugPrint('🗑️ Store deleted, refreshing page...');
              _handleStoreDeleted();
              break;
            default:
              break;
          }
        },
        onError: (error) {
          debugPrint('❌ Error listening to store changes in HomeView: $error');
        },
      );
    } catch (e) {
      debugPrint('❌ Error setting up store change listener in HomeView: $e');
    }
  }

  /// Handle store deletion by refreshing the page state
  Future<void> _handleStoreDeleted() async {
    try {
      // Reset current store and reload from service
      setState(() {
        _selectedStore = null;
        _selectedService = null;
        _parameters.clear();
        _rawBody = null;
        _responseData = null;
        _currentApiUrl = '';
      });

      // Reload current store from storage
      await _loadCurrentStore();

      // If no stores are available, show setup wizard
      final storeService = StoreManagementService();
      await storeService.init();

      if (storeService.allStores.isEmpty) {
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _showSetupWizard();
            }
          });
        }
      }

      // Force UI refresh
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('❌ Error handling store deletion: $e');
    }
  }

  void _showSetupWizard() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StoreSetupWizard(
        isInitialSetup: true, // Force wizard to start from the beginning
        forceReset: true, // Clear any saved wizard state
        onStoreAdded: (store) {
          setState(() {
            _selectedStore = store;
          });
          _updateApiUrlFromStore(store);

          // Show success message with store information
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: OsmeaComponents.column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    '🎉 Store setup completed successfully!',
                    fontWeight: FontWeight.w600,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  OsmeaComponents.text(
                    '${store.platform.toUpperCase()}: ${store.displayName}',
                    fontSize: 12,
                  ),
                  OsmeaComponents.text(
                    'You can now explore APIs for this platform',
                    fontSize: 12,
                  ),
                ],
              ),
              backgroundColor: OsmeaColors.nordicBlue,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Refresh the UI to show the new store information
          setState(() {});
        },
      ),
    );
  }

  void _closeAllDialogsAndWizards() {
    // Close any open dialogs, wizards, or modals
    if (Navigator.canPop(context)) {
      // Close all routes until we reach the first one (main app)
      Navigator.of(context).popUntil((route) => route.isFirst);
      if (kDebugMode) {
        debugPrint('🔒 Closed all dialogs and wizards');
      }
    }
  }

  void _showResponsivePopupSafely() {
    // Close any open dialogs first
    _closeAllDialogsAndWizards();

    // Wait a bit for dialogs to close, then show popup
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showResponsivePopup = true;
          _hasShownResponsivePopup = true;
        });
        if (kDebugMode) {
          debugPrint('📱 Responsive popup shown safely after closing dialogs');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Check for screen size changes to show responsive popup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScreenSizeChange(screenWidth);
    });

    // Also check immediately if this is the first build
    if (_previousScreenWidth == 0) {
      _checkScreenSizeChange(screenWidth);
    }

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _themeAnimation,
          builder: (context, child) {
            return Theme(
              data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor:
                    _isDarkMode ? OsmeaColors.eclipse : OsmeaColors.white,
                appBar: AppHeader(
                  title: 'OSMEA APIs',
                  apiUrl: _currentApiUrl,
                  onUrlCopied: () =>
                      _showSnackBar('URL copied to clipboard!', isError: false),
                  onThemeToggle: _toggleTheme,
                  onDrawerToggle: _toggleDrawer,
                  isDarkMode: _isDarkMode,
                  onProfileTap: _onProfileTap,
                  onStoreChange: _onStoreChange,
                  onPasswordUpdate: _selectedStore?.platform == 'woocommerce'
                      ? _showPasswordUpdateDialog
                      : null,
                  isProfileEnabled: _selectedStore?.platform == 'woocommerce',
                ),
                drawer: Drawer(
                  width: _calculateDrawerWidth(screenWidth),
                  child: ModernSidebar(
                    expanded: true, // Always expanded in drawer
                    selectedService: _selectedService,
                    onServiceSelected: (service) {
                      _onServiceSelected(service);
                      // Close drawer after selection
                      Navigator.of(context).pop();
                    },
                    animation: _sidebarAnimation,
                  ),
                ),
                body: ResponsiveContent(
                  selectedService: _selectedService,
                  selectedMethod: _selectedMethod,
                  parameters: _parameters,
                  rawBody: _rawBody,
                  currentApiUrl: _currentApiUrl,
                  loading: _loading,
                  responseData: _responseData,
                  responseAnimation: _responseAnimation,
                  onMethodChanged: _onMethodChanged,
                  onParametersChanged: _onParametersChanged,
                  onRawBodyChanged: _onRawBodyChanged,
                  onSendRequest: _sendRequest,
                  screenWidth: screenWidth,
                ),
              ),
            );
          },
        ),

        // Responsive popup overlay
        ResponsivePopup(
          isVisible: _showResponsivePopup,
          onDismiss: _dismissResponsivePopup,
          onUseWebVersion: _openWebVersion,
        ),

        // Password Update Dialog
        if (_showPasswordUpdate)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: OsmeaColors.nordicBlue,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_reset,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Password Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _hidePasswordUpdateDialog,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content
                      const PasswordUpdateWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 👤 Load WordPress user information using handler
  Future<void> _loadWordPressUserInfo() async {
    debugPrint('👤 Loading WordPress user info using handler...');
    
    if (mounted) {
      setState(() {
        _loadingUserInfo = true;
      });
    }

    try {
      // First debug the storage state
      debugPrint('🔍 Debugging storage state...');
      final hasToken = await WooJwtTokenStorage.hasToken();
      debugPrint('📋 Has token: $hasToken');
      
      if (hasToken) {
        final token = await WooJwtTokenStorage.loadToken();
        if (token != null) {
          debugPrint('✅ Token loaded successfully');
          debugPrint('🔐 Token type: ${token.tokenType}');
          debugPrint('⏰ Expires in: ${token.expiresIn}');
          debugPrint('📅 Issued at: ${token.issuedAt}');
          debugPrint('🔑 Access token preview: ${token.accessToken.length > 20 ? token.accessToken.substring(0, 20) + "..." : token.accessToken}');
          debugPrint('🔄 Is expired: ${token.isExpired}');
          
          if (token.isExpired) {
            debugPrint('⚠️ Token is expired!');
          }
        } else {
          debugPrint('❌ Token is null despite hasToken=true');
        }
      }
      
      // Use the GetUsersMeHandler to get user info
      final handler = GetUsersMeHandler();
      final result = await handler.handleRequest('GET', {});
      
      debugPrint('📡 Handler result: ${result["status"]}');
      
      if (result["status"] == "success" && result["user_data"] != null) {
        // Parse the user data from handler response
        final userData = result["user_data"] as Map<String, dynamic>;
        final userResponse = GetUsersMeResponse.fromJson(userData);
        
        if (mounted) {
          setState(() {
            _currentWordPressUser = userResponse;
            _loadingUserInfo = false;
          });
        }
        
        debugPrint('✅ WordPress user loaded: ${userResponse.name}');
        _showSnackBar('WordPress user information loaded successfully!', isError: false);
        
      } else {
        // Handler returned an error
        final errorMessage = result["message"] ?? "Failed to load user information";
        debugPrint('❌ Handler error: $errorMessage');
        
        // Show detailed error information from handler
        if (result["error_details"] != null) {
          final errorDetails = result["error_details"] as Map<String, dynamic>;
          debugPrint('🔍 Error details: $errorDetails');
          
          // If it's an authentication error, show more helpful message
          if (errorDetails["type"] == "authentication_error") {
            final suggestion = errorDetails["suggestion"] ?? errorMessage;
            _showSnackBar('Authentication required: $suggestion', isError: true);
          } else {
            _showSnackBar(errorMessage, isError: true);
          }
        } else {
          _showSnackBar(errorMessage, isError: true);
        }
        
        if (mounted) {
          setState(() {
            _currentWordPressUser = null;
            _loadingUserInfo = false;
          });
        }
      }
      
    } catch (e) {
      debugPrint('❌ Error loading WordPress user: $e');
      
      if (mounted) {
        setState(() {
          _currentWordPressUser = null;
          _loadingUserInfo = false;
        });
      }
      
      _showSnackBar('Error loading user information: ${e.toString()}', isError: true);
    }
  }

  /// 🐛 Debug JWT Storage state
  Future<void> _debugJWTStorage() async {
    try {
      debugPrint('🐛 Starting JWT Storage Debug...');
      
      // Check basic token presence
      final hasToken = await WooJwtTokenStorage.hasToken();
      debugPrint('📋 Has token: $hasToken');
      
      // Get storage statistics
      final stats = await WooJwtTokenStorage.getStorageStats();
      debugPrint('📊 Storage stats: $stats');
      
      // Try to load token
      final token = await WooJwtTokenStorage.loadToken();
      if (token != null) {
        debugPrint('✅ Token found in storage:');
        debugPrint('  - Token type: ${token.tokenType}');
        debugPrint('  - Access token length: ${token.accessToken.length}');
        debugPrint('  - Access token preview: ${token.accessToken.length > 20 ? token.accessToken.substring(0, 20) + "..." : token.accessToken}');
        debugPrint('  - Expires in: ${token.expiresIn} seconds');
        debugPrint('  - Issued at: ${token.issuedAt}');
        debugPrint('  - Expires at: ${token.expiresAt}');
        debugPrint('  - Is expired: ${token.isExpired}');
        debugPrint('  - Needs refresh: ${token.needsRefresh}');
        debugPrint('  - Refresh token: ${token.refreshToken != null ? "Present" : "Not present"}');
        debugPrint('  - Scope: ${token.scope ?? "None"}');
        debugPrint('  - User data: ${token.userData != null ? "Present (${token.userData!.keys.length} fields)" : "Not present"}');
        
        // Show success message
        _showSnackBar('JWT Debug: Token found, check console for details', isError: false);
        
      } else {
        debugPrint('❌ No token found in storage');
        _showSnackBar('JWT Debug: No token found in storage', isError: true);
      }
      
      // Check token expiry
      final isExpired = await WooJwtTokenStorage.isTokenExpired();
      debugPrint('⏰ Is expired: $isExpired');
      
      // Get token info
      final tokenInfo = await WooJwtTokenStorage.getTokenInfo();
      debugPrint('ℹ️ Token info: $tokenInfo');
      
    } catch (e, stackTrace) {
      debugPrint('❌ Error debugging JWT storage: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      _showSnackBar('JWT Debug Error: $e', isError: true);
    }
  }

  /// 🚀 Show Quick Login Dialog
  void _showQuickLoginDialog() {
    final emailController = TextEditingController(text: 'admin@ticimex.store');
    final passwordController = TextEditingController(text: 'admin');
    bool isLoggingIn = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.login, color: OsmeaColors.nordicBlue),
              OsmeaComponents.sizedBox(width: context.spacing8),
              OsmeaComponents.text(
                'WordPress Login',
                variant: OsmeaTextVariant.titleMedium,
                color: OsmeaColors.nordicBlue,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              OsmeaComponents.sizedBox(height: context.spacing12),
              if (isLoggingIn)
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing8),
                    OsmeaComponents.text('Logging in...', fontSize: 12),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoggingIn ? null : () => Navigator.pop(context),
              child: OsmeaComponents.text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoggingIn ? null : () async {
                setDialogState(() => isLoggingIn = true);
                
                try {
                  await _performQuickLogin(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  Navigator.pop(context);
                  _showSnackBar('Login successful! You can now load user info.', isError: false);
                } catch (e) {
                  _showSnackBar('Login failed: ${e.toString()}', isError: true);
                } finally {
                  if (mounted) {
                    setDialogState(() => isLoggingIn = false);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: OsmeaColors.nordicBlue,
                foregroundColor: Colors.white,
              ),
              child: OsmeaComponents.text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔐 Perform Quick Login
  Future<void> _performQuickLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    try {
      debugPrint('🔐 Performing quick login for email: $email');
      
      // Get the WooAuthService
      final authService = GetIt.I<WooAuthService>();
      
      // Create login request
      final loginRequest = UserLoginRequest(
        email: email,
        password: password,
      );
      
      debugPrint('📡 Sending login request...');
      final response = await authService.userLogin('ticimex', loginRequest);
      
      if (response.success && response.data?.jwt != null && response.data!.jwt!.isNotEmpty) {
        debugPrint('✅ Login successful, JWT token received');
        
        // Create JWT token object
        final jwtToken = WooJwtToken(
          accessToken: response.data!.jwt!,
          tokenType: response.data?.tokenType ?? 'Bearer',
          expiresIn: response.data?.expiresIn ?? 3600, // Default 1 hour
          issuedAt: DateTime.now(),
          refreshToken: response.data?.refreshToken,
          scope: response.data?.scope,
          userData: {
            'user_id': response.data?.user?.id,
            'user_email': response.data?.user?.email,
            'user_first_name': response.data?.user?.firstName,
            'user_last_name': response.data?.user?.lastName,
            'user_phone': response.data?.user?.phone,
            'user_company': response.data?.user?.company,
          },
        );
        
        // Save token to storage
        await WooJwtTokenStorage.saveToken(jwtToken);
        debugPrint('💾 JWT token saved to storage successfully');
        
      } else {
        throw Exception('Login failed: ${response.message ?? "No JWT token received from server"}');
      }
      
    } catch (e) {
      debugPrint('❌ Quick login error: $e');
      rethrow;
    }
  }

  Widget _buildUserInfoRow(String label, String value, IconData icon) {
    return OsmeaComponents.row(
      children: [
        Icon(
          icon,
          size: 14,
          color: OsmeaColors.deepSea,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        OsmeaComponents.text(
          '$label:',
          variant: OsmeaTextVariant.bodySmall,
          fontSize: 11,
          color: OsmeaColors.slate,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(width: context.spacing6),
        OsmeaComponents.expanded(
          child: OsmeaComponents.text(
            value,
            variant: OsmeaTextVariant.bodySmall,
            fontSize: 11,
            color: OsmeaColors.eclipse,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
