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
            final state = viewModel.state;
            if (state is ProfileAuthenticated) {
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
            return AppBar(toolbarHeight: 0);
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
    if (state is ProfileInitial || state is ProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProfileAuthenticated) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader(context, 'Account'),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('My Information'),
            leading: const Icon(Icons.person_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => goRoute('/profile/info'),
          ),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('My Addresses'),
            leading: const Icon(Icons.location_on_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => goRoute('/profile/addresses'),
          ),
          
          _buildSectionHeader(context, 'Shopping'),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('My Orders'),
            leading: const Icon(Icons.shopping_bag_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => goRoute('/profile/orders'),
          ),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('My Reviews'),
            leading: const Icon(Icons.star_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to reviews
            },
          ),

          _buildSectionHeader(context, 'General'),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Settings'),
            leading: const Icon(Icons.settings_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => goRoute('/settings'),
          ),
          OsmeaComponents.listItem(
            title: OsmeaComponents.text('Help & Support'),
            leading: const Icon(Icons.help_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
               // Navigate to help
            },
          ),

          if (state.user.role == 'admin') ...[
            _buildSectionHeader(context, 'Admin'),
            OsmeaComponents.listItem(
              title: OsmeaComponents.text('Admin Dashboard'),
              leading: const Icon(Icons.admin_panel_settings_outlined),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => goRoute('/admin/dashboard'),
            ),
          ],
        ],
      );
    }

    if (state is ProfileUnauthenticated) {
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

    // Fallback for any other state
    return const Center(child: Text('An unexpected error occurred.'));
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
      ),
    );
  }
}
