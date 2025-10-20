import 'package:flutter/material.dart';
import 'package:api_explorer/services/index.dart';

enum ApiCategory {
  shopify,
  woocommerce,
  shopifyGraphql, // New main category
  graphql,
  access,
  billing,
  customer,
  discounts,
  events,
  inventory,
  orders,
  marketingEvent,
  giftCard,
  metafield,
  onlineStore,
  products,
  storeProperties,
  tendertransaction,
  webhooks,
  // GraphQL categories
  graphqlQueries,
  graphqlMutations,
  // GraphQL Products and Collections Main Category
  graphqlProductsAndCollections,
  // GraphQL Products and Collections Subcategories
  graphqlProductsAndCollectionsQueries,
  graphqlProductsAndCollectionsMutations,
  // GraphQL Orders Main Category
  //graphqlOrders,
  // GraphQL Orders Subcategories
  //graphqlOrdersQueries,
  //graphqlOrdersMutations,
  // GraphQL Customers Main Category
  graphqlCustomers,
  // GraphQL Customers Subcategories
  graphqlCustomersQueries,
  graphqlCustomersMutations,
  // GraphQL Shop Main Category
  //graphqlShop,
  // GraphQL Shop Subcategories
  // GraphQL Webhooks Main Category
  graphqlWebhooks,
  // GraphQL Webhook Subcategories
  graphqlWebhookQueries,
  graphqlWebhookMutations,
  // WooCommerce categories
  woocommerceCoupons,
  woocommerceProducts,
  woocommerceOrders,
  woocommerceCustomers,
  woocommerceWebhooks,
  woocommerceSystemStatus,
  woocommerceReports,
  woocommerceShippingMethods,
  woocommerceShippingZones,
  woocommerceShippingZoneMethods,
  woocommercePaymentGateways,
  woocommerceData,
  woocommerceContinents,
  woocommerceCountries,
  woocommerceCurrencies,
  woocommerceRefunds,
  woocommerceSetting,
  woocommerceTaxes,
  //WooCommerce Store API
  //TODO: Add other Store API categories here
  woocommerceWishlist,
  woocommerceCart,
  woocommerceCheckout,
  woocommerceCheckoutOrder,
  woocommerceOrder,
  woocommerceStoreProducts,
  woocommerceStoreProductTags,
  woocommerceStoreProductReviews,
  woocommerceStoreProductCollectionData,
  woocommerceStoreProductCategories,
  woocommerceStoreProductBrands,
  woocommerceStoreProductAttributes,
  woocommerceStoreProductAttributeTerms,
}

