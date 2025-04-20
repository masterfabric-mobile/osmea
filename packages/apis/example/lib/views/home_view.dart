import 'package:flutter/material.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:example/widgets/control_panel.dart';
import 'package:example/widgets/response_panel.dart';
import 'package:example/widgets/layout_widgets.dart';

/// 🏠 Main view for the API Explorer application
/// Provides UI for selecting and testing API endpoints
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
    // 📐 Responsive layout handling
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200; // 🖥️ Desktop layout
    final isMediumScreen =
        screenWidth > 800 && screenWidth <= 1200; // 💻 Tablet layout

    // 🎛️ Create control panel for API selection and parameters
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

    // 📊 Create response panel for displaying API results
    final responsePanel = ResponsePanel(
      responseData: _responseData,
      loading: _loading,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('APIS Package'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help or documentation
            },
            tooltip: 'Documentation',
          ),
        ],
      ),
      body: isWideScreen
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
}
