import 'package:flutter/material.dart';

import 'package:core/core.dart';

import 'models/view_model.dart';
import 'models/states.dart';

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
              'Categories',
              color: Theme.of(context).colorScheme.onPrimary, // Text color matches onPrimary
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
      if (state.categories.isEmpty) {
        return Center(
          child: OsmeaComponents.text('No categories found.'),
        );
      }
      return ListView.builder(
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
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
