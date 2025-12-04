import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'models/view_model.dart';
import 'models/states.dart';

class FavoritesView
    extends MasterViewCubit<FavoritesViewModel, FavoritesState> {
  FavoritesView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  });

  @override
  void initialContent(
    FavoritesViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    FavoritesViewModel viewModel,
    FavoritesState state,
  ) {
    if (state is FavoritesErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is FavoritesLoadedState) {
      return OsmeaComponents.scaffold(
        body: OsmeaComponents.center(
          child: OsmeaComponents.text('Favorites Page Content'),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
