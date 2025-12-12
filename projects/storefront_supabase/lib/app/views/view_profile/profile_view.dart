import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'models/view_model.dart';
import 'models/states.dart';
import 'widgets/logo_header_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/signup_form_widget.dart';

class ProfileView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  ProfileView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
         horizontalPadding: const PaddingVisibility.disabled(),
         appBarPadding: const AppBarPaddingVisibility.disabled(),
         coreAppBar: (context, viewModel) {
           // Only show an AppBar if the user is logged in
           if (viewModel.state.isLoggedIn) {
             return OsmeaComponents.appBar(
               title: OsmeaComponents.text('Profile'),
               variant: AppBarVariant.primary,
               size: AppBarSize.large,
               elevation: 0,
               titleSpacing: 0.0,
               actions: [
                 AppBarAction(
                   type: AppBarActionType.profile,
                   icon: const Icon(Icons.logout),
                   onPressed: () => viewModel.logout(),
                 ),
               ],
             );
           }
           return AppBar(toolbarHeight: 0); // Empty AppBar when logged out
         },
       );

  @override
  void initialContent(ProfileViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProfileViewModel viewModel,
    ProfileState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isLoggedIn) {
      // The Scaffold and AppBar are now handled by MasterViewCubit.
      // We just return the body content.
      return ListView(
        children: [
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Settings'),
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => goRoute('/settings'),
          ),
          if (state.userRole == 'admin')
            OsmeaComponents.listItem(
              title: OsmeaComponents.text('Admin Dashboard'),
              leading: const Icon(Icons.admin_panel_settings),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => goRoute('/admin/dashboard'),
            ),
        ],
      );
    }

    // Login/Signup view (no Scaffold or AppBar here)
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoHeaderWidget(),
            if (state.errorMessage != null) ...[
              OsmeaComponents.text(
                state.errorMessage!,
                color: state.errorMessage!.startsWith('Success')
                    ? OsmeaColors.green
                    : OsmeaColors.red,
                textAlign: TextAlign.center,
              ),
              OsmeaComponents.sizedBox(height: 16),
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.showLoginView
                  ? LoginFormWidget(
                      key: const ValueKey('login'),
                      viewModel: viewModel,
                      onSwitchToSignup: viewModel.switchToSignup,
                    )
                  : SignupFormWidget(
                      key: const ValueKey('signup'),
                      viewModel: viewModel,
                      onSwitchToLogin: viewModel.switchToLogin,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
