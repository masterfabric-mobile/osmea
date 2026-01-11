import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/src/views/about/widgets/about_startup_widget.dart';
import 'package:core/src/views/about/widgets/about_space_widget.dart';
import 'package:core/src/views/about/widgets/about_enterprise_widget.dart';

/// 📄 **OSMEA About View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main about view - Shows about information with customizable styles
/// Supports HTML content and fullscreen web view for URLs
///
/// Features:
/// - 🎨 Three distinct about styles: startup, space, enterprise
/// - 📄 HTML content support via WebViewerHelper
/// - 🌐 Fullscreen web view for URLs
/// - ⚙️ Configurable from app_config.json
/// - 📱 Responsive design
///
/// Style Options:
/// - **Startup**: Modern and clean design
/// - **Space**: Minimalist with lots of whitespace
/// - **Enterprise**: Professional and structured
///
/// Usage Examples:
/// ```dart
/// // Simple usage with model
/// AboutView(
///   goRoute: goRoute,
///   aboutPageModel: aboutModel,
/// )
///
/// // With HTML content
/// AboutView(
///   goRoute: goRoute,
///   aboutPageModel: AboutPageModel(
///     title: 'About Us',
///     htmlContent: '<h1>Hello World</h1>',
///     style: AboutStyle.startup,
///   ),
/// )
///
/// // With URL (opens in fullscreen web view)
/// AboutView(
///   goRoute: goRoute,
///   aboutPageModel: AboutPageModel(
///     title: 'About Us',
///     url: 'https://example.com/about',
///     style: AboutStyle.enterprise,
///   ),
/// )
/// ```
///
/// {@category Views}
/// {@subCategory AboutView}

class AboutView extends MasterViewCubit<AboutViewCubit, AboutViewState> {
  /// About page configuration model
  final AboutPageModel? aboutPageModel;

  /// About configuration
  final AboutConfigModel? aboutConfig;

  /// About type for config lookup
  final String? aboutType;

  /// Custom title (fallback)
  final String? title;

  /// Custom description (fallback)
  final String? description;

  /// Custom HTML content (fallback)
  final String? htmlContent;

  /// Custom URL (fallback)
  final String? url;

  AboutView({
    super.key,
    required Function(String path) goRoute,
    Map<String, dynamic> arguments = const {'about': true},
    this.aboutPageModel,
    this.aboutConfig,
    this.aboutType,
    this.title,
    this.description,
    this.htmlContent,
    this.url,
  }) : super(
          goRoute: goRoute,
          arguments: arguments,
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.enabled(),
          useSafeArea: () {
            // Check if URL exists - if yes, disable SafeArea for web view
            // Otherwise, enable SafeArea for regular content
            // Priority: direct url parameter > aboutPageModel.url > config
            if (url != null && url.isNotEmpty) {
              return false; // Web view - no SafeArea
            }
            if (aboutPageModel?.hasUrl == true) {
              return false; // Web view - no SafeArea
            }
            return true; // Regular content - use SafeArea
          }(),
          coreAppBar: (context, viewModel) {
            // Check if URL exists from state or model
            final state = viewModel.state;
            final model = state.model ?? aboutPageModel;

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

            // Get config helper
            final configHelper = AssetConfigHelper();

            // Always show AppBar - get title from model, direct parameter, or config
            String appBarTitle = 'About';

            // Priority 1: From model
            if (model != null) {
              appBarTitle = model.title;
            } else if (title != null && title.isNotEmpty) {
              // Priority 2: Direct title parameter
              appBarTitle = title;
            } else {
              // Priority 3: Try to get from config synchronously
              try {
                final aboutConfigObj =
                    configHelper.getObject('about_configuration');
                if (aboutConfigObj != null) {
                  appBarTitle = aboutConfigObj['title'] as String? ?? 'About';
                }
              } catch (e) {
                debugPrint('⚠️ Could not get about config for AppBar: $e');
              }

              // Priority 4: Check from config model
              if (aboutConfig != null && aboutType != null) {
                final configModel = aboutConfig.getAboutPage(aboutType);
                if (configModel != null) {
                  appBarTitle = configModel.title;
                }
              }
            }

            // Get colors from config - same pattern as other views (CartView, HomeView, etc.)
            // First try app_bar specific colors, then fallback to root config, then defaults
            final backgroundColor = parseColor(
              configHelper
                  .getString('about_configuration.app_bar.backgroundColor'),
              parseColor(
                configHelper.getString('about_configuration.background_color'),
                OsmeaColors.white,
              ),
            );

            final foregroundColor = parseColor(
              configHelper
                  .getString('about_configuration.app_bar.foregroundColor'),
              parseColor(
                configHelper.getString('about_configuration.text_color'),
                OsmeaColors.black,
              ),
            );

            final titleColor = parseColor(
              configHelper.getString('about_configuration.app_bar.titleColor'),
              foregroundColor,
            );

            final iconColor = parseColor(
              configHelper.getString('about_configuration.app_bar.iconColor'),
              foregroundColor,
            );

            final elevation = configHelper.getDouble(
              'about_configuration.app_bar.elevation',
              0.0,
            );

            // Build AppBar following OSMEA standards like other views
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
    debugPrint('📄 About View Started!');

    // Load config first to ensure it's available
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');
    } catch (e) {
      debugPrint('⚠️ Could not load config: $e');
    }

    // Get effective about configuration
    final effectiveModel = _getEffectiveAboutModel();

    // Load about content
    viewModel.loadAbout(effectiveModel);
  }

