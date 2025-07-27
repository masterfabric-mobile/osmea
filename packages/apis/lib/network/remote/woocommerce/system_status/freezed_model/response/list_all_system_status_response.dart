// To parse this JSON data, do
//
//     final listAllSystemStatus = listAllSystemStatusFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:apis/helpers/json_config_helper.dart';
import 'dart:convert';

part 'list_all_system_status_response.freezed.dart';
part 'list_all_system_status_response.g.dart';

ListAllSystemStatus listAllSystemStatusFromJson(String str) =>
    ListAllSystemStatus.fromJson(json.decode(str));

String listAllSystemStatusToJson(ListAllSystemStatus data) =>
    json.encode(data.toJson());

class StringToIntConverter implements JsonConverter<int?, dynamic> {
  const StringToIntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is String) {
      if (json.isEmpty) return null;
      return int.tryParse(json);
    }
    return null;
  }

  @override
  dynamic toJson(int? object) => object;
}

@freezed
class ListAllSystemStatus with _$ListAllSystemStatus {
  const factory ListAllSystemStatus({
    @JsonKey(name: "environment") Environment? environment,
    @JsonKey(name: "database") Database? database,
    @JsonKey(name: "active_plugins") List<ActivePlugin>? activePlugins,
    @JsonKey(name: "inactive_plugins") List<InactivePlugin>? inactivePlugins,
    @JsonKey(name: "dropins_mu_plugins") DropinsMuPlugins? dropinsMuPlugins,
    @JsonKey(name: "theme") Theme? theme,
    @JsonKey(name: "settings") Settings? settings,
    @JsonKey(name: "security") Security? security,
    @JsonKey(name: "pages") List<Page>? pages,
    @JsonKey(name: "post_type_counts") List<PostTypeCount>? postTypeCounts,
    @JsonKey(name: "logging") Logging? logging,
  }) = _ListAllSystemStatus;

  factory ListAllSystemStatus.fromJson(Map<String, dynamic> json) =>
      _$ListAllSystemStatusFromJson(json);
}

@freezed
class ActivePlugin with _$ActivePlugin {
  const factory ActivePlugin({
    @JsonKey(name: "plugin") String? plugin,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "version") String? version,
    @JsonKey(name: "version_latest") String? versionLatest,
    @JsonKey(name: "url") String? url,
    @JsonKey(name: "author_name") String? authorName,
    @JsonKey(name: "author_url") String? authorUrl,
    @JsonKey(name: "network_activated") bool? networkActivated,
  }) = _ActivePlugin;

  factory ActivePlugin.fromJson(Map<String, dynamic> json) =>
      _$ActivePluginFromJson(json);
}

@freezed
class Database with _$Database {
  const factory Database({
    @JsonKey(name: "wc_database_version") String? wcDatabaseVersion,
    @JsonKey(name: "database_prefix") String? databasePrefix,
    @JsonKey(name: "maxmind_geoip_database") String? maxmindGeoipDatabase,
    @JsonKey(name: "database_tables") DatabaseTables? databaseTables,
    @JsonKey(name: "database_size") DatabaseSize? databaseSize,
  }) = _Database;

  factory Database.fromJson(Map<String, dynamic> json) =>
      _$DatabaseFromJson(json);
}

@freezed
class DatabaseSize with _$DatabaseSize {
  const factory DatabaseSize({
    @JsonKey(name: "data") double? data,
    @JsonKey(name: "index") double? index,
  }) = _DatabaseSize;

  factory DatabaseSize.fromJson(Map<String, dynamic> json) =>
      _$DatabaseSizeFromJson(json);
}

@freezed
class DatabaseTables with _$DatabaseTables {
  const factory DatabaseTables({
    @JsonKey(name: "woocommerce") Woocommerce? woocommerce,
    @JsonKey(name: "other") Other? other,
  }) = _DatabaseTables;

  factory DatabaseTables.fromJson(Map<String, dynamic> json) =>
      _$DatabaseTablesFromJson(json);
}

