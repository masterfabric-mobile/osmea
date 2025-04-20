import 'package:core/core.dart';
import 'package:example/views/view_home/home_view_model.dart';
import 'package:example/views/view_home/module/events.dart';
import 'package:example/views/view_home/module/states.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel, HomeViewEvents, HomeViewStates>(
      showBanner: ({backgroundColor, required content, duration}) {},
      builder: (viewModel, context, state) {
        return Scaffold();
      },
    );
  }
}
