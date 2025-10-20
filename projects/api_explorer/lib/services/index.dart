// 📦 Export all handlers for easy importing

export 'api_request_handler.dart';

// 🔐 Authentication Handlers
export 'handlers/woocommerce/auth_handlers/jwt_auth_test_handler.dart';
export 'handlers/woocommerce/auth_handlers/user_login_handler.dart';
export 'handlers/woocommerce/auth_handlers/user_signup_handler.dart';
export 'handlers/woocommerce/auth_handlers/user_logout_handler.dart';
export 'handlers/woocommerce/auth_handlers/send_reset_password_handler.dart';
export 'handlers/woocommerce/auth_handlers/password_update_handler.dart';
export 'handlers/woocommerce/auth_handlers/auth_status_handler.dart';
export 'handlers/woocommerce/auth_handlers/delete_user_handler.dart';

// 🛒 WooCommerce Store API Cart Handlers
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/get_cart_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/add_item_handler.dart';

// 🎟️ WooCommerce Store API Cart Coupons Handlers
export 'handlers/woocommerce/store_api_handlers/cart_coupons_api_handlers/get_cart_coupons_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_coupons_api_handlers/get_cart_coupon_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_coupons_api_handlers/add_cart_coupon_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_coupons_api_handlers/delete_cart_coupon_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_coupons_api_handlers/delete_all_cart_coupons_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/remove_item_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/update_item_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/apply_coupon_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/remove_coupon_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/update_customer_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_api_handlers/select_shipping_rate_handler.dart';

// 🛒 WooCommerce Store API Checkout Data Handlers
export 'handlers/woocommerce/store_api_handlers/checkout_data_api_handlers/get_checkout_data_handler.dart';
export 'handlers/woocommerce/store_api_handlers/checkout_data_api_handlers/update_checkout_data_handler.dart';
export 'handlers/woocommerce/store_api_handlers/checkout_data_api_handlers/process_payment_and_order_handler.dart';

// 🛒 WooCommerce Store API Checkout Order Handlers
export 'handlers/woocommerce/store_api_handlers/checkout_order_api_handlers/process_payment_and_order_handler.dart';

// 📦 WooCommerce Store API Order Handlers
export 'handlers/woocommerce/store_api_handlers/order_api_handlers/get_order_handler.dart';

// 📋 WooCommerce Store API Cart Items Handlers
export 'handlers/woocommerce/store_api_handlers/cart_items_api_handlers/list_cart_items_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_items_api_handlers/get_single_cart_item_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_items_api_handlers/add_cart_item_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_items_api_handlers/edit_single_cart_item_handler.dart';
export 'handlers/woocommerce/store_api_handlers/cart_items_api_handlers/delete_all_cart_items_handler.dart';

// 🛍️ WooCommerce Store API Product Handlers
export 'handlers/woocommerce/store_api_handlers/product_api_handlers/list_all_products_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_api_handlers/retrieve_product_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_api_handlers/retrieve_product_by_slug_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_api_handlers/list_variations_by_type_handler.dart';

// 🏷️ WooCommerce Store API Product Tags Handlers
export 'handlers/woocommerce/store_api_handlers/product_tags_handlers/product_tags_handler.dart';

// 📝 WooCommerce Store API Product Reviews Handlers
export 'handlers/woocommerce/store_api_handlers/product_reviews_handlers/product_reviews_handler.dart';

// 📊 WooCommerce Store API Product Collection Data Handlers
export 'handlers/woocommerce/store_api_handlers/product_collection_data_handlers/product_collection_data_handler.dart';

// 🏷️ WooCommerce Store API Product Categories Handlers
export 'handlers/woocommerce/store_api_handlers/product_categories_handlers/product_categories_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_categories_handlers/list_product_categories_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_categories_handlers/retrieve_product_category_handler.dart';