@freezed
class Other with _$Other {
  const factory Other({
    @JsonKey(name: "wp_actionscheduler_actions") Wp? wpActionschedulerActions,
    @JsonKey(name: "wp_actionscheduler_claims") Wp? wpActionschedulerClaims,
    @JsonKey(name: "wp_actionscheduler_groups") Wp? wpActionschedulerGroups,
    @JsonKey(name: "wp_actionscheduler_logs") Wp? wpActionschedulerLogs,
    @JsonKey(name: "wp_commentmeta") Wp? wpCommentmeta,
    @JsonKey(name: "wp_comments") Wp? wpComments,
    @JsonKey(name: "wp_links") Wp? wpLinks,
    @JsonKey(name: "wp_options") Wp? wpOptions,
    @JsonKey(name: "wp_postmeta") Wp? wpPostmeta,
    @JsonKey(name: "wp_posts") Wp? wpPosts,
    @JsonKey(name: "wp_termmeta") Wp? wpTermmeta,
    @JsonKey(name: "wp_terms") Wp? wpTerms,
    @JsonKey(name: "wp_term_relationships") Wp? wpTermRelationships,
    @JsonKey(name: "wp_term_taxonomy") Wp? wpTermTaxonomy,
    @JsonKey(name: "wp_usermeta") Wp? wpUsermeta,
    @JsonKey(name: "wp_users") Wp? wpUsers,
    @JsonKey(name: "wp_wc_admin_notes") Wp? wpWcAdminNotes,
    @JsonKey(name: "wp_wc_admin_note_actions") Wp? wpWcAdminNoteActions,
    @JsonKey(name: "wp_wc_category_lookup") Wp? wpWcCategoryLookup,
    @JsonKey(name: "wp_wc_customer_lookup") Wp? wpWcCustomerLookup,
    @JsonKey(name: "wp_wc_download_log") Wp? wpWcDownloadLog,
    @JsonKey(name: "wp_wc_orders") Wp? wpWcOrders,
    @JsonKey(name: "wp_wc_orders_meta") Wp? wpWcOrdersMeta,
    @JsonKey(name: "wp_wc_order_addresses") Wp? wpWcOrderAddresses,
    @JsonKey(name: "wp_wc_order_coupon_lookup") Wp? wpWcOrderCouponLookup,
    @JsonKey(name: "wp_wc_order_operational_data") Wp? wpWcOrderOperationalData,
    @JsonKey(name: "wp_wc_order_product_lookup") Wp? wpWcOrderProductLookup,
    @JsonKey(name: "wp_wc_order_stats") Wp? wpWcOrderStats,
    @JsonKey(name: "wp_wc_order_tax_lookup") Wp? wpWcOrderTaxLookup,
    @JsonKey(name: "wp_wc_product_attributes_lookup")
    Wp? wpWcProductAttributesLookup,
    @JsonKey(name: "wp_wc_product_download_directories")
    Wp? wpWcProductDownloadDirectories,
    @JsonKey(name: "wp_wc_product_meta_lookup") Wp? wpWcProductMetaLookup,
    @JsonKey(name: "wp_wc_rate_limits") Wp? wpWcRateLimits,
    @JsonKey(name: "wp_wc_reserved_stock") Wp? wpWcReservedStock,
    @JsonKey(name: "wp_wc_tax_rate_classes") Wp? wpWcTaxRateClasses,
    @JsonKey(name: "wp_wc_webhooks") Wp? wpWcWebhooks,
  }) = _Other;

  factory Other.fromJson(Map<String, dynamic> json) => _$OtherFromJson(json);
}

@freezed
class Wp with _$Wp {
  const factory Wp({
    @JsonKey(name: "data") String? data,
    @JsonKey(name: "index") String? index,
    @JsonKey(name: "engine") String? engine,
  }) = _Wp;

  factory Wp.fromJson(Map<String, dynamic> json) => _$WpFromJson(json);
}

