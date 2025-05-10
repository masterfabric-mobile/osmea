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
  void initialContent(SplashViewModel viewModel, BuildContext context) async {
    final LocalStorageHelper localStorageHelper = LocalStorageHelper();
    try {
      debugPrint('Setting item in local storage');
      localStorageHelper.setItem('SplashViewFirst', 'true');
      // Set the encrypted item in the local storage
      localStorageHelper.setEncryptedItem('SplashViewFirstEncrypted', 'I am a secret Hero 🦸‍♂️');
      // Get the encrypted item from the local storage
      final encryptedItem = await localStorageHelper.getEncryptedItem('SplashViewFirstEncrypted');
      // Log the encrypted item
      debugPrint('Splash View Encrypted item: $encryptedItem');
      // Navigate to home view
      await Future.delayed(Duration(seconds: 2));
      debugPrint('Navigating to home view');
      // ignore: use_build_context_synchronously
      navigateTo(context, '/home');
    } catch (e) {
      // Handle error
      debugPrint('Error occurred: $e');
    }
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
