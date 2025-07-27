import 'package:example/services/index.dart';

enum ApiCategory {
  shopify,
  woocommerce,
  access,
  storefront,
  admin,
  catalog,
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
  woocommerceCoupons,
  woocommerceProducts,
  woocommerceOrders,
  woocommerceCustomers,
  woocommerceWebhooks,
  woocommerceSystemStatus,
}

extension ApiCategoryExtension on ApiCategory {
  String get displayName {
    switch (this) {
      case ApiCategory.shopify:
        return 'Shopify';
      case ApiCategory.woocommerce:
        return 'WooCommerce';
      case ApiCategory.access:
        return 'Access APIs';
      case ApiCategory.storefront:
        return 'Storefront APIs';
      case ApiCategory.admin:
        return 'Admin APIs';
      case ApiCategory.catalog:
        return 'Catalog APIs';
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
      case ApiCategory.woocommerceCoupons:
        return 'WooCommerce Coupons APIs';
      case ApiCategory.woocommerceProducts:
        return 'WooCommerce Products APIs';
      case ApiCategory.woocommerceOrders:
        return 'WooCommerce Orders APIs';
      case ApiCategory.woocommerceCustomers:
        return 'WooCommerce Customers APIs';
      case ApiCategory.woocommerceWebhooks:
        return 'WooCommerce Webhooks APIs';
      case ApiCategory.woocommerceSystemStatus:
        return 'WooCommerce System Status APIs';
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
      name: 'WooCommerce List All Coupons',
      endpoint: '/wp-json/wc/v3/coupons',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'WooCommerce Coupons',
      handler: ListAllCouponsHandler(),
    ),
    ApiService(
      name: 'WooCommerce Retrieve Coupon',
      endpoint: '/wp-json/wc/v3/coupons/{coupon_id}',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'WooCommerce Coupons',
      handler: RetrieveCouponHandler(),
    ),
    ApiService(
      name: 'WooCommerce Create Coupon',
      endpoint: '/wp-json/wc/v3/coupons',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'WooCommerce Coupons',
      handler: CreateCouponHandler(),
    ),
    ApiService(
      name: 'WooCommerce Update Coupon',
      endpoint: '/wp-json/wc/v3/coupons/{coupon_id}',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'WooCommerce Coupons',
      handler: UpdateCouponHandler(),
    ),
    ApiService(
      name: 'WooCommerce Delete Coupon',
      endpoint: '/wp-json/wc/v3/coupons/{coupon_id}',
      category: ApiCategory.woocommerceCoupons,
      subcategory: 'WooCommerce Coupons',
      handler: DeleteCouponHandler(),
    ),

    // 🛍️ WooCommerce Products Services
    ApiService(
      name: 'WooCommerce List All Products',
      endpoint: '/wp-json/wc/v3/products',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Products',
      handler: ListAllProductsHandler(),
    ),
    ApiService(
      name: 'WooCommerce Retrieve Product',
      endpoint: '/wp-json/wc/v3/products/{product_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Products',
      handler: RetrieveProductHandler(),
    ),
    ApiService(
      name: 'WooCommerce Create Product',
      endpoint: '/wp-json/wc/v3/products',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Products',
      handler: CreateProductHandler(),
    ),
    ApiService(
      name: 'WooCommerce Update Product',
      endpoint: '/wp-json/wc/v3/products/{product_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Products',
      handler: UpdateProductHandler(),
    ),
    ApiService(
      name: 'WooCommerce Delete Product',
      endpoint: '/wp-json/wc/v3/products/{product_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Products',
      handler: WooDeleteProductHandler(),
    ),
    ApiService(
      name: 'WooCommerce Retrieve Product Custom Field Names',
      endpoint: '/wp-json/wc/v3/products/{product_id}/custom_fields/names',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Products',
      handler: RetrieveProductCustomFieldNamesHandler(),
    ),

    ApiService(
      name: 'WooCommerce List All Product Categories',
      endpoint: '/wp-json/wc/v3/products/categories',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Categories',
      handler: ListAllProductCategoriesHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Product Category',
      endpoint: '/wp-json/wc/v3/products/categories',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Categories',
      handler: CreateProductCategoryHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Product Category',
      endpoint: '/wp-json/wc/v3/products/categories/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Categories',
      handler: RetrieveProductCategoryHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Product Category',
      endpoint: '/wp-json/wc/v3/products/categories/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Categories',
      handler: UpdateProductCategoryHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Product Category',
      endpoint: '/wp-json/wc/v3/products/categories/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Categories',
      handler: DeleteProductCategoryHandler(),
    ),

    ApiService(
      name: 'WooCommerce List All Product Reviews',
      endpoint: '/wp-json/wc/v3/products/reviews',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Reviews',
      handler: ListAllProductReviewsHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Reviews',
      handler: CreateProductReviewHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Reviews',
      handler: RetrieveProductReviewHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Reviews',
      handler: UpdateProductReviewHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Product Review',
      endpoint: '/wp-json/wc/v3/products/reviews/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Reviews',
      handler: DeleteProductReviewHandler(),
    ),

    ApiService(
      name: 'WooCommerce List All Product Shipping Classes',
      endpoint: '/wp-json/wc/v3/products/shipping_classes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Shipping Classes',
      handler: ListAllProductShippingClassesHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Shipping Classes',
      handler: CreateProductShippingClassHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Shipping Classes',
      handler: RetrieveProductShippingClassHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Shipping Classes',
      handler: UpdateProductShippingClassHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Product Shipping Class',
      endpoint: '/wp-json/wc/v3/products/shipping_classes/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Shipping Classes',
      handler: DeleteProductShippingClassHandler(),
    ),

    ApiService(
      name: 'WooCommerce List All Product Tags',
      endpoint: '/wp-json/wc/v3/products/tags',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Tags',
      handler: ListAllProductTagsHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Tags',
      handler: CreateProductTagHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Tags',
      handler: RetrieveProductTagHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Tags',
      handler: UpdateProductTagHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Product Tag',
      endpoint: '/wp-json/wc/v3/products/tags/{id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Tags',
      handler: DeleteProductTagHandler(),
    ),

    ApiService(
      name: 'WooCommerce List All Product Variations',
      endpoint: '/wp-json/wc/v3/products/{product_id}/variations',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Variations',
      handler: ListAllProductVariationsHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Product Variation',
      endpoint: '/wp-json/wc/v3/products/{product_id}/variations',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Variations',
      handler: CreateProductVariationHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Product Variation',
      endpoint:
          '/wp-json/wc/v3/products/{product_id}/variations/{variation_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Variations',
      handler: RetrieveProductVariationHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Product Variation',
      endpoint:
          '/wp-json/wc/v3/products/{product_id}/variations/{variation_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Variations',
      handler: UpdateProductVariationHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Product Variation',
      endpoint:
          '/wp-json/wc/v3/products/{product_id}/variations/{variation_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Variations',
      handler: DeleteProductVariationHandler(),
    ),

    // 🏷️ WooCommerce Product Attributes Services
    ApiService(
      name: 'WooCommerce List All Product Attributes',
      endpoint: '/wp-json/wc/v3/products/attributes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attributes',
      handler: ListAllProductAttributesHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attributes',
      handler: CreateProductAttributeHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attributes',
      handler: RetrieveProductAttributeHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attributes',
      handler: UpdateProductAttributeHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Product Attribute',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attributes',
      handler: DeleteProductAttributeHandler(),
    ),

    // 🏷️ WooCommerce Product Attribute Terms Services
    ApiService(
      name: 'WooCommerce List All Product Attribute Terms',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}/terms',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attribute Terms',
      handler: ListAllProductAttributeTermsHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Product Attribute Term',
      endpoint: '/wp-json/wc/v3/products/attributes/{attribute_id}/terms',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attribute Terms',
      handler: CreateProductAttributeTermHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Product Attribute Term',
      endpoint:
          '/wp-json/wc/v3/products/attributes/{attribute_id}/terms/{term_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attribute Terms',
      handler: RetrieveProductAttributeTermHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Product Attribute Term',
      endpoint:
          '/wp-json/wc/v3/products/attributes/{attribute_id}/terms/{term_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attribute Terms',
      handler: UpdateProductAttributeTermHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Product Attribute Term',
      endpoint:
          '/wp-json/wc/v3/products/attributes/{attribute_id}/terms/{term_id}',
      category: ApiCategory.woocommerceProducts,
      subcategory: 'WooCommerce Product Attribute Terms',
      handler: DeleteProductAttributeTermHandler(),
    ),

