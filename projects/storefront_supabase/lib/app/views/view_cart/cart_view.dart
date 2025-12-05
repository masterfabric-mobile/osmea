import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'models/view_model.dart';
import 'models/states.dart';

class CartView extends MasterViewCubit<CartViewModel, CartState> {
  CartView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              'My Cart',
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
  void initialContent(CartViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
      BuildContext context, CartViewModel viewModel, CartState state) {
    if (state is CartErrorState) {
      return buildError(state.message, onRetry: viewModel.initial);
    }
    if (state is CartLoadedState) {
      return OsmeaComponents.center(
          child: OsmeaComponents.text('My Cart Page Content'));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
