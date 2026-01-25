import 'package:flutter/material.dart';

/// 📧 **OSMEA Contact Us Models**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Model structures for contact us view system
///
/// {@category Models}
/// {@subCategory ContactUsModels}

/// 📧 Contact us page model
class ContactUsPageModel {
  /// Contact page title
  final String title;

  /// Contact page description/subtitle
  final String? description;

  /// HTML content to display
  final String? htmlContent;

  /// URL to display in web view (if provided, takes priority over htmlContent)
  final String? url;

  /// Contact email
  final String? email;

  /// Contact phone
  final String? phone;

  /// Contact address
  final String? address;

  /// Company/Organization name
  final String? companyName;

  /// Background color
  final String? backgroundColor;

  /// Text color
  final String? textColor;

  /// Primary/accent color
  final String? primaryColor;

  /// Contact style
  final ContactUsStyle style;

  /// Whether to show contact form
  final bool showContactForm;

  /// Whether to show contact information
  final bool showContactInfo;

  /// Form fields configuration
  final ContactUsFormFields formFields;

  /// Whether to enable fullscreen web view for URLs
  final bool enableFullscreenWebView;

  const ContactUsPageModel({
    required this.title,
    this.description,
    this.htmlContent,
    this.url,
    this.email,
    this.phone,
    this.address,
    this.companyName,
    this.backgroundColor,
    this.textColor,
    this.primaryColor,
    this.style = ContactUsStyle.startup,
    this.showContactForm = true,
    this.showContactInfo = true,
    this.formFields = const ContactUsFormFields(),
    this.enableFullscreenWebView = true,
  });

  /// Create ContactUsPageModel from JSON
  factory ContactUsPageModel.fromJson(Map<String, dynamic> json) {
    return ContactUsPageModel(
      title: json['title'] as String,
      description: json['description'] as String?,
      htmlContent: json['html_content'] as String?,
      url: json['url'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      companyName: json['company_name'] as String?,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      primaryColor: json['primary_color'] as String?,
      style: ContactUsStyle.values.firstWhere(
        (s) => s.name == (json['style'] as String? ?? 'startup'),
        orElse: () => ContactUsStyle.startup,
      ),
      showContactForm: json['show_contact_form'] as bool? ?? true,
      showContactInfo: json['show_contact_info'] as bool? ?? true,
      formFields: json['form_fields'] != null
          ? ContactUsFormFields.fromJson(
              json['form_fields'] as Map<String, dynamic>)
          : const ContactUsFormFields(),
      enableFullscreenWebView:
          json['enable_fullscreen_web_view'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'html_content': htmlContent,
      'url': url,
      'email': email,
      'phone': phone,
      'address': address,
      'company_name': companyName,
      'background_color': backgroundColor,
      'text_color': textColor,
      'primary_color': primaryColor,
      'style': style.name,
      'show_contact_form': showContactForm,
      'show_contact_info': showContactInfo,
      'form_fields': formFields.toJson(),
      'enable_fullscreen_web_view': enableFullscreenWebView,
    };
  }

  /// Get background color as Color
  Color? getBackgroundColor() {
    if (backgroundColor == null) return null;
    return _parseColor(backgroundColor!);
  }

  /// Get text color as Color
  Color? getTextColor() {
    if (textColor == null) return null;
    return _parseColor(textColor!);
  }

  /// Get primary color as Color
  Color? getPrimaryColor() {
    if (primaryColor == null) return null;
    return _parseColor(primaryColor!);
  }

  /// Parse color string to Color
  Color _parseColor(String colorString) {
    try {
      // Remove # if present
      String hex = colorString.replaceAll('#', '');

      // Handle 6 digit hex
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }

      // Handle 8 digit hex (with alpha)
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }

      // Fallback to black
      return const Color(0xFF000000);
    } catch (e) {
      return const Color(0xFF000000);
    }
  }

