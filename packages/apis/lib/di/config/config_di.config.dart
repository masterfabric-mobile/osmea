// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:apis/dio_config/dio_client/abstract/api_base_client.dart'
    as _i661;
import 'package:apis/dio_config/dio_client/api_dio_client.dart' as _i1004;
import 'package:apis/dio_config/dio_client/shopify_graphql_client.dart'
    as _i1051;
import 'package:apis/dio_config/dio_logger/abstract/api_base_logger.dart'
    as _i724;
import 'package:apis/dio_config/dio_logger/api_dio_logger.dart' as _i584;
import 'package:apis/network/remote/shopify/graphql/customers/abstract/customer_service.dart'
    as _i6;
import 'package:apis/network/remote/shopify/graphql/customers/api/api_customer_service.dart'
    as _i381;
import 'package:apis/network/remote/shopify/graphql/products/abstract/product_service.dart'
    as _i72;
import 'package:apis/network/remote/shopify/graphql/products/api/api_product_service.dart'
    as _i223;
import 'package:apis/network/remote/shopify/graphql/webhooks/abstract/webhooks_service.dart'
    as _i920;
import 'package:apis/network/remote/shopify/graphql/webhooks/api/api_webhooks_service.dart'
    as _i65;
import 'package:apis/network/remote/shopify/rest/access/access_scope/abstract/access_scope_service.dart'
    as _i38;
import 'package:apis/network/remote/shopify/rest/access/access_scope/api/api_access_scope_service.dart'
    as _i338;
import 'package:apis/network/remote/shopify/rest/access/storefront_access_token/abstract/storefront_access_token.dart'
    as _i722;
import 'package:apis/network/remote/shopify/rest/access/storefront_access_token/api/api_storefront_access_token.dart'
    as _i644;
import 'package:apis/network/remote/shopify/rest/billing/application_charge/abstract/application_charge_service.dart'
    as _i676;
import 'package:apis/network/remote/shopify/rest/billing/application_charge/api/api_application_charge_service.dart'
    as _i426;
import 'package:apis/network/remote/shopify/rest/billing/application_credit/abstract/application_credit_service.dart'
    as _i307;
import 'package:apis/network/remote/shopify/rest/billing/application_credit/api/api_application_credit_service.dart'
    as _i903;
import 'package:apis/network/remote/shopify/rest/billing/recurring_application_charge/abstract/recurring_application_charge_service.dart'
    as _i931;
import 'package:apis/network/remote/shopify/rest/billing/recurring_application_charge/api/api_recurring_application_charge_service.dart'
    as _i617;
import 'package:apis/network/remote/shopify/rest/billing/usage_charge/abstract/usage_charge_service.dart'
    as _i429;
import 'package:apis/network/remote/shopify/rest/billing/usage_charge/api/api_usage_charge_service.dart'
    as _i681;
import 'package:apis/network/remote/shopify/rest/customers/customer/abstract/customer_service.dart'
    as _i197;
import 'package:apis/network/remote/shopify/rest/customers/customer/api/api_customer_service.dart'
    as _i1017;
import 'package:apis/network/remote/shopify/rest/customers/customer_address/abstract/customer_adress_service.dart'
    as _i124;
import 'package:apis/network/remote/shopify/rest/customers/customer_address/api/api_customer_adress_service.dart'
    as _i838;
import 'package:apis/network/remote/shopify/rest/discounts/discount_code/abstract/discount_code_service.dart'
    as _i847;
import 'package:apis/network/remote/shopify/rest/discounts/discount_code/api/api_discount_code_service.dart'
    as _i331;
import 'package:apis/network/remote/shopify/rest/discounts/price_rule/abstract/price_rule_service.dart'
    as _i194;
import 'package:apis/network/remote/shopify/rest/discounts/price_rule/api/api_price_rule_service.dart'
    as _i47;
import 'package:apis/network/remote/shopify/rest/events/abstract/events_service.dart'
    as _i967;
import 'package:apis/network/remote/shopify/rest/events/api/api_events_service.dart'
    as _i208;
