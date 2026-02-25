/*
 * OnboardingViewModel
 * -------------------
 * HydratedCubit: PageController + index in ViewModel.
 * Loads pages from URL or app_config; nextPage animates and updates state; finish marks seen and emits completed.
 */

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide OnboardingState;
import 'package:tiny_plates/app/views/view_onboarding/models/module/onboarding_state.dart';

@injectable
class OnboardingViewModel extends BaseViewModelHydratedCubit<OnboardingState> {
  OnboardingViewModel() : super(const OnboardingState());

  final PageController pageController = PageController();
  int get index => state.currentPage;
  int get pageCount => state.pageCount;
  bool get isLastPage => pageCount > 0 && index >= pageCount - 1;

  void Function(String route)? _goRoute;
  void setGoRoute(void Function(String route)? fn) => _goRoute = fn;

  /// Parse pages from app_config or URL JSON. Keeps image_url, logo_url, image_path for URL and asset.
  static List<Map<String, dynamic>> _parsePages(List<dynamic>? list) {
    if (list == null || list.isEmpty) return [];
    final result = <Map<String, dynamic>>[];
    for (final e in list) {
      final map = Map<String, dynamic>.from(e as Map);
      final title = map['title'] as String? ?? '';
      if (title.isEmpty) continue;
      final description = map['description'] as String? ?? '';
      final bgHex =
          map['background_color'] as String? ?? map['backgroundColor'] as String?;
      final imageUrl = map['image_url'] as String? ?? map['imageUrl'] as String?;
      final logoUrl = map['logo_url'] as String? ?? map['logoUrl'] as String?;
      final imagePath = map['image_path'] as String? ?? map['imagePath'] as String?;
      result.add({
        'title': title,
        'description': description,
        'backgroundColor': bgHex,
        'imageUrl': imageUrl ?? logoUrl,
        'logoUrl': logoUrl ?? imageUrl,
        'imagePath': imagePath,
      });
    }
    return result;
  }

  Future<void> loadFromUrl() async {
    stateChanger(state.copyWith(status: OnboardingStatus.loading, errorMessage: null));

    final configHelper = AssetConfigHelper();
    final url = configHelper.getString('onboarding_config_url', '').trim();

    if (url.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(
          const Duration(seconds: 15),
        );
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body) as Map<String, dynamic>?;
          final pagesList = body?['pages'] as List<dynamic>?;
          final pages = _parsePages(pagesList);
          if (pages.isNotEmpty) {
            stateChanger(state.copyWith(
              status: OnboardingStatus.loaded,
              pages: pages,
              currentPage: 0,
              errorMessage: null,
            ));
            return;
          }
        }
      } catch (e, st) {
        debugPrint('Onboarding loadFromUrl error: $e');
        debugPrintStack(stackTrace: st);
      }
    }

    _loadFromAppConfig(configHelper);
  }

  void _loadFromAppConfig(AssetConfigHelper configHelper) {
    final all = configHelper.getAllConfig();
    final raw = all?['onboarding_configuration'] as Map<String, dynamic>? ??
        all?['onboardingConfiguration'] as Map<String, dynamic>?;
    final pagesList = raw?['pages'] as List<dynamic>?;
    final pages = _parsePages(pagesList);
    final style = (raw?['style'] as String?)?.toLowerCase() ?? 'basic';
    final primaryColorHex = raw?['primary_color'] as String? ?? raw?['primaryColor'] as String?;
    final secondaryColorHex = raw?['secondary_color'] as String? ?? raw?['secondaryColor'] as String?;
    final loadingBgHex = raw?['loading_background_color'] as String? ?? raw?['loadingBackgroundColor'] as String?;
    final textColorHex = raw?['text_color'] as String? ?? raw?['textColor'] as String?;
    final padH = (raw?['padding_horizontal'] as num?)?.toDouble() ?? (raw?['paddingHorizontal'] as num?)?.toDouble();
    final padV = (raw?['padding_vertical'] as num?)?.toDouble() ?? (raw?['paddingVertical'] as num?)?.toDouble();

    if (pages.isNotEmpty) {
      stateChanger(state.copyWith(
        status: OnboardingStatus.loaded,
        pages: pages,
        currentPage: 0,
        errorMessage: null,
        style: style,
        primaryColorHex: primaryColorHex,
        secondaryColorHex: secondaryColorHex,
        loadingBackgroundColorHex: loadingBgHex,
        textColorHex: textColorHex,
        paddingHorizontal: padH,
        paddingVertical: padV,
      ));
    } else {
      stateChanger(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: 'No onboarding pages in config',
        pages: const [],
      ));
    }
  }

  void goToPage(int index) {
    if (index >= 0 && index < pageCount) {
      stateChanger(state.copyWith(currentPage: index));
    }
  }

  /// Next: animate page and emit new state, or finish on last page (navigation in view listener).
  void nextPage([BuildContext? context]) {
    if (index < pageCount - 1) {
      stateChanger(state.copyWith(currentPage: index + 1));
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (pageCount > 0 && index >= pageCount - 1) {
      finish();
    }
  }

  Future<void> finish() async {
    await OnboardingStorageHelper().markOnboardingSeen();
    stateChanger(state.copyWith(isCompleted: true));
    _goRoute?.call('/home');
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) {
    return OnboardingState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(OnboardingState state) {
    return state.toJson();
  }
}