    // 🔗 WooCommerce Webhooks Services
    ApiService(
      name: 'WooCommerce List All Webhooks',
      endpoint: '/wp-json/wc/v3/webhooks',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'WooCommerce Webhooks',
      handler: ListAllWebhooksHandler(),
    ),

    ApiService(
      name: 'WooCommerce Create Webhook',
      endpoint: '/wp-json/wc/v3/webhooks',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'WooCommerce Webhooks',
      handler: WooCreateWebhookHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Webhook',
      endpoint: '/wp-json/wc/v3/webhooks/{webhook_id}',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'WooCommerce Webhooks',
      handler: RetrieveWebhookHandler(),
    ),

    ApiService(
      name: 'WooCommerce Update Webhook',
      endpoint: '/wp-json/wc/v3/webhooks/{webhook_id}',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'WooCommerce Webhooks',
      handler: WooUpdateWebhookHandler(),
    ),

    ApiService(
      name: 'WooCommerce Delete Webhook',
      endpoint: '/wp-json/wc/v3/webhooks/{webhook_id}',
      category: ApiCategory.woocommerceWebhooks,
      subcategory: 'WooCommerce Webhooks',
      handler: WooDeleteWebhookHandler(),
    ),

    // 🔧 WooCommerce System Status Services
    ApiService(
      name: 'WooCommerce Get System Status',
      endpoint: '/wp-json/wc/v3/system_status',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'WooCommerce System Status',
      handler: GetSystemStatusHandler(),
    ),