import 'package:apis/network/remote/shopify/rest/gift_card/abstract/gift_card_service.dart'
    as _i611;
import 'package:apis/network/remote/shopify/rest/gift_card/api/api_gift_card_service.dart'
    as _i1034;
import 'package:apis/network/remote/shopify/rest/inventory/inventory_item/abstract/inventory_item_service.dart'
    as _i146;
import 'package:apis/network/remote/shopify/rest/inventory/inventory_item/api/api_inventory_item_service.dart'
    as _i1047;
import 'package:apis/network/remote/shopify/rest/inventory/inventory_level/abstract/inventory_level_service.dart'
    as _i620;
import 'package:apis/network/remote/shopify/rest/inventory/inventory_level/api/api_inventory_level_service.dart'
    as _i153;
import 'package:apis/network/remote/shopify/rest/inventory/location/abstract/location_service.dart'
    as _i342;
import 'package:apis/network/remote/shopify/rest/inventory/location/api/api_location_service.dart'
    as _i395;
import 'package:apis/network/remote/shopify/rest/marketing_event/abstract/marketing_event_service.dart'
    as _i24;
import 'package:apis/network/remote/shopify/rest/marketing_event/api/api_marketing_event_service.dart'
    as _i707;
import 'package:apis/network/remote/shopify/rest/metafield/abstract/metafield_service.dart'
    as _i411;
import 'package:apis/network/remote/shopify/rest/metafield/api/api_metafield_service.dart'
    as _i1048;
import 'package:apis/network/remote/shopify/rest/online_store/article/abstract/article_service.dart'
    as _i783;
import 'package:apis/network/remote/shopify/rest/online_store/article/api/api_article_service.dart'
    as _i595;
import 'package:apis/network/remote/shopify/rest/online_store/asset/abstract/asset_service.dart'
    as _i195;
import 'package:apis/network/remote/shopify/rest/online_store/asset/api/api_asset_service.dart'
    as _i966;
import 'package:apis/network/remote/shopify/rest/online_store/blog/abstract/blog_service.dart'
    as _i225;
import 'package:apis/network/remote/shopify/rest/online_store/blog/api/api_blog_service.dart'
    as _i100;
import 'package:apis/network/remote/shopify/rest/online_store/comment/abstract/comment_service.dart'
    as _i655;
import 'package:apis/network/remote/shopify/rest/online_store/comment/api/api_comment_service.dart'
    as _i744;
import 'package:apis/network/remote/shopify/rest/online_store/page/abstract/page_service.dart'
    as _i99;
import 'package:apis/network/remote/shopify/rest/online_store/page/api/api_page_service.dart'
    as _i619;
import 'package:apis/network/remote/shopify/rest/online_store/redirect/abstract/redirect_service.dart'
    as _i983;
import 'package:apis/network/remote/shopify/rest/online_store/redirect/api/api_redirect_service.dart'
    as _i619;
import 'package:apis/network/remote/shopify/rest/online_store/script_tag/abstract/script_tag_service.dart'
    as _i182;
import 'package:apis/network/remote/shopify/rest/online_store/script_tag/api/api_script_tag_service.dart'
    as _i332;
import 'package:apis/network/remote/shopify/rest/online_store/theme/abstract/theme_service.dart'
    as _i729;
import 'package:apis/network/remote/shopify/rest/online_store/theme/api/api_theme_service.dart'
    as _i915;
import 'package:apis/network/remote/shopify/rest/orders/abandoned_checkouts/abstract/abandoned_checkouts_service.dart'
    as _i462;
import 'package:apis/network/remote/shopify/rest/orders/abandoned_checkouts/api/api_abandoned_checkouts_service.dart'
    as _i349;
import 'package:apis/network/remote/shopify/rest/orders/draft_order/abstract/draft_order_service.dart'
    as _i109;
import 'package:apis/network/remote/shopify/rest/orders/draft_order/api/api_draft_order_service.dart'
    as _i1001;
import 'package:apis/network/remote/shopify/rest/orders/order/abstract/order_service.dart'
    as _i982;
