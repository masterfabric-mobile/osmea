import 'package:flutter/material.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:example/widgets/control_panel.dart';
import 'package:example/widgets/response_panel.dart';
import 'package:example/widgets/layout_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // State for API selection
  ApiCategory? _selectedCategory;
  ApiService? _selectedService;
  String? _selectedMethod;

  // Response state
  Map<String, dynamic>? _responseData;
  bool _loading = false;

  // Controllers for text fields
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

  void _setCategory(ApiCategory category) {
    setState(() {
      _selectedCategory = category;
      final services = ApiServiceRegistry.getByCategory(category);
      if (services.isNotEmpty) {
        _setService(services.first);
      } else {
        _selectedService = null;
        _selectedMethod = null;
      }
    });
  }

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

    // Create control and response panels
    final controlPanel = ControlPanel(
      selectedCategory: _selectedCategory,
      selectedService: _selectedService,
      selectedMethod: _selectedMethod,
      loading: _loading,
      onCategorySelected: _setCategory,
      onServiceSelected: _setService,
      onMethodSelected: _setMethod,
      onExecute: _sendRequest,
      controllers: _controllers,
    );

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

  void _clearFields() {
    _responseData = null;

    // Clear only the text fields, not dispose controllers
    for (final controller in _controllers.values) {
      controller.clear();
    }
  }

  Future<void> _sendRequest() async {
    if (_selectedService == null || _selectedMethod == null) return;

    setState(() {
      _loading = true;
      _responseData = null;
    });

    try {
      // Gather parameters from input fields
      final Map<String, String> params = {};
      if (_selectedService!.requiredFields.containsKey(_selectedMethod)) {
        for (final field
            in _selectedService!.requiredFields[_selectedMethod!]!) {
          params[field.name] = _controllers[field.name]?.text ?? '';
        }
      }

      // Handle the request using the service's handler and get structured data
      _responseData = await _selectedService!.handler.handleRequest(
        _selectedMethod!,
        params,
      );
    } catch (e) {
      _responseData = {"error": e.toString()};
    }

    setState(() {
      _loading = false;
    });
  }
}
