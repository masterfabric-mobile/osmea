import 'package:example/services/handlers/customers_handlers/customer/searches_for_customers_that_match_supplied_query_handler.dart';
import 'package:example/services/handlers/customers_handlers/customer/customer_url_handler.dart';
import 'package:example/services/handlers/customers_handlers/customer/retrieves_single_customer_handler.dart';
import 'package:example/services/handlers/customers_handlers/customer/retrieves_count_of_customers_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/creates_new_address_for_customer_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/destroy_multiple_customer_addresses_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/retrieves_list_of_addresses_for_customer_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/retrieves_details_for_single_customer_address_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/sets_default_address_for_customer_handler.dart';
import 'package:example/services/handlers/events_handlers/retrieves_list_of_events_handler.dart';
import 'package:example/services/handlers/events_handlers/retrieves_single_event_handler.dart';
import 'package:example/services/handlers/events_handlers/retrieves_count_events_handler.dart';
import 'package:example/services/handlers/inventory/inventory_item_handlers/inventory_item_by_id_handler.dart';
import 'package:example/services/handlers/inventory/inventory_item_handlers/update_inventory_item_sku_handler.dart';
import 'package:example/services/handlers/inventory/inventory_item_handlers/update_inventory_item_unit_cost_handler.dart';
import 'package:example/services/handlers/inventory/inventory_level_handlers/inventory_item_at_location_handler.dart';
import 'package:example/services/index.dart';
import 'handlers/customers_handlers/customer/retrieves_list_of_customers_handler.dart';
import 'handlers/customers_handlers/customer/retrieves_all_orders_belonging_to_customer_handler.dart';
import 'handlers/customers_handlers/customer/sends_account_invite_to_customer_handler.dart';

/// 🔖 API service categories
enum ApiCategory {
  access,
  storefront,
  admin,
  catalog,
  customer,
  events,
  inventory,
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
      case ApiCategory.events:
        return 'Events APIs';
      case ApiCategory.inventory:
        return 'Inventory APIs';
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
      handler: AccessScopeHandler(),
    ),

    // 🔑 Move Storefront Access Token to Access category
    ApiService(
        name: 'Storefront Access Token',
        endpoint: '/storefrontAccessToken',
        category: ApiCategory.access,
        subcategory: 'Storefront Access',
        handler: StorefrontAccessTokenHandler()),

    // 👥 Customer API - Get all customers with single GET endpoint
    ApiService(
      name: 'Customers',
      endpoint: '/customers',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesListOfCustomersHandler(),
    ),

    // 👤 Single Customer API - get customer by ID
    ApiService(
      name: 'Single Customer',
      endpoint: '/customers/:id',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesSingleCustomerHandler(),
    ),

    // 🛒 Customer Orders API - Get orders belonging to a customer
    ApiService(
      name: 'Customer Orders',
      endpoint: '/customers/:id/orders',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesAllOrdersBelongingToCustomerHandler(),
    ),

    // 🔍 Customer Match Query API
    ApiService(
      name: 'Customer Match Query',
      endpoint: '/customers/search',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: SearchesForCustomersThatMatchSuppliedQueryHandler(),
    ),

    // 🔗 Customer URL API - Generate account activation URL
    ApiService(
      name: 'Customer URL',
      endpoint: '/customers/:id/account_activation_url',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: CustomerUrlHandler(),
    ),

    // 🔢 Customer Count API
    ApiService(
      name: 'Customer Count',
      endpoint: '/customers/count',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesCountOfCustomersHandler(),
    ),

    // 📧 Customer Invite API
    ApiService(
      name: 'Send Customer Invite',
      endpoint: '/customers/:id/send_invite',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: SendsAccountInviteToCustomerHandler(),
    ),

    // 🏷️ Customer Address APIs - Create Address
    ApiService(
      name: 'Create Customer Address',
      endpoint: '/customers/:id/addresses',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: CreateNewAddressForCustomerHandler(),
    ),

    // 🏠 Customer Address APIs - Get Addresses List
    ApiService(
      name: 'Get Customer Addresses',
      endpoint: '/customers/:id/addresses',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: RetrievesListOfAddressesForCustomerHandler(),
    ),

    // 🔍 Customer Address APIs - Get Single Address Details
    ApiService(
      name: 'Get Single Address Details',
      endpoint: '/customers/:id/addresses/:address_id',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: RetrievesDetailsForSingleCustomerAddressHandler(),
    ),

    // 🏠 Customer Address APIs - Set Default Address
    ApiService(
      name: 'Set Default Address',
      endpoint: '/customers/:id/addresses/:address_id/default',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: SetsDefaultAddressForCustomerHandler(),
    ),

    // 🗑️ Customer Address APIs - Delete Multiple Addresses
    ApiService(
      name: 'Destroy Multiple Addresses',
      endpoint: '/customers/:id/addresses',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: DestroyMultipleCustomerAddressesHandler(),
    ),

    // 📅 Events APIs - List all events
    ApiService(
      name: 'Events List',
      endpoint: '/events',
      category: ApiCategory.events,
      subcategory: 'Events',
      handler: RetrievesListOfEventsHandler(),
    ),

    // 📆 Events APIs - Single event
    ApiService(
      name: 'Single Event',
      endpoint: '/events/:event_id',
      category: ApiCategory.events,
      subcategory: 'Events',
      handler: RetrievesSingleEventHandler(),
    ),

    // 🔢 Events APIs - Count events
    ApiService(
      name: 'Events Count',
      endpoint: '/events/count',
      category: ApiCategory.events,
      subcategory: 'Events',
      handler: RetrievesCountEventsHandler(),
    ),

    // 📦 Inventory Item APIs - Get item by ID
    ApiService(
      name: 'Inventory Item By ID',
      endpoint: '/inventory_items/:id', // Changed to match Shopify API pattern
      category: ApiCategory.inventory,
      subcategory: 'Inventory Items',
      handler: InventoryItemByIdHandler(),
    ),

    // 🔄 Inventory Item APIs - Update item SKU
    ApiService(
      name: 'Update Inventory Item SKU',
      endpoint:
          '/inventory_items/:id/update_sku', // Changed to match Shopify API pattern
      category: ApiCategory.inventory,
      subcategory: 'Inventory Items',
      handler: UpdateInventoryItemSkuHandler(),
    ),

    // 💲 Inventory Item APIs - Update item unit cost
    ApiService(
      name: 'Update Inventory Item Unit Cost',
      endpoint: '/inventory_items/:id/update_unit_cost',
      category: ApiCategory.inventory,
      subcategory: 'Inventory Items',
      handler: UpdateInventoryItemUnitCostHandler(),
    ),

    // 📍 Inventory Level APIs - Get inventory level at location
    ApiService(
      name: 'Inventory Level By Item and Location',
      endpoint: '/inventory_levels/by_item_and_location',
      category: ApiCategory.inventory,
      subcategory: 'Inventory Levels',
      handler: InventoryItemAtLocationHandler(),
    ),
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
      case ApiCategory.events:
        return 'Events';
      case ApiCategory.inventory:
        return 'Inventory';
    }
  }
}