import 'package:apis/network/remote/shopify/rest/orders/order/api/api_order_service.dart'
    as _i85;
import 'package:apis/network/remote/shopify/rest/orders/refund/abstract/refund_service.dart'
    as _i566;
import 'package:apis/network/remote/shopify/rest/orders/refund/api/api_refund_service.dart'
    as _i627;
import 'package:apis/network/remote/shopify/rest/orders/transaction/abstract/transaction_service.dart'
    as _i1035;
import 'package:apis/network/remote/shopify/rest/orders/transaction/api/api_transaction_service.dart'
    as _i709;
import 'package:apis/network/remote/shopify/rest/products/collect/abstract/collect_service.dart'
    as _i969;
import 'package:apis/network/remote/shopify/rest/products/collect/api/api_collect_service.dart'
    as _i525;
import 'package:apis/network/remote/shopify/rest/products/collection/abstract/collection_service.dart'
    as _i171;
import 'package:apis/network/remote/shopify/rest/products/collection/api/api_collection_service.dart'
    as _i261;
import 'package:apis/network/remote/shopify/rest/products/custom_collection/abstract/custom_collections_service.dart'
    as _i1027;
import 'package:apis/network/remote/shopify/rest/products/custom_collection/api/api_custom_collections_service.dart'
    as _i375;
import 'package:apis/network/remote/shopify/rest/products/product/abstract/product_service.dart'
    as _i593;
import 'package:apis/network/remote/shopify/rest/products/product/api/api_product_service.dart'
    as _i888;
import 'package:apis/network/remote/shopify/rest/products/product_image/abstract/product_image_service.dart'
    as _i887;
import 'package:apis/network/remote/shopify/rest/products/product_image/api/api_product_image_service.dart'
    as _i929;
import 'package:apis/network/remote/shopify/rest/products/product_variant/abstract/product_variant_service.dart'
    as _i448;
import 'package:apis/network/remote/shopify/rest/products/product_variant/api/api_product_variant_service.dart'
    as _i938;
import 'package:apis/network/remote/shopify/rest/smart_collections/abstract/smart_collection_service.dart'
    as _i526;
import 'package:apis/network/remote/shopify/rest/smart_collections/api/api_smart_collection_service.dart'
    as _i49;
import 'package:apis/network/remote/shopify/rest/store_properties/country/abstract/country_service.dart'
    as _i300;
import 'package:apis/network/remote/shopify/rest/store_properties/country/api/api_country_service.dart'
    as _i882;
import 'package:apis/network/remote/shopify/rest/store_properties/currency/abstract/currency_service.dart'
    as _i293;
import 'package:apis/network/remote/shopify/rest/store_properties/currency/api/api_currency_service.dart'
    as _i474;
import 'package:apis/network/remote/shopify/rest/store_properties/policy/abstract/shop_policy_service.dart'
    as _i128;
import 'package:apis/network/remote/shopify/rest/store_properties/policy/api/api_shop_policy_service.dart'
    as _i395;
import 'package:apis/network/remote/shopify/rest/store_properties/province/abstract/province_service.dart'
    as _i691;
import 'package:apis/network/remote/shopify/rest/store_properties/province/api/api_province_service.dart'
    as _i383;
import 'package:apis/network/remote/shopify/rest/store_properties/shipping_zone/abstract/shipping_zone_service.dart'
    as _i654;
import 'package:apis/network/remote/shopify/rest/store_properties/shipping_zone/api/api_shipping_zone_service.dart'
    as _i120;
import 'package:apis/network/remote/shopify/rest/store_properties/shop/abstract/shop_service.dart'
    as _i611;
import 'package:apis/network/remote/shopify/rest/store_properties/shop/api/api_shop_service.dart'
    as _i169;
import 'package:apis/network/remote/shopify/rest/tendertransaction/tendertransaction/abstract/tender_transaction_service.dart'
    as _i871;
import 'package:apis/network/remote/shopify/rest/tendertransaction/tendertransaction/api/api_tender_transaction_service.dart'
    as _i71;