    ApiService(
      name: 'WooCommerce List All Tools From System Status',
      endpoint: '/wp-json/wc/v3/system_status/tools',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'WooCommerce System Status',
      handler: ListAllToolsFromSystemStatusHandler(),
    ),

    ApiService(
      name: 'WooCommerce Retrieve Tool From System Status',
      endpoint: '/wp-json/wc/v3/system_status/tools/{tool_id}',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'WooCommerce System Status',
      handler: RetrieveToolFromSystemStatusHandler(),
    ),

    ApiService(
      name: 'WooCommerce Run Tool From System Status',
      endpoint: '/wp-json/wc/v3/system_status/tools/{tool_id}',
      category: ApiCategory.woocommerceSystemStatus,
      subcategory: 'WooCommerce System Status',
      handler: RunToolFromSystemStatusHandler(),
    ),

    // 👥 WooCommerce Customers Services
    ApiService(
      name: 'WooCommerce List All Customers',
      endpoint: '/wp-json/wc/v3/customers',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'WooCommerce Customers',
      handler: ListAllCustomersHandler(),
    ),
    ApiService(
      name: 'WooCommerce Retrieve Customer',
      endpoint: '/wp-json/wc/v3/customers/{customer_id}',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'WooCommerce Customers',
      handler: RetrieveCustomerHandler(),
    ),
    ApiService(
      name: 'WooCommerce Create Customer',
      endpoint: '/wp-json/wc/v3/customers',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'WooCommerce Customers',
      handler: CreateCustomerHandler(),
    ),
    ApiService(
      name: 'WooCommerce Update Customer',
      endpoint: '/wp-json/wc/v3/customers/{customer_id}',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'WooCommerce Customers',
      handler: UpdateCustomerHandler(),
    ),
    ApiService(
      name: 'WooCommerce Delete Customer',
      endpoint: '/wp-json/wc/v3/customers/{customer_id}',
      category: ApiCategory.woocommerceCustomers,
      subcategory: 'WooCommerce Customers',
      handler: DeleteCustomerHandler(),
    ),

