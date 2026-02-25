/*
 * HomeView
 * --------
 * Ana ekran. MasterViewCubit pattern: initialContent / viewContent, coreAppBar.
 * State'e göre loading / content / error widget'larını gösterir.
 */

import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:flutter/material.dart';
import 'package:done_together/app/views/view_home/models/home_view_model.dart';
import 'package:done_together/app/views/view_home/models/module/states.dart';
import 'package:done_together/app/views/view_home/widgets/home_content_widget.dart';
import 'package:done_together/app/views/view_home/widgets/home_error_widget.dart';
import 'package:done_together/app/views/view_home/widgets/home_skeleton_widget.dart';

/// Ana ekran: MasterViewCubit ile coreAppBar, initialContent, viewContent.
class HomeView extends MasterViewCubit<HomeViewModel, HomeState> {
  HomeView({
    super.key,
    super.arguments = const {'home': true},
    required super.goRoute,
  }) : super(
          coreAppBar: (context, viewModel) => AppBar(
            title: const Text('Done Together'),
            centerTitle: true,
          ),
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
        );

  @override
  void initialContent(HomeViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    HomeViewModel viewModel,
    HomeState state,
  ) {
    if (state is HomeErrorState) {
      return HomeErrorWidget(
        message: state.message,
        onRetry: () => viewModel.initial(),
      );
    }
    if (state is HomeLoadingState || state is HomeInitialState) {
      return const HomeSkeletonWidget();
    }
    if (state is HomeLoadedState) {
      return HomeContentWidget(
        state: state,
        viewModel: viewModel,
      );
    }
    return HomeErrorWidget(message: 'Something went wrong.');
  }
}
