import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/models/contact_us_models.dart';
import 'package:core/src/views/contact_us/cubit/contact_us_cubit.dart';
import 'package:core/src/views/contact_us/cubit/contact_us_state.dart';
import 'package:core/src/views/contact_us/widgets/contact_us_startup_widget.dart';
import 'package:core/src/views/contact_us/widgets/contact_us_space_widget.dart';
import 'package:core/src/views/contact_us/widgets/contact_us_enterprise_widget.dart';
import 'package:core/src/helper/asset_config_helper.dart';

/// 📧 **OSMEA Contact Us View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main contact us view - Shows contact information and form with customizable styles
/// Supports HTML content and fullscreen web view for URLs
///
/// Features:
/// - 🎨 Three distinct contact styles: startup, space, enterprise
/// - 📄 HTML content support via WebViewerHelper
/// - 🌐 Fullscreen web view for URLs
/// - 📝 Contact form with customizable fields
/// - 📞 Contact information display
/// - ⚙️ Configurable from app_config.json
/// - 📱 Responsive design
///
/// Style Options:
/// - **Startup**: Modern and clean design
/// - **Space**: Minimalist with lots of whitespace
/// - **Enterprise**: Professional and structured
///
/// {@category Views}
/// {@subCategory ContactUsView}

class ContactUsView
    extends MasterViewCubit<ContactUsViewCubit, ContactUsViewState> {
  /// Contact us page configuration model
  final ContactUsPageModel? contactUsPageModel;

  /// Contact us configuration
  final ContactUsConfigModel? contactUsConfig;

  /// Contact us type for config lookup
  final String? contactUsType;

  /// Custom title (fallback)
  final String? title;

  /// Custom description (fallback)
  final String? description;

  /// Custom HTML content (fallback)
  final String? htmlContent;

  /// Custom URL (fallback)
  final String? url;

  ContactUsView({
    super.key,
    required Function(String path) goRoute,
    Map<String, dynamic> arguments = const {'contact_us': true},
    this.contactUsPageModel,
    this.contactUsConfig,
    this.contactUsType,
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
          // Use safe area if URL is not provided (web view not used)
          // Check direct URL parameter, model URL, config model URL, and config file URL
          useSafeArea: () {
            // Check direct URL parameter
            if (url != null && url.isNotEmpty) return false;
            // Check model URL
            final modelUrl = contactUsPageModel?.url;
            if (modelUrl != null && modelUrl.isNotEmpty) return false;
            // Check config model URL
            if (contactUsConfig != null && contactUsType != null) {
              final configModel = contactUsConfig.getContactPage(contactUsType);
              final configModelUrl = configModel?.url;
              if (configModelUrl != null && configModelUrl.isNotEmpty)
                return false;
            }
            // Try to check config file URL (sync check)
            try {
              final configHelper = AssetConfigHelper();
              final contactUsConfigObj =
                  configHelper.getObject('contact_us_configuration');
              if (contactUsConfigObj != null) {
                final configUrl = contactUsConfigObj['url'] as String?;
                if (configUrl != null && configUrl.isNotEmpty) return false;
              }
            } catch (e) {
              // Config not loaded yet, default to safe area
            }
            // No URL found, use safe area
            return true;
          }(),
          coreAppBar: (context, viewModel) {
            // Get config helper
            final configHelper = AssetConfigHelper();

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

            // Always show AppBar - get title from model, direct parameter, or config
            String appBarTitle = 'Contact Us';

            // Priority 1: From model
            final state = viewModel.state;
            final model = state.model ?? contactUsPageModel;
            if (model != null) {
              appBarTitle = model.title;
            } else if (title != null && title.isNotEmpty) {
              // Priority 2: Direct title parameter
              appBarTitle = title;
            } else {
              // Priority 3: Try to get from config synchronously
              try {
                final contactUsConfigObj =
                    configHelper.getObject('contact_us_configuration');
                if (contactUsConfigObj != null) {
                  appBarTitle =
                      contactUsConfigObj['title'] as String? ?? 'Contact Us';
                }
              } catch (e) {
                debugPrint('⚠️ Could not get contact us config for AppBar: $e');
              }

              // Priority 4: Check from config model
              if (contactUsConfig != null && contactUsType != null) {
                final configModel =
                    contactUsConfig.getContactPage(contactUsType);
                if (configModel != null) {
                  appBarTitle = configModel.title;
                }
              }
            }

            // Get colors from config - same pattern as other views
            final backgroundColor = parseColor(
              configHelper.getString(
                  'contact_us_configuration.app_bar.backgroundColor'),
              parseColor(
                configHelper
                    .getString('contact_us_configuration.background_color'),
                OsmeaColors.white,
              ),
            );

            final foregroundColor = parseColor(
              configHelper.getString(
                  'contact_us_configuration.app_bar.foregroundColor'),
              parseColor(
                configHelper.getString('contact_us_configuration.text_color'),
                OsmeaColors.black,
              ),
            );

            final titleColor = parseColor(
              configHelper
                  .getString('contact_us_configuration.app_bar.titleColor'),
              foregroundColor,
            );

            final iconColor = parseColor(
              configHelper
                  .getString('contact_us_configuration.app_bar.iconColor'),
              foregroundColor,
            );

            final elevation = configHelper.getDouble(
              'contact_us_configuration.app_bar.elevation',
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
                  // Use go_router for back navigation
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    goRoute('/profile');
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
    debugPrint('📧 Contact Us View Started!');

    // Load config first to ensure it's available
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');
    } catch (e) {
      debugPrint('⚠️ Could not load config: $e');
    }

    // Get effective contact us configuration
    final effectiveModel = _getEffectiveContactUsModel();

    // Load contact us content
    viewModel.loadContactUs(effectiveModel);
  }

  /// Get effective contact us model based on priority
  ContactUsPageModel _getEffectiveContactUsModel() {
    // Priority 1: Direct model provided
    if (contactUsPageModel != null) {
      return contactUsPageModel!;
    }

    // Priority 2: From config with type
    if (contactUsConfig != null && contactUsType != null) {
      final configModel = contactUsConfig!.getContactPage(contactUsType!);
      if (configModel != null) {
        return configModel;
      }
    }

    // Priority 3: Fallback model with provided values
    return _createFallbackModel();
  }

  /// Create fallback model
  ContactUsPageModel _createFallbackModel() {
    // Try to get all values from config
    ContactUsStyle style = ContactUsStyle.startup;
    String? configTitle;
    String? configDescription;
    String? configHtmlContent;
    String? configUrl;
    String? configEmail;
    String? configPhone;
    String? configAddress;
    String? configCompanyName;
    String? configBackgroundColor;
    String? configTextColor;
    String? configPrimaryColor;
    bool? configShowContactForm;
    bool? configShowContactInfo;
    ContactUsFormFields? configFormFields;

    try {
      final configHelper = AssetConfigHelper();
      final contactUsConfig =
          configHelper.getObject('contact_us_configuration');

      if (contactUsConfig != null) {
        // Parse style
        final styleString = contactUsConfig['style'] as String? ?? '';
        if (styleString.isNotEmpty) {
          style =
              _stringToContactUsStyle(styleString) ?? ContactUsStyle.startup;
        }

        // Get all values from contact_us_configuration
        configTitle = contactUsConfig['title'] as String?;
        configDescription = contactUsConfig['description'] as String?;
        configHtmlContent = contactUsConfig['html_content'] as String?;
        configUrl = contactUsConfig['url'] as String?;
        configEmail = contactUsConfig['email'] as String?;
        configPhone = contactUsConfig['phone'] as String?;
        configAddress = contactUsConfig['address'] as String?;
        configCompanyName = contactUsConfig['company_name'] as String?;
        configBackgroundColor = contactUsConfig['background_color'] as String?;
        configTextColor = contactUsConfig['text_color'] as String?;
        configPrimaryColor = contactUsConfig['primary_color'] as String?;
        configShowContactForm = contactUsConfig['show_contact_form'] as bool?;
        configShowContactInfo = contactUsConfig['show_contact_info'] as bool?;

        // Parse form fields
        if (contactUsConfig['form_fields'] is Map) {
          configFormFields = ContactUsFormFields.fromJson(
            contactUsConfig['form_fields'] as Map<String, dynamic>,
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Could not load contact us config: $e');
    }

    return ContactUsPageModel(
      title: title ?? configTitle ?? 'Contact Us',
      description: description ?? configDescription,
      htmlContent: htmlContent ?? configHtmlContent,
      url: url ?? configUrl,
      email: configEmail,
      phone: configPhone,
      address: configAddress,
      companyName: configCompanyName,
      backgroundColor: configBackgroundColor,
      textColor: configTextColor,
      primaryColor: configPrimaryColor,
      style: style,
      showContactForm: configShowContactForm ?? true,
      showContactInfo: configShowContactInfo ?? true,
      formFields: configFormFields ?? const ContactUsFormFields(),
    );
  }

  /// Convert string to ContactUsStyle enum
  ContactUsStyle? _stringToContactUsStyle(String styleString) {
    switch (styleString.toLowerCase()) {
      case 'startup':
        return ContactUsStyle.startup;
      case 'space':
        return ContactUsStyle.space;
      case 'enterprise':
        return ContactUsStyle.enterprise;
      default:
        return null;
    }
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    // Get effective contact us configuration
    final effectiveModel = _getEffectiveContactUsModel();

    return BlocListener<ContactUsViewCubit, ContactUsViewState>(
      listener: (context, state) {
        if (state.hasError) {
          debugPrint('❌ Contact us view error: ${state.errorMessage}');
        }
        if (state.isSubmitted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Message sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: FutureBuilder<ContactUsStyle>(
        future: _getContactUsStyleFromConfig(effectiveModel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return _getContactUsWidget(
                snapshot.data!, effectiveModel, viewModel);
          } else {
            debugPrint(
                '⚠️ Could not get contact us style from config, using default');
            return _getContactUsWidget(
                ContactUsStyle.startup, effectiveModel, viewModel);
          }
        },
      ),
    );
  }

  /// Get contact us style from config or model
  Future<ContactUsStyle> _getContactUsStyleFromConfig(
      ContactUsPageModel model) async {
    try {
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');

      final styleString =
          configHelper.getString('contact_us_configuration.style', '');
      if (styleString.isNotEmpty) {
        final style = _stringToContactUsStyle(styleString);
        if (style != null) {
          debugPrint('✅ Contact us style from config: $styleString -> $style');
          return style;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Could not load style from config: $e');
    }

    // Return style from model
    return model.style;
  }

  /// Get appropriate contact us widget based on style
  Widget _getContactUsWidget(ContactUsStyle style, ContactUsPageModel model,
      ContactUsViewCubit cubit) {
    switch (style) {
      case ContactUsStyle.startup:
        return ContactUsStartupWidget(
          model: model,
          cubit: cubit,
        );
      case ContactUsStyle.space:
        return ContactUsSpaceWidget(
          model: model,
          cubit: cubit,
        );
      case ContactUsStyle.enterprise:
        return ContactUsEnterpriseWidget(
          model: model,
          cubit: cubit,
        );
    }
  }
}

/// 🚀 Ready-to-use widget for easy implementation
class ContactUsScreen extends StatelessWidget {
  /// Navigation callback for routing to other pages
  final Function(String path) goRoute;

  /// Contact us page model
  final ContactUsPageModel? contactUsPageModel;

  /// Contact us configuration
  final ContactUsConfigModel? contactUsConfig;

  /// Contact us type for config lookup
  final String? contactUsType;

  /// Custom title (fallback)
  final String? title;

  /// Custom description (fallback)
  final String? description;

  /// Custom HTML content (fallback)
  final String? htmlContent;

  /// Custom URL (fallback)
  final String? url;

  const ContactUsScreen({
    super.key,
    required this.goRoute,
    this.contactUsPageModel,
    this.contactUsConfig,
    this.contactUsType,
    this.title,
    this.description,
    this.htmlContent,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ContactUsView(
      goRoute: goRoute,
      contactUsPageModel: contactUsPageModel,
      contactUsConfig: contactUsConfig,
      contactUsType: contactUsType,
      title: title,
      description: description,
      htmlContent: htmlContent,
      url: url,
    );
  }
}