// 🏷️ WooCommerce Store API Product Brands Handlers
export 'handlers/woocommerce/store_api_handlers/product_brands_handlers/product_brands_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_brands_handlers/list_product_brands_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_brands_handlers/retrieve_product_brand_handler.dart';

// 🏷️ WooCommerce Store API Product Attributes Handlers
export 'handlers/woocommerce/store_api_handlers/product_attributes_handlers/product_attributes_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_attributes_handlers/list_product_attributes_handler.dart';
export 'handlers/woocommerce/store_api_handlers/product_attributes_handlers/retrieve_product_attribute_handler.dart';

// 🏷️ WooCommerce Store API Product Attribute Terms Handlers
export 'handlers/woocommerce/store_api_handlers/product_attribute_terms_handlers/product_attribute_terms_handler.dart';

// 🚀 GraphQL Handlers - Modular Structure

// Products GraphQL Handlers
export 'handlers/shopify/graphql_handlers/products/queries/products_handler.dart';
export 'handlers/shopify/graphql_handlers/products/queries/product_handler.dart';
export 'handlers/shopify/graphql_handlers/products/mutations/product_create_handler.dart';

// Customers GraphQL Handlers
export 'handlers/shopify/graphql_handlers/customers/mutations/customer_create_handler.dart';
export 'handlers/shopify/graphql_handlers/customers/mutations/customer_update_handler.dart';
export 'handlers/shopify/graphql_handlers/customers/mutations/customer_disable_handler.dart';
export 'handlers/shopify/graphql_handlers/customers/queries/get_customers_handler.dart';
export 'handlers/shopify/graphql_handlers/customers/queries/get_customer_handler.dart';
export 'handlers/shopify/graphql_handlers/customers/queries/get_customers_count_handler.dart';

// Webhook Query Handlers
export 'handlers/shopify/graphql_handlers/webhooks/queries/get_webhook_subscriptions_handler.dart';
export 'handlers/shopify/graphql_handlers/webhooks/queries/get_webhook_subscription_handler.dart';
export 'handlers/shopify/graphql_handlers/webhooks/queries/get_webhook_subscriptions_count_handler.dart';

// Webhook Mutation Handlers
export 'handlers/shopify/graphql_handlers/webhooks/mutations/create_webhook_subscription_handler.dart';
export 'handlers/shopify/graphql_handlers/webhooks/mutations/update_webhook_subscription_handler.dart';
export 'handlers/shopify/graphql_handlers/webhooks/mutations/delete_webhook_subscription_handler.dart';

// Restful Handlers

// 🔐 Access Handlers
export 'handlers/shopify/rest_handlers/access_handlers/access_scope_handler.dart';
export 'handlers/shopify/rest_handlers/access_handlers/storefront_access_token_handler.dart';

// 💰 Billing Handlers
export 'handlers/shopify/rest_handlers/billing_handlers/application_charge_handlers/retrieve_list_of_application_charges_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/application_charge_handlers/retrieve_an_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/application_charge_handlers/create_an_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/application_credit_handlers/retrieve_list_of_application_credits_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/application_credit_handlers/retrieve_an_application_credit_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/recurring_application_charge_handlers/retrieve_list_of_recurring_application_charges_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/recurring_application_charge_handlers/retrieve_a_recurring_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/recurring_application_charge_handlers/customize_recurring_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/recurring_application_charge_handlers/delete_recurring_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/recurring_application_charge_handlers/create_basic_recurring_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/recurring_application_charge_handlers/create_trial_recurring_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/recurring_application_charge_handlers/create_capped_recurring_application_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/usage_charge_handlers/retrieve_list_of_usage_charges_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/usage_charge_handlers/retrieve_a_usage_charge_handler.dart';
export 'handlers/shopify/rest_handlers/billing_handlers/usage_charge_handlers/create_usage_charge_handler.dart';