  /// Check if URL is provided
  bool get hasUrl => url != null && url!.isNotEmpty;

  /// Check if HTML content is provided
  bool get hasHtmlContent => htmlContent != null && htmlContent!.isNotEmpty;
}

/// 🎨 Contact us view style
enum ContactUsStyle {
  /// Startup style - modern and clean
  startup,

  /// Space style - minimalist with lots of whitespace
  space,

  /// Enterprise style - professional and structured
  enterprise,
}

/// 📋 Contact us form fields configuration
class ContactUsFormFields {
  /// Show name field
  final bool showName;

  /// Show email field
  final bool showEmail;

  /// Show phone field
  final bool showPhone;

  /// Show subject field
  final bool showSubject;

  /// Show message field
  final bool showMessage;

  /// Show company field
  final bool showCompany;

  /// Name field label
  final String nameLabel;

  /// Email field label
  final String emailLabel;

  /// Phone field label
  final String phoneLabel;

  /// Subject field label
  final String subjectLabel;

  /// Message field label
  final String messageLabel;

  /// Company field label
  final String companyLabel;

  /// Submit button text
  final String submitButtonText;

  const ContactUsFormFields({
    this.showName = true,
    this.showEmail = true,
    this.showPhone = false,
    this.showSubject = true,
    this.showMessage = true,
    this.showCompany = false,
    this.nameLabel = 'Name',
    this.emailLabel = 'Email',
    this.phoneLabel = 'Phone',
    this.subjectLabel = 'Subject',
    this.messageLabel = 'Message',
    this.companyLabel = 'Company',
    this.submitButtonText = 'Send Message',
  });

  /// Create ContactUsFormFields from JSON
  factory ContactUsFormFields.fromJson(Map<String, dynamic> json) {
    return ContactUsFormFields(
      showName: json['show_name'] as bool? ?? true,
      showEmail: json['show_email'] as bool? ?? true,
      showPhone: json['show_phone'] as bool? ?? false,
      showSubject: json['show_subject'] as bool? ?? true,
      showMessage: json['show_message'] as bool? ?? true,
      showCompany: json['show_company'] as bool? ?? false,
      nameLabel: json['name_label'] as String? ?? 'Name',
      emailLabel: json['email_label'] as String? ?? 'Email',
      phoneLabel: json['phone_label'] as String? ?? 'Phone',
      subjectLabel: json['subject_label'] as String? ?? 'Subject',
      messageLabel: json['message_label'] as String? ?? 'Message',
      companyLabel: json['company_label'] as String? ?? 'Company',
      submitButtonText: json['submit_button_text'] as String? ?? 'Send Message',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'show_name': showName,
      'show_email': showEmail,
      'show_phone': showPhone,
      'show_subject': showSubject,
      'show_message': showMessage,
      'show_company': showCompany,
      'name_label': nameLabel,
      'email_label': emailLabel,
      'phone_label': phoneLabel,
      'subject_label': subjectLabel,
      'message_label': messageLabel,
      'company_label': companyLabel,
      'submit_button_text': submitButtonText,
    };
  }
}

/// 📋 Contact us configuration model
class ContactUsConfigModel {
  /// Map of contact pages by type
  final Map<String, ContactUsPageModel> contactPages;

  const ContactUsConfigModel({
    required this.contactPages,
  });

  /// Create ContactUsConfigModel from JSON
  factory ContactUsConfigModel.fromJson(Map<String, dynamic> json) {
    final pages = <String, ContactUsPageModel>{};

    if (json['contact_pages'] is Map) {
      final pagesMap = json['contact_pages'] as Map<String, dynamic>;
      pagesMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          pages[key] = ContactUsPageModel.fromJson(value);
        }
      });
    }

    return ContactUsConfigModel(contactPages: pages);
  }

  /// Get contact page by type
  ContactUsPageModel? getContactPage(String type) {
    return contactPages[type];
  }
}