  /// Get effective about model based on priority
  AboutPageModel _getEffectiveAboutModel() {
    // Priority 1: Direct model provided
    if (aboutPageModel != null) {
      return aboutPageModel!;
    }

    // Priority 2: From config with type
    if (aboutConfig != null && aboutType != null) {
      final configModel = aboutConfig!.getAboutPage(aboutType!);
      if (configModel != null) {
        return configModel;
      }
    }

    // Priority 3: Fallback model with provided values
    return _createFallbackModel();
  }

  /// Create fallback model
  AboutPageModel _createFallbackModel() {
    // Try to get all values from config
    AboutStyle style = AboutStyle.startup;
    String? configTitle;
    String? configDescription;
    String? configHtmlContent;
    String? configUrl;
    bool? configEnableFullscreenWebView;
    bool? configShowVersion;
    bool? configShowCompanyInfo;
    String? configCompanyName;
    String? configCopyright;
    String? configBackgroundColor;
    String? configTextColor;
    String? configPrimaryColor;
    String? configVersion;
    String? configBuildNumber;
    String? configAppName;

    try {
      final configHelper = AssetConfigHelper();
      final aboutConfig = configHelper.getObject('about_configuration');

      if (aboutConfig != null) {
        // Parse style
        final styleString = aboutConfig['style'] as String? ?? '';
        if (styleString.isNotEmpty) {
          style = _stringToAboutStyle(styleString) ?? AboutStyle.startup;
        }

        // Get all values from about_configuration
        configTitle = aboutConfig['title'] as String?;
        configDescription = aboutConfig['description'] as String?;
        configHtmlContent = aboutConfig['html_content'] as String?;
        configUrl = aboutConfig['url'] as String?;
        configEnableFullscreenWebView =
            aboutConfig['enable_fullscreen_web_view'] as bool?;
        configShowVersion = aboutConfig['show_version'] as bool?;
        configShowCompanyInfo = aboutConfig['show_company_info'] as bool?;
        configCompanyName = aboutConfig['company_name'] as String?;
        configCopyright = aboutConfig['copyright'] as String?;
        configBackgroundColor = aboutConfig['background_color'] as String?;
        configTextColor = aboutConfig['text_color'] as String?;
        configPrimaryColor = aboutConfig['primary_color'] as String?;
        configVersion = aboutConfig['version'] as String?;
        configBuildNumber = aboutConfig['build_number'] as String?;
        configAppName = aboutConfig['app_name'] as String?;
      }

      // Get app info from app_settings if not in about_configuration
      if (configVersion == null ||
          configBuildNumber == null ||
          configAppName == null) {
        final appSettings = configHelper.getObject('app_settings');
        if (appSettings != null) {
          configAppName ??= appSettings['app_name'] as String?;
          configVersion ??= appSettings['app_version'] as String?;
          configBuildNumber ??= appSettings['build_number'] as String?;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Could not load about config: $e');
    }

    return AboutPageModel(
      title: title ?? configTitle ?? 'About',
      description: description ?? configDescription,
      htmlContent: htmlContent ?? configHtmlContent,
      url: url ?? configUrl,
      style: style,
      enableFullscreenWebView: configEnableFullscreenWebView ?? true,
      showVersion: configShowVersion ?? false,
      showCompanyInfo: configShowCompanyInfo ?? false,
      companyName: configCompanyName,
      copyright: configCopyright,
      backgroundColor: configBackgroundColor,
      textColor: configTextColor,
      primaryColor: configPrimaryColor,
      version: configVersion,
      buildNumber: configBuildNumber,
      appName: configAppName,
    );
  }

  /// Convert string to AboutStyle enum
  AboutStyle? _stringToAboutStyle(String styleString) {
    switch (styleString.toLowerCase()) {
      case 'startup':
        return AboutStyle.startup;
      case 'space':
        return AboutStyle.space;
      case 'enterprise':
        return AboutStyle.enterprise;
      default:
        return null;
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    // Get effective about configuration
    final effectiveModel = _getEffectiveAboutModel();

    return BlocListener<AboutViewCubit, AboutViewState>(
      listener: (context, state) {
        if (state.hasError) {
          debugPrint('❌ About view error: ${state.errorMessage}');
        }
      },
      child: FutureBuilder<AboutStyle>(
        future: _getAboutStyleFromConfig(effectiveModel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return _getAboutWidget(snapshot.data!, effectiveModel, viewModel);
          } else {
            debugPrint(
                '⚠️ Could not get about style from config, using default');
            return _getAboutWidget(
                AboutStyle.startup, effectiveModel, viewModel);
          }
        },
      ),
    );
  }

  /// Get about style from config or model
  Future<AboutStyle> _getAboutStyleFromConfig(AboutPageModel model) async {
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');

      final styleString =
          configHelper.getString('about_configuration.style', '');
      if (styleString.isNotEmpty) {
        final style = _stringToAboutStyle(styleString);
        if (style != null) {
          debugPrint('✅ About style from config: $styleString -> $style');
          return style;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Could not load style from config: $e');
    }

    // Return style from model
    return model.style;
  }

  /// Get appropriate about widget based on style
  Widget _getAboutWidget(
      AboutStyle style, AboutPageModel model, AboutViewCubit cubit) {
    switch (style) {
      case AboutStyle.startup:
        return AboutStartupWidget(
          model: model,
        );
      case AboutStyle.space:
        return AboutSpaceWidget(
          model: model,
        );
      case AboutStyle.enterprise:
        return AboutEnterpriseWidget(
          model: model,
        );
    }
  }
}

/// 🚀 Ready-to-use widget for easy implementation
class AboutScreen extends StatelessWidget {
  /// Navigation callback for routing to other pages
  final Function(String path) goRoute;

  /// About page model
  final AboutPageModel? aboutPageModel;

  /// About configuration
  final AboutConfigModel? aboutConfig;

  /// About type for config lookup
  final String? aboutType;

  /// Custom title (fallback)
  final String? title;

  /// Custom description (fallback)
  final String? description;

  /// Custom HTML content (fallback)
  final String? htmlContent;

  /// Custom URL (fallback)
  final String? url;

  const AboutScreen({
    super.key,
    required this.goRoute,
    this.aboutPageModel,
    this.aboutConfig,
    this.aboutType,
    this.title,
    this.description,
    this.htmlContent,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AboutView(
      goRoute: goRoute,
      aboutPageModel: aboutPageModel,
      aboutConfig: aboutConfig,
      aboutType: aboutType,
      title: title,
      description: description,
      htmlContent: htmlContent,
      url: url,
    );
  }
}