// 👥 Customer Handlers
export 'handlers/shopify/rest_handlers/customers_handlers/customer/retrieves_list_of_customers_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customer/retrieves_single_customer_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customer/retrieves_all_orders_belonging_to_customer_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customer/searches_for_customers_that_match_supplied_query_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customer/customer_url_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customer/retrieves_count_of_customers_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customer/sends_account_invite_to_customer_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customers_address/creates_new_address_for_customer_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customers_address/retrieves_list_of_addresses_for_customer_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customers_address/retrieves_details_for_single_customer_address_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customers_address/sets_default_address_for_customer_handler.dart';
export 'handlers/shopify/rest_handlers/customers_handlers/customers_address/destroy_multiple_customer_addresses_handler.dart';

// 📅 Events Handlers
export 'handlers/shopify/rest_handlers/events_handlers/retrieves_list_of_events_handler.dart';
export 'handlers/shopify/rest_handlers/events_handlers/retrieves_single_event_handler.dart';
export 'handlers/shopify/rest_handlers/events_handlers/retrieves_count_events_handler.dart';

// 🎯 Discount Handlers
export 'handlers/shopify/rest_handlers/discount_handlers/discount_code_handler/retrieves_count_of_discount_codes_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/discount_code_handler/retrieves_search_for_discount_code_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/discount_code_handler/retrieves_list_of_discount_codes_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/discount_code_handler/retrieves_list_of_discount_code_creation_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/discount_code_handler/create_discount_code_creation_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/discount_code_handler/create_discount_code_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/create_price_rule_discount_collection_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/create_price_rule_discount_selected_customers_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/create_price_rule_free_shipping_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/create_price_rule_free_item_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/create_price_rule_discount_order_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/price_rule_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/retrieves_count_of_price_rules_handler.dart';
export 'handlers/shopify/rest_handlers/discount_handlers/price_rule_handler/retrieves_get_list_of_price_rules_handler.dart';

// 📦 Inventory Handlers
export 'handlers/shopify/rest_handlers/inventory/inventory_item_handlers/inventory_item_by_id_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/inventory_item_handlers/update_inventory_item_sku_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/inventory_item_handlers/update_inventory_item_unit_cost_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/inventory_level_handlers/inventory_item_at_location_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/inventory_level_handlers/inventory_item_to_location_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/inventory_level_handlers/set_inventory_location_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/inventory_level_handlers/list_inventory_levels_single_location_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/inventory_level_handlers/list_inventory_levels_single_item_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/location/list_all_locations_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/location/single_location_by_id_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/location/list_inventory_by_location_id_handler.dart';
export 'handlers/shopify/rest_handlers/inventory/location/count_all_locations_handler.dart';

// 🛒 Order Handlers
export 'handlers/shopify/rest_handlers/orders_handlers/abandoned_checkouts_handlers/retrieves_count_of_checkouts_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/abandoned_checkouts_handlers/retrieves_list_abandoned_checkouts_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/create_draft_order_custom_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/create_draft_order_discounted_item_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/create_draft_order_percent_discount_item_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/create_draft_order_simple_product_variant_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/create_draft_order_with_discount_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/create_invoice_customized_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/create_invoice_default_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/draft_order_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/retrieves_get_draft_order_count_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/update_add_note_draft_order_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/update_draft_order_complete_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/draft_order_handlers/update_set_discount_on_draft_order_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_cancel_order_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_close_order_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_comprehensive_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_fulfill_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_partially_paid_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_sending_order_confirmation_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_with_pending_customer_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_with_product_id_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_with_tax_lines_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_order_without_order_receipt_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/create_reopen_order_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/order_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/retrieves_get_order_after_timestamp_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/retrieves_get_order_count_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/retrieves_get_order_list_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/retrieves_get_orders_authorized_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/retrieves_get_orders_with_properties_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_add_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_add_note_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_change_whether_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_email_address_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_note_attributes_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_order_tag_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_phone_number_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_remove_customer_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_handlers/update_shipping_address_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_risk_handlers/create_order_risk_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/order_risk_handlers/retrieves_get_list_order_risks_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/refund_handlers/create_refund_calculate_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/refund_handlers/create_refund_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/refund_handlers/refund_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/refund_handlers/retrieves_list_refunds_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/transaction_handlers/create_transaction_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/transaction_handlers/retrieves_transaction_count_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/transaction_handlers/retrieves_transaction_list_handler.dart';
export 'handlers/shopify/rest_handlers/orders_handlers/transaction_handlers/retrieves_transaction_single_handler.dart';