import 'package:apis/network/remote/shopify/rest/webhooks/webhook/abstract/webhook_service.dart'
    as _i352;
import 'package:apis/network/remote/shopify/rest/webhooks/webhook/api/api_webhook_service.dart'
    as _i827;
import 'package:apis/network/remote/woocommerce/admin_api/coupons/abstract/coupons_service.dart'
    as _i373;
import 'package:apis/network/remote/woocommerce/admin_api/coupons/api/api_coupons_service.dart'
    as _i1029;
import 'package:apis/network/remote/woocommerce/admin_api/customers/abstract/customers_service.dart'
    as _i660;
import 'package:apis/network/remote/woocommerce/admin_api/customers/api/api_customers_service.dart'
    as _i98;
import 'package:apis/network/remote/woocommerce/admin_api/datas/continents/abstract/continents_service.dart'
    as _i727;
import 'package:apis/network/remote/woocommerce/admin_api/datas/continents/api/api_continents_service.dart'
    as _i755;
import 'package:apis/network/remote/woocommerce/admin_api/datas/countries/abstract/countries_service.dart'
    as _i128;
import 'package:apis/network/remote/woocommerce/admin_api/datas/countries/api/api_countries_service.dart'
    as _i751;
import 'package:apis/network/remote/woocommerce/admin_api/datas/currencies/abstract/currencies_service.dart'
    as _i1013;
import 'package:apis/network/remote/woocommerce/admin_api/datas/currencies/api/api_currencies_service.dart'
    as _i730;
import 'package:apis/network/remote/woocommerce/admin_api/datas/data/abstract/data_service.dart'
    as _i558;
import 'package:apis/network/remote/woocommerce/admin_api/datas/data/api/api_data_service.dart'
    as _i1067;
import 'package:apis/network/remote/woocommerce/admin_api/orders/abstract/orders_service.dart'
    as _i402;
import 'package:apis/network/remote/woocommerce/admin_api/orders/api/api_orders_service.dart'
    as _i150;
import 'package:apis/network/remote/woocommerce/admin_api/orders/order_id/notes/abstract/order_notes_service.dart'
    as _i961;
import 'package:apis/network/remote/woocommerce/admin_api/orders/order_id/notes/api/api_order_notes_service.dart'
    as _i490;
import 'package:apis/network/remote/woocommerce/admin_api/payment_gateways/abstract/payment_gateways_service.dart'
    as _i1052;
import 'package:apis/network/remote/woocommerce/admin_api/payment_gateways/api/api_payment_gateways_service.dart'
    as _i329;
import 'package:apis/network/remote/woocommerce/admin_api/products/attribute_terms/abstract/product_attribute_terms_service.dart'
    as _i515;
import 'package:apis/network/remote/woocommerce/admin_api/products/attribute_terms/api/api_product_attribute_terms_service.dart'
    as _i44;
import 'package:apis/network/remote/woocommerce/admin_api/products/attributes/abstract/product_attributes_service.dart'
    as _i947;
import 'package:apis/network/remote/woocommerce/admin_api/products/attributes/api/api_product_attributes_service.dart'
    as _i831;
import 'package:apis/network/remote/woocommerce/admin_api/products/categories/abstract/product_categories_service.dart'
    as _i527;
import 'package:apis/network/remote/woocommerce/admin_api/products/categories/api/api_product_categories_service.dart'
    as _i259;
import 'package:apis/network/remote/woocommerce/admin_api/products/product/abstract/products_service.dart'
    as _i588;
import 'package:apis/network/remote/woocommerce/admin_api/products/product/api/api_products_service.dart'
    as _i235;
import 'package:apis/network/remote/woocommerce/admin_api/products/reviews/abstract/product_reviews_service.dart'
    as _i218;
import 'package:apis/network/remote/woocommerce/admin_api/products/reviews/api/api_product_reviews_service.dart'
    as _i619;
import 'package:apis/network/remote/woocommerce/admin_api/products/shipping_classes/abstract/product_shipping_classes_service.dart'
    as _i163;
import 'package:apis/network/remote/woocommerce/admin_api/products/shipping_classes/api/api_product_shipping_classes_service.dart'
    as _i515;
