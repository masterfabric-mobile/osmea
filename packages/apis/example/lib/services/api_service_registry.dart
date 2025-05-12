// ignore_for_file: constant_identifier_names

import 'package:example/services/handlers/customers_handlers/customer/searches_for_customers_that_match_supplied_query_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/country_handlers/receive_list_of_countries_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/country_handlers/retrieves_count_of_countries_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/country_handlers/creates_new_country_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/country_handlers/creates_country_using_custom_tax_rate_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/country_handlers/creates_country_using_shopify_tax_rate_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/country_handlers/updates_existing_country_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/country_handlers/delete_country_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/currency_handlers/retrieves_list_of_currencies_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/policy_handlers/retrieves_list_of_shop_policies_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/province_handlers/retrieves_list_of_provinces_for_country_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/province_handlers/retrieves_count_of_provinces_for_country_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/province_handlers/updates_existing_province_for_country_handler.dart';
import 'package:example/services/handlers/store_properties_handlers/shipping_zone_handlers/receive_list_of_shipping_zones_handler.dart';
import 'package:example/services/handlers/customers_handlers/customer/customer_url_handler.dart';
import 'package:example/services/handlers/customers_handlers/customer/retrieves_single_customer_handler.dart';
import 'package:example/services/handlers/customers_handlers/customer/retrieves_count_of_customers_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/creates_new_address_for_customer_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/destroy_multiple_customer_addresses_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/retrieves_list_of_addresses_for_customer_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/retrieves_details_for_single_customer_address_handler.dart';
import 'package:example/services/handlers/customers_handlers/customers_address/sets_default_address_for_customer_handler.dart';
import 'package:example/services/handlers/discount_handlers/discount_code_handler/discount_code_creation_handler.dart';
import 'package:example/services/handlers/discount_handlers/discount_code_handler/discount_code_handler.dart';
import 'package:example/services/handlers/discount_handlers/discount_code_handler/retrieves_count_of_discount_codes_handler.dart';
import 'package:example/services/handlers/discount_handlers/discount_code_handler/retrieves_list_of_discount_code_creation_handler.dart';
import 'package:example/services/handlers/discount_handlers/discount_code_handler/retrieves_list_of_discount_codes_handler.dart';
import 'package:example/services/handlers/discount_handlers/discount_code_handler/retrieves_search_for_discount_code_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/create_price_rule_discount_collection_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/create_price_rule_discount_order_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/create_price_rule_discount_selected_customers_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/create_price_rule_free_item_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/create_price_rule_free_shipping_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/get_count_of_price_rules_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/get_list_of_price_rules_handler.dart';
import 'package:example/services/handlers/discount_handlers/price_rule_handler/price_rule_handler.dart';

import 'package:example/services/handlers/events_handlers/retrieves_list_of_events_handler.dart';
import 'package:example/services/handlers/events_handlers/retrieves_single_event_handler.dart';
import 'package:example/services/handlers/events_handlers/retrieves_count_events_handler.dart';
import 'package:example/services/handlers/inventory/inventory_item_handlers/inventory_item_by_id_handler.dart';
import 'package:example/services/handlers/inventory/inventory_item_handlers/update_inventory_item_sku_handler.dart';
import 'package:example/services/handlers/inventory/inventory_item_handlers/update_inventory_item_unit_cost_handler.dart';
import 'package:example/services/handlers/inventory/inventory_level_handlers/inventory_item_at_location_handler.dart';
import 'package:example/services/handlers/inventory/inventory_level_handlers/inventory_item_to_location_handler.dart';
import 'package:example/services/handlers/inventory/inventory_level_handlers/list_inventory_levels_single_item_handler.dart';
import 'package:example/services/handlers/inventory/inventory_level_handlers/list_inventory_levels_single_location_handler.dart';
import 'package:example/services/handlers/inventory/inventory_level_handlers/set_inventory_location_handler.dart';
import 'package:example/services/handlers/inventory/location/count_all_locations_handler.dart';
import 'package:example/services/handlers/inventory/location/list_inventory_by_location_id_handler.dart';
import 'package:example/services/handlers/inventory/location/single_location_by_id_handler.dart';
import 'package:example/services/handlers/metafield_handlers/count_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/create_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/delete_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/get_specific_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/list_metafields_handler.dart';
import 'package:example/services/handlers/metafield_handlers/list_metafields_query_parameters_handler.dart';
import 'package:example/services/handlers/metafield_handlers/update_metafield_handler.dart';
import 'package:example/services/index.dart';
import 'handlers/customers_handlers/customer/retrieves_list_of_customers_handler.dart';
import 'handlers/customers_handlers/customer/retrieves_all_orders_belonging_to_customer_handler.dart';
import 'handlers/customers_handlers/customer/sends_account_invite_to_customer_handler.dart';
import 'package:example/services/handlers/inventory/location/list_all_locations_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/create_new_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/disable_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/retrieves_count_of_gift_cards_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/retrieves_list_of_gift_cards_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/retrieves_single_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/searches_for_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/updates_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/automatically_create_gift_card_handler.dart';

