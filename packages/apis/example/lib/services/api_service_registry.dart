import 'api_handlers.dart';

/// 🔖 API service categories
enum ApiCategory {
  access,
  storefront,
  admin,
  catalog,
}

/// 🏷️ Extension methods for ApiCategory
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

/// 📝 Class representing a field in an API request
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

/// 🔌 Class representing an API service
class ApiService {
  final String name;
  final String endpoint;
  final ApiCategory category;
  final ApiRequestHandler handler;
  final String subcategory; 

  const ApiService({
    required this.name,
    required this.endpoint,
    required this.category,
    required this.handler,
    required this.subcategory, 
  });

  /// 📋 Get supported methods from the handler
  List<String> get supportedMethods => handler.supportedMethods;

  /// 📄 Get required fields for each method
  Map<String, List<ApiField>> get requiredFields => handler.requiredFields;
}

/// 📚 Registry of all available API services
class ApiServiceRegistry {
  static final List<ApiService> _services = [
    // 🔐 Access APIs with subcategories
    ApiService(
      name: 'Access Scope',
      endpoint: '/accessScope',
      category: ApiCategory.access, // ➡️ Keep in Access category
      subcategory: 'Access Scope', // 🏷️ Subcategory
      handler: ApiHandlerFactory.getHandler('Access Scope')!,
    ),

    // 🔑 Move Storefront Access Token to Access category
    ApiService(
      name: 'Storefront Access Token',
      endpoint: '/storefrontAccessToken',
      category: ApiCategory.access, // ↩️ Changed from storefront to access
      subcategory: 'Storefront Access', // 🏷️ Subcategory name
      handler: ApiHandlerFactory.getHandler('Storefront Access Token')!,
    ),

    // ➕ Add more services here, organized by category
  ];

  // 🔄 Add the initialize method back for compatibility
  static void initialize() {
    // 📝 Services are already initialized statically,
    // but we keep this method for backward compatibility
    // with code that expects to call initialize()
  }

  // 📋 Get all services
  static List<ApiService> get all => _services;

  // 🔖 Get all available categories
  static List<ApiCategory> get categories =>
      _services.map((s) => s.category).toSet().toList();

  // 🔍 Get services by category
  static List<ApiService> getByCategory(ApiCategory category) =>
      _services.where((s) => s.category == category).toList();

  // 🏷️ Get subcategory names for a specific category
  static List<String> getSubcategoriesByCategory(ApiCategory category) {
    return _services
        .where((s) => s.category == category)
        .map((s) => s.subcategory)
        .toSet()
        .toList();
  }

  // 🔍 Get services by subcategory
  static List<ApiService> getBySubcategory(
      ApiCategory category, String subcategoryName) {
    return _services
        .where(
            (s) => s.category == category && s.subcategory == subcategoryName)
        .toList();
  }

  // 🔄 Helper to convert enum to string
  static String getCategoryName(ApiCategory category) {
    switch (category) {
      case ApiCategory.access:
        return 'Access';
      case ApiCategory.storefront:
        return 'Storefront';
      case ApiCategory.admin:
        return 'Admin';
      case ApiCategory.catalog:
        return 'Catalog';
    }
  }
}
