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
         
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.appTitle,
              color: const Color(0xFF000000), // Black text
            ),
            backgroundColor: const Color(0xFFFFFFFF), // White background
            foregroundColor: const Color(0xFF000000), // Black foreground
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
            actions: [
              AppBarAction(
                type: AppBarActionType.more, // Using generic type for custom icon
                icon: const Icon(
                  Icons.language, // Globe/Language icon
                  color: Color(0xFF000000),
                ),
                onPressed: () => LocalizationHelper.showLanguageCurrencySheet(context),
              ),
              AppBarAction(
                type: AppBarActionType.more,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF000000), 
                ),
                onPressed: () => goRoute('/cart'),
              ),
            ],
          ),
        );

  @override
  void initialContent(SupabaseHomeViewModel viewModel, BuildContext context) {
    viewModel.initial();
    
    // Check for login success flag from navigation
    final loginSuccess = arguments['loginSuccess'] == 'true';
    if (loginSuccess) {
      // Trigger the snackbar via state change
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
           // Ensure context is mounted and available
           Future.delayed(Duration.zero, () {
             if (context.mounted) {
                context.showSnackbar(
                  message: "Welcome back! You have successfully logged in.",
                  type: SnackbarType.success,
                );
                viewModel.resetLoginSnackbar();
             }
           });
        }
      },
      child: Builder(
        builder: (context) {
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
              goRoute: goRoute,
            );
          }

          return HomeErrorWidget(message: context.resources.somethingWentWrong);
        }
      ),
    );
  }
}