extension ApiCategoryExtension on ApiCategory {
  String get displayName {
    switch (this) {
      case ApiCategory.shopify:
        return 'Shopify';
      case ApiCategory.woocommerce:
        return 'WooCommerce';
      case ApiCategory.shopifyGraphql:
        return 'Shopify GraphQL';
      case ApiCategory.graphql:
        return 'GraphQL APIs (Modern)';
      case ApiCategory.access:
        return 'Access APIs';
      case ApiCategory.billing:
        return 'Billing APIs';
      case ApiCategory.customer:
        return 'Customer APIs';
      case ApiCategory.discounts:
        return 'Discounts APIs';
      case ApiCategory.events:
        return 'Events APIs';
      case ApiCategory.inventory:
        return 'Inventory APIs';
      case ApiCategory.orders:
        return 'Orders APIs';
      case ApiCategory.marketingEvent:
        return 'Marketing Event APIs';
      case ApiCategory.giftCard:
        return 'Gift Card APIs';
      case ApiCategory.metafield:
        return 'Metafield APIs';
      case ApiCategory.onlineStore:
        return 'Online Store APIs';
      case ApiCategory.products:
        return 'Products APIs';
      case ApiCategory.storeProperties:
        return 'Store Properties APIs';
      case ApiCategory.tendertransaction:
        return 'Tender Transaction APIs';
      case ApiCategory.webhooks:
        return 'Webhooks APIs';
      case ApiCategory.graphqlQueries:
        return 'GraphQL Queries (Data Fetching)';
      case ApiCategory.graphqlMutations:
        return 'GraphQL Mutations (Data Modification)';
      // GraphQL Products and Collections
      case ApiCategory.graphqlProductsAndCollections:
        return 'Products and Collections';
      case ApiCategory.graphqlProductsAndCollectionsQueries:
        return 'Queries';
      case ApiCategory.graphqlProductsAndCollectionsMutations:
        return 'Mutations';

      case ApiCategory.graphqlCustomers:
        return 'Customers';
      case ApiCategory.graphqlCustomersQueries:
        return 'Queries';
      case ApiCategory.graphqlCustomersMutations:
        return 'Mutations';
      // GraphQL Webhooks
      case ApiCategory.graphqlWebhooks:
        return 'Webhooks';
      case ApiCategory.graphqlWebhookQueries:
        return 'Queries';
      case ApiCategory.graphqlWebhookMutations:
        return 'Mutations';
      // GraphQL Shop
      case ApiCategory.woocommerceCoupons:
        return 'Coupons APIs';
      case ApiCategory.woocommerceProducts:
        return 'Products APIs';
      case ApiCategory.woocommerceOrders:
        return 'Orders APIs';
      case ApiCategory.woocommerceCustomers:
        return 'Customers APIs';
      case ApiCategory.woocommerceWebhooks:
        return 'Webhooks APIs';
      case ApiCategory.woocommerceSystemStatus:
        return 'System Status APIs';
      case ApiCategory.woocommerceReports:
        return 'Reports APIs';
      case ApiCategory.woocommerceShippingMethods:
        return 'Shipping Methods APIs';
      case ApiCategory.woocommerceShippingZones:
        return 'Shipping Zones APIs';
      case ApiCategory.woocommerceShippingZoneMethods:
        return 'Shipping Zone Methods APIs';
      case ApiCategory.woocommercePaymentGateways:
        return 'Payment Gateways APIs';
      case ApiCategory.woocommerceData:
        return 'Data APIs';
      case ApiCategory.woocommerceContinents:
        return 'Continents APIs';
      case ApiCategory.woocommerceCountries:
        return 'Countries APIs';
      case ApiCategory.woocommerceCurrencies:
        return 'Currencies APIs';
      case ApiCategory.woocommerceRefunds:
        return 'Refunds APIs';
      case ApiCategory.woocommerceSetting:
        return 'Settings';
      case ApiCategory.woocommerceTaxes:
        return 'Taxes APIs';
      // WooCommerce Store API
      case ApiCategory.woocommerceWishlist:
        return 'Wishlist APIs';
      case ApiCategory.woocommerceCart:
        return 'Cart API';
      case ApiCategory.woocommerceCheckout:
        return 'Checkout API';
      case ApiCategory.woocommerceCheckoutOrder:
        return 'Checkout Order API';
      case ApiCategory.woocommerceOrder:
        return 'WooCommerce Store Order API';
      case ApiCategory.woocommerceStoreProducts:
        return 'Products API';
      case ApiCategory.woocommerceStoreProductTags:
        return 'Product Tags API';
      case ApiCategory.woocommerceStoreProductReviews:
        return 'Product Reviews API';
      case ApiCategory.woocommerceStoreProductCollectionData:
        return 'Product Collection Data API';
      case ApiCategory.woocommerceStoreProductCategories:
        return 'Product Categories API';
      case ApiCategory.woocommerceStoreProductBrands:
        return 'Product Brands API';
      case ApiCategory.woocommerceStoreProductAttributes:
        return 'Product Attributes API';
      case ApiCategory.woocommerceStoreProductAttributeTerms:
        return 'Product Attribute Terms API';
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

    // 💰 Billing APIs with subcategories
    ApiService(
      name: 'List Application Charges',
      endpoint: '/application_charges',
      category: ApiCategory.billing,
      subcategory: 'Application Charge',
      handler: RetrieveListOfApplicationChargesHandler(),
    ),

    // 💰 Single Application Charge API
    ApiService(
      name: 'Get Application Charge',
      endpoint: '/application_charges/:id',
      category: ApiCategory.billing,
      subcategory: 'Application Charge',
      handler: RetrieveAnApplicationChargeHandler(),
    ),

    ApiService(
      name: 'Create Application Charge',
      endpoint: '/application_charges',
      category: ApiCategory.billing,
      subcategory: 'Application Charge',
      handler: CreateAnApplicationChargeHandler(),
    ),

    // 💰 Application Credit APIs
    ApiService(
      name: 'List Application Credits',
      endpoint: '/application_credits',
      category: ApiCategory.billing,
      subcategory: 'Application Credit', // New subcategory
      handler: RetrieveListOfApplicationCreditsHandler(),
    ),

    // 💰 Single Application Credit API
    ApiService(
      name: 'Get Application Credit',
      endpoint: '/application_credits/:id',
      category: ApiCategory.billing,
      subcategory: 'Application Credit',
      handler: RetrieveAnApplicationCreditHandler(),
    ),

    // 💰 Recurring Application Charge APIs
    ApiService(
      name: 'List Recurring Application Charges',
      endpoint: '/recurring_application_charges',
      category: ApiCategory.billing,
      subcategory: 'Recurring Application Charge',
      handler: RetrieveListOfRecurringApplicationChargesHandler(),
    ),

    // 💰 Single Recurring Application Charge API
    ApiService(
      name: 'Get Recurring Application Charge',
      endpoint: '/recurring_application_charges/:id',
      category: ApiCategory.billing,
      subcategory: 'Recurring Application Charge',
      handler: RetrieveARecurringApplicationChargeHandler(),
    ),

    // 💰 Customize Recurring Application Charge API
    ApiService(
      name: 'Customize Recurring Application Charge',
      endpoint: '/recurring_application_charges/:id/customize',
      category: ApiCategory.billing,
      subcategory: 'Recurring Application Charge',
      handler: CustomizeRecurringApplicationChargeHandler(),
    ),

    // 💰 Delete Recurring Application Charge API
    ApiService(
      name: 'Delete Recurring Application Charge',
      endpoint: '/recurring_application_charges/:id',
      category: ApiCategory.billing,
      subcategory: 'Recurring Application Charge',
      handler: DeleteRecurringApplicationChargeHandler(),
    ),

    // 💰 Create Basic Recurring Application Charge API
    ApiService(
      name: 'Create Basic Recurring Application Charge',
      endpoint: '/recurring_application_charges/basic',
      category: ApiCategory.billing,
      subcategory: 'Recurring Application Charge',
      handler: CreateBasicRecurringApplicationChargeHandler(),
    ),

    // 💰 Create Trial Recurring Application Charge API
    ApiService(
      name: 'Create Trial Recurring Application Charge',
      endpoint: '/recurring_application_charges/trial',
      category: ApiCategory.billing,
      subcategory: 'Recurring Application Charge',
      handler: CreateTrialRecurringApplicationChargeHandler(),
    ),

    // 💰 Create Capped Recurring Application Charge API
    ApiService(
      name: 'Create Capped Recurring Application Charge',
      endpoint: '/recurring_application_charges/capped',
      category: ApiCategory.billing,
      subcategory: 'Recurring Application Charge',
      handler: CreateCappedRecurringApplicationChargeHandler(),
    ),

    // 💰 Usage Charge APIs
    ApiService(
      name: 'Retrieve List of Usage Charges',
      endpoint:
          '/recurring_application_charges/:recurring_application_charge_id/usage_charges',
      category: ApiCategory.billing,
      subcategory: 'Usage Charge',
      handler: RetrieveListOfUsageChargesHandler(),
    ),

    ApiService(
      name: 'Retrieve a Usage Charge',
      endpoint:
          '/recurring_application_charges/:recurring_application_charge_id/usage_charges/:id',
      category: ApiCategory.billing,
      subcategory: 'Usage Charge',
      handler: RetrieveAUsageChargeHandler(),
    ),

    ApiService(
      name: 'Create Usage Charge',
      endpoint:
          '/recurring_application_charges/:recurring_application_charge_id/usage_charges',
      category: ApiCategory.billing,
      subcategory: 'Usage Charge',
      handler: CreateUsageChargeHandler(),
    ),

    // 🏷️ Customer Address APIs - Create Address
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
      name: 'Abandoned Checkouts List',
      endpoint: '/orders',
      category: ApiCategory.orders,
      subcategory: 'Abandoned Checkouts',
      handler: GetAbandonedCheckoutsListHandler(),
    ),
    ApiService(
      name: 'Abandoned Checkouts Count',
      endpoint: '/orders',
      category: ApiCategory.orders,
      subcategory: 'Abandoned Checkouts',
      handler: GetAbandonedCheckoutsCountHandler(),
    ),
    ApiService(
        name: 'draft order with percent discount',
        endpoint: '/draft_orders',
        category: ApiCategory.orders,
        subcategory: 'Draft Order',
        handler: CreateDraftOrderPercentDiscountItemHandler()),

    ApiService(
        name: 'draft order with simple product variant',
        endpoint: '/draft_orders',
        category: ApiCategory.orders,
        subcategory: 'Draft Order',
        handler: CreateDraftOrderSimpleProductVariantHandler()),

    ApiService(
        name: 'draft order with discount',
        endpoint: '/draft_orders',
        category: ApiCategory.orders,
        subcategory: 'Draft Order',
        handler: CreateDraftOrderWithDiscountHandler()),

    ApiService(
        name: 'draft order discounted item',
        endpoint: '/draft_orders',
        category: ApiCategory.orders,
        subcategory: 'Draft Order',
        handler: CreateDraftOrderDiscountedItemHandler()),
    ApiService(
        name: 'draft order custom',
        endpoint: '/draft_orders',
        category: ApiCategory.orders,
        subcategory: 'Draft Order',
        handler: CreateDraftOrderCustomHandler()),
    // 📈 Marketing Events APIs - Retrieves A List Of All Marketing Events
    ApiService(
        name: 'Retrieves A List Of All',
        endpoint: '/marketing_events',
        category: ApiCategory.marketingEvent,
        subcategory: 'Marketing Events',
        handler: RetrievesAListOfAllHandler()),

    // 📊 Marketing Events APIs - Retrieves A Single Marketing Event
    ApiService(
        name: 'Retrieves A Single',
        endpoint: '/marketing_events/:id',
        category: ApiCategory.marketingEvent,
        subcategory: 'Marketing Events',
        handler: RetrievesASingleHandler()),

    // 🔢 Marketing Events APIs - Retrieves A Count Of All Marketing Events
    ApiService(
        name: 'Retrieves A Count Of All',
        endpoint: '/marketing_events/count',
        category: ApiCategory.marketingEvent,
        subcategory: 'Marketing Events',
        handler: RetrievesACountOfAllHandler()),

    // ➕ Marketing Events APIs - Creates A Marketing Event
    ApiService(
        name: 'Creates A Marketing Event',
        endpoint: '/marketing_events',
        category: ApiCategory.marketingEvent,
        subcategory: 'Marketing Events',
        handler: CreatesMarketingEventHandler()),

    // 🔄 Marketing Events APIs - Update Marketing Event
    ApiService(
        name: 'Update Marketing Event',
        endpoint: '/marketing_events/:id',
        category: ApiCategory.marketingEvent,
        subcategory: 'Marketing Events',
        handler: UpdatesAMarketingEventHandler()),

    // 🗑️ Marketing Events APIs - Delete Marketing Event
    ApiService(
        name: 'Delete Marketing Event',
        endpoint: '/marketing_events/:id',
        category: ApiCategory.marketingEvent,
        subcategory: 'Marketing Events',
        handler: DeletesAMarketingEventHandler()),

    // 🔗 Marketing Events APIs - Create Marketing Event Engagement On A Marketing Event
    ApiService(
        name: 'Create Marketing Event Engagement',
        endpoint: '/marketing_events/:id/engagements',
        category: ApiCategory.marketingEvent,
        subcategory: 'Marketing Events',
        handler: CreatesMarketingEngagementsHandler()),
    ApiService(
      name: 'Create Gift Card',
      endpoint: '/gift_cards',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: CreateNewGiftCardHandler(),
    ),
    ApiService(
      name: 'Create Gift Card With Custom Code',
      endpoint: '/gift_cards/custom_code',
      category: ApiCategory.giftCard,
      subcategory: 'Gift Card',
      handler: CreateGiftCardWithCustomCodeHandler(),
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
      name: 'send invoice customized',
      endpoint: '/draft_orders/:draft_order_id/invoice',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: CreateInvoiceCustomizedHandler(),
    ),
    ApiService(
      name: 'send invoice default',
      endpoint: '/draft_orders/:draft_order_id/invoice',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: CreateInvoiceDefaultHandler(),
    ),
    ApiService(
      name: 'Update Draft Order Modify Existing',
      endpoint: '/draft_orders/:draft_order_id',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: UpdateDraftOrderCompleteHandler(),
    ),
    ApiService(
      name: 'Update Set Discount on Draft Order',
      endpoint: '/draft_orders/:draft_order_id',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: UpdateSetDiscountOnDraftOrderHandler(),
    ),
    ApiService(
      name: 'Update Draft Order Complete',
      endpoint: '/draft_orders/:draft_order_id/complete',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: GetDraftOrderCountHandler(),
    ),
    ApiService(
      name: 'Update Set Discount on Draft Order',
      endpoint: '/draft_orders/:draft_order_id',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: UpdateSetDiscountOnDraftOrderHandler(),
    ),
    ApiService(
      name: 'Get Draft Order Count',
      endpoint: '/draft_orders/count',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: CreateDraftOrderHandler(),
    ),

    ApiService(
        name: 'Order',
        endpoint: '/orders',
        category: ApiCategory.orders,
        subcategory: 'Order',
        handler: OrderHandler()),

    ApiService(
        name: 'Get Order List',
        endpoint: '/orders/count',
        category: ApiCategory.orders,
        subcategory: 'Order',
        handler: GetOrderListHandler()),
    ApiService(
        name: 'Get Order Count',
        endpoint: '/orders/count',
        category: ApiCategory.orders,
        subcategory: 'Order',
        handler: GetOrderCountHandler()),

    ApiService(
        name: 'Create Cancel Order',
        endpoint: '/orders/:order_id/cancel',
        category: ApiCategory.orders,
        subcategory: 'Order',
        handler: CreateCancelOrderHandler()),
    ApiService(
        name: 'Create Close Order',
        endpoint: '/orders/:order_id/close',
        category: ApiCategory.orders,
        subcategory: 'Order',
        handler: CreateCloseOrderHandler()),
    ApiService(
        name: 'Create Reopen Order',
        endpoint: '/orders/:order_id/reopen',
        category: ApiCategory.orders,
        subcategory: 'Order',
        handler: CreateReopenOrderHandler()),

    ApiService(
        name: 'Create Order with Tax Lines',
        endpoint: '/orders',
        category: ApiCategory.orders,
        subcategory: 'Order',
        handler: CreateOrderWithTaxLinesHandler()),
    ApiService(
      name: 'Create Order Partially Paid',
      endpoint: '/orders/order',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: CreateOrderPartiallyPaidHandler(),
    ),

    ApiService(
      name: 'Create Order Comprehensive',
      endpoint: '/orders/order',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: CreateOrderComprehensiveHandler(),
    ),

    ApiService(
      name: 'Create Order with Product ID',
      endpoint: '/orders/order',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: CreateOrderWithProductIdHandler(),
    ),

    ApiService(
      name: 'Create Order without Order Receipt',
      endpoint: '/orders/order',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: CreateOrderWithoutOrderReceiptHandler(),
    ),

    ApiService(
      name: 'Create Order Sending Order Confirmation',
      endpoint: '/orders/order',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: CreateOrderSendingOrderConfirmationHandler(),
    ),

    ApiService(
      name: 'Create Order with Pending Customer',
      endpoint: '/orders/order',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: CreateOrderWithPendingCustomerHandler(),
    ),

    ApiService(
      name: 'Create Order Fulfill',
      endpoint: '/orders/order',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: CreateOrderFulfillHandler(),
    ),

    // Risk endpoints with incorrect format
    ApiService(
      name: 'Get List Order Risks',
      endpoint: '/orders/:order_id/risks', // Fixed from '/orders/order'
      category: ApiCategory.orders,
      subcategory: 'Order Risk',
      handler: GetListOrderRisksHandler(),
    ),

    ApiService(
      name: 'Order Risk',
      endpoint:
          '/orders/:order_id/risks/:risk_id', // Fixed from '/orders/order'
      category: ApiCategory.orders,
      subcategory: 'Order Risk',
      handler: OrderRiskHandler(),
    ),

    // Refund endpoints with incorrect format
    ApiService(
      name: 'Get Single Refund',
      endpoint:
          '/orders/:order_id/refunds/:refund_id', // Fixed from '/orders/order'
      category: ApiCategory.orders,
      subcategory: 'Refund',
      handler: RefundHandler(),
    ),

    ApiService(
      name: 'Get List Refund',
      endpoint: '/orders/:order_id/refunds', // Fixed from '/orders/order'
      category: ApiCategory.orders,
      subcategory: 'Refund',
      handler: GetListRefundHandler(),
    ),

    ApiService(
      name: 'Create Calculate Refund',
      endpoint:
          '/orders/:order_id/refunds/calculate', // Fixed from '/orders/order'
      category: ApiCategory.orders,
      subcategory: 'Refund',
      handler: CreateRefundCalculateHandler(),
    ),

    ApiService(
      name: 'Create Refund',
      endpoint: '/orders/:order_id/refunds', // Fixed from '/orders/order'
      category: ApiCategory.orders,
      subcategory: 'Refund',
      handler: CreateRefundHandler(),
    ),

    // Transaction endpoints with incorrect format
    ApiService(
      name: 'Create Transaction',
      endpoint:
          '/orders/:order_id/transactions', // Fixed from complex nested path
      category: ApiCategory.orders,
      subcategory: 'Transaction',
      handler: CreateTransactionHandler(),
    ),

    ApiService(
      name: 'Get Count Transactions',
      endpoint:
          '/orders/:order_id/transactions/count', // Fixed from complex nested path
      category: ApiCategory.orders,
      subcategory: 'Transaction',
      handler: GetTransactionCountHandler(),
    ),

    ApiService(
      name: 'Get Transaction List',
      endpoint:
          '/orders/:order_id/transactions', // Fixed from complex nested path
      category: ApiCategory.orders,
      subcategory: 'Transaction',
      handler: GetTransactionListHandler(),
    ),

    ApiService(
      name: 'Get Transaction Single',
      endpoint:
          '/orders/:order_id/transactions/:transaction_id', // Fixed from count endpoint
      category: ApiCategory.orders,
      subcategory: 'Transaction',
      handler: GetTransactionSingleHandler(),
    ),
    ApiService(
      name: 'Update Note Attributes',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateNoteAttributesHandler(),
    ),
    ApiService(
      name: 'Update Shipping Address',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateShippingAddressHandler(),
    ),
    ApiService(
      name: 'Update Order Tags',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateOrderTagHandler(),
    ),
    ApiService(
      name: 'Update Order Add Note',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateAddNoteHandler(),
    ),
    ApiService(
      name: 'Update Order Phone Number',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdatePhoneNumberHandler(),
    ),
    ApiService(
      name: 'Update Order Email Address',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateEmailAddressHandler(),
    ),
    ApiService(
      name: 'Update Order Add Metafield',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateAddMetafieldHandler(),
    ),
    ApiService(
      name: 'Remove Customer from Order',
      endpoint: '/orders/:order_id',
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateRemoveCustomerHandler(),
    ),
    ApiService(
      name: 'Update Order Marketing Preferences',
      endpoint:
          '/orders/:order_id', // Fixed from '/api/{api_version}/orders/{order_id}'
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: UpdateChangeWhetherHandler(),
    ),

    ApiService(
      name: 'Get Orders With Properties',
      endpoint: '/orders', // Fixed from '/api/{api_version}/orders'
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: GetOrdersWithPropertiesHandler(),
    ),

    ApiService(
      name: 'Get Authorized Orders',
      endpoint: '/orders', // Fixed from '/api/{api_version}/orders'
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: GetOrdersAuthorizedHandler(),
    ),

    ApiService(
      name: 'Get Unfulfilled Orders',
      endpoint: '/orders', // Fixed from '/api/{api_version}/orders'
      category: ApiCategory.orders,
      subcategory: 'Order',
      handler: GetOrderAfterTimestampHandler(),
    ),
    ApiService(
      name: 'Update Set Discount on Draft Order',
      endpoint: '/draft_orders/:draft_order_id',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: UpdateSetDiscountOnDraftOrderHandler(),
    ),
    ApiService(
      name: 'Update Add Note on Draft Order',
      endpoint: '/draft_orders/:draft_order_id',
      category: ApiCategory.orders,
      subcategory: 'Draft Order',
      handler: UpdateAddNoteDraftOrderHandler(),
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
      endpoint: '/countries/:id', // Fixed from '/update_country'
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: UpdatesExistingCountryHandler(),
    ),

    ApiService(
      name: 'Delete a country',
      endpoint: '/countries/:id', // Fixed from '/countries/{id}.json'
      category: ApiCategory.storeProperties,
      subcategory: 'Country',
      handler: DeleteCountryHandler(),
    ),

    ApiService(
      name: 'Currencies List',
      endpoint: '/currencies', // Fixed from '/currencies.json'
      category: ApiCategory.storeProperties,
      subcategory: 'Currency',
      handler: RetrievesListOfCurrenciesHandler(),
    ),

    ApiService(
      name: 'Retrieve List of Shop Policies',
      endpoint: '/policies', // Fixed from '/policies.json'
      category: ApiCategory.storeProperties,
      subcategory: 'Policy',
      handler: RetrievesShopPoliciesHandler(),
    ),

    ApiService(
      name: 'Retrieve Provinces for Country',
      endpoint:
          '/countries/:country_id/provinces', // Fixed from '/countries/{country_id}/provinces.json'
      category: ApiCategory.storeProperties,
      subcategory: 'Province',
      handler: RetrievesListOfProvincesForCountryHandler(),
    ),

    ApiService(
      name: 'Retrieve Single Province for Country',
      endpoint:
          '/countries/:country_id/provinces/:province_id', // Fixed from '{...}'
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
      endpoint:
          '/countries/:country_id/provinces/:province_id', // Fixed from .json suffix
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
    ApiService(
      name: 'Retrieve Shop Configuration',
      endpoint: '/shop', // Fixed from '/shop.json'
      category: ApiCategory.storeProperties,
      subcategory: 'Shop',
      handler: RetrievesShopConfigurationHandler(),
    ),

    // 📝 LIST ALL ARTICLE AUTHORS
    ApiService(
      name: 'List All Article Authors',
      endpoint: '/article_authors',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: ListAllArticleAuthorsHandler(),
    ),
    // 📝 LIST TAGS FOR A SPECIFIC BLOG
    ApiService(
      name: 'List Tags for a Specific Blog',
      endpoint: '/blogs/:blog_id/tags',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: ListTagsSpecificBlogHandler(),
    ),
    // 🏷️ LIST MOST POPULAR TAGS
    ApiService(
      name: 'List Most Popular Tags',
      endpoint: '/tags/popular',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: ListMostPopularTagsHandler(),
    ),

    // 🏷️ LIST TAGS FOR ALL ARTICLES
    ApiService(
      name: 'List Tags for All Articles',
      endpoint: '/tags/all',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: ListTagsAllArticlesHandler(),
    ),

    // 🏷️ LIST MOST POPULAR TAGS FOR SPECIFIC BLOG
    ApiService(
      name: 'List Most Popular Tags for Specific Blog',
      endpoint: '/blogs/:blog_id/tags/popular',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: ListMostPopularTagsSpecificBlogHandler(),
    ),

    // 📚 LIST ARTICLES FROM BLOG
    ApiService(
      name: 'List Articles from Blog',
      endpoint: '/blogs/:blog_id/articles',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: ListArticlesFromBlogHandler(),
    ),

    // 📝 GET SINGLE ARTICLE
    ApiService(
      name: 'Get Single Article',
      endpoint: '/blogs/:blogs_id/articles/:article_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: GetSingleArticleHandler(),
    ),

    // 🔢 COUNT BLOG ARTICLES
    ApiService(
      name: 'Count Blog Articles',
      endpoint: '/blogs/:blog_id/articles/count',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: CountBlogArticlesHandler(),
    ),

    // 🏷️ LIST ARTICLE TAGS SPECIFIC BLOG
    ApiService(
      name: 'List Article Tags Specific Blog',
      endpoint: '/blogs/:blog_id/articles/tags',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: ListArticleTagsSpecificBlogHandler(),
    ),

    // 📝 CREATE ARTICLE WITH METAFIELD
    ApiService(
      name: 'Create Article With Metafield',
      endpoint: '/blogs/:blog_id/articles',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: CreateArticleWithMetafieldHandler(),
    ),

    // 📝 CREATE ARTICLE WITH IMAGE
    ApiService(
      name: 'Create Article With Image',
      endpoint: '/blogs/:blog_id/articles',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: CreateArticleWithImageHandler(),
    ),

    // 📝 CREATE ARTICLE HTML MARKUP
    ApiService(
      name: 'Create Article HTML Markup',
      endpoint: '/blogs/:blog_id/articles',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: CreateArticleHtmlMarkupHandler(),
    ),

    // 📝 CREATE ARTICLE WITH BASE64
    ApiService(
      name: 'Create Article With Base',
      endpoint: '/blogs/:blog_id/articles',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: CreateArticleBaseImageHandler(),
    ),

    // 📝 CREATE UNPUBLISHED ARTICLE
    ApiService(
      name: 'Create Unpublished Article',
      endpoint: '/blogs/:blog_id/articles',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: CreateUnpublishedArticleBlogHandler(),
    ),

    // 📝 UPDATE ARTICLE
    ApiService(
      name: 'Update Article',
      endpoint: '/blogs/:blog_id/articles/:article_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: UpdateArticleHandler(),
    ),

    //🗑️ DELETE ARTICLE
    ApiService(
      name: 'Delete Article',
      endpoint: '/blogs/:blog_id/articles/:article_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Article',
      handler: DeleteArticleFromBlogHandler(),
    ),

    // 🎨 LIST ALL THEME ASSETS
    ApiService(
      name: 'List All Theme Assets',
      endpoint: '/themes/:theme_id/assets',
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: ListAllAssetsThemeHandler(),
    ),

    // 🖼️ GET LIQUID TEMPLATE
    ApiService(
      name: 'Get Liquid Template',
      endpoint: '/themes/:theme_id/assets/:key',
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: GetLiquidTemplateHandler(),
    ),

    // 🖼️ CREATE IMAGE ASSET BASE
    ApiService(
      name: 'Create Image Asset Base',
      endpoint:
          '/themes/:theme_id/assets', // Fixed from '/themes/:theme_id/assets.json'
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: CreateImageAssetBaseHandler(),
    ),

    ApiService(
      name: 'Create Image Asset From URL',
      endpoint:
          '/themes/:theme_id/assets', // Fixed from '/themes/:theme_id/assets.json'
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: CreateImageAssetSourceUrlHandler(),
    ),

    // 📝 CHANGE LIQUID TEMPLATE
    ApiService(
      name: 'Change Liquid Template',
      endpoint:
          '/themes/:theme_id/assets', // Fixed from '/themes/:theme_id/assets.json'
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: ChangeLiquidTemplateValueHandler(),
    ),

    // 🔄 DUPLICATE ASSET SOURCE KEY
    ApiService(
      name: 'Duplicate Asset Source Key',
      endpoint:
          '/themes/:theme_id/assets', // Fixed from '/themes/:theme_id/assets.json'
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: DuplicateAssetSourceKeyHandler(),
    ),

    // 🗑️ DELETE IMAGE FROM THEME
    ApiService(
      name: 'Delete Image From Theme',
      endpoint:
          '/themes/:theme_id/assets', // Fixed from '/themes/:theme_id/assets.json'
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: DeleteImageFromThemeHandler(),
    ),

    // 📋 GET ALL BLOGS
    ApiService(
      name: 'Get All Blogs',
      endpoint: '/blogs',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: GetAllBlogsHandler(),
    ),

    // 📝 GET SINGLE BLOG
    ApiService(
      name: 'Get Single Blog',
      endpoint: '/blogs/:id',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: GetSingleBlogHandler(),
    ),

    // 🔢 COUNT ALL BLOGS
    ApiService(
      name: 'Count All Blogs',
      endpoint: '/blogs/count',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: CountAllBlogsHandler(),
    ),

    // 📝 CREATE EMPTY BLOG
    ApiService(
      name: 'Create Empty Blog',
      endpoint: '/blogs',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: CreateEmptyBlogHandler(),
    ),

    // 📝 CREATE BLOG WITH METAFIELD
    ApiService(
      name: 'Create Blog With Metafield',
      endpoint: '/blogs',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: CreateEmptyBlogWithMetafieldHandler(),
    ),

    // 🏷️ METAFIELD TO EXISTING BLOG
    ApiService(
      name: 'Metafield To Existing Blog',
      endpoint: '/blogs/:blog_id/metafields',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: MetafieldExistingBlogHandler(),
    ),

    // 📝 UPDATE EXISTING BLOG TITLE
    ApiService(
      name: 'Update Existing Blog Title',
      endpoint: '/blogs/:blog_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: UpdateExistingBlogTitleHandler(),
    ),

    // 📝 Update Blog Title
    ApiService(
      name: 'Update Blog Title',
      endpoint: '/blogs/:blog_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: UpdateBlogTitleHandler(),
    ),

    // 🗑️ REMOVE BLOG
    ApiService(
      name: 'Remove Blog',
      endpoint: '/blogs/:blog_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Blog',
      handler: RemoveBlogHandler(),
    ),

    // 📋 LIST ALL COMMENTS
    ApiService(
      name: 'List All Comments',
      endpoint: '/blogs/:blog_id/articles/:article_id/comments',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: ListAllCommentsHandler(),
    ),

    //📋 GET SINGLE COMMENT
    ApiService(
      name: 'Get Single Comment',
      endpoint: '/blogs/:blog_id/articles/:article_id/comments/:comment_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: GetSingleCommentHandler(),
    ),

    // 🔢 COUNT COMMENTS
    ApiService(
      name: 'Count Comments',
      endpoint: 'comments/count',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: CountCommentsHandler(),
    ),

    // ✏️ UPDATE COMMENT BODY
    ApiService(
      name: 'Update Comment Body',
      endpoint: '/blogs/:blog_id/articles/:article_id/comments/:comment_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: UpdateCommentBodyHandler(),
    ),

    // 💬 CREATE COMMENT WITH TEXTILE MARKUP
    ApiService(
      name: 'Create Comment With Textile Markup',
      endpoint: '/blogs/:blog_id/articles/:article_id/comments',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: CreateCommentTextileMarkupHandler(),
    ),

    // ✅ APPROVE AND PUBLISH COMMENT
    ApiService(
      name: 'Approve And Publish Comment',
      endpoint: '/blogs/:blog_id/articles/:article_id/comments/:comment_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: ApproveAndPublishCommentHandler(),
    ),

    // 🔄 MARK COMMENT NOT SPAM & RESTORE
    ApiService(
      name: 'Mark Comment Not Spam & Restore',
      endpoint: '/blogs/:blog_id/articles/:article_id/comments/:comment_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: MarkCommentNotSpamRestoreHandler(),
    ),

    /// 📦 Remove a comment
    ApiService(
      name: 'Remove Comment',
      endpoint: '/blogs/:blog_id/articles/:article_id/comments/:comment_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: RemoveCommentHandler(),
    ),

    /// 🔄 RESTORE REMOVE COMMENT
    ApiService(
      name: 'Restore Removed Comment',
      endpoint:
          '/blogs/:blog_id/articles/:article_id/comments/:comment_id/restore',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: RestoreRemoveCommentHandler(),
    ),

    /// 🚫 MARK COMMENT AS SPAM
    ApiService(
      name: 'Mark Comment As Spam',
      endpoint:
          '/blogs/:blog_id/articles/:article_id/comments/:comment_id/spam',
      category: ApiCategory.onlineStore,
      subcategory: 'Comment',
      handler: MarkCommentAsSpamHandler(),
    ),

    // 📋 LIST ALL PAGES
    ApiService(
      name: 'List All Pages',
      endpoint: '/pages',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: ListAllPagesHandler(),
    ),

    // 📋 GET SINGLE PAGE
    ApiService(
      name: 'Get Single Page',
      endpoint: '/pages/:page_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: GetSinglePageHandler(),
    ),

    // 🔢 COUNT ALL PAGES
    ApiService(
      name: 'Count All Pages',
      endpoint: '/pages/count',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: CountAllPagesHandler(),
    ),

    // 📝 CREATE PAGE WITH METAFIELD
    ApiService(
      name: 'Create Page With Metafield',
      endpoint: '/pages',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: CreatePageWithMetafieldHandler(),
    ),

    // 📝 CREATE PAGE WITH HTML MARKUP
    ApiService(
      name: 'Create Page With HTML Markup',
      endpoint: '/pages',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: CreatePageHtmlMarkupHandler(),
    ),

    // 📝 CREATE UNPUBLISHED PAGE
    ApiService(
      name: 'Create Unpublished Page',
      endpoint: '/pages',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: CreateUnpublishedPageHandler(),
    ),

    // 📝 UPDATE EXISTING PAGE COMPLETELY
    ApiService(
      name: 'Update Existing Page Completely',
      endpoint: '/pages/:page_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: UpdateExistingPageCompletelyHandler(),
    ),

    // 🏷️ ADD METAFIELD TO PAGE
    ApiService(
      name: 'Add Metafield to Page',
      endpoint: '/pages/:page_id/metafields',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: AddMetafieldToPageHandler(),
    ),

    // 👁️ SHOW HIDDEN PAGE
    ApiService(
      name: 'Show Hidden Page',
      endpoint: '/pages/:page_id/show',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: ShowHiddenPageHandler(),
    ),

    // 📝 UPDATE PAGE BODY HTML
    ApiService(
      name: 'Update Page Body HTML',
      endpoint: '/pages/:page_id/body_html',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: UpdateBodyHtmlOfPageHandler(),
    ),

    // 🙈 HIDE PUBLISHED PAGE
    ApiService(
      name: 'Hide Published Page',
      endpoint: '/pages/:page_id/hide',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: HidePublishedPageHandler(),
    ),

    // 🗑️ DELETE PAGE
    ApiService(
      name: 'Delete Page',
      endpoint: '/pages/:page_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Page',
      handler: DeletePageHandler(),
    ),

    // 📋 LIST ALL REDIRECTS
    ApiService(
      name: 'List All Redirects',
      endpoint: '/redirects',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: ListAllRedirectsHandler(),
    ),

    // 📋 GET SINGLE REDIRECT
    ApiService(
      name: 'Get Single Redirect',
      endpoint: '/redirects/:redirect_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: GetSingleRedirectHandler(),
    ),

    // 🔢 COUNT ALL REDIRECTS
    ApiService(
      name: 'Count All Redirects',
      endpoint: '/redirects/count',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: CountAllRedirectsHandler(),
    ),

    // 🔀 CREATE REDIRECT WITH FULL URL
    ApiService(
      name: 'Create Redirect With Full URL',
      endpoint: '/redirects',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: CreateRedirectFullUrlHandler(),
    ),

    // 🔀 CREATE REDIRECT
    ApiService(
      name: 'Create Redirect',
      endpoint: '/redirects',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: CreateRedirectHandler(),
    ),

    // 🔄 UPDATE REDIRECT PATH/URI
    ApiService(
      name: 'Update Redirect Path/URI',
      endpoint: '/redirects/:redirect_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: UpdateRedirectPathUriHandler(),
    ),

    // 🔄 UPDATE REDIRECT PATH AND TARGET
    ApiService(
      name: 'Update Redirect Path and Target',
      endpoint: '/redirects/:redirect_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: UpdateRedirectPathAndTargetHandler(),
    ),

    // 🗑️ DELETE REDIRECT
    ApiService(
      name: 'Delete Redirect',
      endpoint: '/redirects/:redirect_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Redirect',
      handler: DeleteRedirectHandler(),
    ),

    // 📋 LIST ALL SCRIPT TAGS
    ApiService(
      name: 'List All Script Tags',
      endpoint: '/script_tags',
      category: ApiCategory.onlineStore,
      subcategory: 'Script Tag',
      handler: ListAllScriptTagsHandler(),
    ),

    // 📋 GET SINGLE SCRIPT TAG
    ApiService(
      name: 'Get Single Script Tag',
      endpoint: '/script_tags/:script_tag_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Script Tag',
      handler: GetSingleScriptHandler(),
    ),

    // 🔢 COUNT ALL SCRIPT TAGS
    ApiService(
      name: 'Count All Script Tags',
      endpoint: '/script_tags/count',
      category: ApiCategory.onlineStore,
      subcategory: 'Script Tag',
      handler: CountAllScriptHandler(),
    ),

    // 📝 CREATE SCRIPT TAG
    ApiService(
      name: 'Create Script Tag',
      endpoint: '/script_tags',
      category: ApiCategory.onlineStore,
      subcategory: 'Script Tag',
      handler: CreateScriptTagHandler(),
    ),

    // 🔄 UPDATE SCRIPT TAG URL
    ApiService(
      name: 'Update Script Tag URL',
      endpoint: '/script_tags/:script_tag_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Script Tag',
      handler: UpdateScriptTagUrlHandler(),
    ),

    // 🗑️ DELETE SCRIPT TAG
    ApiService(
      name: 'Delete Script Tag',
      endpoint: '/script_tags/:script_tag_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Script Tag',
      handler: DeleteScriptTagHandler(),
    ),

    // 📋 LIST ALL THEMES
    ApiService(
      name: 'List All Themes',
      endpoint: '/themes',
      category: ApiCategory.onlineStore,
      subcategory: 'Theme',
      handler: ListThemesHandler(),
    ),

    // 📋 GET SINGLE THEME
    ApiService(
      name: 'Get Single Theme',
      endpoint: '/themes/:theme_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Theme',
      handler: GetSingleThemeHandler(),
    ),

    // 🚀 PUBLISH UNPUBLISHED THEME
    ApiService(
      name: 'Publish Unpublished Theme',
      endpoint: '/themes/:theme_id/publish',
      category: ApiCategory.onlineStore,
      subcategory: 'Theme',
      handler: PublishUnpublishedThemeHandler(),
    ),

    // 📝 UPDATE THEME NAME
    ApiService(
      name: 'Update Theme Name',
      endpoint: '/themes/:theme_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Theme',
      handler: UpdateThemeNameHandler(),
    ),

    // 🎨 CREATE THEME
    ApiService(
      name: 'Create Theme',
      endpoint: '/themes',
      category: ApiCategory.onlineStore,
      subcategory: 'Theme',
      handler: CreateThemeHandler(),
    ),

    // 🗑️ DELETE THEME
    ApiService(
      name: 'Delete Theme',
      endpoint: '/themes/:theme_id',
      category: ApiCategory.onlineStore,
      subcategory: 'Theme',
      handler: DeleteThemeHandler(),
    ),

    // 📦 Products - Collect APIs
    // List/Get Operations
    ApiService(
      name: 'List All Collects',
      endpoint: '/collects',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: GetCollectsHandler(),
    ),

    ApiService(
      name: 'List Collects by Collection',
      endpoint: '/collects',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: GetCollectsByCollectionHandler(),
    ),

    ApiService(
      name: 'List Collects by Product',
      endpoint: '/collects',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: GetCollectsByProductHandler(),
    ),

    ApiService(
      name: 'Get Single Collect',
      endpoint: '/collects/:id',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: GetSingleCollectHandler(),
    ),

    // Count Operations
    ApiService(
      name: 'Count All Collects',
      endpoint: '/collects/count',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: GetCollectsCountHandler(),
    ),

    ApiService(
      name: 'Count Collects by Collection',
      endpoint: '/collects/count',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: GetCollectsCountByCollectionHandler(),
    ),

    ApiService(
      name: 'Count Collects by Product',
      endpoint: '/collects/count',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: GetCollectsCountByProductHandler(),
    ),

    // Management Operations
    ApiService(
      name: 'Create Collect',
      endpoint: '/collects',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: CreateCollectHandler(),
    ),

    ApiService(
      name: 'Delete Collect',
      endpoint: '/collects/:id',
      category: ApiCategory.products,
      subcategory: 'Collects',
      handler: DeleteCollectHandler(),
    ),

    // 📦 Products - Product Variant APIs
    // GET Operations
    ApiService(
      name: 'List Product Variants',
      endpoint: '/products/:product_id/variants',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: RetrievesListOfProductVariantsHandler(),
    ),

    ApiService(
      name: 'Get Single Product Variant',
      endpoint: '/variants/:variant_id',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: RetrievesSingleProductVariantHandler(),
    ),

    ApiService(
      name: 'Count Product Variants',
      endpoint: '/products/:product_id/variants/count',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: RetrievesCountOfProductVariantsHandler(),
    ),

    // POST Operations
    ApiService(
      name: 'Create Product Variant',
      endpoint: '/products/:product_id/variants',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: CreateProductVariantHandler(),
    ),

    ApiService(
      name: 'Create Product Variant with Metafield',
      endpoint: '/products/:product_id/variants',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: CreateProductVariantWithMetafieldHandler(),
    ),

    ApiService(
      name: 'Create Product Variant with Image',
      endpoint: '/products/:product_id/variants',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: CreateProductVariantWithImageHandler(),
    ),

    ApiService(
      name: 'Add Metafield to Product Variant',
      endpoint: '/variants/:variant_id',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: AddMetafieldToProductVariantHandler(),
    ),

    ApiService(
      name: 'Add Image to Product Variant',
      endpoint: '/variants/:variant_id',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: AddImageToProductVariantHandler(),
    ),

    // PUT Operations
    ApiService(
      name: 'Update Variant Title and Price',
      endpoint: '/variants/:variant_id',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: UpdateVariantTitleAndPriceHandler(),
    ),

    // DELETE Operations
    ApiService(
      name: 'Delete Product Variant',
      endpoint: '/variants/:variant_id',
      category: ApiCategory.products,
      subcategory: 'Product Variants',
      handler: DeleteProductVariantHandler(),
    ),

    // 💰 Tender Transaction APIs
    ApiService(
      name: 'List Tender Transactions',
      endpoint: '/tender_transactions',
      category: ApiCategory.tendertransaction,
      subcategory: 'Tender Transaction',
      handler: RetrieveListOfTenderTransactionsHandler(),
    ),

    // 📋 LIST ALL CUSTOM COLLECTIONS
    ApiService(
      name: 'List All Custom Collections',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: ListAllCustomCollectionsHandler(),
    ),

    // 📋 SPECIFIC CUSTOM COLLECTION
    ApiService(
      name: 'Get Specific Custom Collection',
      endpoint: '/custom_collections/:id',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: SpecificCustomCollectionsHandler(),
    ),

    // 🔢 COUNT CUSTOM COLLECTIONS
    ApiService(
      name: 'Count Custom Collections',
      endpoint: '/custom_collections/count',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: CountCustomCollectionsHandler(),
    ),

    // 🆕 CREATE CUSTOM COLLECTION
    ApiService(
      name: 'Create Custom Collection',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: CreateCustomCollectionHandler(),
    ),

    // 🆕 CREATE UNPUBLISHED CUSTOM COLLECTION
    ApiService(
      name: 'Create Unpublished Custom Collection',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: CreateUnpublishedCustomCollectionHandler(),
    ),

    // 🆕 CREATE COLLECTION WITH COLLECT
    ApiService(
      name: 'Create Collection With Collect',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: CreateCollectionWithCollectHandler(),
    ),

    // 🖼️ CREATE CUSTOM COLLECTION WITH IMAGE
    ApiService(
      name: 'Create Custom Collection With Image',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: CreateCustomCollectionBaseImageHandler(),
    ),

    // 🏷️ CREATE COLLECTION WITH METAFIELD
    ApiService(
      name: 'Create Collection With Metafield',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: CreateCustomCollectionWithMetafieldHandler(),
    ),

    // 🖼️ CREATE CUSTOM COLLECTION WITH UPLOADED IMAGE
    ApiService(
      name: 'Create Custom Collection With Uploaded Image',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: CreateCustomCollectionUploadedImageHandler(),
    ),

    // 📝 UPDATE CUSTOM COLLECTION DESCRIPTION
    ApiService(
      name: 'Update Custom Collection Description',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: UpdateCustomCollectionDescriptionHandler(),
    ),

    // 🖼️ UPDATE CUSTOM COLLECTION NEW IMAGE
    ApiService(
      name: 'Update Custom Collection New Image',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: UpdateCustomCollectionNewImageHandler(),
    ),

    // 🏷️ UPDATE CUSTOM COLLECTION ALT TEXT
    ApiService(
      name: 'Update Custom Collection Alt Text',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: UpdateCustomCollectionAltTextHandler(),
    ),

    // 📢 PUBLISH HIDDEN CUSTOM COLLECTION
    ApiService(
      name: 'Publish Hidden Custom Collection',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: PublishHiddenCustomCollectionHandler(),
    ),

    // 🫥 HIDE PUBLISHED CUSTOM COLLECTION
    ApiService(
      name: 'Hide Published Custom Collection',
      endpoint: '/custom_collections/:id',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: HidePublishedCustomCollectionHandler(),
    ),

    // ➕ ADD COLLECT TO COLLECTION BY PRODUCT ID
    ApiService(
      name: 'Add Collect to Collection by Product ID',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: AddCollectToCollectionByProductIdHandler(),
    ),

    // 🗑️ UPDATE REMOVE IMAGE FROM CUSTOM COLLECTION
    ApiService(
      name: 'Update Remove Image from Custom Collection',
      endpoint: '/custom_collections',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: UpdateRemoveImageHandler(),
    ),

    // 🏷️ ADD METAFIELD TO CUSTOM COLLECTION
    ApiService(
      name: 'Add Metafield to Custom Collection',
      endpoint: '/custom_collections/:id',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: AddMetafieldToCustomCollectionHandler(),
    ),

    // 🗑️ DELETE CUSTOM COLLECTION
    ApiService(
      name: 'Delete Custom Collection',
      endpoint: '/custom_collections/:id',
      category: ApiCategory.products,
      subcategory: 'Custom Collection',
      handler: DeleteCustomCollectionHandler(),
    ),

    // 📋 LIST ALL PRODUCTS HANDLER 📋
    ApiService(
      name: 'List All Products',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: ListOfProductsHandler(),
    ),

    // 📄 SINGLE PRODUCT HANDLER
    ApiService(
      name: 'Get Single Product',
      endpoint: '/products/:id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: SingleProductHandler(),
    ),

    // 🔢 COUNT PRODUCTS COLLECTION HANDLER
    ApiService(
      name: 'Count Products',
      endpoint: '/products/count',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CountProductsCollectionHandler(),
    ),

    // 🛍️ CREATE PRODUCT WITH MULTI VARIANTS OPTIONS HANDLER
    ApiService(
      name: 'Create Product Multi Variants Options',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CreateProductMultiVariantsOptionsHandler(),
    ),

    // 🔄 CREATE PRODUCT WITH MULTI VARIANTS HANDLER
    ApiService(
      name: 'Create Product Multi Variants',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CreateProductMultiVariantsHandler(),
    ),

    // 🖼️ CREATE PRODUCT WITH BASE IMAGE HANDLER
    ApiService(
      name: 'Create Product Base Image',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CreateProductBaseImageHandler(),
    ),

    // 🏷️ CREATE PRODUCT WITH METAFIELD HANDLER
    ApiService(
      name: 'Create Product With Metafield',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CreateProductWithMetafieldHandler(),
    ),

    // 🔧 CREATE DEFAULT PRODUCT VARIANT HANDLER
    ApiService(
      name: 'Create Default Product Variant',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CreateDefaultProductVariantHandler(),
    ),
    // 📥 CREATE PRODUCT DOWNLOADED IMAGE HANDLER
    ApiService(
      name: 'Create Product Downloaded Image',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CreateProductDownloadedImageHandler(),
    ),
    // 🚫 CREATE UNPUBLISHED PRODUCT HANDLER
    ApiService(
      name: 'Create Unpublished Product',
      endpoint: '/products',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: CreateUnpublishedProductHandler(),
    ),
    // 🏷️ ADD METAFIELD TO PRODUCT HANDLER
    ApiService(
      name: 'Add Metafield to Product',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: AddMetafieldToProductHandler(),
    ),
    // 🖼️ UPDATE PRODUCT ADD IMAGE HANDLER
    ApiService(
      name: 'Update Product Add Image',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductAddImageHandler(),
    ),
    // 🔄 UPDATE PRODUCT REORDER IMAGE HANDLER
    ApiService(
      name: 'Update Product Reorder Image',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductReorderImageHandler(),
    ),

    // 📝 UPDATE PRODUCT TITLE HANDLER
    ApiService(
      name: 'Update Product Title',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductTitleHandler(),
    ),

    // 🗑️ UPDATE PRODUCT CLEAR IMAGES HANDLER
    ApiService(
      name: 'Update Product Clear Images',
      endpoint: '/products/:product_id/clear_images',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductClearImagesHandler(),
    ),

    // 🔍 UPDATE PRODUCT SEO HANDLER
    ApiService(
      name: 'Update Product SEO',
      endpoint: '/products/:product_id/seo',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductSeoHandler(),
    ),

    // 🔄 UPDATE PRODUCT WITH VARIANT HANDLER
    ApiService(
      name: 'Update Product With Variant',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductWithVariantHandler(),
    ),

    // 🔄 UPDATE PRODUCT REORDER VARIANTS HANDLER

    ApiService(
      name: 'Update Product Reorder Variants',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductReorderVariantsHandler(),
    ),

    // 👁️ SHOW HIDDEN PRODUCT HANDLER
    ApiService(
      name: 'Show Hidden Product',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: ShowHiddenProductHandler(),
    ),

    // 🗑️ DELETE PRODUCT HANDLER
    ApiService(
      name: 'Delete Product',
      endpoint: '/products/:id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: DeleteProductHandler(),
    ),

    // 🏷️ UPDATE PRODUCT TAGS HANDLER
    ApiService(
      name: 'Update Product Tags',
      endpoint: '/products/:product_id',
      category: ApiCategory.products,
      subcategory: 'Product',
      handler: UpdateProductTagsHandler(),
    ),

    // 📋 GET SINGLE COLLECTION HANDLER
    ApiService(
      name: 'Get Single Collection',
      endpoint: '/collections/:collection_id',
      category: ApiCategory.products,
      subcategory: 'Collection',
      handler: SingleCollectionHandler(),
    ),

    // 📦 GET PRODUCTS BELONGING TO COLLECTION
    ApiService(
      name: 'Get Products Belonging to Collection',
      endpoint: '/collections/:collection_id/products',
      category: ApiCategory.products,
      subcategory: 'Collection',
      handler: ProductsBelongingToCollectionHandler(),
    ),

    // 🔔 Webhooks APIs
    ApiService(
      name: 'List Webhooks',
      endpoint: '/webhooks',
      category: ApiCategory.webhooks,
      subcategory: 'Webhook',
      handler: RetrieveListOfWebhooksHandler(),
    ),
    ApiService(
      name: 'Get Webhook',
      endpoint: '/webhooks/:id',
      category: ApiCategory.webhooks,
      subcategory: 'Webhook',
      handler: RetrieveAWebhookHandler(),
    ),
    ApiService(
      name: 'Count Webhooks',
      endpoint: '/webhooks/count',
      category: ApiCategory.webhooks,
      subcategory: 'Webhook',
      handler: RetrieveCountOfWebhooksHandler(),
    ),
    ApiService(
      name: 'Create Webhook',
      endpoint: '/webhooks',
      category: ApiCategory.webhooks,
      subcategory: 'Webhook',
      handler: CreateWebhookHandler(),
    ),
    ApiService(
      name: 'Update Webhook',
      endpoint: '/webhooks/:id',
      category: ApiCategory.webhooks,
      subcategory: 'Webhook',
      handler: UpdateWebhookHandler(),
    ),
    ApiService(
      name: 'Delete Webhook',
      endpoint: '/webhooks/:id',
      category: ApiCategory.webhooks,
      subcategory: 'Webhook',
      handler: DeleteWebhookHandler(),
    ),

    // 🔔 GraphQL Webhooks APIs
    ApiService(
      name: 'Get Webhook Subscriptions (GraphQL)',
      endpoint: '',
      category: ApiCategory.graphqlWebhookQueries,
      subcategory: 'Queries',
      handler: GetWebhookSubscriptionsHandler(),
    ),
    ApiService(
      name: 'Get Webhook Subscription (GraphQL)',
      endpoint: '',
      category: ApiCategory.graphqlWebhookQueries,
      subcategory: 'Queries',
      handler: GetWebhookSubscriptionHandler(),
    ),
    ApiService(
      name: 'Get Webhook Subscriptions Count (GraphQL)',
      endpoint: '',
      category: ApiCategory.graphqlWebhookQueries,
      subcategory: 'Queries',
      handler: GetWebhookSubscriptionsCountHandler(),
    ),

    // Webhook Mutation APIs
    ApiService(
      name: 'Create Webhook Subscription (GraphQL)',
      endpoint: '',
      category: ApiCategory.graphqlWebhookMutations,
      subcategory: 'Mutations',
      handler: CreateWebhookSubscriptionGraphQLHandler(),
    ),

    ApiService(
      name: 'Update Webhook Subscription (GraphQL)',
      endpoint: '',
      category: ApiCategory.graphqlWebhookMutations,
      subcategory: 'Mutations',
      handler: UpdateWebhookSubscriptionGraphQLHandler(),
    ),

    ApiService(
      name: 'Delete Webhook Subscription (GraphQL)',
      endpoint: '',
      category: ApiCategory.graphqlWebhookMutations,
      subcategory: 'Mutations',
      handler: DeleteWebhookSubscriptionGraphQLHandler(),
    ),

    ApiService(
      name: 'List Smart Collections',
      endpoint: '/smart_collections',
      category: ApiCategory.products,
      subcategory: 'Smart Collection',
      handler: RetrievesAllSmartCollectionsHandler(),
    ),

    ApiService(
      name: 'Get Single Smart Collection',
      endpoint: '/smart_collections/:id',
      category: ApiCategory.products,
      subcategory: 'Smart Collection',
      handler: RetrievesSingleSmartCollectionHandler(),
    ),

    ApiService(
      name: 'Count Smart Collections',
      endpoint: '/smart_collections/count',
      category: ApiCategory.products,
      subcategory: 'Smart Collection',
      handler: RetrieveCountOfSmartCollectionsHandler(),
    ),

    ApiService(
      name: 'Update Smart Collection',
      endpoint: '/smart_collections/:id',
      category: ApiCategory.products,
      subcategory: 'Smart Collection',
      handler: UpdatesSmartCollectionHandler(),
    ),
    ApiService(
      name: 'Update Product Order in Smart Collection',
      endpoint: '/smart_collections/:id/order',
      category: ApiCategory.products,
      subcategory: 'Smart Collection',
      handler: UpdateProductOrderHandler(),
    ),

    ApiService(
      name: 'Delete Smart Collection',
      endpoint: '/smart_collections/:id',
      category: ApiCategory.products,
      subcategory: 'Smart Collection',
      handler: DeletesSmartCollectionHandler(),
    ),

    ApiService(
      name: 'Create Smart Collection',
      endpoint: '/smart_collections',
      category: ApiCategory.products,
      subcategory: 'Smart Collection',
      handler: CreatesSmartCollectionHandler(),
    ),

    // ⚙️ WooCommerce Settings
    ApiService(
      name: 'List Product Images',
      endpoint: '/products/:product_id/images',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: RetrieveListOfProductImagesHandler(),
    ),
    ApiService(
      name: 'Create Product Image',
      endpoint: '/products/:product_id/images',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: CreateANewProductImageHandler(),
    ),
    ApiService(
      name: 'Get Single Product Image',
      endpoint: '/products/:product_id/images/:image_id',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: GetSingleProductImageHandler(),
    ),

    ApiService(
      name: 'Delete Product Image',
      endpoint: '/products/:product_id/images/:image_id',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: DeleteProductImageHandler(),
    ),

    ApiService(
      name: 'Count Product Images',
      endpoint: '/products/:product_id/images/count.json',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: ReceiveCountOfProductImagesHandler(),
    ),

    ApiService(
      name: 'Modify Product Image',
      endpoint: '/products/:product_id/images/:image_id',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: ModifyAnExistingProductImageHandler(),
    ),

    ApiService(
      name: 'Create Product Image With Attachment',
      endpoint: '/products/:product_id/images/attachment',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: CreateProductImageAttachmentHandler(),
    ),

    ApiService(
      name: 'Create Product Image Main',
      endpoint: '/products/:product_id/images/main',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: CreateProductImageMainHandler(),
    ),

    ApiService(
      name: 'Create Product Image With Variant',
      endpoint: '/products/:product_id/images/variant',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: CreateProductImageVariantHandler(),
    ),

    ApiService(
      name: 'Create Product Image From Source URL',
      endpoint: '/products/:product_id/images/source_url',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: CreateProductImageSourceUrlHandler(),
    ),

    ApiService(
      name: 'Modify Product Image Alt & Position',
      endpoint: '/products/:product_id/images/:image_id',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: ModifyProductImagePositionAltHandler(),
    ),

    ApiService(
      name: 'Modify Product Image - Attach Variants',
      endpoint: '/products/:product_id/images/:image_id/attach_variants',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: ModifyProductImageAttachVariantsHandler(),
    ),

    ApiService(
      name: 'Create Product Image Metafield',
      endpoint: '/products/:product_id/images/metafields',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: CreateProductImageMetafieldHandler(),
    ),

    ApiService(
      name: 'Modify Product Image - Add Metafield',
      endpoint: '/products/:product_id/images/:image_id/metafields',
      category: ApiCategory.products,
      subcategory: 'Product Images',
      handler: ModifyProductImageAddMetafieldHandler(),
    ),
    ApiService(
      name: 'List All Coupons',
      endpoint: '/coupons',
      category: ApiCategory.discounts,
      subcategory: 'Coupons',
      handler: ListAllCouponsHandler(),
    ),

    // 🛒 WooCommerce Services
    ApiService(
      name: 'List All Coupons',
      endpoint: '/wp-json/wc/v3/coupons',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'Coupons',
      handler: ListAllCouponsHandler(),
    ),
    ApiService(
      name: 'Retrieve Coupon',
      endpoint: '/wp-json/wc/v3/coupons/{coupon_id}',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'Coupons',
      handler: RetrieveCouponHandler(),
    ),
    ApiService(
      name: 'Create Coupon',
      endpoint: '/wp-json/wc/v3/coupons',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'Coupons',
      handler: CreateCouponHandler(),
    ),
    ApiService(
      name: 'Update Coupon',
      endpoint: '/wp-json/wc/v3/coupons/{coupon_id}',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'Coupons',
      handler: UpdateCouponHandler(),
    ),
    ApiService(
      name: 'Delete Coupon',
      endpoint: '/wp-json/wc/v3/coupons/{coupon_id}',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'Coupons',
      handler: DeleteCouponHandler(),
    ),
    ApiService(
      name: 'WooCommerce Batch Update Coupons',
      endpoint: '/wp-json/wc/v3/coupons/batch',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'WooCommerce Coupons',
      handler: BatchUpdateCouponsHandler(),
    ),

    // 🛍️ WooCommerce Products Services
    ApiService(
      name: 'List All Products',
      endpoint: '/wp-json/wc/v3/products',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Products',
      handler: ListAllProductsHandler(),
    ),
    ApiService(
      name: 'Retrieve Product',
      endpoint: '/wp-json/wc/v3/products/{product_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Products',
      handler: RetrieveProductHandler(),
    ),
    ApiService(
      name: 'Create Product',
      endpoint: '/wp-json/wc/v3/products',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Products',
      handler: CreateProductHandler(),
    ),
    ApiService(
      name: 'Update Product',
      endpoint: '/wp-json/wc/v3/products/{product_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Products',
      handler: UpdateProductHandler(),
    ),
    ApiService(
      name: 'Delete Product',
      endpoint: '/wp-json/wc/v3/products/{product_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Products',
      handler: WooDeleteProductHandler(),
    ),
    ApiService(
      name: 'Retrieve Product Custom Field Names',
      endpoint: '/wp-json/wc/v3/products/{product_id}/custom_fields/names',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Products',
      handler: RetrieveProductCustomFieldNamesHandler(),
    ),

    ApiService(
      name: 'Batch Update Products',
      endpoint: '/wp-json/wc/v3/products/batch',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Products',
      handler: BatchUpdateProductsHandler(),
    ),

    ApiService(
      name: 'List All Product Categories',
      endpoint: '/wp-json/wc/v3/products/categories',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Categories',
      handler: ListAllProductCategoriesHandler(),
    ),

    ApiService(
      name: 'Create Product Category',
      endpoint: '/wp-json/wc/v3/products/categories',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Categories',
      handler: CreateProductCategoryHandler(),
    ),

    ApiService(
      name: 'Retrieve Product Category',
      endpoint: '/wp-json/wc/v3/products/categories/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Categories',
      handler: RetrieveProductCategoryHandler(),
    ),

    ApiService(
      name: 'Update Product Category',
      endpoint: '/wp-json/wc/v3/products/categories/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Categories',
      handler: UpdateProductCategoryHandler(),
    ),

    ApiService(
      name: 'Delete Product Category',
      endpoint: '/wp-json/wc/v3/products/categories/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Categories',
      handler: DeleteProductCategoryHandler(),
    ),
    ApiService(
      name: 'Batch Update Product Categories',
      endpoint: '/wp-json/wc/v3/products/categories/batch',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Categories',
      handler: BatchUpdateProductCategoriesHandler(),
    ),

    ApiService(
      name: 'List All Product Reviews',
      endpoint: '/wp-json/wc/v3/products/reviews',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Reviews',
      handler: ListAllProductReviewsHandler(),
    ),

    ApiService(
      name: 'Create Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Reviews',
      handler: CreateProductReviewHandler(),
    ),

    ApiService(
      name: 'Retrieve Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Reviews',
      handler: RetrieveProductReviewHandler(),
    ),

    ApiService(
      name: 'Update Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Reviews',
      handler: UpdateProductReviewHandler(),
    ),

    ApiService(
      name: 'Delete Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Reviews',
      handler: DeleteProductReviewHandler(),
    ),
    ApiService(
      name: 'Batch Update Product Reviews',
      endpoint: '/wp-json/wc/v3/products/reviews/batch',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Reviews',
      handler: BatchUpdateProductReviewsHandler(),
    ),

    ApiService(
      name: 'List All Product Shipping Classes',
      endpoint: '/wp-json/wc/v3/products/shipping_classes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Shipping Classes',
      handler: ListAllProductShippingClassesHandler(),
    ),

    ApiService(
      name: 'Create Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Shipping Classes',
      handler: CreateProductShippingClassHandler(),
    ),

    ApiService(
      name: 'Retrieve Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Shipping Classes',
      handler: RetrieveProductShippingClassHandler(),
    ),

    ApiService(
      name: 'Update Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Shipping Classes',
      handler: UpdateProductShippingClassHandler(),
    ),

    ApiService(
      name: 'Delete Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Shipping Classes',
      handler: DeleteProductShippingClassHandler(),
    ),

    ApiService(
      name: 'Batch Update Product Shipping Classes',
      endpoint: '/wp-json/wc/v3/products/shipping_classes/batch',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Shipping Classes',
      handler: BatchUpdateProductShippingClassesHandler(),
    ),

    ApiService(
      name: 'List All Product Tags',
      endpoint: '/wp-json/wc/v3/products/tags',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Tags',
      handler: ListAllProductTagsHandler(),
    ),

    ApiService(
      name: 'Create Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Tags',
      handler: CreateProductTagHandler(),
    ),

    ApiService(
      name: 'Retrieve Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Tags',
      handler: RetrieveProductTagHandler(),
    ),

    ApiService(
      name: 'Update Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Tags',
      handler: UpdateProductTagHandler(),
    ),

    ApiService(
      name: 'Delete Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Tags',
      handler: DeleteProductTagHandler(),
    ),

    ApiService(
      name: 'Batch Update Product Tags',
      endpoint: '/wp-json/wc/v3/products/tags/batch',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Tags',
      handler: BatchUpdateProductTagsHandler(),
    ),

    ApiService(
      name: 'List All Product Variations',
      endpoint: '/wp-json/wc/v3/products/{product_id}/variations',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Variations',
      handler: ListAllProductVariationsHandler(),
    ),

    ApiService(
      name: 'Create Product Variation',
      endpoint: '/wp-json/wc/v3/products/{product_id}/variations',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Variations',
      handler: CreateProductVariationHandler(),
    ),

    ApiService(
      name: 'Retrieve Product Variation',
      endpoint:
          '/wp-json/wc/v3/products/{product_id}/variations/{variation_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Variations',
      handler: RetrieveProductVariationHandler(),
    ),

    ApiService(
      name: 'Update Product Variation',
      endpoint:
          '/wp-json/wc/v3/products/{product_id}/variations/{variation_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Variations',
      handler: UpdateProductVariationHandler(),
    ),

    ApiService(
      name: 'Delete Product Variation',
      endpoint:
          '/wp-json/wc/v3/products/{product_id}/variations/{variation_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Variations',
      handler: DeleteProductVariationHandler(),
    ),

    // 🏷️ WooCommerce Product Attributes Services
    ApiService(
      name: 'List All Product Attributes',
      endpoint: '/wp-json/wc/v3/products/attributes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attributes',
      handler: ListAllProductAttributesHandler(),
    ),

    ApiService(
      name: 'Create Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attributes',
      handler: CreateProductAttributeHandler(),
    ),

    ApiService(
      name: 'Retrieve Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attributes',
      handler: RetrieveProductAttributeHandler(),
    ),

    ApiService(
      name: 'Update Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attributes',
      handler: UpdateProductAttributeHandler(),
    ),

    ApiService(
      name: 'Delete Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attributes',
      handler: DeleteProductAttributeHandler(),
    ),
    ApiService(
      name: 'Batch Update Product Attributes',
      endpoint: '/wp-json/wc/v3/products/attributes/batch',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attributes',
      handler: BatchUpdateProductAttributesHandler(),
    ),

    // 🏷️ WooCommerce Product Attribute Terms Services
    ApiService(
      name: 'List All Product Attribute Terms',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}/terms',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attribute Terms',
      handler: ListAllProductAttributeTermsHandler(),
    ),

    ApiService(
      name: 'Create Product Attribute Term',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}/terms',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attribute Terms',
      handler: CreateProductAttributeTermHandler(),
    ),

