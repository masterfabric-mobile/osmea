import 'package:flutter/material.dart';
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


class SupabaseHomeView
    extends MasterViewCubit<SupabaseHomeViewModel, SupabaseHomeState> {
  SupabaseHomeView({
    super.key,
    super.arguments = const {'home': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
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
                type: AppBarActionType.more,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF000000), 
                ),
                onPressed: () => goRoute('/cart'),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70), 
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        key: const ValueKey('homeSearchBar'),
                        controller: viewModel.searchController,
                        decoration: InputDecoration(
                          hintText: context.resources.searchProductsHint,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero, 
                          isDense: true,
                        ),
                        onChanged: viewModel.setSearchQuery,
                      ),
                    ),
                    const SizedBox(height: 16), 
                  ],
                ),
              ),
            ),
          ),
        );

  @override
  void initialContent(SupabaseHomeViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SupabaseHomeViewModel viewModel,
    SupabaseHomeState state,
  ) {
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
}
