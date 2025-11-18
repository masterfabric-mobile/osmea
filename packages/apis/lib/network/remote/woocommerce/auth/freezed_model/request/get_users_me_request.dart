// To parse this JSON data, do
//
//     final getUsersMeRequest = getUsersMeRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_users_me_request.freezed.dart';
part 'get_users_me_request.g.dart';

GetUsersMeRequest getUsersMeRequestFromJson(String str) => GetUsersMeRequest.fromJson(json.decode(str));

String getUsersMeRequestToJson(GetUsersMeRequest data) => json.encode(data.toJson());

@freezed
class GetUsersMeRequest with _$GetUsersMeRequest {
    const factory GetUsersMeRequest({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "name")
        String? name,
        @JsonKey(name: "url")
        String? url,
        @JsonKey(name: "description")
        String? description,
        @JsonKey(name: "link")
        String? link,
        @JsonKey(name: "slug")
        String? slug,
        @JsonKey(name: "avatar_urls")
        AvatarUrls? avatarUrls,
        @JsonKey(name: "meta")
        List<dynamic>? meta,
        @JsonKey(name: "is_super_admin")
        bool? isSuperAdmin,
        @JsonKey(name: "woocommerce_meta")
        WoocommerceMeta? woocommerceMeta,
        @JsonKey(name: "_links")
        Links? links,
    }) = _GetUsersMeRequest;

    factory GetUsersMeRequest.fromJson(Map<String, dynamic> json) => _$GetUsersMeRequestFromJson(json);
}

@freezed
class AvatarUrls with _$AvatarUrls {
    const factory AvatarUrls({
        @JsonKey(name: "24")
        String? the24,
        @JsonKey(name: "48")
        String? the48,
        @JsonKey(name: "96")
        String? the96,
    }) = _AvatarUrls;

    factory AvatarUrls.fromJson(Map<String, dynamic> json) => _$AvatarUrlsFromJson(json);
}

@freezed
class Links with _$Links {
    const factory Links({
        @JsonKey(name: "self")
        List<Self>? self,
        @JsonKey(name: "collection")
        List<Collection>? collection,
    }) = _Links;

    factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
}

@freezed
class Collection with _$Collection {
    const factory Collection({
        @JsonKey(name: "href")
        String? href,
    }) = _Collection;

    factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);
}

@freezed
class Self with _$Self {
    const factory Self({
        @JsonKey(name: "href")
        String? href,
        @JsonKey(name: "targetHints")
        TargetHints? targetHints,
    }) = _Self;

    factory Self.fromJson(Map<String, dynamic> json) => _$SelfFromJson(json);
}

@freezed
class TargetHints with _$TargetHints {
    const factory TargetHints({
        @JsonKey(name: "allow")
        List<String>? allow,
    }) = _TargetHints;

    factory TargetHints.fromJson(Map<String, dynamic> json) => _$TargetHintsFromJson(json);
}

@freezed
class WoocommerceMeta with _$WoocommerceMeta {
    const factory WoocommerceMeta({
        @JsonKey(name: "variable_product_tour_shown")
        String? variableProductTourShown,
        @JsonKey(name: "activity_panel_inbox_last_read")
        String? activityPanelInboxLastRead,
        @JsonKey(name: "activity_panel_reviews_last_read")
        String? activityPanelReviewsLastRead,
        @JsonKey(name: "categories_report_columns")
        String? categoriesReportColumns,
        @JsonKey(name: "coupons_report_columns")
        String? couponsReportColumns,
        @JsonKey(name: "customers_report_columns")
        String? customersReportColumns,
        @JsonKey(name: "orders_report_columns")
        String? ordersReportColumns,
        @JsonKey(name: "products_report_columns")
        String? productsReportColumns,
        @JsonKey(name: "revenue_report_columns")
        String? revenueReportColumns,
        @JsonKey(name: "taxes_report_columns")
        String? taxesReportColumns,
        @JsonKey(name: "variations_report_columns")
        String? variationsReportColumns,
        @JsonKey(name: "dashboard_sections")
        String? dashboardSections,
        @JsonKey(name: "dashboard_chart_type")
        String? dashboardChartType,
        @JsonKey(name: "dashboard_chart_interval")
        String? dashboardChartInterval,
        @JsonKey(name: "dashboard_leaderboard_rows")
        String? dashboardLeaderboardRows,
        @JsonKey(name: "order_attribution_install_banner_dismissed")
        String? orderAttributionInstallBannerDismissed,
        @JsonKey(name: "homepage_layout")
        String? homepageLayout,
        @JsonKey(name: "homepage_stats")
        String? homepageStats,
        @JsonKey(name: "task_list_tracked_started_tasks")
        String? taskListTrackedStartedTasks,
        @JsonKey(name: "android_app_banner_dismissed")
        String? androidAppBannerDismissed,
        @JsonKey(name: "launch_your_store_tour_hidden")
        String? launchYourStoreTourHidden,
        @JsonKey(name: "coming_soon_banner_dismissed")
        String? comingSoonBannerDismissed,
    }) = _WoocommerceMeta;

    factory WoocommerceMeta.fromJson(Map<String, dynamic> json) => _$WoocommerceMetaFromJson(json);
}