// 📈 Marketing Event Handlers
export 'handlers/shopify/rest_handlers/marketing_event_handlers/retrieves_a_list_of_all_handler.dart';
export 'handlers/shopify/rest_handlers/marketing_event_handlers/retrieves_a_single_handler.dart';
export 'handlers/shopify/rest_handlers/marketing_event_handlers/retrieves_a_count_of_all_handler.dart';
export 'handlers/shopify/rest_handlers/marketing_event_handlers/creates_marketing_event_handler.dart';
export 'handlers/shopify/rest_handlers/marketing_event_handlers/updates_a_marketing_event_handler.dart';
export 'handlers/shopify/rest_handlers/marketing_event_handlers/deletes_a_marketing_event_handler.dart';
export 'handlers/shopify/rest_handlers/marketing_event_handlers/creates_marketing_engagements_handler.dart';

// 🎁 Gift Card Handlers
export 'handlers/shopify/rest_handlers/gift_card_handlers/create_new_gift_card_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/automatically_create_gift_card_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/disable_gift_card_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/retrieves_count_of_gift_cards_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/retrieves_list_of_gift_cards_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/retrieves_single_gift_card_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/searches_for_gift_card_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/updates_gift_card_handler.dart';
export 'handlers/shopify/rest_handlers/gift_card_handlers/create_gift_card_with_custom_code_handler.dart';

// 🏷️ Metafield Handlers
export 'handlers/shopify/rest_handlers/metafield_handlers/create_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/metafield_handlers/list_metafields_handler.dart';
export 'handlers/shopify/rest_handlers/metafield_handlers/get_specific_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/metafield_handlers/count_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/metafield_handlers/list_metafields_query_parameters_handler.dart';
export 'handlers/shopify/rest_handlers/metafield_handlers/update_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/metafield_handlers/delete_metafield_handler.dart';

// 🌐 Online Store Handlers
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/list_all_article_authors_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/list_tags_specific_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/list_most_popular_tags_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/list_tags_all_articles_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/list_most_popular_tags_specific_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/list_articles_from_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/get_single_article_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/count_blog_articles_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/list_article_tags_specific_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/create_article_with_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/create_article_with_image_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/create_article_html_markup_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/create_article_base_image_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/create_unpublished_article_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/update_article_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/article_handlers/delete_article_from_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/asset_handlers/list_all_assets_theme_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/asset_handlers/get_liquid_template_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/asset_handlers/create_image_asset_base_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/asset_handlers/create_image_asset_source_url_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/asset_handlers/change_liquid_template_value_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/asset_handlers/duplicate_asset_source_key_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/asset_handlers/delete_image_from_theme_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/get_all_blogs_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/get_single_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/count_all_blogs_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/create_empty_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/create_empty_blog_with_metafield.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/metafield_existing_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/update_existing_blog_title_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/update_blog_title_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/blog_handlers/remove_blog_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/list_all_comments_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/get_single_comment_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/count_comments_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/update_comment_body_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/create_comment_textile_markup_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/approve_and_publish_comment_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/mark_comment_not_spam_restore_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/remove_comment_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/restore_remove_comment_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/comment_handlers/mark_comment_as_spam_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/list_all_pages_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/get_single_page_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/count_all_pages_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/create_page_with_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/create_page_html_markup_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/create_unpublished_page_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/update_existing_page_completely_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/add_metafield_to_page_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/show_hidden_page_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/update_body_html_of_page_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/hide_published_page_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/page_handlers/delete_page_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/list_all_redirects_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/get_single_redirect_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/count_all_redirects_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/create_redirect_full_url_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/create_redirect_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/update_redirect_path_uri_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/update_redirect_path_and_target_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/redirect_handlers/delete_redirect_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/script_tag_handler/list_all_script_tags_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/script_tag_handler/get_single_script_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/script_tag_handler/count_all_script_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/script_tag_handler/create_script_tag_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/script_tag_handler/update_script_tag_url_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/script_tag_handler/delete_script_tag_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/theme_handler/list_themes_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/theme_handler/get_single_theme_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/theme_handler/publish_unpublished_theme_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/theme_handler/update_theme_name_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/theme_handler/create_theme_handler.dart';
export 'handlers/shopify/rest_handlers/online_store_handlers/theme_handler/delete_theme_handler.dart';

