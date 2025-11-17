// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_users_me_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUsersMeRequestImpl _$$GetUsersMeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUsersMeRequestImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      url: json['url'] as String?,
      description: json['description'] as String?,
      link: json['link'] as String?,
      slug: json['slug'] as String?,
      avatarUrls: json['avatar_urls'] == null
          ? null
          : AvatarUrls.fromJson(json['avatar_urls'] as Map<String, dynamic>),
      meta: json['meta'] as List<dynamic>?,
      isSuperAdmin: json['is_super_admin'] as bool?,
      woocommerceMeta: json['woocommerce_meta'] == null
          ? null
          : WoocommerceMeta.fromJson(
              json['woocommerce_meta'] as Map<String, dynamic>),
      links: json['_links'] == null
          ? null
          : Links.fromJson(json['_links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetUsersMeRequestImplToJson(
    _$GetUsersMeRequestImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('url', instance.url);
  writeNotNull('description', instance.description);
  writeNotNull('link', instance.link);
  writeNotNull('slug', instance.slug);
  writeNotNull('avatar_urls', instance.avatarUrls?.toJson());
  writeNotNull('meta', instance.meta);
  writeNotNull('is_super_admin', instance.isSuperAdmin);
  writeNotNull('woocommerce_meta', instance.woocommerceMeta?.toJson());
  writeNotNull('_links', instance.links?.toJson());
  return val;
}

_$AvatarUrlsImpl _$$AvatarUrlsImplFromJson(Map<String, dynamic> json) =>
    _$AvatarUrlsImpl(
      the24: json['24'] as String?,
      the48: json['48'] as String?,
      the96: json['96'] as String?,
    );

Map<String, dynamic> _$$AvatarUrlsImplToJson(_$AvatarUrlsImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('24', instance.the24);
  writeNotNull('48', instance.the48);
  writeNotNull('96', instance.the96);
  return val;
}

_$LinksImpl _$$LinksImplFromJson(Map<String, dynamic> json) => _$LinksImpl(
      self: (json['self'] as List<dynamic>?)
          ?.map((e) => Self.fromJson(e as Map<String, dynamic>))
          .toList(),
      collection: (json['collection'] as List<dynamic>?)
          ?.map((e) => Collection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LinksImplToJson(_$LinksImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('self', instance.self?.map((e) => e.toJson()).toList());
  writeNotNull(
      'collection', instance.collection?.map((e) => e.toJson()).toList());
  return val;
}

_$CollectionImpl _$$CollectionImplFromJson(Map<String, dynamic> json) =>
    _$CollectionImpl(
      href: json['href'] as String?,
    );

Map<String, dynamic> _$$CollectionImplToJson(_$CollectionImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('href', instance.href);
  return val;
}

_$SelfImpl _$$SelfImplFromJson(Map<String, dynamic> json) => _$SelfImpl(
      href: json['href'] as String?,
      targetHints: json['targetHints'] == null
          ? null
          : TargetHints.fromJson(json['targetHints'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SelfImplToJson(_$SelfImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('href', instance.href);
  writeNotNull('targetHints', instance.targetHints?.toJson());
  return val;
}

_$TargetHintsImpl _$$TargetHintsImplFromJson(Map<String, dynamic> json) =>
    _$TargetHintsImpl(
      allow:
          (json['allow'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$TargetHintsImplToJson(_$TargetHintsImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('allow', instance.allow);
  return val;
}

_$WoocommerceMetaImpl _$$WoocommerceMetaImplFromJson(
        Map<String, dynamic> json) =>
    _$WoocommerceMetaImpl(
      variableProductTourShown: json['variable_product_tour_shown'] as String?,
      activityPanelInboxLastRead:
          json['activity_panel_inbox_last_read'] as String?,
      activityPanelReviewsLastRead:
          json['activity_panel_reviews_last_read'] as String?,
      categoriesReportColumns: json['categories_report_columns'] as String?,
      couponsReportColumns: json['coupons_report_columns'] as String?,
      customersReportColumns: json['customers_report_columns'] as String?,
      ordersReportColumns: json['orders_report_columns'] as String?,
      productsReportColumns: json['products_report_columns'] as String?,
      revenueReportColumns: json['revenue_report_columns'] as String?,
      taxesReportColumns: json['taxes_report_columns'] as String?,
      variationsReportColumns: json['variations_report_columns'] as String?,
      dashboardSections: json['dashboard_sections'] as String?,
      dashboardChartType: json['dashboard_chart_type'] as String?,
      dashboardChartInterval: json['dashboard_chart_interval'] as String?,
      dashboardLeaderboardRows: json['dashboard_leaderboard_rows'] as String?,
      orderAttributionInstallBannerDismissed:
          json['order_attribution_install_banner_dismissed'] as String?,
      homepageLayout: json['homepage_layout'] as String?,
      homepageStats: json['homepage_stats'] as String?,
      taskListTrackedStartedTasks:
          json['task_list_tracked_started_tasks'] as String?,
      androidAppBannerDismissed:
          json['android_app_banner_dismissed'] as String?,
      launchYourStoreTourHidden:
          json['launch_your_store_tour_hidden'] as String?,
      comingSoonBannerDismissed:
          json['coming_soon_banner_dismissed'] as String?,
    );

Map<String, dynamic> _$$WoocommerceMetaImplToJson(
    _$WoocommerceMetaImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'variable_product_tour_shown', instance.variableProductTourShown);
  writeNotNull(
      'activity_panel_inbox_last_read', instance.activityPanelInboxLastRead);
  writeNotNull('activity_panel_reviews_last_read',
      instance.activityPanelReviewsLastRead);
  writeNotNull('categories_report_columns', instance.categoriesReportColumns);
  writeNotNull('coupons_report_columns', instance.couponsReportColumns);
  writeNotNull('customers_report_columns', instance.customersReportColumns);
  writeNotNull('orders_report_columns', instance.ordersReportColumns);
  writeNotNull('products_report_columns', instance.productsReportColumns);
  writeNotNull('revenue_report_columns', instance.revenueReportColumns);
  writeNotNull('taxes_report_columns', instance.taxesReportColumns);
  writeNotNull('variations_report_columns', instance.variationsReportColumns);
  writeNotNull('dashboard_sections', instance.dashboardSections);
  writeNotNull('dashboard_chart_type', instance.dashboardChartType);
  writeNotNull('dashboard_chart_interval', instance.dashboardChartInterval);
  writeNotNull('dashboard_leaderboard_rows', instance.dashboardLeaderboardRows);
  writeNotNull('order_attribution_install_banner_dismissed',
      instance.orderAttributionInstallBannerDismissed);
  writeNotNull('homepage_layout', instance.homepageLayout);
  writeNotNull('homepage_stats', instance.homepageStats);
  writeNotNull(
      'task_list_tracked_started_tasks', instance.taskListTrackedStartedTasks);
  writeNotNull(
      'android_app_banner_dismissed', instance.androidAppBannerDismissed);
  writeNotNull(
      'launch_your_store_tour_hidden', instance.launchYourStoreTourHidden);
  writeNotNull(
      'coming_soon_banner_dismissed', instance.comingSoonBannerDismissed);
  return val;
}