@freezed
class Woocommerce with _$Woocommerce {
  const factory Woocommerce({
    @JsonKey(name: "wp_woocommerce_sessions") Wp? wpWoocommerceSessions,
    @JsonKey(name: "wp_woocommerce_api_keys") Wp? wpWoocommerceApiKeys,
    @JsonKey(name: "wp_woocommerce_attribute_taxonomies")
    Wp? wpWoocommerceAttributeTaxonomies,
    @JsonKey(name: "wp_woocommerce_downloadable_product_permissions")
    Wp? wpWoocommerceDownloadableProductPermissions,
    @JsonKey(name: "wp_woocommerce_order_items") Wp? wpWoocommerceOrderItems,
    @JsonKey(name: "wp_woocommerce_order_itemmeta")
    Wp? wpWoocommerceOrderItemmeta,
    @JsonKey(name: "wp_woocommerce_tax_rates") Wp? wpWoocommerceTaxRates,
    @JsonKey(name: "wp_woocommerce_tax_rate_locations")
    Wp? wpWoocommerceTaxRateLocations,
    @JsonKey(name: "wp_woocommerce_shipping_zones")
    Wp? wpWoocommerceShippingZones,
    @JsonKey(name: "wp_woocommerce_shipping_zone_locations")
    Wp? wpWoocommerceShippingZoneLocations,
    @JsonKey(name: "wp_woocommerce_shipping_zone_methods")
    Wp? wpWoocommerceShippingZoneMethods,
    @JsonKey(name: "wp_woocommerce_payment_tokens")
    Wp? wpWoocommercePaymentTokens,
    @JsonKey(name: "wp_woocommerce_payment_tokenmeta")
    Wp? wpWoocommercePaymentTokenmeta,
    @JsonKey(name: "wp_woocommerce_log") Wp? wpWoocommerceLog,
  }) = _Woocommerce;

  factory Woocommerce.fromJson(Map<String, dynamic> json) =>
      _$WoocommerceFromJson(json);
}

@freezed
class DropinsMuPlugins with _$DropinsMuPlugins {
  const factory DropinsMuPlugins({
    @JsonKey(name: "dropins") List<dynamic>? dropins,
    @JsonKey(name: "mu_plugins") List<dynamic>? muPlugins,
  }) = _DropinsMuPlugins;

  factory DropinsMuPlugins.fromJson(Map<String, dynamic> json) =>
      _$DropinsMuPluginsFromJson(json);
}

@freezed
class Environment with _$Environment {
  const factory Environment({
    @JsonKey(name: "home_url") String? homeUrl,
    @JsonKey(name: "site_url") String? siteUrl,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "version") String? version,
    @JsonKey(name: "log_directory") String? logDirectory,
    @JsonKey(name: "log_directory_writable") bool? logDirectoryWritable,
    @JsonKey(name: "wp_version") String? wpVersion,
    @JsonKey(name: "wp_multisite") bool? wpMultisite,
    @JsonKey(name: "wp_memory_limit") int? wpMemoryLimit,
    @JsonKey(name: "wp_debug_mode") bool? wpDebugMode,
    @JsonKey(name: "wp_cron") bool? wpCron,
    @JsonKey(name: "language") String? language,
    @JsonKey(name: "external_object_cache") dynamic externalObjectCache,
    @JsonKey(name: "server_info") String? serverInfo,
    @JsonKey(name: "server_architecture") String? serverArchitecture,
    @JsonKey(name: "php_version") String? phpVersion,
    @JsonKey(name: "php_post_max_size") int? phpPostMaxSize,
    @JsonKey(name: "php_max_execution_time") int? phpMaxExecutionTime,
    @JsonKey(name: "php_max_input_vars") int? phpMaxInputVars,
    @JsonKey(name: "curl_version") String? curlVersion,
    @JsonKey(name: "suhosin_installed") bool? suhosinInstalled,
    @JsonKey(name: "max_upload_size") int? maxUploadSize,
    @JsonKey(name: "mysql_version") String? mysqlVersion,
    @JsonKey(name: "mysql_version_string") String? mysqlVersionString,
    @JsonKey(name: "default_timezone") String? defaultTimezone,
    @JsonKey(name: "fsockopen_or_curl_enabled") bool? fsockopenOrCurlEnabled,
    @JsonKey(name: "soapclient_enabled") bool? soapclientEnabled,
    @JsonKey(name: "domdocument_enabled") bool? domdocumentEnabled,
    @JsonKey(name: "gzip_enabled") bool? gzipEnabled,
    @JsonKey(name: "mbstring_enabled") bool? mbstringEnabled,
    @JsonKey(name: "remote_post_successful") bool? remotePostSuccessful,
    @JsonKey(name: "remote_post_response")
    @StringToIntConverter()
    int? remotePostResponse,
    @JsonKey(name: "remote_get_successful") bool? remoteGetSuccessful,
    @JsonKey(name: "remote_get_response")
    @StringToIntConverter()
    int? remoteGetResponse,
  }) = _Environment;

  factory Environment.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentFromJson(json);
}