// 📦 Products Handlers
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/get_collects_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/get_collects_by_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/get_collects_by_product_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/get_single_collect_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/get_collects_count_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/get_collects_count_by_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/get_collects_count_by_product_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/create_collect_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collect_handlers/delete_collect_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/retrieves_list_of_product_variants_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/retrieves_single_product_variant_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/retrieves_count_of_product_variants_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/create_product_variant_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/create_product_variant_with_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/create_product_variant_with_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/add_metafield_to_product_variant_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/add_image_to_product_variant_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/update_variant_title_and_price_handler.dart';

// 🛒 WooCommerce Handlers
export 'handlers/shopify/rest_handlers/products_handlers/product_variant_handlers/delete_product_variant_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/list_all_custom_collections_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/specific_custom_collections_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/count_custom_collections_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/create_custom_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/create_unpublished_custom_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/create_collection_with_collect_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/create_custom_collection_base_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/create_custom_collection_with_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/create_custom_collection_uploaded_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/update_custom_collection_description_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/update_custom_collection_new_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/update_custom_collection_alt_text_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/publish_hidden_custom_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/hide_published_custom_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/add_collect_to_collection_by_product_id_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/update_remove_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/add_metafield_to_custom_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/custom_collections_handlers/delete_custom_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/list_of_products_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/single_product_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/count_products_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/create_product_multi_variants_options_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/create_product_multi_variants_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/create_product_base_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/create_product_with_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/create_default_product_variant_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/create_product_downloaded_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/create_unpublished_product_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/add_metafield_to_product_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_add_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_reorder_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_title_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_clear_images_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_seo_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_with_variant_hadler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_reorder_variants_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/show_hidden_product_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/delete_product_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_handlers/update_product_tags_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collection_handlers/single_collection_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/collection_handlers/products_belonging_to_collection_handler.dart';

// 📸 Product Image Handlers
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/create_a_new_product_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/create_product_image_attachment_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/create_product_image_main_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/create_product_image_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/create_product_image_source_url_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/create_product_image_variant_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/delete_product_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/modify_an_existing_product_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/modify_product_image_add_metafield_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/modify_product_image_attach_variants_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/modify_product_image_position_alt_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/receive_a_count_of_all_product_images_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/receive_a_single_product_image_handler.dart';
export 'handlers/shopify/rest_handlers/products_handlers/product_image_handlers/receive_list_of_product_images_handler.dart';

// 🏪 Store Properties Handlers
export 'handlers/shopify/rest_handlers/store_properties_handlers/country_handlers/receive_list_of_countries_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/country_handlers/retrieves_count_of_countries_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/country_handlers/creates_new_country_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/country_handlers/creates_country_using_custom_tax_rate_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/country_handlers/creates_country_using_shopify_tax_rate_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/country_handlers/updates_existing_country_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/country_handlers/delete_country_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/currency_handlers/retrieves_list_of_currencies_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/policy_handlers/retrieves_list_of_shop_policies_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/province_handlers/retrieves_list_of_provinces_for_country_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/province_handlers/retrieves_count_of_provinces_for_country_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/province_handlers/updates_existing_province_for_country_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/shipping_zone_handlers/receive_list_of_shipping_zones_handler.dart';
export 'handlers/shopify/rest_handlers/store_properties_handlers/shop_handlers/retrieves_the_shop_configuration_handler.dart';

