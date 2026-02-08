import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/utils/localization_helper.dart';
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
          verticalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) {
            final state = viewModel.state;
            if (state is ProfileAuthenticated) {
              return OsmeaComponents.appBar(
                title: OsmeaComponents.text(
                  context.resources.profile,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                variant: AppBarVariant.primary,
                size: AppBarSize.large,
                elevation: 0,
                titleSpacing: 0.0,
                actions: [
                  // Language/Currency Selector
                  AppBarAction(
                    type: AppBarActionType.more,
                    icon: const Icon(Icons.language, color: Colors.black),
                    onPressed: () => LocalizationHelper.showLanguageCurrencySheet(context),
                  ),
                  // Settings button for both authenticated and unauthenticated
                  AppBarAction(
                    type: AppBarActionType.profile,
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          final resources = context.resources;
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: OsmeaComponents.text(resources.logout),
                            content: OsmeaComponents.text(resources.confirmLogoutMessage),
                            actions: [
                              OsmeaComponents.button(
                                text: resources.cancel,
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                variant: ButtonVariant.ghost,
                                textColor: Colors.black, // Explicitly set text color for ghost variant
                              ),
                              OsmeaComponents.button(
                                text: resources.logout,
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  
                                  if (context.mounted) {
                                    context.showSnackbar(
                                      message: resources.logoutSuccess,
                                      type: SnackbarType.success,
                                    );
                                    context.go('/home');
                                  }
                                  
                                  viewModel.logout();
                                },
                                variant: ButtonVariant.primary,
                                backgroundColor: Colors.red, // Use red for logout action
                                textColor: Colors.white,
                              ),
                            ],
                          );
                        },
                      );
                    },
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
    return BlocListener<ProfileViewModel, ProfileState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is ProfileAuthenticated && state.shouldRedirectToHome) {
          // Trigger navigation to home and then reset the flag
          Future.delayed(Duration.zero, () {
            if (context.mounted) {
              context.go('/home?loginSuccess=true');
              viewModel.resetRedirectFlag();
            }
          });
        }
      },
      child: Builder(
        builder: (context) {
          final resources = context.resources;
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileAuthenticated) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader(context, resources.account),
                OsmeaComponents.listItem(
                  title: OsmeaComponents.text(resources.myInformation),
                  leading: const Icon(Icons.person_outline),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => goRoute('/profile/info'),
                ),
                OsmeaComponents.listItem(
                  title: OsmeaComponents.text(resources.myAddresses),
                  leading: const Icon(Icons.location_on_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => goRoute('/profile/addresses'),
                ),
                OsmeaComponents.listItem(
                  title: OsmeaComponents.text(resources.changePassword),
                  leading: const Icon(Icons.lock_reset_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => goRoute('/profile/change-password'),
                ),
                
                _buildSectionHeader(context, resources.shopping),
                OsmeaComponents.listItem(
                  title: OsmeaComponents.text(resources.myOrders),
                  leading: const Icon(Icons.shopping_bag_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => goRoute('/profile/orders'),
                ),
                OsmeaComponents.listItem(
                  title: OsmeaComponents.text(resources.myReviews),
                  leading: const Icon(Icons.star_outline),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to reviews
                  },
                ),

                _buildSectionHeader(context, resources.general),
                OsmeaComponents.listItem(
                  title: OsmeaComponents.text(resources.settings),
                  leading: const Icon(Icons.settings_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => goRoute('/settings'),
                ),
                OsmeaComponents.listItem(
                  title: OsmeaComponents.text(resources.helpSupport),
                  leading: const Icon(Icons.help_outline),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                     // Navigate to help
                  },
                ),

                if (state.user.role == 'admin') ...[
                  _buildSectionHeader(context, resources.admin),
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(resources.adminDashboard),
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => goRoute('/admin/dashboard'),
                  ),
                ],
              ],
            );
          }

          if (state is ProfileUnauthenticated) {
            return OsmeaComponents.center(
              child: SingleChildScrollView( // OsmeaComponents.singleChildScrollView might not be available or tricky, keeping standard for now or check import.
                padding: const EdgeInsets.all(24),
                child: OsmeaComponents.column(
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
          return OsmeaComponents.center(child: OsmeaComponents.text(resources.unexpectedError));
        }
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: OsmeaComponents.text(
        title,
        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
      ),
    );
  }
}