    ApiService(
      name: 'Retrieve Product Attribute Term',
      endpoint:
          '/wp-json/wc/v3/products/attributes/{attribute_id}/terms/{term_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attribute Terms',
      handler: RetrieveProductAttributeTermHandler(),
    ),

    ApiService(
      name: 'Update Product Attribute Term',
      endpoint:
          '/wp-json/wc/v3/products/attributes/{attribute_id}/terms/{term_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attribute Terms',
      handler: UpdateProductAttributeTermHandler(),
    ),

    ApiService(
      name: 'Delete Product Attribute Term',
      endpoint:
          '/wp-json/wc/v3/products/attributes/{attribute_id}/terms/{term_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'Product Attribute Terms',
      handler: DeleteProductAttributeTermHandler(),
    ),

    // 🔗 WooCommerce Webhooks Services
    ApiService(
      name: 'List All Webhooks',
      endpoint: '/wp-json/wc/v3/webhooks',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'Webhooks',
      handler: ListAllWebhooksHandler(),
    ),

    ApiService(
      name: 'Create Webhook',
      endpoint: '/wp-json/wc/v3/webhooks',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'Webhooks',
      handler: WooCreateWebhookHandler(),
    ),

    ApiService(
      name: 'Retrieve Webhook',
      endpoint: '/wp-json/wc/v3/webhooks/{webhook_id}',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'Webhooks',
      handler: RetrieveWebhookHandler(),
    ),