import 'package:apis/network/remote/woocommerce/admin_api/products/tags/abstract/product_tags_service.dart'
    as _i486;
import 'package:apis/network/remote/woocommerce/admin_api/products/tags/api/api_product_tags_service.dart'
    as _i533;
import 'package:apis/network/remote/woocommerce/admin_api/products/variations/abstract/product_variations_service.dart'
    as _i680;
import 'package:apis/network/remote/woocommerce/admin_api/products/variations/api/api_product_variations_service.dart'
    as _i262;
import 'package:apis/network/remote/woocommerce/admin_api/refunds/abstract/refunds_service.dart'
    as _i288;
import 'package:apis/network/remote/woocommerce/admin_api/refunds/api/api_refunds_service.dart'
    as _i472;
import 'package:apis/network/remote/woocommerce/admin_api/reports/abstract/reports_service.dart'
    as _i973;
import 'package:apis/network/remote/woocommerce/admin_api/reports/api/api_reports_service.dart'
    as _i1029;
import 'package:apis/network/remote/woocommerce/admin_api/settings/abstract/settings_service.dart'
    as _i950;
import 'package:apis/network/remote/woocommerce/admin_api/settings/api/api_settings_service.dart'
    as _i330;
import 'package:apis/network/remote/woocommerce/admin_api/shipping_methods/abstract/shipping_methods_service.dart'
    as _i241;
import 'package:apis/network/remote/woocommerce/admin_api/shipping_methods/api/api_shipping_methods_service.dart'
    as _i665;
import 'package:apis/network/remote/woocommerce/admin_api/shipping_zones/method/abstract/shipping_zone_methods_service.dart'
    as _i93;
import 'package:apis/network/remote/woocommerce/admin_api/shipping_zones/method/api/api_shipping_zone_methods_service.dart'
    as _i350;
import 'package:apis/network/remote/woocommerce/admin_api/shipping_zones/shipping_zone/abstract/shipping_zones_service.dart'
    as _i351;
import 'package:apis/network/remote/woocommerce/admin_api/shipping_zones/shipping_zone/api/api_shipping_zones_service.dart'
    as _i604;
import 'package:apis/network/remote/woocommerce/admin_api/system_status/abstract/system_status_service.dart'
    as _i330;
import 'package:apis/network/remote/woocommerce/admin_api/system_status/api/api_system_status_service.dart'
    as _i997;
import 'package:apis/network/remote/woocommerce/admin_api/taxes/classes/abstract/taxes_classes_service.dart'
    as _i447;
import 'package:apis/network/remote/woocommerce/admin_api/taxes/classes/api/api_taxes_classes_service.dart'
    as _i156;
import 'package:apis/network/remote/woocommerce/admin_api/taxes/rates/abstract/taxes_rates_service.dart'
    as _i574;
import 'package:apis/network/remote/woocommerce/admin_api/taxes/rates/api/api_taxes_rates_service.dart'
    as _i842;
import 'package:apis/network/remote/woocommerce/admin_api/webhooks/abstract/webhooks_service.dart'
    as _i813;
import 'package:apis/network/remote/woocommerce/admin_api/webhooks/api/api_webhooks_service.dart'
    as _i331;
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart'
    as _i28;
import 'package:apis/network/remote/woocommerce/auth/api/api_woo_auth_service.dart'
    as _i916;
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart'
    as _i654;
import 'package:apis/network/remote/woocommerce/store_api/cart_api/api/api_cart_service.dart'
    as _i845;
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/abstract/cart_coupons_service.dart'
    as _i441;
import 'package:apis/network/remote/woocommerce/store_api/cart_coupons_api/api/api_cart_coupons_service.dart'
    as _i359;
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/abstract/cart_items_service.dart'
    as _i240;
import 'package:apis/network/remote/woocommerce/store_api/cart_items_api/api/api_cart_items_service.dart'
    as _i977;
import 'package:apis/network/remote/woocommerce/store_api/checkout_data_api/abstract/checkout_data_service.dart'
    as _i209;
