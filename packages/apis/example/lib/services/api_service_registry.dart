import 'package:example/services/api_request_handler.dart';
import 'package:example/services/handlers/customers_handlers/customer_match_query.dart';
import 'package:example/services/handlers/customers_handlers/customer_url_handler.dart';
import 'package:example/services/handlers/customers_handlers/sigle_customer_handler.dart';
import 'api_handlers.dart';
// Import other needed files
import 'handlers/customers_handlers/customer_handler.dart';
import 'handlers/customers_handlers/orders_belonging_to_customer_handler.dart'; // Added import

/// 🔖 API service categories
enum ApiCategory {
  access,
  storefront,
  admin,
  catalog,
  customer,
  customers,
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
      case ApiCategory.customer:
        return 'Customer APIs';
      case ApiCategory.customers:
        return 'Customer APIs';
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
      category: ApiCategory.access,
      subcategory: 'Access Scope',
      handler: ApiHandlerFactory.getHandler('Access Scope')!,
    ),

    // 🔑 Move Storefront Access Token to Access category
    ApiService(
      name: 'Storefront Access Token',
      endpoint: '/storefrontAccessToken',
      category: ApiCategory.access,
      subcategory: 'Storefront Access',
      handler: ApiHandlerFactory.getHandler('Storefront Access Token')!,
    ),

    // 👥 Customer API - Get all customers with single GET endpoint
    ApiService(
      name: 'Customers',
      endpoint: '/customers',
      category: ApiCategory.customer,
      subcategory: 'All Customers',
      handler: CustomerHandler(),
    ),

    // 👤 Single Customer API - get customer by ID
    ApiService(
      name: 'Single Customer',
      endpoint: '/customers/:id',
      category: ApiCategory.customer,
      subcategory: 'Single Customer',
      handler: SingleCustomerHandler(),
    ),

    // 🛒 Customer Orders API - Get orders belonging to a customer
    ApiService(
      name: 'Customer Orders',
      endpoint: '/customers/:id/orders',
      category: ApiCategory.customer,
      subcategory: 'Customer Orders',
      handler: OrdersBelongingToCustomerHandler(),
    ),

    // 🔍 Customer Match Query API
    ApiService(
      name: 'Customer Match Query',
      endpoint: '/customers/search',
      category: ApiCategory.customer,
      subcategory: 'Customer Match Query',
      handler: CustomerMatchQueryHandler(),
    ),

    // In the _services list, add:
    ApiService(
      name: 'Customer URL',
      endpoint: '/customers/:id/account_activation_url',
      category: ApiCategory.customer,
      subcategory: 'Customer URL',
      handler: CustomerUrlHandler(),
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
      case ApiCategory.customer:
        return 'Customer';
      case ApiCategory.customers:
        throw UnimplementedError();
    }
  }
}