// 💳 Tender Transaction Handlers
export 'handlers/shopify/rest_handlers/tendertransaction_handlers/tendertransaction_handler/retrieve_list_of_tender_transactions_handler.dart';

// 🔔 Webhooks Handlers
export 'handlers/shopify/rest_handlers/webhooks_handlers/webhook_handlers/retrieve_list_of_webhooks_handler.dart';
export 'handlers/shopify/rest_handlers/webhooks_handlers/webhook_handlers/retrieve_a_webhook_handler.dart';
export 'handlers/shopify/rest_handlers/webhooks_handlers/webhook_handlers/retrieve_count_of_webhooks_handler.dart';
export 'handlers/shopify/rest_handlers/webhooks_handlers/webhook_handlers/create_webhook_handler.dart';
export 'handlers/shopify/rest_handlers/webhooks_handlers/webhook_handlers/update_webhook_handler.dart';
export 'handlers/shopify/rest_handlers/webhooks_handlers/webhook_handlers/delete_webhook_handler.dart';

// 🧠 Smart Collection Handlers
export 'handlers/shopify/rest_handlers/smart_collection_handlers/retrieves_list_of_smart_collections_handler.dart';
export 'handlers/shopify/rest_handlers/smart_collection_handlers/retrieves_single_smart_collection_handler.dart';
export 'handlers/shopify/rest_handlers/smart_collection_handlers/retrieves_count_of_smart_collections_handler.dart';
export 'handlers/shopify/rest_handlers/smart_collection_handlers/create_smart_collection_handler.dart';
export 'handlers/shopify/rest_handlers/smart_collection_handlers/updates_existing_smart_collection_handler.dart';
export 'handlers/shopify/rest_handlers/smart_collection_handlers/updates_ordering_type_of_products_smart_collection_handler.dart';
export 'handlers/shopify/rest_handlers/smart_collection_handlers/delete_smart_collection_handler.dart';

// 📦 Coupons Handlers
export 'handlers/woocommerce/admin_api_handlers/coupons_handlers/list_all_coupons_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/coupons_handlers/retrieve_coupon_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/coupons_handlers/create_coupon_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/coupons_handlers/update_coupon_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/coupons_handlers/delete_coupon_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/coupons_handlers/batch_update_coupons_handler.dart';

// 👥 Customers Handlers
export 'handlers/woocommerce/admin_api_handlers/customers_handlers/list_all_customers_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/customers_handlers/retrieve_customer_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/customers_handlers/create_customer_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/customers_handlers/update_customer_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/customers_handlers/delete_customer_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/customers_handlers/batch_update_customers_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/customers_handlers/batch_update_customer_id_handler.dart';

// 🛍️ Products Handlers
export 'handlers/woocommerce/admin_api_handlers/products_handlers/list_all_products_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/products_handlers/retrieve_product_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/products_handlers/create_product_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/products_handlers/update_product_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/products_handlers/delete_product_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/products_handlers/retrieve_product_custom_field_names_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/products_handlers/batch_update_products_handler.dart';

// 🏷️ Product Categories Handlers
export 'handlers/woocommerce/admin_api_handlers/product_categories_handlers/list_all_product_categories_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_categories_handlers/create_product_category_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_categories_handlers/retrieve_product_category_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_categories_handlers/update_product_category_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_categories_handlers/delete_product_category_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_categories_handlers/batch_update_product_categories_handler.dart';

// 🏷️ WooCommerce Product Reviews Handlers
export 'handlers/woocommerce/admin_api_handlers/product_reviews_handlers/list_all_product_reviews_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_reviews_handlers/create_product_review_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_reviews_handlers/retrieve_product_review_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_reviews_handlers/update_product_review_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_reviews_handlers/delete_product_review_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_reviews_handlers/batch_update_product_reviews_handler.dart';