    ApiService(
      name: 'Update Webhook',
      endpoint: '/wp-json/wc/v3/webhooks/{webhook_id}',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'Webhooks',
      handler: WooUpdateWebhookHandler(),
    ),

    ApiService(
      name: 'Delete Webhook',
      endpoint: '/wp-json/wc/v3/webhooks/{webhook_id}',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'Webhooks',
      handler: WooDeleteWebhookHandler(),
    ),
    ApiService(
      name: 'Batch Update Webhooks',
      endpoint: '/wp-json/wc/v3/webhooks/batch',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'Webhooks',
      handler: BatchUpdateWebhooksHandler(),
    ),

    // 🔧 WooCommerce System Status Services
    ApiService(
      name: 'Get System Status',
      endpoint: '/wp-json/wc/v3/system_status',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'System Status',
      handler: GetSystemStatusHandler(),
    ),

    ApiService(
      name: 'List All Tools From System Status',
      endpoint: '/wp-json/wc/v3/system_status/tools',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'System Status',
      handler: ListAllToolsFromSystemStatusHandler(),
    ),

    ApiService(
      name: 'Retrieve Tool From System Status',
      endpoint: '/wp-json/wc/v3/system_status/tools/{tool_id}',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'System Status',
      handler: RetrieveToolFromSystemStatusHandler(),
    ),