@freezed
class InactivePlugin with _$InactivePlugin {
  const factory InactivePlugin({
    @JsonKey(name: "plugin") String? plugin,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "version") String? version,
    @JsonKey(name: "version_latest") String? versionLatest,
    @JsonKey(name: "url") String? url,
    @JsonKey(name: "author_name") String? authorName,
    @JsonKey(name: "author_url") String? authorUrl,
    @JsonKey(name: "network_activated") bool? networkActivated,
  }) = _InactivePlugin;

  factory InactivePlugin.fromJson(Map<String, dynamic> json) =>
      _$InactivePluginFromJson(json);
}

@freezed
class Logging with _$Logging {
  const factory Logging({
    @JsonKey(name: "logging_enabled") bool? loggingEnabled,
    @JsonKey(name: "default_handler") String? defaultHandler,
    @JsonKey(name: "retention_period_days") int? retentionPeriodDays,
    @JsonKey(name: "level_threshold") String? levelThreshold,
    @JsonKey(name: "log_directory_size") String? logDirectorySize,
  }) = _Logging;

  factory Logging.fromJson(Map<String, dynamic> json) =>
      _$LoggingFromJson(json);
}

@freezed
class Page with _$Page {
  const factory Page({
    @JsonKey(name: "page_name") String? pageName,
    @JsonKey(name: "page_id") String? pageId,
    @JsonKey(name: "page_set") bool? pageSet,
    @JsonKey(name: "page_exists") bool? pageExists,
    @JsonKey(name: "page_visible") bool? pageVisible,
    @JsonKey(name: "shortcode") String? shortcode,
    @JsonKey(name: "block") String? block,
    @JsonKey(name: "shortcode_required") bool? shortcodeRequired,
    @JsonKey(name: "shortcode_present") bool? shortcodePresent,
    @JsonKey(name: "block_present") bool? blockPresent,
    @JsonKey(name: "block_required") bool? blockRequired,
  }) = _Page;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}

@freezed
class PostTypeCount with _$PostTypeCount {
  const factory PostTypeCount({
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "count") String? count,
  }) = _PostTypeCount;

  factory PostTypeCount.fromJson(Map<String, dynamic> json) =>
      _$PostTypeCountFromJson(json);
}

@freezed
class Security with _$Security {
  const factory Security({
    @JsonKey(name: "secure_connection") bool? secureConnection,
    @JsonKey(name: "hide_errors") bool? hideErrors,
  }) = _Security;

  factory Security.fromJson(Map<String, dynamic> json) =>
      _$SecurityFromJson(json);
}

