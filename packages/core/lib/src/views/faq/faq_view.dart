import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/src/models/faq_models.dart';
import 'package:core/src/views/faq/cubit/faq_cubit.dart';
import 'package:core/src/views/faq/cubit/faq_state.dart';
import 'package:core/src/views/faq/widgets/faq_startup_widget.dart';
import 'package:core/src/views/faq/widgets/faq_space_widget.dart';
import 'package:core/src/views/faq/widgets/faq_enterprise_widget.dart';

/// ❓ **OSMEA FAQ View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main FAQ view - Shows frequently asked questions with customizable styles
///
/// Features:
/// - 🎨 Three distinct FAQ styles: startup, space, enterprise
/// - 📄 Expandable FAQ items
/// - 🔍 Search functionality (optional)
/// - 🏷️ Category filtering (optional)
/// - ⚙️ Configurable from app_config.json
/// - 📱 Responsive design
///
/// Style Options:
/// - **Startup**: Modern and clean design
/// - **Space**: Minimalist with lots of whitespace
/// - **Enterprise**: Professional and structured
///
/// {@category Views}
/// {@subCategory FAQView}

class FAQView extends MasterViewCubit<FAQViewCubit, FAQViewState> {
  /// FAQ page configuration model
  final FAQPageModel? faqPageModel;

  /// FAQ configuration
  final FAQConfigModel? faqConfig;

  /// FAQ type for config lookup
  final String? faqType;

  /// Custom title (fallback)
  final String? title;

  /// Custom description (fallback)
  final String? description;

  /// Custom items (fallback)
  final List<FAQItem>? items;

