// Example implementation of MasterView
import 'package:core/core.dart';
import 'package:example/views/view_splash/module/events.dart';
import 'package:example/views/view_splash/module/states.dart';
import 'package:example/views/view_splash/splash_view_model.dart';
import 'package:flutter/material.dart';

class SplashView extends MasterView<SplashViewModel, SplashEvent, SplashState> {
  SplashView(
      {super.key,
      super.appBar,
      super.arguments,
      super.currentView,
      super.snackBarFunction});

  @override
  MasterViewTypes get currentView => super.currentView;


  @override
  void initialContent(SplashViewModel viewModel, BuildContext context) async{
    // Navigate to home view
    await Future.delayed(Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    navigateTo(context, '/home');
  }
  
  @override
  Widget viewContent(
      BuildContext context, SplashViewModel viewModel, SplashState state) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(), // Only the splash animation
      ),
    );
  }
}