    ApiService(
      name: 'Run Tool From System Status',
      endpoint: '/wp-json/wc/v3/system_status/tools/{tool_id}',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'System Status',
      handler: RunToolFromSystemStatusHandler(),
    ),

    // 👥 WooCommerce Customers Services
    ApiService(
      name: 'List All Customers',
      endpoint: '/wp-json/wc/v3/customers',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'Customers',
      handler: ListAllCustomersHandler(),
    ),
    ApiService(
      name: 'Retrieve Customer',
      endpoint: '/wp-json/wc/v3/customers/{customer_id}',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'Customers',
      handler: RetrieveCustomerHandler(),
    ),
    ApiService(
      name: 'Create Customer',
      endpoint: '/wp-json/wc/v3/customers',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'Customers',
      handler: CreateCustomerHandler(),
    ),
    ApiService(
      name: 'Update Customer',
      endpoint: '/wp-json/wc/v3/customers/{customer_id}',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'Customers',
      handler: UpdateCustomerHandler(),
    ),
    ApiService(
      name: 'Delete Customer',
      endpoint: '/wp-json/wc/v3/customers/{customer_id}',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'Customers',
      handler: DeleteCustomerHandler(),
    ),
    ApiService(
      name: 'WooCommerce Batch Update Customers',
      endpoint: '/wp-json/wc/v3/customers/batch',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'WooCommerce Customers',
      handler: BatchUpdateCustomersHandler(),
    ),
    ApiService(
      name: 'WooCommerce Batch Update Customer ID',
      endpoint: '/wp-json/wc/v3/customers/batch',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'WooCommerce Customers',
      handler: BatchUpdateCustomerIdHandler(),
    ),

    // 🛒 WooCommerce Orders
    ApiService(
      name: 'List All Orders',
      endpoint: '/wp-json/wc/v3/orders',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Orders',
      handler: ListAllOrdersHandler(),
    ),
    ApiService(
      name: 'Create Order',
      endpoint: '/wp-json/wc/v3/orders',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Orders',
      handler: CreateOrderHandler(),
    ),
    ApiService(
      name: 'Retrieve Order',
      endpoint: '/wp-json/wc/v3/orders/{order_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Orders',
      handler: RetrieveOrderHandler(),
    ),
    ApiService(
      name: 'Update Order',
      endpoint: '/wp-json/wc/v3/orders/{order_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Orders',
      handler: UpdateOrderHandler(),
    ),
    ApiService(
      name: 'Delete Order',
      endpoint: '/wp-json/wc/v3/orders/{order_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Orders',
      handler: DeleteOrderHandler(),
    ),
    ApiService(
      name: 'Send Order Details',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/actions/send_order_details',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Orders',
      handler: SendOrderDetailsHandler(),
    ),
    ApiService(
      name: 'WooCommerce Batch Update Orders',
      endpoint: '/wp-json/wc/v3/orders/batch',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Orders',
      handler: BatchUpdateOrdersHandler(),
    ),