import 'package:apis/network/remote/woocommerce/store_api/checkout_data_api/api/api_checkout_data_service.dart'
    as _i488;
import 'package:apis/network/remote/woocommerce/store_api/checkout_order_api/abstract/checkout_order_service.dart'
    as _i616;
import 'package:apis/network/remote/woocommerce/store_api/checkout_order_api/api/api_checkout_order_service.dart'
    as _i994;
import 'package:apis/network/remote/woocommerce/store_api/order_api/abstract/order_service.dart'
    as _i702;
import 'package:apis/network/remote/woocommerce/store_api/order_api/api/api_order_service.dart'
    as _i791;
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart'
    as _i846;
import 'package:apis/network/remote/woocommerce/store_api/product_api/api/api_product_service.dart'
    as _i125;
import 'package:apis/network/remote/woocommerce/store_api/product_attribute_terms/abstract/store_product_attribute_terms_service.dart'
    as _i601;
import 'package:apis/network/remote/woocommerce/store_api/product_attribute_terms/api/api_store_product_attribute_terms_service.dart'
    as _i91;
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/abstract/store_product_attributes_service.dart'
    as _i739;
import 'package:apis/network/remote/woocommerce/store_api/product_attributes_api/api/api_store_product_attributes_service.dart'
    as _i260;
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/abstract/store_product_brands_service.dart'
    as _i286;
import 'package:apis/network/remote/woocommerce/store_api/product_brands_api/api/api_store_product_brands_service.dart'
    as _i568;
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart'
    as _i694;
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/api/api_store_product_categories_service.dart'
    as _i900;
import 'package:apis/network/remote/woocommerce/store_api/product_collection_data_api/abstract/store_product_collection_data_service.dart'
    as _i913;
import 'package:apis/network/remote/woocommerce/store_api/product_collection_data_api/api/api_store_product_collection_data_service.dart'
    as _i948;
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/abstract/store_product_reviews_service.dart'
    as _i667;
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/api/api_store_product_reviews_service.dart'
    as _i535;
import 'package:apis/network/remote/woocommerce/store_api/product_tags_api/abstract/store_product_tags_service.dart'
    as _i197;
import 'package:apis/network/remote/woocommerce/store_api/product_tags_api/api/api_store_product_tags_service.dart'
    as _i1053;
import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart'
    as _i671;
import 'package:apis/network/remote/woocommerce/wishlist/api/api_woo_wishlist_service.dart'
    as _i965;