// 📦 WooCommerce Product Shipping Classes Handlers
export 'handlers/woocommerce/admin_api_handlers/product_shipping_classes_handlers/list_all_product_shipping_classes_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_shipping_classes_handlers/create_product_shipping_class_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_shipping_classes_handlers/retrieve_product_shipping_class_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_shipping_classes_handlers/update_product_shipping_class_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_shipping_classes_handlers/delete_product_shipping_class_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_shipping_classes_handlers/batch_update_product_shipping_classes_handler.dart';

// 🏷️ WooCommerce Product Tags Handlers
export 'handlers/woocommerce/admin_api_handlers/product_tags_handlers/list_all_product_tags_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_tags_handlers/create_product_tag_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_tags_handlers/retrieve_product_tag_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_tags_handlers/update_product_tag_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_tags_handlers/delete_product_tag_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_tags_handlers/batch_update_product_tags_handler.dart';

// 🔄 WooCommerce Product Variations Handlers
export 'handlers/woocommerce/admin_api_handlers/product_variations_handlers/list_all_product_variations_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_variations_handlers/create_product_variation_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_variations_handlers/retrieve_product_variation_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_variations_handlers/update_product_variation_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_variations_handlers/delete_product_variation_handler.dart';

// 🏷️ WooCommerce Product Attributes Handlers
export 'handlers/woocommerce/admin_api_handlers/product_attributes_handlers/list_all_product_attributes_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attributes_handlers/create_product_attribute_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attributes_handlers/retrieve_product_attribute_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attributes_handlers/update_product_attribute_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attributes_handlers/delete_product_attribute_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attributes_handlers/batch_update_product_attributes_handler.dart';

// 🏷️ WooCommerce Product Attribute Terms Handlers
export 'handlers/woocommerce/admin_api_handlers/product_attribute_terms_handlers/list_all_product_attribute_terms_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attribute_terms_handlers/create_product_attribute_term_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attribute_terms_handlers/retrieve_product_attribute_term_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attribute_terms_handlers/update_product_attribute_term_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/product_attribute_terms_handlers/delete_product_attribute_term_handler.dart';

// 🔗 WooCommerce Webhooks Handlers
export 'handlers/woocommerce/admin_api_handlers/webhooks_handlers/list_all_webhooks_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/webhooks_handlers/create_webhook_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/webhooks_handlers/retrieve_webhook_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/webhooks_handlers/update_webhook_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/webhooks_handlers/delete_webhook_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/webhooks_handlers/batch_update_webhooks_handler.dart';

// 🔧 WooCommerce System Status Handlers
export 'handlers/woocommerce/admin_api_handlers/system_status_handlers/get_system_status_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/system_status_handlers/list_all_tools_from_system_status_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/system_status_handlers/retrieve_tool_from_system_status_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/system_status_handlers/run_tool_from_system_status_handler.dart';

// 🛒 Orders Handlers
export 'handlers/woocommerce/admin_api_handlers/orders_handlers/list_all_orders_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/orders_handlers/create_order_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/orders_handlers/retrieve_order_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/orders_handlers/update_order_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/orders_handlers/delete_order_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/orders_handlers/send_order_details_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/orders_handlers/batch_update_orders_handler.dart';

// 📝 Order Notes Handlers
export 'handlers/woocommerce/admin_api_handlers/order_notes_handlers/list_all_order_notes_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/order_notes_handlers/create_order_note_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/order_notes_handlers/retrieve_order_note_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/order_notes_handlers/delete_order_note_handler.dart';

// 🚚 WooCommerce Shipping Methods Handlers
export 'handlers/woocommerce/admin_api_handlers/shipping_methods_handlers/list_all_shipping_methods_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_methods_handlers/retrieve_shipping_method_handler.dart';