    // 📝 WooCommerce Order Notes
    ApiService(
      name: 'List All Order Notes',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Order Notes',
      handler: ListAllOrderNotesHandler(),
    ),
    ApiService(
      name: 'Create Order Note',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Order Notes',
      handler: CreateOrderNoteHandler(),
    ),
    ApiService(
      name: 'Retrieve Order Note',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes/{note_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Order Notes',
      handler: RetrieveOrderNoteHandler(),
    ),
    ApiService(
      name: 'Delete Order Note',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes/{note_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'Order Notes',
      handler: DeleteOrderNoteHandler(),
    ),

    // 🚚 WooCommerce Shipping Methods
    ApiService(
      name: 'List All Shipping Methods',
      endpoint: '/wp-json/wc/v3/shipping_methods',
      category: ApiCategory.woocommerceShippingMethods,
      subcategory: 'Shipping Methods',
      handler: ListAllShippingMethodsHandler(),
    ),
    ApiService(
      name: 'Retrieve Shipping Method',
      endpoint: '/wp-json/wc/v3/shipping_methods/{id}',
      category: ApiCategory.woocommerceShippingMethods,
      subcategory: 'Shipping Methods',
      handler: RetrieveShippingMethodHandler(),
    ),

    // 💳 WooCommerce Payment Gateways
    ApiService(
      name: 'List All Payment Gateways',
      endpoint: '/wp-json/wc/v3/payment_gateways',
      category: ApiCategory.woocommercePaymentGateways,
      subcategory: 'Payment Gateways',
      handler: ListAllPaymentGatewaysHandler(),
    ),
    ApiService(
      name: 'Retrieve Payment Gateway',
      endpoint: '/wp-json/wc/v3/payment_gateways/{id}',
      category: ApiCategory.woocommercePaymentGateways,
      subcategory: 'Payment Gateways',
      handler: RetrievePaymentGatewayHandler(),
    ),
    ApiService(
      name: 'Update Payment Gateway',
      endpoint: '/wp-json/wc/v3/payment_gateways/{id}',
      category: ApiCategory.woocommercePaymentGateways,
      subcategory: 'Payment Gateways',
      handler: UpdatePaymentGatewayHandler(),
    ),

// 📊 WooCommerce Reports
    ApiService(
      name: 'List All Reports',
      endpoint: '/wp-json/wc/v3/reports',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: ListAllReportsHandler(),
    ),
    ApiService(
      name: 'Retrieve Coupon Totals',
      endpoint: '/wp-json/wc/v3/reports/coupons/totals',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: RetrieveCouponTotalsHandler(),
    ),
    ApiService(
      name: 'Retrieve Customer Totals',
      endpoint: '/wp-json/wc/v3/reports/customers/totals',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: RetrieveCustomerTotalsHandler(),
    ),
    ApiService(
      name: 'Retrieve Order Totals',
      endpoint: '/wp-json/wc/v3/reports/orders/totals',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: RetrieveOrderTotalsHandler(),
    ),
    ApiService(
      name: 'Retrieve Product Totals',
      endpoint: '/wp-json/wc/v3/reports/products/totals',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: RetrieveProductTotalsHandler(),
    ),
    ApiService(
      name: 'Retrieve Sales Report',
      endpoint: '/wp-json/wc/v3/reports/sales',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: RetrieveSalesReportHandler(),
    ),
    ApiService(
      name: 'Retrieve Review Totals',
      endpoint: '/wp-json/wc/v3/reports/reviews/totals',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: RetrieveReviewTotalsHandler(),
    ),
    ApiService(
      name: 'Retrieve Top Sellers Report',
      endpoint: '/wp-json/wc/v3/reports/products/totals',
      category: ApiCategory.woocommerceReports,
      subcategory: 'Reports',
      handler: RetrieveTopSellerReportHandler(),
    ),
    // 🚚 WooCommerce Shipping Methods
    ApiService(
      name: 'List All Shipping Methods',
      endpoint: '/wp-json/wc/v3/shipping_methods',
      category: ApiCategory.woocommerceShippingMethods,
      subcategory: 'Shipping Methods',
      handler: ListAllShippingMethodsHandler(),
    ),
    ApiService(
      name: 'Retrieve Shipping Method',
      endpoint: '/wp-json/wc/v3/shipping_methods/{id}',
      category: ApiCategory.woocommerceShippingMethods,
      subcategory: 'Shipping Methods',
      handler: RetrieveShippingMethodHandler(),
    ),

    // 💳 WooCommerce Payment Gateways
    ApiService(
      name: 'List All Payment Gateways',
      endpoint: '/wp-json/wc/v3/payment_gateways',
      category: ApiCategory.woocommercePaymentGateways,
      subcategory: 'Payment Gateways',
      handler: ListAllPaymentGatewaysHandler(),
    ),
    ApiService(
      name: 'Retrieve Payment Gateway',
      endpoint: '/wp-json/wc/v3/payment_gateways/{id}',
      category: ApiCategory.woocommercePaymentGateways,
      subcategory: 'Payment Gateways',
      handler: RetrievePaymentGatewayHandler(),
    ),
    ApiService(
      name: 'Update Payment Gateway',
      endpoint: '/wp-json/wc/v3/payment_gateways/{id}',
      category: ApiCategory.woocommercePaymentGateways,
      subcategory: 'Payment Gateways',
      handler: UpdatePaymentGatewayHandler(),
    ),

    // ⚙️ WooCommerce Settings Handlers
    ApiService(
      name: 'List All Settings Groups',
      endpoint: '/wp-json/wc/v3/settings',
      category: ApiCategory.woocommerceSetting,
      subcategory: 'Settings',
      handler: ListSettingsGroupsHandler(),
    ),
    ApiService(
      name: 'Retrieve Setting Option',
      endpoint: '/wp-json/wc/v3/settings/{group_id}/{option_id}',
      category: ApiCategory.woocommerceSetting,
      subcategory: 'Settings',
      handler: RetrieveSettingOptionHandler(),
    ),
    ApiService(
      name: 'Update Setting Option',
      endpoint: '/wp-json/wc/v3/settings/{group_id}/{option_id}',
      category: ApiCategory.woocommerceSetting,
      subcategory: 'Settings',
      handler: UpdateSettingsOptionHandler(),
    ),

    ApiService(
      name: 'List All Tax Classes',
      endpoint: '/wp-json/wc/v3/taxes/classes',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Classes',
      handler: ListTaxClassesHandler(),
    ),

    ApiService(
      name: 'Create Tax Class',
      endpoint: '/wp-json/wc/v3/taxes/classes',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Classes',
      handler: CreateTaxClassHandler(),
    ),
    ApiService(
      name: 'Delete Tax Class',
      endpoint: '/wp-json/wc/v3/taxes/classes/{slug}',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Classes',
      handler: DeleteTaxClassHandler(),
    ),

    ApiService(
      name: 'Retrieve Tax Rate',
      endpoint: '/wp-json/wc/v3/taxes/{tax_rate_id}',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Rates',
      handler: RetrieveTaxRateHandler(),
    ),

    ApiService(
      name: 'Delete Tax Rate',
      endpoint: '/wp-json/wc/v3/taxes/{tax_rate_id}',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Rates',
      handler: DeleteTaxRateHandler(),
    ),

    ApiService(
      name: 'Create Tax Rate',
      endpoint: '/wp-json/wc/v3/taxes',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Rates',
      handler: CreateTaxRateHandler(),
    ),

    ApiService(
      name: 'Update Tax Rate',
      endpoint: '/wp-json/wc/v3/taxes/{tax_rate_id}',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Rates',
      handler: UpdateTaxRateHandler(),
    ),

    ApiService(
      name: 'List All Tax Rates',
      endpoint: '/wp-json/wc/v3/taxes',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Rates',
      handler: ListTaxRatesHandler(),
    ),
    ApiService(
      name: 'Batch Update Tax Rates',
      endpoint: '/wp-json/wc/v3/taxes/batch',
      category: ApiCategory.woocommerceTaxes,
      subcategory: 'Tax Rates',
      handler: BatchUpdateTaxesRatesHandler(),
    ),

    // 🚚 WooCommerce Shipping Zones
    ApiService(
      name: 'List All Shipping Zones',
      endpoint: '/wp-json/wc/v3/shipping/zones',
      category: ApiCategory.woocommerceShippingZones,
      subcategory: 'Shipping Zones',
      handler: ListAllShippingZonesHandler(),
    ),
    ApiService(
      name: 'Create Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones',
      category: ApiCategory.woocommerceShippingZones,
      subcategory: 'Shipping Zones',
      handler: CreateShippingZoneHandler(),
    ),
    ApiService(
      name: 'Retrieve Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}',
      category: ApiCategory.woocommerceShippingZones,
      subcategory: 'Shipping Zones',
      handler: RetrieveShippingZoneHandler(),
    ),
    ApiService(
      name: 'Update Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}',
      category: ApiCategory.woocommerceShippingZones,
      subcategory: 'Shipping Zones',
      handler: UpdateShippingZoneHandler(),
    ),
    ApiService(
      name: 'Delete Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}',
      category: ApiCategory.woocommerceShippingZones,
      subcategory: 'Shipping Zones',
      handler: DeleteShippingZoneHandler(),
    ),
    ApiService(
      name: 'Retrieve Shipping Zone Location',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}/locations',
      category: ApiCategory.woocommerceShippingZones,
      subcategory: 'Shipping Zones',
      handler: RetrieveShippingZoneLocationHandler(),
    ),

    // 🚚 WooCommerce Shipping Zone Methods
    ApiService(
      name: 'List All Shipping Methods from Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}/methods',
      category: ApiCategory.woocommerceShippingZoneMethods,
      subcategory: 'Shipping Zone Methods',
      handler: ListAllShippingMethodsFromShippingZoneHandler(),
    ),
    ApiService(
      name: 'Include Shipping Method to Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}/methods',
      category: ApiCategory.woocommerceShippingZoneMethods,
      subcategory: 'Shipping Zone Methods',
      handler: IncludeShippingMethodToShippingZoneHandler(),
    ),
    ApiService(
      name: 'Retrieve Shipping Method from Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}/methods/{methodId}',
      category: ApiCategory.woocommerceShippingZoneMethods,
      subcategory: 'Shipping Zone Methods',
      handler: RetrieveShippingMethodFromShippingZoneHandler(),
    ),
    ApiService(
      name: 'Update Shipping Method from Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}/methods/{methodId}',
      category: ApiCategory.woocommerceShippingZoneMethods,
      subcategory: 'Shipping Zone Methods',
      handler: UpdateShippingMethodFromShippingZoneHandler(),
    ),
    ApiService(
      name: 'Delete Shipping Method from Shipping Zone',
      endpoint: '/wp-json/wc/v3/shipping/zones/{zoneId}/methods/{methodId}',
      category: ApiCategory.woocommerceShippingZoneMethods,
      subcategory: 'Shipping Zone Methods',
      handler: DeleteShippingMethodFromShippingZoneHandler(),
    ),

    // 💳 WooCommerce Payment Gateways

    // 📊 WooCommerce Data
    ApiService(
      name: 'List All Data',
      endpoint: '/wp-json/wc/v3/data',
      category: ApiCategory.woocommerceData,
      subcategory: 'Data',
      handler: ListAllDataHandler(),
    ),

    // 🌍 WooCommerce Continents
    ApiService(
      name: 'List All Continents',
      endpoint: '/wp-json/wc/v3/data/continents',
      category: ApiCategory.woocommerceContinents,
      subcategory: 'Continents',
      handler: ListAllContinentsHandler(),
    ),
    ApiService(
      name: 'Retrieve Continent Data',
      endpoint: '/wp-json/wc/v3/data/continents/{code}',
      category: ApiCategory.woocommerceContinents,
      subcategory: 'Continents',
      handler: RetrieveContinentDataHandler(),
    ),

    // 🏳️ WooCommerce Countries
    ApiService(
      name: 'List All Countries',
      endpoint: '/wp-json/wc/v3/data/countries',
      category: ApiCategory.woocommerceCountries,
      subcategory: 'Countries',
      handler: ListAllCountriesHandler(),
    ),
    ApiService(
      name: 'Retrieve Country Data',
      endpoint: '/wp-json/wc/v3/data/countries/{code}',
      category: ApiCategory.woocommerceCountries,
      subcategory: 'Countries',
      handler: RetrieveCountryDataHandler(),
    ),

    // 💰 WooCommerce Currencies
    ApiService(
      name: 'List All Currencies',
      endpoint: '/wp-json/wc/v3/data/currencies',
      category: ApiCategory.woocommerceCurrencies,
      subcategory: 'Currencies',
      handler: ListAllCurrenciesHandler(),
    ),
    ApiService(
      name: 'Retrieve Currency Data',
      endpoint: '/wp-json/wc/v3/data/currencies/{currency}',
      category: ApiCategory.woocommerceCurrencies,
      subcategory: 'Currencies',
      handler: RetrieveCurrencyDataHandler(),
    ),
    ApiService(
      name: 'Retrieve Current Currency',
      endpoint: '/wp-json/wc/v3/data/currencies/current',
      category: ApiCategory.woocommerceCurrencies,
      subcategory: 'Currencies',
      handler: RetrieveCurrentCurrencyHandler(),
    ),

    // 💸 WooCommerce Refunds
    ApiService(
      name: 'List All Refunds',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/refunds',
      category: ApiCategory.woocommerceRefunds,
      subcategory: 'Refunds',
      handler: ListAllRefundsHandler(),
    ),

    // 🚀 GraphQL APIs - Product Operations
    ApiService(
      name: 'Products - GraphQL Query',
      endpoint: '',
      category: ApiCategory.graphqlProductsAndCollectionsQueries,
      subcategory: 'Products',
      handler: GetProductsGraphQLHandler(),
    ),
    ApiService(
      name: 'Product - GraphQL Query',
      endpoint: '',
      category: ApiCategory.graphqlProductsAndCollectionsQueries,
      subcategory: 'Products',
      handler: ProductGraphQLHandler(),
    ),
    ApiService(
      name: 'Create Product - GraphQL Mutation',
      endpoint: '',
      category: ApiCategory.graphqlProductsAndCollectionsMutations,
      subcategory: 'Products',
      handler: CreateProductGraphQLHandler(),
    ),

    ApiService(
      name: 'Get Customers - GraphQL Query',
      endpoint: '',
      category: ApiCategory.graphqlCustomersQueries,
      subcategory: 'Customers',
      handler: GetCustomersHandler(),
    ),
    ApiService(
      name: 'Get Customer - GraphQL Query',
      endpoint: '',
      category: ApiCategory.graphqlCustomersQueries,
      subcategory: 'Customers',
      handler: GetCustomerHandler(),
    ),
    ApiService(
      name: 'Get Customers Count - GraphQL Query',
      endpoint: '',
      category: ApiCategory.graphqlCustomersQueries,
      subcategory: 'Customers',
      handler: GetCustomersCountHandler(),
    ),
    ApiService(
      name: 'Create Customer - GraphQL Mutation',
      endpoint: '',
      category: ApiCategory.graphqlCustomersMutations,
      subcategory: 'Customers',
      handler: CreateCustomerGraphQLHandler(),
    ),
    ApiService(
      name: 'Update Customer - GraphQL Mutation',
      endpoint: '/customers/update',
      category: ApiCategory.graphqlCustomersMutations,
      subcategory: 'Customers',
      handler: UpdateCustomerGraphQLHandler(),
    ),
    ApiService(
      name: 'Disable Customer - GraphQL Mutation',
      endpoint: '/customers/disable',
      category: ApiCategory.graphqlCustomersMutations,
      subcategory: 'Customers',
      handler: DisableCustomerGraphQLHandler(),
    ),

    // 🔐 WooCommerce Authentication Services
    ApiService(
      name: 'User Login',
      endpoint: '/wp-json/{brand_name}-auth-login/v1/auth',
      category: ApiCategory.woocommerce,
      subcategory: 'Authentication',
      handler: UserLoginHandler(),
    ),
    ApiService(
      name: 'User Sign Up',
      endpoint: '/wp-json/{brand_name}-auth-login/v1/users',
      category: ApiCategory.woocommerce,
      subcategory: 'Authentication',
      handler: UserSignUpHandler(),
    ),
    ApiService(
      name: 'User Logout',
      endpoint: '/wp-json/{brand_name}-auth-login/v1/logout',
      category: ApiCategory.woocommerce,
      subcategory: 'Authentication',
      handler: UserLogoutHandler(),
    ),

    ApiService(
      name: 'Password Update',
      endpoint: '/wp-json/{brand_name}-auth-login/v1/user/reset_password',
      category: ApiCategory.woocommerce,
      subcategory: 'Authentication',
      handler: PasswordUpdateHandler(),
    ),
    ApiService(
      name: 'Auth Status',
      endpoint: '/wp-json/{brand_name}-auth-login/v1/status',
      category: ApiCategory.woocommerce,
      subcategory: 'Authentication',
      handler: AuthStatusHandler(),
    ),
    ApiService(
      name: 'JWT Auth Test',
      endpoint: '/wp-json/jwt-auth/v1/token',
      category: ApiCategory.woocommerce,
      subcategory: 'Authentication',
      handler: JwtAuthTestHandler(),
    ),
    ApiService(
      name: 'Delete User',
      endpoint: '/wp-json/{brand_name}-auth-login/v1/users',
      category: ApiCategory.woocommerce,
      subcategory: 'Authentication',
      handler: DeleteUserHandler(),
    ),

    // 💖 WooCommerce Wishlist APIs
    ApiService(
      name: 'Create Wishlist Group',
      endpoint: '/wp-json/custom-wishlist/v1/groups',
      category: ApiCategory.woocommerceWishlist,
      subcategory: 'Wishlist Groups',
      handler: CreateWishlistGroupHandler(),
    ),
    ApiService(
      name: 'Get All Wishlist Groups',
      endpoint: '/wp-json/custom-wishlist/v1/groups',
      category: ApiCategory.woocommerceWishlist,
      subcategory: 'Wishlist Groups',
      handler: GetAllWishlistGroupsHandler(),
    ),
    ApiService(
      name: 'Update Wishlist Group',
      endpoint: '/wp-json/custom-wishlist/v1/groups/:id',
      category: ApiCategory.woocommerceWishlist,
      subcategory: 'Wishlist Groups',
      handler: UpdateWishlistGroupHandler(),
    ),
    ApiService(
      name: 'Delete Wishlist Group',
      endpoint: '/wp-json/custom-wishlist/v1/groups/:id',
      category: ApiCategory.woocommerceWishlist,
      subcategory: 'Wishlist Groups',
      handler: DeleteWishlistGroupHandler(),
    ),
    ApiService(
      name: 'Get Wishlist Items',
      endpoint: '/wp-json/custom-wishlist/v1/items',
      category: ApiCategory.woocommerceWishlist,
      subcategory: 'Wishlist Items',
      handler: GetWishlistItemsHandler(),
    ),
    ApiService(
      name: 'Add Wishlist Item',
      endpoint: '/wp-json/custom-wishlist/v1/items',
      category: ApiCategory.woocommerceWishlist,
      subcategory: 'Wishlist Items',
      handler: AddWishlistItemHandler(),
    ),
    ApiService(
      name: 'Delete Wishlist Item',
      endpoint: '/wp-json/custom-wishlist/v1/items/:id',
      category: ApiCategory.woocommerceWishlist,
      subcategory: 'Wishlist Items',
      handler: DeleteWishlistItemHandler(),
    ),

    // 🛒 WooCommerce Store API Cart
    ApiService(
      name: 'Get Cart',
      endpoint: '/wp-json/wc/store/v1/cart',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: GetCartHandler(),
    ),

    // 🎟️ WooCommerce Store API Cart Coupons
    ApiService(
      name: 'Get Cart Coupons',
      endpoint: '/wp-json/wc/store/v1/cart/coupons',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Coupons',
      handler: GetCartCouponsHandler(),
    ),
    ApiService(
      name: 'Get Cart Coupon',
      endpoint: '/wp-json/wc/store/v1/cart/coupons/{coupon_code}',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Coupons',
      handler: GetCartCouponHandler(),
    ),
    ApiService(
      name: 'Add Cart Coupon',
      endpoint: '/wp-json/wc/store/v1/cart/coupons',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Coupons',
      handler: AddCartCouponHandler(),
    ),
    ApiService(
      name: 'Delete Cart Coupon',
      endpoint: '/wp-json/wc/store/v1/cart/coupons/{coupon_code}',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Coupons',
      handler: DeleteCartCouponHandler(),
    ),
    ApiService(
      name: 'Delete All Cart Coupons',
      endpoint: '/wp-json/wc/store/v1/cart/coupons',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Coupons',
      handler: DeleteAllCartCouponsHandler(),
    ),

    ApiService(
      name: 'Add Item',
      endpoint: '/wp-json/wc/store/v1/cart/add-item',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: AddItemHandler(),
    ),
    ApiService(
      name: 'Remove Item',
      endpoint: '/wp-json/wc/store/v1/cart/remove-item',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: RemoveItemHandler(),
    ),
    ApiService(
      name: 'Update Item',
      endpoint: '/wp-json/wc/store/v1/cart/update-item',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: UpdateItemHandler(),
    ),
    ApiService(
      name: 'Apply Coupon',
      endpoint: '/wp-json/wc/store/v1/cart/apply-coupon',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: ApplyCouponHandler(),
    ),
    ApiService(
      name: 'Remove Coupon',
      endpoint: '/wp-json/wc/store/v1/cart/remove-coupon',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: RemoveCouponHandler(),
    ),
    ApiService(
      name: 'Update Customer',
      endpoint: '/wp-json/wc/store/v1/cart/update-customer',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: UpdateCartCustomerHandler(),
    ),
    ApiService(
      name: 'Select Shipping Rate',
      endpoint: '/wp-json/wc/store/v1/cart/select-shipping-rate',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart API',
      handler: SelectShippingRateHandler(),
    ),

    // 🛒 WooCommerce Store API Checkout Data
    ApiService(
      name: 'Get Checkout Data',
      endpoint: '/wp-json/wc/store/v1/checkout',
      category: ApiCategory.woocommerceCheckout,
      subcategory: 'Checkout Data',
      handler: GetCheckoutDataHandler(),
    ),
    ApiService(
      name: 'Update Checkout Data',
      endpoint: '/wp-json/wc/store/v1/checkout',
      category: ApiCategory.woocommerceCheckout,
      subcategory: 'Checkout Data',
      handler: UpdateCheckoutDataHandler(),
    ),
    ApiService(
      name: 'Process Payment and Order',
      endpoint: '/wp-json/wc/store/v1/checkout',
      category: ApiCategory.woocommerceCheckout,
      subcategory: 'Checkout Data',
      handler: ProcessPaymentAndOrderHandler(),
    ),
    ApiService(
      name: 'Process Payment and Order (Order API)',
      endpoint: '/wp-json/wc/store/v1/checkout/order',
      category: ApiCategory.woocommerceCheckoutOrder,
      subcategory: 'Checkout Order API',
      handler: ProcessPaymentAndOrderOrderHandler(),
    ),

    // 📦 WooCommerce Store API Order
    ApiService(
      name: 'Get Order',
      endpoint: '/wp-json/wc/store/v1/order/{order_key}',
      category: ApiCategory.woocommerceOrder,
      subcategory: 'Order API',
      handler: GetOrderHandler(),
    ),

    // 📋 WooCommerce Cart Items API Handler - Store API
    ApiService(
      name: 'List Cart Items',
      endpoint: '/wp-json/wc/store/v1/cart/items',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Items API',
      handler: ListCartItemsHandler(),
    ),
    ApiService(
      name: 'Single Cart Item',
      endpoint: '/wp-json/wc/store/v1/cart/items?key=',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Items API',
      handler: GetSingleCartItemHandler(),
    ),
    ApiService(
      name: 'Add Cart Item',
      endpoint: '/wp-json/wc/store/v1/cart/items',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Items API',
      handler: AddCartItemHandler(),
    ),
    ApiService(
      name: 'Edit Single Cart Item',
      endpoint: '/wp-json/wc/store/v1/cart/items/{key}?quantity=',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Items API',
      handler: EditSingleCartItemHandler(),
    ),
    ApiService(
      name: 'Delete All Cart Items',
      endpoint: '/wp-json/wc/store/v1/cart/items',
      category: ApiCategory.woocommerceCart,
      subcategory: 'Cart Items API',
      handler: DeleteAllCartItemsHandler(),
    ),

    // 🛍️ WooCommerce Store API Products
    ApiService(
      name: 'List All Products',
      endpoint: '/wp-json/wc/store/v1/products',
      category: ApiCategory.woocommerceStoreProducts,
      subcategory: 'Products API',
      handler: StoreListAllProductsHandler(),
    ),
    ApiService(
      name: 'Retrieve Product',
      endpoint: '/wp-json/wc/store/v1/products/{product_id}',
      category: ApiCategory.woocommerceStoreProducts,
      subcategory: 'Products API',
      handler: StoreRetrieveProductHandler(),
    ),
    ApiService(
      name: 'Retrieve Product By Slug',
      endpoint: '/wp-json/wc/store/v1/products/{product_slug}',
      category: ApiCategory.woocommerceStoreProducts,
      subcategory: 'Products API',
      handler: StoreRetrieveProductBySlugHandler(),
    ),
    ApiService(
      name: 'List Variations By Type',
      endpoint: '/wp-json/wc/store/v1/products?type={type}',
      category: ApiCategory.woocommerceStoreProducts,
      subcategory: 'Products API',
      handler: StoreListVariationsByTypeHandler(),
    ),

    // 🏷️ WooCommerce Store API Product Tags
    ApiService(
      name: 'Product Tags',
      endpoint: '/wp-json/wc/store/{api_version}/products/tags',
      category: ApiCategory.woocommerceStoreProductTags,
      subcategory: 'Product Tags API',
      handler: ProductTagsHandler(),
    ),

    // 📝 WooCommerce Store API Product Reviews
    ApiService(
      name: 'Product Reviews',
      endpoint: '/wp-json/wc/store/{api_version}/products/reviews',
      category: ApiCategory.woocommerceStoreProductReviews,
      subcategory: 'Product Reviews API',
      handler: ProductReviewsHandler(),
    ),

    // 📊 WooCommerce Store API Product Collection Data
    ApiService(
      name: 'Product Collection Data',
      endpoint: '/wp-json/wc/store/{api_version}/products/collection-data',
      category: ApiCategory.woocommerceStoreProductCollectionData,
      subcategory: 'Product Collection Data API',
      handler: ProductCollectionDataHandler(),
    ),

    // 🏷️ WooCommerce Store API Product Categories
    ApiService(
      name: 'Product Categories',
      endpoint: '/wp-json/wc/store/{api_version}/products/categories',
      category: ApiCategory.woocommerceStoreProductCategories,
      subcategory: 'Product Categories API',
      handler: ProductCategoriesHandler(),
    ),

    // 📋 WooCommerce Store API List Product Categories
    ApiService(
      name: 'List Product Categories',
      endpoint: '/wp-json/wc/store/{api_version}/products/categories',
      category: ApiCategory.woocommerceStoreProductCategories,
      subcategory: 'Product Categories API',
      handler: StoreListProductCategoriesHandler(),
    ),

    // 🔍 WooCommerce Store API Retrieve Product Category
    ApiService(
      name: 'Retrieve Product Category',
      endpoint:
          '/wp-json/wc/store/{api_version}/products/categories/{category_id}',
      category: ApiCategory.woocommerceStoreProductCategories,
      subcategory: 'Product Categories API',
      handler: StoreRetrieveProductCategoryHandler(),
    ),

    // 🏷️ WooCommerce Store API Product Brands
    ApiService(
      name: 'Product Brands',
      endpoint: '/wp-json/wc/store/{api_version}/products/brands',
      category: ApiCategory.woocommerceStoreProductBrands,
      subcategory: 'Product Brands API',
      handler: ProductBrandsHandler(),
    ),

    // 📋 WooCommerce Store API List Product Brands
    ApiService(
      name: 'List Product Brands',
      endpoint: '/wp-json/wc/store/{api_version}/products/brands',
      category: ApiCategory.woocommerceStoreProductBrands,
      subcategory: 'Product Brands API',
      handler: StoreListProductBrandsHandler(),
    ),

    // 🔍 WooCommerce Store API Retrieve Product Brand
    ApiService(
      name: 'Retrieve Product Brand',
      endpoint: '/wp-json/wc/store/{api_version}/products/brands/{brand_id}',
      category: ApiCategory.woocommerceStoreProductBrands,
      subcategory: 'Product Brands API',
      handler: StoreRetrieveProductBrandHandler(),
    ),

    // 🏷️ WooCommerce Store API Product Attributes
    ApiService(
      name: 'Product Attributes',
      endpoint: '/wp-json/wc/store/{api_version}/products/attributes',
      category: ApiCategory.woocommerceStoreProductAttributes,
      subcategory: 'Product Attributes API',
      handler: ProductAttributesHandler(),
    ),

    // 📋 WooCommerce Store API List Product Attributes
    ApiService(
      name: 'List Product Attributes',
      endpoint: '/wp-json/wc/store/{api_version}/products/attributes',
      category: ApiCategory.woocommerceStoreProductAttributes,
      subcategory: 'Product Attributes API',
      handler: StoreListProductAttributesHandler(),
    ),

    // 🔍 WooCommerce Store API Retrieve Product Attribute
    ApiService(
      name: 'Retrieve Product Attribute',
      endpoint:
          '/wp-json/wc/store/{api_version}/products/attributes/{attribute_id}',
      category: ApiCategory.woocommerceStoreProductAttributes,
      subcategory: 'Product Attributes API',
      handler: StoreRetrieveProductAttributeHandler(),
    ),

    // 🏷️ WooCommerce Store API Product Attribute Terms
    ApiService(
      name: 'Product Attribute Terms',
      endpoint:
          '/wp-json/wc/store/{api_version}/products/attributes/{attribute_id}/terms',
      category: ApiCategory.woocommerceStoreProductAttributeTerms,
      subcategory: 'Product Attribute Terms API',
      handler: ProductAttributeTermsHandler(),
    ),
  ];

