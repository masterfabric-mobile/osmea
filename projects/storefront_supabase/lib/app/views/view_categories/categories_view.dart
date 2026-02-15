import 'package:flutter/material.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/src/resources/resources.g.dart';

import 'models/categories_view_model.dart';
import 'models/module/states.dart';

class CategoriesView
    extends MasterViewCubit<CategoriesViewModel, CategoriesState> {
  CategoriesView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.categories,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
          ),
        );

  @override
  void initialContent(
    CategoriesViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    CategoriesViewModel viewModel,
    CategoriesState state,
  ) {
    final resources = context.resources;
    if (state is CategoriesErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is CategoriesLoadingState || state is CategoriesInitialState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CategoriesLoadedState) {
      if (state.rootCategories.isEmpty) {
        return OsmeaComponents.center(
          child: OsmeaComponents.text(resources.noCategories),
        );
      }
      return ListView.builder(
        itemCount: state.rootCategories.length,
        itemBuilder: (context, index) {
          final category = state.rootCategories[index];
          return OsmeaComponents.listItem(
            title: OsmeaComponents.text(category.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => goRoute(
                '/categories/products/${category.id}?name=${Uri.encodeComponent(category.name)}'),
          );
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}