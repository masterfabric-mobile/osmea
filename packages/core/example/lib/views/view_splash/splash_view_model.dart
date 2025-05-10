import 'package:core/core.dart';
import 'package:example/views/view_splash/module/events.dart';
import 'package:example/views/view_splash/module/states.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@injectable
class SplashViewModel extends BaseViewModelBloc<SplashEvent, SplashState> {
  SplashViewModel() : super(SplashStateLoading()) {
    on<SplashEventCheckUser>(_onCheckUser);
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This is a bottom sheet!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(resources.cancel, style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );
      },
    );
  }
}

_onCheckUser(SplashEventCheckUser event, emit) async {
  emit(SplashStateLoading());
  try {
    await Future.delayed(Duration(seconds: 3));
    emit(SplashStateContent(
        contentValue: "Content coming from View Model logic!"));
  } catch (e) {
    debugPrint('Error occurred: $e');
    emit(SplashStateError(contentValue: 'Failed to load content'));
  }
}