enum ApiCategory {
  access,
  storefront,
  admin,
  catalog,
  customer,
  discounts,
  events,
  inventory,
  giftCard,
  metafield,
  storeProperties,
}

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
      case ApiCategory.discounts:
        return 'Discounts APIs';
      case ApiCategory.events:
        return 'Events APIs';
      case ApiCategory.inventory:
        return 'Inventory APIs';
      case ApiCategory.giftCard:
        return 'Gift Card APIs';
      case ApiCategory.metafield:
        return 'Metafield APIs';
      case ApiCategory.storeProperties:
        return 'Store Properties APIs';
    }
  }
}

class ApiField {
  final String name;
  final String label;
  final String hint;
  final bool isRequired;
  final ApiFieldType type;

  const ApiField({
    required this.name,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.type = ApiFieldType.text,
  });
}

enum ApiFieldType {
  text,
  number,
  boolean,
  date,
  select,
  multiselect,
}

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

  List<String> get supportedMethods => handler.supportedMethods;

  Map<String, List<ApiField>> get requiredFields => handler.requiredFields;
}

class ApiServiceRegistry {
  static final List<ApiService> _services = [
    ApiService(
      name: 'Access Scope',
      endpoint: '/accessScope',
      category: ApiCategory.access,
      subcategory: 'Access Scope',
      handler: AccessScopeHandler(),
    ),

    ApiService(
      name: 'Storefront Access Token',
      endpoint: '/storefrontAccessToken',
      category: ApiCategory.access,
      subcategory: 'Storefront Access',
      handler: StorefrontAccessTokenHandler(),
    ),
    ApiService(
      name: 'Customers',
      endpoint: '/customers',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesListOfCustomersHandler(),
    ),
    ApiService(
      name: 'Single Customer',
      endpoint: '/customers/:id',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesSingleCustomerHandler(),
    ),
    ApiService(
      name: 'Customer Orders',
      endpoint: '/customers/:id/orders',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesAllOrdersBelongingToCustomerHandler(),
    ),
    ApiService(
      name: 'Customer Match Query',
      endpoint: '/customers/search',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: SearchesForCustomersThatMatchSuppliedQueryHandler(),
    ),
    ApiService(
      name: 'Customer URL',
      endpoint: '/customers/:id/account_activation_url',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: CustomerUrlHandler(),
    ),
    ApiService(
      name: 'Customer Count',
      endpoint: '/customers/count',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: RetrievesCountOfCustomersHandler(),
    ),
    ApiService(
      name: 'Send Customer Invite',
      endpoint: '/customers/:id/send_invite',
      category: ApiCategory.customer,
      subcategory: 'Customers',
      handler: SendsAccountInviteToCustomerHandler(),
    ),
    ApiService(
      name: 'Create Customer Address',
      endpoint: '/customers/:id/addresses',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: CreateNewAddressForCustomerHandler(),
    ),
    ApiService(
      name: 'Get Customer Addresses',
      endpoint: '/customers/:id/addresses',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: RetrievesListOfAddressesForCustomerHandler(),
    ),
    ApiService(
      name: 'Get Single Address Details',
      endpoint: '/customers/:id/addresses/:address_id',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: RetrievesDetailsForSingleCustomerAddressHandler(),
    ),
    ApiService(
      name: 'Set Default Address',
      endpoint: '/customers/:id/addresses/:address_id/default',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: SetsDefaultAddressForCustomerHandler(),
    ),
    ApiService(
      name: 'Destroy Multiple Addresses',
      endpoint: '/customers/:id/addresses',
      category: ApiCategory.customer,
      subcategory: 'Customer Address',
      handler: DestroyMultipleCustomerAddressesHandler(),
    ),
    ApiService(
      name: 'Events List',
      endpoint: '/events',
      category: ApiCategory.events,
      subcategory: 'Events',
      handler: RetrievesListOfEventsHandler(),
    ),
    ApiService(
      name: 'Single Event',
      endpoint: '/events/:event_id',
      category: ApiCategory.events,
      subcategory: 'Events',
      handler: RetrievesSingleEventHandler(),
    ),
    ApiService(
      name: 'Events Count',
      endpoint: '/events/count',
      category: ApiCategory.events,
      subcategory: 'Events',
      handler: RetrievesCountEventsHandler(),
    ),

    ApiService(
      name: 'Discount Code',
      endpoint: '/discountCodes',
      category: ApiCategory.discounts,
      handler: DiscountCodeHandler(),
      subcategory: 'Discount Code',
    ),

    ApiService(
      name: 'Count of Discount Codes',
      endpoint: '/discountCodes',
      category: ApiCategory.discounts,
      handler: GetDiscountCodesCountHandler(),
      subcategory: 'Discount Code',
    ),
    ApiService(
      name: 'Search for Discount Code',
      endpoint: '/discountCodes/:code',
      category: ApiCategory.discounts,
      handler: SearchDiscountCodeHandler(),
      subcategory: 'Discount Code',
    ),
    ApiService(
      name: 'Discount Code Creation',
      endpoint: '/discountCodes',
      category: ApiCategory.discounts,
      handler: DiscountCodeCreationHandler(),
      subcategory: 'Discount Code',
    ),
    ApiService(
      name: 'Discount Codes List',
      endpoint: '/discountCodes',
      category: ApiCategory.discounts,
      handler: GetListDiscountCodesHandler(),
      subcategory: 'Discount Code',
    ),
    ApiService(
      name: 'Discount Code Creation List',
      endpoint: '/discountCodes',
      category: ApiCategory.discounts,
      handler: GetListDiscountCodeCreationHandler(),
      subcategory: 'Discount Code',
    ),
    ApiService(
      name: 'Price Rule Discount Collection',
      endpoint: '/priceRules',
      category: ApiCategory.discounts,
      handler: CreatePriceRuleDiscountCollectionHandler(),
      subcategory: 'Price Rule',
    ),
    ApiService(
      name: 'Price Rule Discount Selected Customers',
      endpoint: '/priceRules',
      category: ApiCategory.discounts,
      handler: CreatePriceRuleDiscountSelectedCustomersHandler(),
      subcategory: 'Price Rule',
    ),
    ApiService(
      name: 'Price Rule Free Shipping',
      endpoint: '/priceRules',
      category: ApiCategory.discounts,
      handler: CreatePriceRuleFreeShippingHandler(),
      subcategory: 'Price Rule',
    ),
    ApiService(
      name: 'Price Rule Free Item',
      endpoint: '/priceRules',
      category: ApiCategory.discounts,
      handler: CreatePriceRuleFreeItemHandler(),
      subcategory: 'Price Rule',
    ),
    ApiService(
      name: 'Price Rule Discount Order',
      endpoint: '/priceRules',
      category: ApiCategory.discounts,
      handler: CreatePriceRuleDiscountOrderHandler(),
      subcategory: 'Price Rule',
    ),
    ApiService(
      name: 'Price Rule List',
      endpoint: '/priceRules',
      category: ApiCategory.discounts,
      handler: GetPriceRuleListHandler(),
      subcategory: 'Price Rule',
    ),
    ApiService(
      name: 'Price Rule Count',
      endpoint: '/priceRules',
      category: ApiCategory.discounts,
      handler: GetPriceRuleCountHandler(),
      subcategory: 'Price Rule',
    ),
    ApiService(
      name: 'Price Rule Discount Code',
      endpoint: '/priceRules/:id/discountCodes',
      category: ApiCategory.discounts,
      handler: PriceRuleHandler(),
      subcategory: 'Price Rule',
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

    // 🔗 Inventory Level APIs - Connect item to location
    ApiService(
      name: 'Connect Inventory Item to Location',
      endpoint: '/inventory_levels/connect',
      category: ApiCategory.inventory,
      subcategory: 'Inventory Levels',
      handler: InventoryItemToLocationHandler(),
    ),

    // 📊 Inventory Level APIs - Set inventory level for item at location
    ApiService(
      name: 'Set Inventory Level',
      endpoint: '/inventory_levels/set',
      category: ApiCategory.inventory,
      subcategory: 'Inventory Levels',
      handler: SetInventoryLocationHandler(),
    ),

    // 📦 Retrieves a list of inventory levels for a single location
    ApiService(
      name: 'List Inventory Levels By Location',
      endpoint: '/inventory_levels/:location_id',
      category: ApiCategory.inventory,
      subcategory: 'Inventory Levels',
      handler: ListInventoryLevelsSingleLocationHandler(),
    ),

    // 🗺️ Location APIs - List all locations
    ApiService(
      name: 'List All Locations',
      endpoint: '/locations',
      category: ApiCategory.inventory,
      subcategory: 'Locations',
      handler: ListAllLocationsHandler(),
    ),

    // 📍 Location APIs - Get single location by ID
    ApiService(
      name: 'Get Single Location',
      endpoint: '/locations/:id',
      category: ApiCategory.inventory,
      subcategory: 'Locations',
      handler: SingleLocationByIdHandler(),
    ),

    // 📦 Inventory APIs - List inventory by location ID
    ApiService(
      name: 'List Inventory By Location ID',
      endpoint: '/locations/:id/inventory_levels',
      category: ApiCategory.inventory,
      subcategory: 'Locations',
      handler: ListInventoryByLocationIdHandler(),
    ),

    // 📊 Retrieves a count of all locations
    ApiService(
      name: 'Count All Locations',
      endpoint: '/locations/count',
      category: ApiCategory.inventory,
      subcategory: 'Locations',
      handler: CountAllLocationsHandler(),
    ),

    // 📦 Retrieve inventory levels for a single inventory item
    ApiService(
      name: 'List Inventory Levels By Item',
      endpoint: '/inventory_levels/by_item',
      category: ApiCategory.inventory,
      subcategory: 'Inventory Levels',
      handler: ListInventoryLevelsSingleItemHandler(),
    ),
    ApiService(
      name: 'Create Gift Card',
      endpoint: '/gift_cards',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: CreateNewGiftCardHandler(),
    ),
    ApiService(
      name: 'Automatically Create Gift Card',
      endpoint: '/gift_cards/auto_create',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: AutomaticallyCreateGiftCardHandler(),
    ),
    ApiService(
      name: 'Disable Gift Card',
      endpoint: '/gift_cards/:id/disable',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: DisableGiftCardHandler(),
    ),
    ApiService(
      name: 'Gift Cards Count',
      endpoint: '/gift_cards/count',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: RetrievesCountOfGiftCardsHandler(),
    ),
    ApiService(
      name: 'Gift Cards List',
      endpoint: '/gift_cards',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: RetrievesListOfGiftCardsHandler(),
    ),
    ApiService(
      name: 'Single Gift Card',
      endpoint: '/gift_cards/:id',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: RetrievesSingleGiftCardHandler(),
    ),
    ApiService(
      name: 'Search Gift Cards',
      endpoint: '/gift_cards/search',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: SearchesForGiftCardsHandler(),
    ),
    ApiService(
      name: 'Update Gift Card',
      endpoint: '/gift_cards/:id',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: UpdatesGiftCardHandler(),
    ),

    ApiService(
      name: 'Create Metafield',
      endpoint: '/:owner_resource/:owner_id/metafields',
      category: ApiCategory.metafield,
      subcategory: 'Metafield',
      handler: CreateMetafieldHandler(),
    ),

    ApiService(
      name: 'List Metafields',
      endpoint: '/:owner_resource/:owner_id/metafields',
      category: ApiCategory.metafield,
      subcategory: 'Metafield',
      handler: ListMetafieldsHandler(),
    ),

    ApiService(
      name: 'Get Specific Metafield',
      endpoint: '/:owner_resource/:owner_id/metafields/:metafield_id',
      category: ApiCategory.metafield,
      subcategory: 'Metafield',
      handler: GetSpecificMetafieldHandler(),
    ),

    ApiService(
      name: 'Count Metafields',
      endpoint: '/:owner_resource/:owner_id/metafields/count',
      category: ApiCategory.metafield,
      subcategory: 'Metafield',
      handler: CountMetafieldHandler(),
    ),
    ApiService(
      name: 'List Metafields By Query Parameters',
      endpoint: '/:owner_resource/:owner_id/metafields',
      category: ApiCategory.metafield,
      subcategory: 'Metafield',
      handler: ListMetafieldsQueryParametersHandler(),
    ),
    ApiService(
      name: 'Update Metafield',
      endpoint: '/:owner_resource/:owner_id/metafields/:metafield_id',
      category: ApiCategory.metafield,
      subcategory: 'Metafield',
      handler: UpdateMetafieldHandler(),
    ),

    // 📦 Delete Metafield
    ApiService(
      name: 'Delete Metafield',
      endpoint: '/:owner_resource/:owner_id/metafields/:metafield_id',
      category: ApiCategory.metafield,
      subcategory: 'Metafield',
      handler: DeleteMetafieldHandler(),
    ),
    ApiService(
      name: 'Countries List',
      endpoint: '/countries',
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: ReceivesListOfCountriesHandler(),
    ),
    ApiService(
      name: 'Countries Count',
      endpoint: '/countries/count',
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: RetrievesCountOfCountriesHandler(),
    ),
    ApiService(
      name: 'Create Country',
      endpoint: '/countries',
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: CreateCountryHandler(),
    ),
    ApiService(
      name: 'Create Country With Custom Tax Rate',
      endpoint: '/countries/create_custom_tax',
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: CreateCountryWithCustomTaxHandler(),
    ),
    ApiService(
      name: 'Create Country (Shopify Tax Rate)',
      endpoint: '/countries/create_with_shopify_tax',
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: CreateCountryUsingShopifyTaxRateHandler(),
    ),
    ApiService(
      name: 'Update Existing Country',
      endpoint: '/update_country',
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: UpdatesExistingCountryHandler(),
    ),
    ApiService(
      name: 'Delete a country',
      endpoint: '/countries/{id}.json',
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: DeleteCountryHandler(),
    ),
    ApiService(
      name: 'Currencies List',
      endpoint: '/currencies.json',
      category: ApiCategory.storeProperties,
      subcategory: 'Currency',
      handler: RetrievesListOfCurrenciesHandler(),
    ),
    ApiService(
      name: 'Retrieve List of Shop Policies',
      endpoint: '/policies.json',
      category: ApiCategory.storeProperties,
      subcategory: 'Policy',
      handler: RetrievesShopPoliciesHandler(),
    ),
    ApiService(
      name: 'Retrieve Provinces for Country',
      endpoint: '/countries/{country_id}/provinces.json',
      category: ApiCategory.storeProperties,
      subcategory: 'Province',
      handler: RetrievesListOfProvincesForCountryHandler(),
    ),
    ApiService(
      name: 'Retrieve Single Province for Country',
      endpoint: '/countries/{country_id}/provinces/{province_id}',
      category: ApiCategory.storeProperties,
      subcategory: 'Province',
      handler: RetrievesListOfProvincesForCountryHandler(),
    ),
    ApiService(
      name: 'Count Provinces for Country',
      endpoint: '/provinces/count',
      category: ApiCategory.storeProperties,
      subcategory: 'Province',
      handler: RetrievesCountOfProvincesForCountryHandler(),
    ),
    ApiService(
      name: 'Update Existing Province',
      endpoint: '/countries/{country_id}/provinces/{province_id}.json',
      category: ApiCategory.storeProperties,
      subcategory: 'Province',
      handler: UpdatesProvinceForCountryHandler(),
    ),
    ApiService(
      name: 'Receive List of Shipping Zones',
      endpoint: '/shipping_zones',
      category: ApiCategory.storeProperties,
      subcategory: 'Shipping Zones',
      handler: ReceiveListOfShippingZonesHandler(),
    ),
  ];

  static void initialize() {}

  static List<ApiService> get all => _services;

  static List<ApiCategory> get categories =>
      _services.map((s) => s.category).toSet().toList();

  static List<ApiService> getByCategory(ApiCategory category) =>
      _services.where((s) => s.category == category).toList();

  static List<String> getSubcategoriesByCategory(ApiCategory category) =>
      _services
          .where((s) => s.category == category)
          .map((s) => s.subcategory)
          .toSet()
          .toList();

  static List<ApiService> getBySubcategory(
          ApiCategory category, String subcategoryName) =>
      _services
          .where(
              (s) => s.category == category && s.subcategory == subcategoryName)
          .toList();

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
      case ApiCategory.discounts:
        return 'Discounts';
      case ApiCategory.events:
        return 'Events';
      case ApiCategory.inventory:
        return 'Inventory';
      case ApiCategory.giftCard:
        return 'Gift Card';
      case ApiCategory.metafield:
        return 'Metafield';
      case ApiCategory.storeProperties:
        return 'Store Properties';
    }
  }
}
