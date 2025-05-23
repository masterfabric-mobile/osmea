// ignore_for_file: constant_identifier_names

import 'package:example/services/handlers/customers_handlers/customer/searches_for_customers_that_match_supplied_query_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/create_article_base_image_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/create_article_html_markup_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/create_article_with_image_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/create_article_with_metafield_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/create_unpublished_article_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/asset_handlers/delete_image_from_theme_handler.dart';
import 'package:example/services/handlers/online_store_handlers/asset_handlers/duplicate_asset_source_key_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/count_all_blogs_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/create_empty_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/create_empty_blog_with_metafield.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/get_all_blogs_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/get_single_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/metafield_existing_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/remove_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/update_blog_title_handler.dart';
import 'package:example/services/handlers/online_store_handlers/blog_handlers/update_existing_blog_title_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/approve_and_publish_comment_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/count_comments_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/create_comment_textile_markup_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/get_single_comment_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/list_all_comments_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/mark_comment_as_spam_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/mark_comment_not_spam_restore_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/remove_comment_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/restore_remove_comment_handler.dart';
import 'package:example/services/handlers/online_store_handlers/comment_handlers/update_comment_body_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/add_metafield_to_page_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/count_all_pages_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/create_page_html_markup_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/create_page_with_metafield_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/create_unpublished_page_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/delete_page_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/get_single_page_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/hide_published_page_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/list_all_pages_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/show_hidden_page_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/update_body_html_of_page_handler.dart';
import 'package:example/services/handlers/online_store_handlers/page_handlers/update_existing_page_completely_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/count_all_redirects_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/create_redirect_full_url_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/create_redirect_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/delete_redirect_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/get_single_redirect_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/list_all_redirects_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/update_redirect_path_and_target_handler.dart';
import 'package:example/services/handlers/online_store_handlers/redirect_handlers/update_redirect_path_uri_handler.dart';
import 'package:example/services/handlers/online_store_handlers/script_tag_handler/count_all_script_handler.dart';
import 'package:example/services/handlers/online_store_handlers/script_tag_handler/create_script_tag_handler.dart';
import 'package:example/services/handlers/online_store_handlers/script_tag_handler/delete_script_tag_handler.dart';
import 'package:example/services/handlers/online_store_handlers/script_tag_handler/get_single_script_handler.dart';
import 'package:example/services/handlers/online_store_handlers/script_tag_handler/list_all_script_tags_handler.dart';
import 'package:example/services/handlers/online_store_handlers/script_tag_handler/update_script_tag_url_handler.dart';
import 'package:example/services/handlers/online_store_handlers/theme_handler/create_theme_handler.dart';
import 'package:example/services/handlers/online_store_handlers/theme_handler/delete_theme_handler.dart';
import 'package:example/services/handlers/online_store_handlers/theme_handler/get_single_theme_handler.dart';
import 'package:example/services/handlers/online_store_handlers/theme_handler/list_themes_handler.dart';
import 'package:example/services/handlers/online_store_handlers/theme_handler/publish_unpublished_theme_handler.dart';
import 'package:example/services/handlers/online_store_handlers/theme_handler/update_theme_name_handler.dart';
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
import 'package:example/services/handlers/store_properties_handlers/shop_handlers/retrieves_the_shop_configuration_handler.dart';
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
import 'package:example/services/handlers/marketing_event_handlers/creates_marketing_engagements_handler.dart';
import 'package:example/services/handlers/marketing_event_handlers/creates_marketing_event_handler.dart';
import 'package:example/services/handlers/marketing_event_handlers/deletes_a_marketing_event_handler.dart';
import 'package:example/services/handlers/marketing_event_handlers/retrieves_a_count_of_all_handler.dart';
import 'package:example/services/handlers/marketing_event_handlers/retrieves_a_list_of_all_handler.dart';
import 'package:example/services/handlers/marketing_event_handlers/retrieves_a_single_handler.dart';
import 'package:example/services/handlers/marketing_event_handlers/updates_a_marketing_event_handler.dart';
import 'package:example/services/handlers/metafield_handlers/count_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/create_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/delete_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/get_specific_metafield_handler.dart';
import 'package:example/services/handlers/metafield_handlers/list_metafields_handler.dart';
import 'package:example/services/handlers/metafield_handlers/list_metafields_query_parameters_handler.dart';
import 'package:example/services/handlers/metafield_handlers/update_metafield_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/count_blog_articles_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/delete_article_from_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/get_single_article_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/list_all_article_authors_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/list_article_tags_specific_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/list_articles_from_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/list_most_popular_tags_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/list_most_popular_tags_specific_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/list_tags_all_articles_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/list_tags_specific_blog_handler.dart';
import 'package:example/services/handlers/online_store_handlers/article_handlers/update_article_handler.dart';
import 'package:example/services/handlers/online_store_handlers/asset_handlers/change_liquid_template_value_handler.dart';
import 'package:example/services/handlers/online_store_handlers/asset_handlers/create_image_asset_base_handler.dart';
import 'package:example/services/handlers/online_store_handlers/asset_handlers/create_image_asset_source_url_handler.dart';
import 'package:example/services/handlers/online_store_handlers/asset_handlers/get_liquid_template_handler.dart';
import 'package:example/services/handlers/online_store_handlers/asset_handlers/list_all_assets_theme_handler.dart';
import 'package:example/services/handlers/tendertransaction_handlers/tendertransaction_handler/retrieve_list_of_tender_transactions_handler.dart';
import 'package:example/services/index.dart';
import 'handlers/customers_handlers/customer/retrieves_list_of_customers_handler.dart';
import 'handlers/customers_handlers/customer/retrieves_all_orders_belonging_to_customer_handler.dart';
import 'handlers/customers_handlers/customer/sends_account_invite_to_customer_handler.dart';
import 'package:example/services/handlers/billing_handlers/application_charge_handlers/retrieve_list_of_application_charges_handler.dart';
import 'package:example/services/handlers/billing_handlers/application_charge_handlers/retrieve_an_application_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/application_charge_handlers/create_an_application_charge_handler.dart';
import 'package:example/services/handlers/inventory/location/list_all_locations_handler.dart';
import 'package:example/services/handlers/billing_handlers/application_credit_handlers/retrieve_list_of_application_credits_handler.dart';
import 'package:example/services/handlers/billing_handlers/application_credit_handlers/retrieve_an_application_credit_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/create_new_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/disable_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/retrieves_count_of_gift_cards_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/retrieves_list_of_gift_cards_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/retrieves_single_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/searches_for_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/updates_gift_card_handler.dart';
import 'package:example/services/handlers/gift_card_handlers/automatically_create_gift_card_handler.dart';
import 'package:example/services/handlers/billing_handlers/recurring_application_charge_handlers/retrieve_list_of_recurring_application_charges_handler.dart';
import 'package:example/services/handlers/billing_handlers/recurring_application_charge_handlers/retrieve_a_recurring_application_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/recurring_application_charge_handlers/customize_recurring_application_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/recurring_application_charge_handlers/delete_recurring_application_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/recurring_application_charge_handlers/create_basic_recurring_application_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/recurring_application_charge_handlers/create_trial_recurring_application_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/recurring_application_charge_handlers/create_capped_recurring_application_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/usage_charge_handlers/retrieve_list_of_usage_charges_handler.dart';
import 'package:example/services/handlers/billing_handlers/usage_charge_handlers/retrieve_a_usage_charge_handler.dart';
import 'package:example/services/handlers/billing_handlers/usage_charge_handlers/create_usage_charge_handler.dart';
import 'package:example/services/handlers/webhooks_handlers/webhook_handlers/retrieve_list_of_webhooks_handler.dart';
import 'package:example/services/handlers/webhooks_handlers/webhook_handlers/retrieve_a_webhook_handler.dart';
import 'package:example/services/handlers/webhooks_handlers/webhook_handlers/retrieve_count_of_webhooks_handler.dart';
import 'package:example/services/handlers/webhooks_handlers/webhook_handlers/create_webhook_handler.dart';
import 'package:example/services/handlers/webhooks_handlers/webhook_handlers/update_webhook_handler.dart';
import 'package:example/services/handlers/webhooks_handlers/webhook_handlers/delete_webhook_handler.dart';

