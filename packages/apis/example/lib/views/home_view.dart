import 'package:flutter/material.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:example/widgets/control_panel.dart';
import 'package:example/widgets/response_panel.dart';
import 'package:example/widgets/layout_widgets.dart';
import 'package:apis/apis.dart';
import 'package:example/widgets/app_header.dart';
import 'package:example/styles/app_theme.dart';

/// 🏠 Main view for the API Explorer application
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // 🔄 State variables for API selection flow

  /// 🔖 Currently selected API category
  ApiCategory? _selectedCategory;

  /// 🏷️ Currently selected API subcategory within the category
  String? _selectedSubcategory;

  /// 🔌 Currently selected API service
  ApiService? _selectedService;

  /// 📋 Currently selected API method (GET, POST, etc.)
  String? _selectedMethod;

  // 📊 Response handling state

  /// 📦 Data returned from API request
  Map<String, dynamic>? _responseData;

  /// ⏳ Loading state during API request
  bool _loading = false;

  /// 🌐 Current API URL being accessed
  String _currentApiUrl = '';

  /// 🎛️ Text field controllers for parameter input
  /// Maps field names to their respective controllers
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Set default category if available
    final categories = ApiServiceRegistry.categories;
    if (categories.isNotEmpty) {
      _setCategory(categories.first);
    }
  }

  /// 🔄 Sets the selected category and updates dependent selections
  /// Updates subcategory, service, and method based on available options
  void _setCategory(ApiCategory category) {
    setState(() {
      _selectedCategory = category;
      _selectedSubcategory = null;

      // 📂 Check if there are subcategories
      final subcategories =
          ApiServiceRegistry.getSubcategoriesByCategory(category);
      if (subcategories.isNotEmpty) {
        _setSubcategory(subcategories.first);
      } else {
        // 📝 No subcategories, directly select first service in category
        final services = ApiServiceRegistry.getByCategory(category);
        if (services.isNotEmpty) {
          _setService(services.first);
        } else {
          _selectedService = null;
          _selectedMethod = null;
        }
      }
    });
  }

  /// 🏷️ Sets the selected subcategory and updates service selection
  void _setSubcategory(String subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
      // 🔍 Get services for this subcategory
      final services =
          ApiServiceRegistry.getBySubcategory(_selectedCategory!, subcategory);
      if (services.isNotEmpty) {
        _setService(services.first);
      } else {
        _selectedService = null;
        _selectedMethod = null;
      }
    });
  }

  /// 🔌 Sets the selected service and updates available methods
  void _setService(ApiService service) {
    setState(() {
      _selectedService = service;
      if (service.supportedMethods.isNotEmpty) {
        _setMethod(service.supportedMethods.first);
      } else {
        _selectedMethod = null;
      }
    });
  }

  /// 📋 Sets the selected method and clears input fields
  void _setMethod(String method) {
    setState(() {
      _selectedMethod = method;
      _clearFields();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800 && screenWidth <= 1200;

    final controlPanel = ControlPanel(
      selectedCategory: _selectedCategory,
      selectedSubcategory: _selectedSubcategory,
      selectedService: _selectedService,
      selectedMethod: _selectedMethod,
      loading: _loading,
      onCategorySelected: _setCategory,
      onSubcategorySelected: _setSubcategory,
      onServiceSelected: _setService,
      onMethodSelected: _setMethod,
      onExecute: _sendRequest,
      controllers: _controllers,
    );

    final responsePanel = ResponsePanel(
      responseData: _responseData,
      loading: _loading,
    );

    return Theme(
      data: AppTheme.getTheme(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppHeader(
          title: 'OSMEA API Explorer',
          apiUrl: _currentApiUrl,
          onUrlCopied: _handleUrlCopy,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isWideScreen
                ? WideLayoutView(
                    controlPanel: controlPanel,
                    responsePanel: responsePanel,
                  )
                : isMediumScreen
                    ? MediumLayoutView(
                        controlPanel: controlPanel,
                        responsePanel: responsePanel,
                      )
                    : NarrowLayoutView(
                        controlPanel: controlPanel,
                        responsePanel: responsePanel,
                      ),
          ),
        ),
      ),
    );
  }

  void _handleUrlCopy() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('URL copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.primary,
        width: 200,
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// 🧹 Clears input fields and response data
  void _clearFields() {
    _responseData = null;

    // Clear only the text fields, not dispose controllers
    for (final controller in _controllers.values) {
      controller.clear();
    }
  }

  /// 🚀 Executes API request with current selections and parameters
  /// Updates the response data and loading state
  Future<void> _sendRequest() async {
    if (_selectedService == null || _selectedMethod == null) return;

    setState(() {
      _loading = true;
      _responseData = null;
    });

    try {
      // 📝 Gather parameters from input fields
      final Map<String, String> params = {};
      if (_selectedService!.requiredFields.containsKey(_selectedMethod)) {
        for (final field
            in _selectedService!.requiredFields[_selectedMethod!]!) {
          params[field.name] = _controllers[field.name]?.text ?? '';
        }
      }

      // 🔗 Generate the API URL based on the service, method and params
      _updateApiUrl(_selectedService!, _selectedMethod!, params);

      // 🔄 Handle the request using the service's handler and get structured data
      _responseData = await _selectedService!.handler.handleRequest(
        _selectedMethod!,
        params,
      );
    } catch (e) {
      // ⚠️ Handle errors and display in response panel
      _responseData = {"error": e.toString()};
    }

    setState(() {
      _loading = false;
    });
  }

  /// 🌐 Updates the current API URL based on the selected service, method, and parameters
  void _updateApiUrl(
      ApiService service, String method, Map<String, String> params) {
    String path = '';
    String queryParams = '';

    // Determine path based on service name and method
    switch (service.name) {
      case 'Storefront Access Token':
        if (method == 'DELETE' &&
            params.containsKey('id') &&
            params['id']!.isNotEmpty) {
          final id = params['id']!;
          // Use the exact format from ApiNetwork class
          final apiUrl =
              '${ApiNetwork.baseUrl}/api/${ApiNetwork.apiVersion}/storefront_access_tokens/$id.json';
          setState(() {
            _currentApiUrl = apiUrl;
          });
          return;
        } else {
          path = '/api/${ApiNetwork.apiVersion}/storefront_access_tokens.json';
        }
        break;

      case 'Access Scope':
        path = '/api/${ApiNetwork.apiVersion}/oauth/access_scopes.json';
        break;

      // Add other services as needed
      default:
        path =
            '/api/${ApiNetwork.apiVersion}/${service.name.toLowerCase().replaceAll(' ', '_')}';
        if (method == 'GET') {
          path += '.json';
        }
    }

    // Add query parameters for GET requests if there are any
    if (method == 'GET' && params.isNotEmpty) {
      queryParams =
          '?${params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';
    }

    setState(() {
      _currentApiUrl = ApiNetwork.baseUrl + path + queryParams;
    });
  }
}