  static void initialize() {}

  static List<ApiService> get all => _services;

  static List<ApiCategory> get categories {
    // Main categories
    return [
      ApiCategory.shopify,
      ApiCategory.woocommerce,
      ApiCategory.shopifyGraphql
    ];
  }

  static List<ApiCategory> getShopifyCategories() {
    return [
      ApiCategory.access,
      ApiCategory.customer,
      ApiCategory.discounts,
      ApiCategory.billing,
      ApiCategory.events,
      ApiCategory.inventory,
      ApiCategory.orders,
      ApiCategory.marketingEvent,
      ApiCategory.giftCard,
      ApiCategory.metafield,
      ApiCategory.onlineStore,
      ApiCategory.products,
      ApiCategory.storeProperties,
      ApiCategory.webhooks,
      // Removed GraphQL categories from here - now separate main category
    ];
  }

  static List<ApiCategory> getShopifyGraphqlCategories() {
    return [
      ApiCategory
          .graphqlProductsAndCollections, // Products and Collections main category
      //ApiCategory.graphqlOrders, // Orders main category
      ApiCategory.graphqlCustomers, // Customers main category
      ApiCategory.graphqlWebhooks, // Webhooks main category
    ];
  }

  // Products and Collections subcategories
  static List<ApiCategory> getGraphqlProductsAndCollectionsSubCategories() {
    return [
      ApiCategory.graphqlProductsAndCollectionsQueries,
      ApiCategory.graphqlProductsAndCollectionsMutations,
    ];
  }