    // 🛒 WooCommerce Orders
    ApiService(
      name: 'WooCommerce List All Orders',
      endpoint: '/wp-json/wc/v3/orders',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Orders',
      handler: ListAllOrdersHandler(),
    ),
    ApiService(
      name: 'WooCommerce Create Order',
      endpoint: '/wp-json/wc/v3/orders',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Orders',
      handler: CreateOrderHandler(),
    ),
    ApiService(
      name: 'WooCommerce Retrieve Order',
      endpoint: '/wp-json/wc/v3/orders/{order_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Orders',
      handler: RetrieveOrderHandler(),
    ),
    ApiService(
      name: 'WooCommerce Update Order',
      endpoint: '/wp-json/wc/v3/orders/{order_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Orders',
      handler: UpdateOrderHandler(),
    ),
    ApiService(
      name: 'WooCommerce Delete Order',
      endpoint: '/wp-json/wc/v3/orders/{order_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Orders',
      handler: DeleteOrderHandler(),
    ),
    ApiService(
      name: 'WooCommerce Send Order Details',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/actions/send_order_details',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Orders',
      handler: SendOrderDetailsHandler(),
    ),

    // 📝 WooCommerce Order Notes
    ApiService(
      name: 'WooCommerce List All Order Notes',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Order Notes',
      handler: ListAllOrderNotesHandler(),
    ),
    ApiService(
      name: 'WooCommerce Create Order Note',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Order Notes',
      handler: CreateOrderNoteHandler(),
    ),
    ApiService(
      name: 'WooCommerce Retrieve Order Note',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes/{note_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Order Notes',
      handler: RetrieveOrderNoteHandler(),
    ),
    ApiService(
      name: 'WooCommerce Delete Order Note',
      endpoint: '/wp-json/wc/v3/orders/{order_id}/notes/{note_id}',
      category: ApiCategory.woocommerceOrders,
      subcategory: 'WooCommerce Order Notes',
      handler: DeleteOrderNoteHandler(),
    ),
  ];

  static void initialize() {}

  static List<ApiService> get all => _services;

  static List<ApiCategory> get categories {
    // Ana kategoriler
    return [ApiCategory.shopify, ApiCategory.woocommerce];
  }

  static List<ApiCategory> getShopifyCategories() {
    return [
      ApiCategory.access,
      ApiCategory.storefront,
      ApiCategory.admin,
      ApiCategory.catalog,
      ApiCategory.billing,
      ApiCategory.customer,
      ApiCategory.discounts,
      ApiCategory.events,
      ApiCategory.inventory,
      ApiCategory.orders,
      ApiCategory.marketingEvent,
      ApiCategory.giftCard,
      ApiCategory.metafield,
      ApiCategory.onlineStore,
      ApiCategory.products,
      ApiCategory.storeProperties,
      ApiCategory.tendertransaction,
      ApiCategory.webhooks,
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
    ];
  }

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
      case ApiCategory.shopify:
        return 'Shopify';
      case ApiCategory.woocommerce:
        return 'WooCommerce';
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
        return 'WooCommerce Coupons';
      case ApiCategory.woocommerceProducts:
        return 'WooCommerce Products';
      case ApiCategory.woocommerceOrders:
        return 'WooCommerce Orders';
      case ApiCategory.woocommerceCustomers:
        return 'WooCommerce Customers';
      case ApiCategory.woocommerceWebhooks:
        return 'WooCommerce Webhooks';
      case ApiCategory.woocommerceSystemStatus:
        return 'WooCommerce System Status';
    }
  }
}
