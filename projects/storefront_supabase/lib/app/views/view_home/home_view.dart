import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_supabase/app/views/view_home/models/states.dart';
import 'package:storefront_supabase/app/views/view_home/widgets/home_content_widget.dart';
import 'package:storefront_supabase/app/views/view_home/widgets/home_error_widget.dart';
import 'package:storefront_supabase/app/views/view_home/widgets/home_skeleton_widget.dart';
import 'package:storefront_supabase/app/utils/localization_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/utils/unified_loading_widget.dart';
import 'package:storefront_supabase/app/views/view_home/widgets/search_bar_widget.dart';

class SupabaseHomeView
    extends MasterViewCubit<SupabaseHomeViewModel, SupabaseHomeState> {
  SupabaseHomeView({
    super.key,
    super.arguments = const {'home': true},
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  }) : super(
         
          coreAppBar: (context, viewModel) {
            final configHelper = AssetConfigHelper();
            
            final titleSource = configHelper.getString('home_view.app_bar.title_source', 'app_settings.app_name');
            final fallbackTitle = configHelper.getString('home_view.app_bar.fallback_title', context.resources.appTitle);
            final title = configHelper.getString(titleSource, fallbackTitle);
            
            final backgroundColor = _parseColor(configHelper.getString('home_view.app_bar.backgroundColor', '#FFFFFF'));
            final foregroundColor = _parseColor(configHelper.getString('home_view.app_bar.foregroundColor', '#000000'));
            final titleColor = _parseColor(configHelper.getString('home_view.app_bar.titleColor', '#000000'));
            final iconColor = _parseColor(configHelper.getString('home_view.app_bar.iconColor', '#000000'));
            final elevation = configHelper.getDouble('home_view.app_bar.elevation', 0.0);

            // Use SearchBarWidget inside the AppBar if variant allows, otherwise SearchBarWidget is in content
            // The SearchBarWidget is actually positioned below AppBar in Content usually, but here we can use a custom title
            // or specific actions.
            // For matching Woo, we use a standard AppBar and put SearchBarWidget as first item in content.
            // Wait, Woo implementation puts search bar IN the app bar using `OsmeaComponents.appBarWithSearchBar`
            // But here I'm using `MasterViewCubit` which takes `coreAppBar`.
            // I'll stick to standard AppBar and put SearchBarWidget in `HomeContentWidget` or just below.
            // Woo's `HomeView` uses `_buildHomeAppBar` which uses `OsmeaComponents.appBarWithSearchBar`.
            // Supabase's `OsmeaComponents` might not have `appBarWithSearchBar` if I didn't update it?
            // Actually `OsmeaComponents` is in `core`. Both projects use same `core` (ideally).
            // I will use standard AppBar here and let `HomeContentWidget` handle the search bar if needed, 
            // OR I can use `SearchBarWidget` as the bottom of AppBar if supported.
            // Looking at `search_bar_widget.dart`, it's a standalone widget.
            // I'll put it in `HomeContentWidget` list of components (it was removed from there in Woo logic? No, Woo `_buildOrderedComponents` commented out search bar).
            // Woo uses `_buildHomeAppBar` which returns `OsmeaComponents.appBarWithSearchBar`.
            
            return OsmeaComponents.appBar(
              title: OsmeaComponents.text(
                title,
                color: titleColor,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
              ),
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              size: AppBarSize.large,
              elevation: elevation,
              titleSpacing: 0.0,
              actions: [
                AppBarAction(
                  type: AppBarActionType.more,
                  icon: Icon(
                    Icons.language,
                    color: iconColor,
                  ),
                  onPressed: () => LocalizationHelper.showLanguageCurrencySheet(context),
                ),
                AppBarAction(
                  type: AppBarActionType.more,
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: iconColor,
                  ),
                  onPressed: () => goRoute('/cart'),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: SearchBarWidget(configHelper: configHelper),
              ),
            );
          },
        );

  @override
  void initialContent(SupabaseHomeViewModel viewModel, BuildContext context) {
    viewModel.initial();
    
    final loginSuccess = arguments['loginSuccess'] == 'true';
    if (loginSuccess) {
      viewModel.showLoginSuccess();
    }
  }

  @override
  Widget viewContent(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeState state,
  ) {
    return BlocListener<SupabaseHomeViewModel, SupabaseHomeState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is SupabaseHomeLoadedState && state.showLoginSuccessSnackbar) {
           Future.delayed(Duration.zero, () {
             if (context.mounted) {
                context.showSnackbar(
                  message: context.resources.welcomeBackLogin,
                  type: SnackbarType.success,
                );
                viewModel.resetLoginSnackbar();
             }
           });
        }
      },
      child: Builder(
        builder: (context) {
          if (state is HomeAuthRequiredState) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showSnackbar(
                  message: state.message,
                  type: SnackbarType.warning,
                );
                context.push('/auth');
             });
             return buildUnifiedLoading(goRoute: goRoute);
          }

          if (state is SupabaseHomeErrorState) {
            return HomeErrorWidget(
              message: state.message,
              onRetry: () => viewModel.initial(),
            );
          }

          if (state is SupabaseHomeLoadingState ||
              state is SupabaseHomeInitialState) {
            return const HomeSkeletonWidget();
          }

          if (state is SupabaseHomeLoadedState) {
            return HomeContentWidget(
              state: state,
              viewModel: viewModel,
            );
          }

          return HomeErrorWidget(message: context.resources.somethingWentWrong);
        }
      ),
    );
  }
}

Color _parseColor(String colorString) {
  try {
    String hex = colorString.replaceAll('#', '');
    if (hex.length == 8) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return OsmeaColors.black;
  } catch (e) {
    return OsmeaColors.black;
  }
}
