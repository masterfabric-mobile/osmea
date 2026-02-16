/*
 * HomeView - SubServe Home Page
 * -----------------------------
 * Same file style as storefront_woo view_home.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:sub_serve/app/views/view_home/models/home_view_model.dart';
import 'package:sub_serve/app/views/view_home/models/module/states.dart';
import 'package:sub_serve/app/views/view_home/widgets/home_content_widget.dart';

class HomeView extends MasterViewHydratedCubit<HomeViewModel, HomeState> {
  HomeView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    required super.goRoute,
  });

  @override
  void initialContent(HomeViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    HomeViewModel viewModel,
    HomeState state,
  ) {
    if (state is HomeLoadingState || state is HomeInitialState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HomeLoadedState) {
      return HomeContentWidget(
        state: state,
        viewModel: viewModel,
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
