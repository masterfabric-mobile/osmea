import 'api_handlers.dart';

/// API service categories
enum ApiCategory {
  access,
  storefront,
  admin,
  catalog,
}

/// Extension methods for ApiCategory
extension ApiCategoryExtension on ApiCategory {
  String get displayName {
    switch (this) {
      case ApiCategory.access:
        return 'Access APIs';
      case ApiCategory.storefront:
        return 'Storefront APIs';
      case ApiCategory.admin:
        return 'Admin APIs';
      case ApiCategory.catalog:
        return 'Catalog APIs';
    }
  }
}

/// Class representing a field in an API request
class ApiField {
  final String name;
  final String label;
  final String hint;

  const ApiField({
    required this.name,
    required this.label,
    required this.hint,
  });
}

/// Class representing an API service
class ApiService {
  final String name;
  final String endpoint;
  final ApiCategory category;
  final ApiRequestHandler handler;

  const ApiService({
    required this.name,
    required this.endpoint,
    required this.category,
    required this.handler,
  });

  List<String> get supportedMethods => handler.supportedMethods;
  Map<String, List<ApiField>> get requiredFields => handler.requiredFields;
}

/// Registry of all available API services
class ApiServiceRegistry {
  static final List<ApiService> _services = [
    // Access APIs
    ApiService(
      name: 'Access Scope',
      endpoint: '/accessScope',
      category: ApiCategory.access,
      handler: ApiHandlerFactory.getHandler('Access Scope')!,
    ),

    // Storefront APIs
    ApiService(
      name: 'Storefront Access Token',
      endpoint: '/storefrontAccessToken',
      category: ApiCategory.storefront,
      handler: ApiHandlerFactory.getHandler('Storefront Access Token')!,
    ),

    // Add more services here, organized by category
  ];

  // Get all services
  static List<ApiService> get all => _services;

  // Get all available categories
  static List<ApiCategory> get categories =>
      _services.map((s) => s.category).toSet().toList();

  // Get services by category
  static List<ApiService> getByCategory(ApiCategory category) =>
      _services.where((s) => s.category == category).toList();
}
