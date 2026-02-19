/*
 * HomeView - SubServe Home Page
 * -----------------------------
 * Same file style as storefront_woo view_home.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 * No static UI: all from OsmeaComponents, sizer/text extensions, slang (context.t).
 */

import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide LoadingType;
import 'package:osmea_components/osmea_components.dart';
import 'package:sub_serve/app/views/view_home/models/home_view_model.dart';
import 'package:sub_serve/app/views/view_home/models/module/states.dart';
import 'package:sub_serve/gen/strings.g.dart';

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
      return OsmeaComponents.center(
        child: OsmeaComponents.loading(
          type: LoadingType.rotatingDots,
          size: context.iconSizeHigh,
        ),
      );
    }

    if (state is HomeLoadedState) {
      final t = context.t;
      return OsmeaComponents.center(
        child: OsmeaComponents.text(
          t.homeTitle,
          fontSize: context.fontSizeExtraLarge,
          fontWeight: context.bold,
          color: OsmeaColors.thunder,
        ),
      );
    }

    return OsmeaComponents.center(
      child: OsmeaComponents.loading(
        type: LoadingType.rotatingDots,
        size: context.iconSizeHigh,
      ),
    );
  }
}