@freezed
class Settings with _$Settings {
  const factory Settings({
    @JsonKey(name: "api_enabled") bool? apiEnabled,
    @JsonKey(name: "force_ssl") bool? forceSsl,
    @JsonKey(name: "currency") String? currency,
    @JsonKey(name: "currency_symbol") String? currencySymbol,
    @JsonKey(name: "currency_position") String? currencyPosition,
    @JsonKey(name: "thousand_separator") String? thousandSeparator,
    @JsonKey(name: "decimal_separator") String? decimalSeparator,
    @JsonKey(name: "number_of_decimals") int? numberOfDecimals,
    @JsonKey(name: "geolocation_enabled") bool? geolocationEnabled,
    @JsonKey(name: "taxonomies") Taxonomies? taxonomies,
    @JsonKey(name: "product_visibility_terms")
    ProductVisibilityTerms? productVisibilityTerms,
    @JsonKey(name: "woocommerce_com_connected") String? woocommerceComConnected,
    @JsonKey(name: "enforce_approved_download_dirs")
    bool? enforceApprovedDownloadDirs,
    @JsonKey(name: "order_datastore") String? orderDatastore,
    @JsonKey(name: "HPOS_enabled") bool? hposEnabled,
    @JsonKey(name: "HPOS_sync_enabled") bool? hposSyncEnabled,
    @JsonKey(name: "enabled_features") List<String>? enabledFeatures,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}

@freezed
class ProductVisibilityTerms with _$ProductVisibilityTerms {
  const factory ProductVisibilityTerms({
    @JsonKey(name: "exclude-from-catalog") String? excludeFromCatalog,
    @JsonKey(name: "exclude-from-search") String? excludeFromSearch,
    @JsonKey(name: "featured") String? featured,
    @JsonKey(name: "outofstock") String? outofstock,
    @JsonKey(name: "rated-1") String? rated1,
    @JsonKey(name: "rated-2") String? rated2,
    @JsonKey(name: "rated-3") String? rated3,
    @JsonKey(name: "rated-4") String? rated4,
    @JsonKey(name: "rated-5") String? rated5,
  }) = _ProductVisibilityTerms;

  factory ProductVisibilityTerms.fromJson(Map<String, dynamic> json) =>
      _$ProductVisibilityTermsFromJson(json);
}

@freezed
class Taxonomies with _$Taxonomies {
  const factory Taxonomies({
    @JsonKey(name: "external") String? taxonomiesExternal,
    @JsonKey(name: "grouped") String? grouped,
    @JsonKey(name: "simple") String? simple,
    @JsonKey(name: "variable") String? variable,
  }) = _Taxonomies;

  factory Taxonomies.fromJson(Map<String, dynamic> json) =>
      _$TaxonomiesFromJson(json);
}

@freezed
class Theme with _$Theme {
  const factory Theme({
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "version") String? version,
    @JsonKey(name: "version_latest") String? versionLatest,
    @JsonKey(name: "author_url") String? authorUrl,
    @JsonKey(name: "is_child_theme") bool? isChildTheme,
    @JsonKey(name: "is_block_theme") bool? isBlockTheme,
    @JsonKey(name: "has_woocommerce_support") bool? hasWoocommerceSupport,
    @JsonKey(name: "has_woocommerce_file") bool? hasWoocommerceFile,
    @JsonKey(name: "has_outdated_templates") bool? hasOutdatedTemplates,
    @JsonKey(name: "overrides") List<Override>? overrides,
    @JsonKey(name: "parent_name") String? parentName,
    @JsonKey(name: "parent_version") String? parentVersion,
    @JsonKey(name: "parent_version_latest") String? parentVersionLatest,
    @JsonKey(name: "parent_author_url") String? parentAuthorUrl,
  }) = _Theme;

  factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
}

@freezed
class Override with _$Override {
  const factory Override({
    @JsonKey(name: "file") String? file,
    @JsonKey(name: "version") String? version,
    @JsonKey(name: "core_version") String? coreVersion,
  }) = _Override;

  factory Override.fromJson(Map<String, dynamic> json) =>
      _$OverrideFromJson(json);
}
