import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'models/view_model.dart';
import 'models/states.dart';

class ProductDetailView
    extends MasterViewCubit<ProductDetailViewModel, ProductDetailState> {
  ProductDetailView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  });

  @override
  void initialContent(
    ProductDetailViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailState state,
  ) {
    if (state is ProductDetailErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    if (state is ProductDetailLoadedState) {
      return OsmeaComponents.scaffold(
        body: OsmeaComponents.center(
          child: OsmeaComponents.text(state.productName),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