import 'package:apis/services/auth/woo_auth_manager.dart' as _i459;
import 'package:apis/services/auth/woo_jwt_auth_service.dart' as _i1011;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    gh.singleton<_i361.Dio>(() => dioModule.dio());
    gh.factory<_i1013.CurrenciesService>(
        () => _i730.ApiCurrenciesService(gh<_i361.Dio>()));
    gh.factory<_i947.ProductAttributesService>(
        () => _i831.ProductAttributesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i163.ProductShippingClassesService>(
        () => _i515.ProductShippingClassesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i601.StoreProductAttributeTermsService>(
        () => _i91.StoreProductAttributeTermsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i1052.PaymentGatewaysService>(
        () => _i329.ApiPaymentGatewaysService(gh<_i361.Dio>()));
    gh.factory<_i288.RefundsService>(
        () => _i472.ApiRefundsService(gh<_i361.Dio>()));
    gh.factory<_i402.OrdersService>(
        () => _i150.OrdersServiceClient(gh<_i361.Dio>()));
    gh.factory<_i588.ProductsService>(
        () => _i235.ProductsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i351.ShippingZonesService>(
        () => _i604.ShippingZonesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i667.StoreProductReviewsService>(
        () => _i535.StoreProductReviewsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i913.StoreProductCollectionDataService>(
        () => _i948.StoreProductCollectionDataServiceClient(gh<_i361.Dio>()));
    gh.factory<_i973.ReportsService>(
        () => _i1029.ApiReportsService(gh<_i361.Dio>()));
    gh.factory<_i574.TaxesRatesService>(
        () => _i842.TaxesRatesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i515.ProductAttributeTermsService>(
        () => _i44.ProductAttributeTermsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i611.ShopService>(
        () => _i169.ShopServiceClient(gh<_i361.Dio>()));
    gh.factory<_i813.WebhooksService>(
        () => _i331.WebhooksServiceClient(gh<_i361.Dio>()));
    gh.factory<_i197.StoreProductTagsService>(
        () => _i1053.StoreProductTagsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i441.CartCouponsService>(
        () => _i359.CartCouponsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i654.CartService>(
        () => _i845.CartServiceClient(gh<_i361.Dio>()));
    gh.factory<_i330.SystemStatusService>(
        () => _i997.SystemStatusServiceClient(gh<_i361.Dio>()));
    gh.singleton<_i724.ApiBaseLogger>(
        () => _i584.ApiDioLogger(logger: gh<_i974.Logger>()));
    gh.factory<_i447.TaxesClassesService>(
        () => _i156.TaxesClassesServiceClient(gh<_i361.Dio>()));
    gh.singleton<_i661.ApiBaseClient>(() => _i1004.ApiDioClient());
    gh.factory<_i1035.TransactionService>(
        () => _i709.TransactionServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i950.SettingsService>(
        () => _i330.SettingsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i300.CountryService>(
        () => _i882.CountryServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i24.MarketingEventEvents>(
        () => _i707.MarketingEventEventsApi(gh<_i661.ApiBaseClient>()));
    gh.factory<_i209.CheckoutDataService>(
        () => _i488.CheckoutDataServiceClient(gh<_i361.Dio>()));
    gh.factory<_i611.GiftCardService>(
        () => _i1034.GiftCardServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i722.StorefrontAccessTokenService>(
        () => _i644.StorefrontAccessTokenClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i293.CurrencyService>(
        () => _i474.CurrencyServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i171.CollectionService>(
        () => _i261.CollectionServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i462.AbandonedCheckoutsService>(
        () => _i349.AbandonedCheckoutsServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i566.RefundService>(
        () => _i627.RefundServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i967.RetrievesListOfEvents>(
        () => _i208.RetrievesListOfEventsClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i93.ShippingZoneMethodsService>(
        () => _i350.ShippingZoneMethodsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i527.ProductCategoriesService>(
        () => _i259.ProductCategoriesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i99.PageService>(
        () => _i619.PageServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i887.ProductImageService>(
        () => _i929.ProductImageServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i671.WooWishlistService>(
        () => _i965.ApiWooWishlistService(gh<_i361.Dio>()));
    gh.factory<_i28.WooAuthService>(
        () => _i916.ApiWooAuthService(gh<_i361.Dio>()));
    gh.factory<_i459.WooAuthManager>(
        () => _i459.WooAuthManager(gh<_i28.WooAuthService>()));
    gh.factory<_i846.ProductService>(
        () => _i125.ProductServiceClient(gh<_i361.Dio>()));
    gh.factory<_i195.AssetService>(
        () => _i966.AssetServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i739.StoreProductAttributesService>(
        () => _i260.StoreProductAttributesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i727.ContinentsService>(
        () => _i755.ApiContinentsService(gh<_i361.Dio>()));
    gh.factory<_i558.DataService>(() => _i1067.ApiDataService(gh<_i361.Dio>()));
    gh.factory<_i655.CommentService>(
        () => _i744.CommentServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i931.RecurringApplicationChargeService>(() =>
        _i617.RecurringApplicationChargeServiceClient(
            gh<_i661.ApiBaseClient>()));
    gh.factory<_i197.CustomerService>(
        () => _i1017.CustomerServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i620.InventoryLevelService>(
        () => _i153.InventoryLevelServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i1011.WooJwtAuthService>(
        () => _i1011.WooJwtAuthService(gh<_i361.Dio>()));
    gh.factory<_i352.WebhookService>(
        () => _i827.WebhookServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i286.StoreProductBrandsService>(
        () => _i568.StoreProductBrandsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i448.ProductVariantService>(
        () => _i938.ProductVariantServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i616.CheckoutOrderService>(
        () => _i994.CheckoutOrderServiceClient(gh<_i361.Dio>()));
    gh.factory<_i342.LocationService>(
        () => _i395.LocationServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i128.CountriesService>(
        () => _i751.ApiCountriesService(gh<_i361.Dio>()));
    gh.singleton<_i661.GraphQLBaseClient>(() => _i1051.ShopifyGraphQLClient());
    gh.factory<_i967.RetrievesCountEvents>(
        () => _i208.RetrievesCountEventsClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i982.OrderService>(
        () => _i85.OrderServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i307.ApplicationCreditService>(
        () => _i903.ApplicationCreditServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i694.StoreProductCategoriesService>(
        () => _i900.StoreProductCategoriesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i240.CartItemsService>(
        () => _i977.CartItemsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i373.CouponsService>(
        () => _i1029.CouponsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i702.OrderService>(
        () => _i791.OrderServiceClient(gh<_i361.Dio>()));
    gh.factory<_i961.OrderNotesService>(
        () => _i490.OrderNotesServiceClient(gh<_i361.Dio>()));
    gh.factory<_i241.ShippingMethodsService>(
        () => _i665.ApiShippingMethodsService(gh<_i361.Dio>()));
    gh.factory<_i660.CustomersService>(
        () => _i98.CustomersServiceClient(gh<_i361.Dio>()));
    gh.factory<_i654.ShippingZoneService>(
        () => _i120.ShippingZoneServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i6.CustomerGraphQLService>(
        () => _i381.CustomerGraphQLServiceImpl(gh<_i661.GraphQLBaseClient>()));
    gh.factory<_i920.WebhooksGraphQLService>(
        () => _i65.ApiWebhooksService(gh<_i661.GraphQLBaseClient>()));
    gh.factory<_i680.ProductVariationsService>(
        () => _i262.ProductVariationsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i194.PriceRuleService>(
        () => _i47.PriceRuleServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i526.SmartCollectionService>(
        () => _i49.ApiSmartCollectionService(gh<_i661.ApiBaseClient>()));
    gh.factory<_i486.ProductTagsService>(
        () => _i533.ProductTagsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i218.ProductReviewsService>(
        () => _i619.ProductReviewsServiceClient(gh<_i361.Dio>()));
    gh.factory<_i429.UsageChargeService>(
        () => _i681.UsageChargeServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i676.ApplicationChargeService>(
        () => _i426.ApplicationChargeServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i967.RetrievesSingleEvent>(
        () => _i208.RetrievesSingleEventClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i593.ProductService>(
        () => _i888.ProductServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i128.ShopPolicyService>(
        () => _i395.ShopPolicyServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i146.InventoryItemService>(
        () => _i1047.InventoryItemServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i38.AccessScopeService>(
        () => _i338.AccessScopeServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i225.BlogService>(
        () => _i100.BlogServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i847.DiscountCodeService>(
        () => _i331.DiscountServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i729.ThemeService>(
        () => _i915.ThemeServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i109.DraftOrderService>(
        () => _i1001.DraftOrderServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i691.ProvinceService>(
        () => _i383.ProvinceServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i411.MetafieldService>(
        () => _i1048.MetafieldServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i1027.CustomCollectionsService>(
        () => _i375.CustomCollectionsServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i182.ScriptTagService>(
        () => _i332.ScriptTagServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i969.CollectService>(
        () => _i525.CollectServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i871.TenderTransactionService>(
        () => _i71.TenderTransactionServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i783.ArticleService>(
        () => _i595.ArticleServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i983.RedirectService>(
        () => _i619.RedirectServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i124.CustomerAddressService>(
        () => _i838.CustomerAddressServiceClient(gh<_i661.ApiBaseClient>()));
    gh.factory<_i72.ProductGraphQLService>(
        () => _i223.ProductGraphQLServiceImpl(gh<_i661.GraphQLBaseClient>()));
    return this;
  }
}

class _$DioModule extends _i1004.DioModule {}