  // Customers subcategories
  static List<ApiCategory> getGraphqlCustomersSubCategories() {
    return [
      ApiCategory.graphqlCustomersQueries,
      ApiCategory.graphqlCustomersMutations,
    ];
  }

  static List<ApiCategory> getWooCommerceCategories() {
    return [
      ApiCategory.woocommerceCoupons,
      ApiCategory.woocommerceProducts,
      ApiCategory.woocommerceOrders,
      ApiCategory.woocommerceCustomers,
      ApiCategory.woocommerceWebhooks,
      ApiCategory.woocommerceSystemStatus,
      ApiCategory.woocommerceReports,
      ApiCategory.woocommerceShippingMethods,
      ApiCategory.woocommerceShippingZones,
      ApiCategory.woocommerceShippingZoneMethods,
      ApiCategory.woocommercePaymentGateways,
      ApiCategory.woocommerceSetting,
      ApiCategory.woocommerceData,
      ApiCategory.woocommerceContinents,
      ApiCategory.woocommerceCountries,
      ApiCategory.woocommerceCurrencies,
      ApiCategory.woocommerceRefunds,
      ApiCategory.woocommerceTaxes,
      ApiCategory.woocommerceWishlist,
    ];
  }

  // Get WooCommerce Admin categories (all except customer-facing ones)
  static List<ApiCategory> getWooCommerceAdminCategories() {
    return [
      ApiCategory.woocommerceCoupons,
      ApiCategory.woocommerceProducts,
      ApiCategory.woocommerceOrders,
      ApiCategory.woocommerceCustomers,
      ApiCategory.woocommerceCart,
      ApiCategory.woocommerceWebhooks,
      ApiCategory.woocommerceSystemStatus,
      ApiCategory.woocommerceReports,
      ApiCategory.woocommerceShippingMethods,
      ApiCategory.woocommerceShippingZones,
      ApiCategory.woocommerceShippingZoneMethods,
      ApiCategory.woocommercePaymentGateways,
      ApiCategory.woocommerceSetting,
      ApiCategory.woocommerceData,
      ApiCategory.woocommerceContinents,
      ApiCategory.woocommerceCountries,
      ApiCategory.woocommerceCurrencies,
      ApiCategory.woocommerceRefunds,
      ApiCategory.woocommerceTaxes,
    ];
  }

  // Get WooCommerce Customer categories (customer-facing features)
  static List<ApiCategory> getWooCommerceCustomerCategories() {
    return [
      ApiCategory.woocommerceOrder, // Move to top for testing
      ApiCategory.woocommerceWishlist,
      ApiCategory.woocommerceCart,
      ApiCategory.woocommerceCheckout,
      ApiCategory.woocommerceCheckoutOrder,
      ApiCategory.woocommerceStoreProducts,
      ApiCategory.woocommerceStoreProductTags,
      ApiCategory.woocommerceStoreProductReviews,
      ApiCategory.woocommerceStoreProductCollectionData,
      ApiCategory.woocommerceStoreProductCategories,
      ApiCategory.woocommerceStoreProductBrands,
      ApiCategory.woocommerceStoreProductAttributes,
      ApiCategory.woocommerceStoreProductAttributeTerms,
    ];
  }

  static List<ApiService> getByCategory(ApiCategory category) =>
      _services.where((s) => s.category == category).toList();

  static List<String> getSubcategoriesByCategory(ApiCategory category) {
    // Special handling for GraphQL main categories
    switch (category) {
      case ApiCategory.graphqlProductsAndCollections:
        return ['Queries', 'Mutations'];
      case ApiCategory.graphqlCustomers:
        return ['Queries', 'Mutations'];
      case ApiCategory.graphqlWebhooks:
        return ['Queries'];
      default:
        return _services
            .where((s) => s.category == category)
            .map((s) => s.subcategory)
            .toSet()
            .toList();
    }
  }

  static List<ApiService> getBySubcategory(
      ApiCategory category, String subcategoryName) {
    // Special handling for GraphQL main categories
    ApiCategory? targetCategory;

    switch (category) {
      case ApiCategory.graphqlProductsAndCollections:
        targetCategory = subcategoryName == 'Queries'
            ? ApiCategory.graphqlProductsAndCollectionsQueries
            : ApiCategory.graphqlProductsAndCollectionsMutations;
        break;
      // case ApiCategory.graphqlOrders:
      //   targetCategory = subcategoryName == 'Queries'
      //       ? ApiCategory.graphqlOrdersQueries
      //       : ApiCategory.graphqlOrdersMutations;
      //   break;
      case ApiCategory.graphqlCustomers:
        targetCategory = subcategoryName == 'Queries'
            ? ApiCategory.graphqlCustomersQueries
            : ApiCategory.graphqlCustomersMutations;
        break;
      case ApiCategory.graphqlWebhooks:
        targetCategory = subcategoryName == 'Queries'
            ? ApiCategory.graphqlWebhookQueries
            : ApiCategory.graphqlWebhookMutations;
        break;
      default:
        // Use old logic for normal categories
        return _services
            .where((s) =>
                s.category == category && s.subcategory == subcategoryName)
            .toList();
    }

    return _services.where((s) => s.category == targetCategory).toList();
  }

  static String getCategoryName(ApiCategory category) {
    switch (category) {
      case ApiCategory.shopify:
        return 'Shopify';
      case ApiCategory.woocommerce:
        return 'WooCommerce';
      case ApiCategory.shopifyGraphql:
        return 'Shopify GraphQL';
      case ApiCategory.graphql:
        return 'GraphQL';
      case ApiCategory.graphqlQueries:
        return 'GraphQL Queries';
      case ApiCategory.graphqlMutations:
        return 'GraphQL Mutations';
      // GraphQL Products and Collections
      case ApiCategory.graphqlProductsAndCollections:
        return 'Products and Collections';
      case ApiCategory.graphqlProductsAndCollectionsQueries:
        return 'Queries';
      case ApiCategory.graphqlProductsAndCollectionsMutations:
        return 'Mutations';
      // GraphQL Orders
      // case ApiCategory.graphqlOrders:
      //   return 'Orders';
      // case ApiCategory.graphqlOrdersQueries:
      //   return 'Queries';
      // case ApiCategory.graphqlOrdersMutations:
      //   return 'Mutations';
      // GraphQL Customers
      case ApiCategory.graphqlCustomers:
        return 'Customers';
      case ApiCategory.graphqlCustomersQueries:
        return 'Queries';
      case ApiCategory.graphqlCustomersMutations:
        return 'Mutations';
      // GraphQL Shop
      case ApiCategory.graphqlWebhooks:
        return 'Webhooks';
      case ApiCategory.graphqlWebhookQueries:
        return 'Queries';
      case ApiCategory.graphqlWebhookMutations:
        return 'Mutations';
      case ApiCategory.access:
        return 'Access';
      case ApiCategory.customer:
        return 'Customer';
      case ApiCategory.discounts:
        return 'Discounts';
      case ApiCategory.billing:
        return 'Billing';
      case ApiCategory.events:
        return 'Events';
      case ApiCategory.inventory:
        return 'Inventory';
      case ApiCategory.orders:
        return 'Orders';
      case ApiCategory.marketingEvent:
        return 'Marketing Event';
      case ApiCategory.giftCard:
        return 'Gift Card';
      case ApiCategory.metafield:
        return 'Metafield';
      case ApiCategory.onlineStore:
        return 'Online Store';
      case ApiCategory.products:
        return 'Products';
      case ApiCategory.storeProperties:
        return 'Store Properties';
      case ApiCategory.tendertransaction:
        return 'Tender Transaction';
      case ApiCategory.webhooks:
        return 'Webhooks';
      // WooCommerce categories
      case ApiCategory.woocommerceCoupons:
        return 'Coupons';
      case ApiCategory.woocommerceProducts:
        return 'Products';
      case ApiCategory.woocommerceOrders:
        return 'Orders';
      case ApiCategory.woocommerceCustomers:
        return 'Customers';
      case ApiCategory.woocommerceWebhooks:
        return 'Webhooks';
      case ApiCategory.woocommerceSystemStatus:
        return 'System Status';
      case ApiCategory.woocommerceReports:
        return 'Reports';
      case ApiCategory.woocommerceShippingMethods:
        return 'Shipping Methods';
      case ApiCategory.woocommerceShippingZones:
        return 'Shipping Zones';
      case ApiCategory.woocommerceShippingZoneMethods:
        return 'Shipping Zone Methods';
      case ApiCategory.woocommercePaymentGateways:
        return 'Payment Gateways';
      case ApiCategory.woocommerceSetting:
        return 'Settings';
      case ApiCategory.woocommerceData:
        return 'Data';
      case ApiCategory.woocommerceContinents:
        return 'Continents';
      case ApiCategory.woocommerceCountries:
        return 'Countries';
      case ApiCategory.woocommerceCurrencies:
        return 'Currencies';
      case ApiCategory.woocommerceRefunds:
        return 'Refunds';
      case ApiCategory.woocommerceTaxes:
        return 'Taxes';
      case ApiCategory.woocommerceWishlist:
        return 'Wishlist';
      case ApiCategory.woocommerceCart:
        return 'Cart';
      case ApiCategory.woocommerceCheckout:
        return 'Checkout';
      case ApiCategory.woocommerceCheckoutOrder:
        return 'Checkout Order';
      case ApiCategory.woocommerceOrder:
        return 'Order';
      case ApiCategory.woocommerceStoreProducts:
        return 'Products';
      case ApiCategory.woocommerceStoreProductTags:
        return 'Product Tags';
      case ApiCategory.woocommerceStoreProductReviews:
        return 'Product Reviews';
      case ApiCategory.woocommerceStoreProductCollectionData:
        return 'Product Collection Data';
      case ApiCategory.woocommerceStoreProductCategories:
        return 'Product Categories';
      case ApiCategory.woocommerceStoreProductBrands:
        return 'Product Brands';
      case ApiCategory.woocommerceStoreProductAttributes:
        return 'Product Attributes';
      case ApiCategory.woocommerceStoreProductAttributeTerms:
        return 'Product Attribute Terms';
    }
  }

  // UI Helper method for category icons
  static IconData getCategoryIcon(ApiCategory category) {
    switch (category) {
      case ApiCategory.shopify:
        return Icons.shopping_bag_rounded;
      case ApiCategory.woocommerce:
        return Icons.shopping_cart_checkout_rounded;
      case ApiCategory.shopifyGraphql:
        return Icons.analytics_rounded;
      case ApiCategory.graphql:
        return Icons.analytics_rounded;
      case ApiCategory.graphqlQueries:
        return Icons.search_rounded;
      case ApiCategory.graphqlMutations:
        return Icons.edit_rounded;
      case ApiCategory.graphqlProductsAndCollections:
        return Icons.inventory_2_rounded;
      case ApiCategory.graphqlProductsAndCollectionsQueries:
        return Icons.search_rounded;
      case ApiCategory.graphqlProductsAndCollectionsMutations:
        return Icons.edit_rounded;
      case ApiCategory.graphqlCustomers:
        return Icons.people_alt_rounded;
      case ApiCategory.graphqlCustomersQueries:
        return Icons.search_rounded;
      case ApiCategory.graphqlCustomersMutations:
        return Icons.edit_rounded;
      case ApiCategory.graphqlWebhooks:
        return Icons.webhook_rounded;
      case ApiCategory.graphqlWebhookQueries:
        return Icons.search_rounded;
      case ApiCategory.graphqlWebhookMutations:
        return Icons.edit_rounded;
      case ApiCategory.access:
        return Icons.security_rounded;
      case ApiCategory.customer:
        return Icons.people_rounded;
      case ApiCategory.discounts:
        return Icons.local_offer_rounded;
      case ApiCategory.billing:
        return Icons.payment_rounded;
      case ApiCategory.events:
        return Icons.event_rounded;
      case ApiCategory.inventory:
        return Icons.inventory_rounded;
      case ApiCategory.orders:
        return Icons.shopping_cart_rounded;
      case ApiCategory.marketingEvent:
        return Icons.campaign_rounded;
      case ApiCategory.giftCard:
        return Icons.card_giftcard_rounded;
      case ApiCategory.metafield:
        return Icons.label_rounded;
      case ApiCategory.onlineStore:
        return Icons.store_rounded;
      case ApiCategory.products:
        return Icons.category_rounded;
      case ApiCategory.storeProperties:
        return Icons.settings_rounded;
      case ApiCategory.tendertransaction:
        return Icons.account_balance_wallet_rounded;
      case ApiCategory.webhooks:
        return Icons.webhook_rounded;
      case ApiCategory.woocommerceCoupons:
        return Icons.local_offer_rounded;
      case ApiCategory.woocommerceProducts:
        return Icons.category_rounded;
      case ApiCategory.woocommerceOrders:
        return Icons.shopping_cart_rounded;
      case ApiCategory.woocommerceCustomers:
        return Icons.people_rounded;
      case ApiCategory.woocommerceWebhooks:
        return Icons.webhook_rounded;
      case ApiCategory.woocommerceSystemStatus:
        return Icons.system_update_rounded;
      case ApiCategory.woocommerceReports:
        return Icons.analytics_rounded;
      case ApiCategory.woocommerceShippingMethods:
        return Icons.local_shipping_rounded;
      case ApiCategory.woocommerceShippingZones:
        return Icons.location_on_rounded;
      case ApiCategory.woocommerceShippingZoneMethods:
        return Icons.route_rounded;
      case ApiCategory.woocommercePaymentGateways:
        return Icons.payment_rounded;
      case ApiCategory.woocommerceSetting:
        return Icons.settings_applications_rounded;
      case ApiCategory.woocommerceData:
        return Icons.data_usage_rounded;
      case ApiCategory.woocommerceContinents:
        return Icons.public_rounded;
      case ApiCategory.woocommerceCountries:
        return Icons.flag_rounded;
      case ApiCategory.woocommerceCurrencies:
        return Icons.attach_money_rounded;
      case ApiCategory.woocommerceRefunds:
        return Icons.money_off_rounded;
      case ApiCategory.woocommerceTaxes:
        return Icons.receipt_long_rounded;
      case ApiCategory.woocommerceWishlist:
        return Icons.favorite_border_rounded;
      case ApiCategory.woocommerceCart:
        return Icons.shopping_cart_rounded;
      case ApiCategory.woocommerceCheckout:
        return Icons.shopping_cart_checkout_rounded;
      case ApiCategory.woocommerceCheckoutOrder:
        return Icons.payment_rounded;
      case ApiCategory.woocommerceOrder:
        return Icons.receipt_long_rounded;
      case ApiCategory.woocommerceStoreProducts:
        return Icons.store_rounded;
      case ApiCategory.woocommerceStoreProductTags:
        return Icons.label_outlined;
      case ApiCategory.woocommerceStoreProductReviews:
        return Icons.star_outline;
      case ApiCategory.woocommerceStoreProductCollectionData:
        return Icons.analytics_outlined;
      case ApiCategory.woocommerceStoreProductCategories:
        return Icons.category_outlined;
      case ApiCategory.woocommerceStoreProductBrands:
        return Icons.business_outlined;
      case ApiCategory.woocommerceStoreProductAttributes:
        return Icons.tune_outlined;
      case ApiCategory.woocommerceStoreProductAttributeTerms:
        return Icons.label_outlined;
    }
  }
}
