/*
 * Onboarding State
 * ----------------
 * All theme/layout from app_config onboarding_configuration.
 * status, pages, currentPage; primaryColorHex, secondaryColorHex, loadingBackgroundColorHex;
 * paddingHorizontal, paddingVertical from config. Fallbacks: OsmeaColors in UI.
 */

enum OnboardingStatus { loading, loaded, error }

class OnboardingState {
  const OnboardingState({
    this.status = OnboardingStatus.loading,
    this.pages = const [],
    this.currentPage = 0,
    this.isCompleted = false,
    this.errorMessage,
    this.style = 'basic',
    this.primaryColorHex,
    this.secondaryColorHex,
    this.loadingBackgroundColorHex,
    this.textColorHex,
    this.paddingHorizontal,
    this.paddingVertical,
  });

  final OnboardingStatus status;
  final List<Map<String, dynamic>> pages;
  final int currentPage;
  final bool isCompleted;
  final String? errorMessage;
  final String style;
  /// From config: primary_color
  final String? primaryColorHex;
  /// From config: secondary_color
  final String? secondaryColorHex;
  /// From config: loading_background_color (loading/empty screen)
  final String? loadingBackgroundColorHex;
  /// From config: text_color (default text/link color; full black #000000)
  final String? textColorHex;
  /// From config: padding_horizontal (double, added to insets)
  final double? paddingHorizontal;
  /// From config: padding_vertical (double, added to insets)
  final double? paddingVertical;

  int get pageCount => pages.length;

  OnboardingState copyWith({
    OnboardingStatus? status,
    List<Map<String, dynamic>>? pages,
    int? currentPage,
    bool? isCompleted,
    String? errorMessage,
    String? style,
    String? primaryColorHex,
    String? secondaryColorHex,
    String? loadingBackgroundColorHex,
    String? textColorHex,
    double? paddingHorizontal,
    double? paddingVertical,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: errorMessage,
      style: style ?? this.style,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      secondaryColorHex: secondaryColorHex ?? this.secondaryColorHex,
      loadingBackgroundColorHex: loadingBackgroundColorHex ?? this.loadingBackgroundColorHex,
      textColorHex: textColorHex ?? this.textColorHex,
      paddingHorizontal: paddingHorizontal ?? this.paddingHorizontal,
      paddingVertical: paddingVertical ?? this.paddingVertical,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'isCompleted': isCompleted,
      };

  factory OnboardingState.fromJson(Map<String, dynamic> json) {
    return OnboardingState(
      status: OnboardingStatus.loading,
      pages: const [],
      currentPage: json['currentPage'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