  FAQView({
    super.key,
    required Function(String path) goRoute,
    Map<String, dynamic> arguments = const {'faq': true},
    this.faqPageModel,
    this.faqConfig,
    this.faqType,
    this.title,
    this.description,
    this.items,
  }) : super(
          goRoute: goRoute,
          arguments: arguments,
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.enabled(),
          useSafeArea: true,
          coreAppBar: (context, viewModel) {
            final state = viewModel.state;
            final model = state.model ?? faqPageModel;

            // Helper to parse color from string
            Color parseColor(String? colorString, Color fallback) {
              if (colorString == null || colorString.isEmpty) return fallback;
              try {
                if (colorString.startsWith('#')) {
                  final hexString = colorString.substring(1);
                  if (hexString.length == 6) {
                    return Color(int.parse('FF$hexString', radix: 16));
                  } else if (hexString.length == 8) {
                    return Color(int.parse(hexString, radix: 16));
                  }
                }
              } catch (e) {
                debugPrint('⚠️ Failed to parse color $colorString: $e');
              }
              return fallback;
            }

            // Get config helper and ensure config is loaded
            final configHelper = AssetConfigHelper();
            try {
              // Try to load config if not already loaded
              configHelper.loadConfig('assets/app_config.json');
            } catch (e) {
              debugPrint('⚠️ Could not load config in AppBar: $e');
            }

            // Always show AppBar - get title from config first, then model, then direct parameter
            String? appBarTitle;

            // Priority 1: Try to get from config synchronously (app_config.json)
            try {
              final faqConfigObj =
                  configHelper.getObject('faq_configuration');
              if (faqConfigObj != null) {
                // First try app_bar.title, then fallback to root title
                final appBarObj = faqConfigObj['app_bar'] as Map<String, dynamic>?;
                final appBarTitleFromConfig = appBarObj?['title'] as String?;
                if (appBarTitleFromConfig != null && appBarTitleFromConfig.isNotEmpty) {
                  appBarTitle = appBarTitleFromConfig;
                  debugPrint('✅ FAQ AppBar title from app_bar.title: $appBarTitle');
                } else {
                  final rootTitle = faqConfigObj['title'] as String?;
                  if (rootTitle != null && rootTitle.isNotEmpty) {
                    appBarTitle = rootTitle;
                    debugPrint('✅ FAQ AppBar title from root title: $appBarTitle');
                  }
                }
              }
            } catch (e) {
              debugPrint('⚠️ Could not get FAQ config for AppBar: $e');
            }

            // Priority 2: From model (only if config didn't provide)
            if (appBarTitle == null || appBarTitle.isEmpty) {
              if (model != null) {
                appBarTitle = model.title;
                debugPrint('✅ FAQ AppBar title from model: $appBarTitle');
              }
            }

            // Priority 3: Direct title parameter (only if config and model didn't provide)
            if (appBarTitle == null || appBarTitle.isEmpty) {
              if (title != null && title.isNotEmpty) {
                appBarTitle = title;
                debugPrint('✅ FAQ AppBar title from direct parameter: $appBarTitle');
              }
            }

            // Priority 4: Check from config model (only if still null)
            if (appBarTitle == null || appBarTitle.isEmpty) {
              if (faqConfig != null && faqType != null) {
                final configModel = faqConfig.getFAQPage(faqType);
                if (configModel != null) {
                  appBarTitle = configModel.title;
                  debugPrint('✅ FAQ AppBar title from config model: $appBarTitle');
                }
              }
            }

            // Fallback to default
            appBarTitle ??= 'FAQ';
            debugPrint('📋 Final FAQ AppBar title: $appBarTitle');

            // Get colors from config
            final backgroundColor = parseColor(
              configHelper.getString('faq_configuration.app_bar.backgroundColor'),
              parseColor(
                configHelper.getString('faq_configuration.background_color'),
                OsmeaColors.white,
              ),
            );

            final foregroundColor = parseColor(
              configHelper.getString('faq_configuration.app_bar.foregroundColor'),
              parseColor(
                configHelper.getString('faq_configuration.text_color'),
                OsmeaColors.black,
              ),
            );

            final titleColor = parseColor(
              configHelper.getString('faq_configuration.app_bar.titleColor'),
              foregroundColor,
            );

            final iconColor = parseColor(
              configHelper.getString('faq_configuration.app_bar.iconColor'),
              foregroundColor,
            );

            final elevation = configHelper.getDouble(
              'faq_configuration.app_bar.elevation',
              0.0,
            );

            // Build AppBar following OSMEA standards
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(
                appBarTitle,
                color: titleColor,
                textStyle: OsmeaTextStyle.titleLarge(context),
              ),
              variant: AppBarVariant.standard,
              size: AppBarSize.standard,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              elevation: elevation,
              leading: OsmeaComponents.iconButton(
                onPressed: () {
                  // Use goRoute from app router
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    goRoute('/profile'); // Navigate to profile using app router
                  }
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: iconColor,
                  size: context.iconSizeNormal,
                ),
                backgroundColor: OsmeaColors.transparent,
                tooltip: 'Back',
              ),
            );
          },
        );

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('❓ FAQ View Started!');

    // Load config first to ensure it's available
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');
    } catch (e) {
      debugPrint('⚠️ Could not load config: $e');
    }

    // Get effective FAQ configuration
    final effectiveModel = _getEffectiveFAQModel();

    // Load FAQ content
    viewModel.loadFAQ(effectiveModel);
  }

  /// Get effective FAQ model based on priority
  FAQPageModel _getEffectiveFAQModel() {
    // Priority 1: Direct model provided
    if (faqPageModel != null) {
      return faqPageModel!;
    }

    // Priority 2: From config with type
    if (faqConfig != null && faqType != null) {
      final configModel = faqConfig!.getFAQPage(faqType!);
      if (configModel != null) {
        return configModel;
      }
    }

    // Priority 3: Fallback model with provided values
    return _createFallbackModel();
  }

  /// Create fallback model
  FAQPageModel _createFallbackModel() {
    // Try to get all values from config
    FAQStyle style = FAQStyle.startup;
    String? configTitle;
    String? configDescription;
    List<FAQItem>? configItems;
    String? configBackgroundColor;
    String? configTextColor;
    String? configPrimaryColor;
    bool? configAllowMultipleExpanded;
    bool? configShowSearchBar;
    bool? configShowCategories;

    try {
      final configHelper = AssetConfigHelper();
      final faqConfig = configHelper.getObject('faq_configuration');

      if (faqConfig != null) {
        // Parse style
        final styleString = faqConfig['style'] as String? ?? '';
        if (styleString.isNotEmpty) {
          style = _stringToFAQStyle(styleString) ?? FAQStyle.startup;
        }

        // Get all values from faq_configuration
        configTitle = faqConfig['title'] as String?;
        configDescription = faqConfig['description'] as String?;
        configBackgroundColor = faqConfig['background_color'] as String?;
        configTextColor = faqConfig['text_color'] as String?;
        configPrimaryColor = faqConfig['primary_color'] as String?;
        configAllowMultipleExpanded =
            faqConfig['allow_multiple_expanded'] as bool?;
        configShowSearchBar = faqConfig['show_search_bar'] as bool?;
        configShowCategories = faqConfig['show_categories'] as bool?;

        // Parse items
        final itemsList = faqConfig['items'] as List<dynamic>?;
        if (itemsList != null) {
          configItems = itemsList
              .map((item) => FAQItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('⚠️ Could not load FAQ config: $e');
    }

    return FAQPageModel(
      title: title ?? configTitle ?? 'FAQ',
      description: description ?? configDescription,
      items: items ?? configItems ?? [],
      backgroundColor: configBackgroundColor,
      textColor: configTextColor,
      primaryColor: configPrimaryColor,
      style: style,
      allowMultipleExpanded: configAllowMultipleExpanded ?? true,
      showSearchBar: configShowSearchBar ?? false,
      showCategories: configShowCategories ?? false,
    );
  }

  /// Convert string to FAQStyle enum
  FAQStyle? _stringToFAQStyle(String styleString) {
    switch (styleString.toLowerCase()) {
      case 'startup':
        return FAQStyle.startup;
      case 'space':
        return FAQStyle.space;
      case 'enterprise':
        return FAQStyle.enterprise;
      default:
        return null;
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    // Get effective FAQ configuration
    final effectiveModel = _getEffectiveFAQModel();

    return BlocListener<FAQViewCubit, FAQViewState>(
      listener: (context, state) {
        if (state.hasError) {
          debugPrint('❌ FAQ view error: ${state.errorMessage}');
        }
      },
      child: FutureBuilder<FAQStyle>(
        future: _getFAQStyleFromConfig(effectiveModel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return _getFAQWidget(snapshot.data!, effectiveModel, viewModel);
          } else {
            debugPrint(
                '⚠️ Could not get FAQ style from config, using default');
            return _getFAQWidget(FAQStyle.startup, effectiveModel, viewModel);
          }
        },
      ),
    );
  }

  /// Get FAQ style from config or model
  Future<FAQStyle> _getFAQStyleFromConfig(FAQPageModel model) async {
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');

      final styleString =
          configHelper.getString('faq_configuration.style', '');
      if (styleString.isNotEmpty) {
        final style = _stringToFAQStyle(styleString);
        if (style != null) {
          debugPrint('✅ FAQ style from config: $styleString -> $style');
          return style;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Could not load style from config: $e');
    }

    // Return style from model
    return model.style;
  }

  /// Get appropriate FAQ widget based on style
  Widget _getFAQWidget(
      FAQStyle style, FAQPageModel model, FAQViewCubit cubit) {
    switch (style) {
      case FAQStyle.startup:
        return FAQStartupWidget(
          model: model,
          cubit: cubit,
        );
      case FAQStyle.space:
        return FAQSpaceWidget(
          model: model,
          cubit: cubit,
        );
      case FAQStyle.enterprise:
        return FAQEnterpriseWidget(
          model: model,
          cubit: cubit,
        );
    }
  }
}
