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

    if (state is CategoriesLoadedState) {
      return ListView.builder(
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          return OsmeaComponents.listItem(
            title: OsmeaComponents.text(state.categories[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