enum ApiCategory {
  access,
  storefront,
  admin,
  catalog,
  billing,
  customer,
  discounts,
  events,
  inventory,
  marketingEvent,
  giftCard,
  metafield,
  storeProperties,
  onlineStore,
  tendertransaction,
  webhooks
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
      case ApiCategory.marketingEvent:
        return 'Marketing Event APIs';
      case ApiCategory.giftCard:
        return 'Gift Card APIs';
      case ApiCategory.metafield:
        return 'Metafield APIs';
      case ApiCategory.storeProperties:
        return 'Store Properties APIs';
      case ApiCategory.onlineStore:
        return 'Online Store APIs';
      case ApiCategory.tendertransaction:
        return 'Tender Transaction APIs';
      case ApiCategory.webhooks:
        return 'Webhooks APIs';
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
    ApiService(
      name: 'Retrieve Shop Configuration',
      endpoint: '/shop.json',
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
      endpoint: '/themes/:theme_id/assets.json',
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: CreateImageAssetBaseHandler(),
    ),

    // 🔗 CREATE IMAGE ASSET FROM URL
    ApiService(
      name: 'Create Image Asset From URL',
      endpoint: '/themes/:theme_id/assets.json',
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: CreateImageAssetSourceUrlHandler(),
    ),

    // 📝 CHANGE LIQUID TEMPLATE
    ApiService(
      name: 'Change Liquid Template',
      endpoint: '/themes/:theme_id/assets.json',
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: ChangeLiquidTemplateValueHandler(),
    ),

    // 🔄 DUPLICATE ASSET SOURCE KEY
    ApiService(
      name: 'Duplicate Asset Source Key',
      endpoint: '/themes/:theme_id/assets.json',
      category: ApiCategory.onlineStore,
      subcategory: 'Asset',
      handler: DuplicateAssetSourceKeyHandler(),
    ),

    // 🗑️ DELETE IMAGE FROM THEME
    ApiService(
      name: 'Delete Image From Theme',
      endpoint: '/themes/:theme_id/assets.json',
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

    // 💰 Tender Transaction APIs
    ApiService(
      name: 'List Tender Transactions',
      endpoint: '/tender_transactions',
      category: ApiCategory.tendertransaction, // Changed from billing
      subcategory: 'Tender Transaction',
      handler: RetrieveListOfTenderTransactionsHandler(),
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
      case ApiCategory.billing:
        return 'Billing';
      case ApiCategory.events:
        return 'Events';
      case ApiCategory.inventory:
        return 'Inventory';
      case ApiCategory.marketingEvent:
        return 'Marketing Event';
      case ApiCategory.giftCard:
        return 'Gift Card';
      case ApiCategory.metafield:
        return 'Metafield';
      case ApiCategory.storeProperties:
        return 'Store Properties';
      case ApiCategory.onlineStore:
        return 'Online Store';
      case ApiCategory.tendertransaction:
        return 'Tender Transaction';
      case ApiCategory.webhooks:
        return 'Webhooks';
    }
  }
}