// 🚚 WooCommerce Shipping Zone Methods Handlers
export 'handlers/woocommerce/admin_api_handlers/shipping_zone_methods_handlers/list_all_shipping_methods_from_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zone_methods_handlers/include_shipping_method_to_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zone_methods_handlers/retrieve_shipping_method_from_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zone_methods_handlers/update_shipping_method_from_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zone_methods_handlers/delete_shipping_method_from_shipping_zone_handler.dart';

// 🚚 WooCommerce Shipping Zones Handlers
export 'handlers/woocommerce/admin_api_handlers/shipping_zones_handlers/list_all_shipping_zones_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zones_handlers/create_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zones_handlers/retrieve_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zones_handlers/update_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zones_handlers/delete_shipping_zone_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/shipping_zones_handlers/retrieve_shipping_zone_location_handler.dart';

// 💳 WooCommerce Payment Gateways Handlers
export 'handlers/woocommerce/admin_api_handlers/payment_gateways_handlers/list_all_payment_gateways_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/payment_gateways_handlers/retrieve_payment_gateway_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/payment_gateways_handlers/update_payment_gateway_handler.dart';

// 📊 WooCommerce Data Handlers
export 'handlers/woocommerce/admin_api_handlers/data_handlers/list_all_data_handler.dart';

// 🌍 WooCommerce Continents Handlers
export 'handlers/woocommerce/admin_api_handlers/continents_handlers/list_all_continents_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/continents_handlers/retrieve_continent_data_handler.dart';

// 🌍 WooCommerce Countries Handlers
export 'handlers/woocommerce/admin_api_handlers/countries_handlers/list_all_countries_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/countries_handlers/retrieve_country_data_handler.dart';

// 💰 WooCommerce Currencies Handlers
export 'handlers/woocommerce/admin_api_handlers/currencies_handlers/list_all_currencies_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/currencies_handlers/retrieve_currency_data_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/currencies_handlers/retrieve_current_currency_handler.dart';

// 💰 WooCommerce Refunds Handlers
export 'handlers/woocommerce/admin_api_handlers/refunds_handlers/list_all_refunds_handler.dart';

// 📊 Reports Handlers
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/list_all_reports_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/retrieve_report_sale_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/retrieve_top_seller_report_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/retrieve_order_totals_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/retrieve_product_totals_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/retrieve_customer_totals_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/retrieve_coupon_totals_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/reports_handlers/retrieve_review_totals_handler.dart';

// Setting handlers
export 'handlers/woocommerce/admin_api_handlers/settings_handlers/list_settings_groups_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/settings_handlers/retrieve_setting_option_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/settings_handlers/update_settings_option_handler.dart';

// Taxes handlers
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_classes_handlers/list_tax_classes_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_classes_handlers/create_tax_class_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_classes_handlers/delete_tax_class_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_rates_handlers/retrieve_tax_rate_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_rates_handlers/delete_tax_rate_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_rates_handlers/list_tax_rates_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_rates_handlers/create_tax_rate_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_rates_handlers/update_tax_rate_handler.dart';
export 'handlers/woocommerce/admin_api_handlers/taxes_handlers/taxes_rates_handlers/batch_update_taxes_rates_handler.dart';

// 💖 WooCommerce Wishlist Handlers
export 'handlers/woocommerce/wishlist_handlers/create_wishlist_group_handler.dart';
export 'handlers/woocommerce/wishlist_handlers/get_all_wishlist_groups_handler.dart';
export 'handlers/woocommerce/wishlist_handlers/update_wishlist_group_handler.dart';
export 'handlers/woocommerce/wishlist_handlers/delete_wishlist_group_handler.dart';
export 'handlers/woocommerce/wishlist_handlers/get_wishlist_items_handler.dart';
export 'handlers/woocommerce/wishlist_handlers/add_wishlist_item_handler.dart';
export 'handlers/woocommerce/wishlist_handlers/delete_wishlist_item_handler.dart';
