import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/models/app_user.dart';
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
              final theme = Theme.of(context);
              final res = context.resources;
              return OsmeaComponents.appBar(
                title: Text(
                  res.myProfile,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.onSurface,
                elevation: 0,
                leading: OsmeaComponents.iconButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                  backgroundColor: OsmeaColors.transparent,
                ),
                actions: [
                  AppBarAction(
                    type: AppBarActionType.more,
                    icon: Icon(Icons.language, color: theme.colorScheme.onSurface),
                    onPressed: () => LocalizationHelper.showLanguageCurrencySheet(context),
                  ),
                  AppBarAction(
                    type: AppBarActionType.profile,
                    icon: Icon(Icons.logout, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      final res = context.resources;
                      showDialog(
                        context: context,
                        builder: (BuildContext dc) {
                          final dTheme = Theme.of(dc);
                          return AlertDialog(
                            backgroundColor: dTheme.colorScheme.surface,
                            title: Text(
                              res.logout,
                              style: dTheme.textTheme.titleLarge?.copyWith(
                                color: dTheme.colorScheme.onSurface,
                              ),
                            ),
                            content: Text(
                              res.confirmLogoutMessage,
                              style: dTheme.textTheme.bodyMedium?.copyWith(
                                color: dTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            actions: [
                              OsmeaComponents.button(
                                text: res.cancel,
                                onPressed: () => Navigator.of(dc).pop(),
                                variant: ButtonVariant.ghost,
                                textColor: dTheme.colorScheme.onSurface,
                              ),
                              OsmeaComponents.button(
                                text: res.logout,
                                onPressed: () {
                                  Navigator.of(dc).pop();
                                  if (context.mounted) {
                                    context.showSnackbar(
                                      message: res.logoutSuccess,
                                      type: SnackbarType.success,
                                    );
                                    context.go('/home');
                                  }
                                  viewModel.logout();
                                },
                                variant: ButtonVariant.outlined,
                                textColor: dTheme.colorScheme.onSurface,
                                borderColor: dTheme.colorScheme.onSurface,
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
            return _buildProfileContent(context, state, viewModel);
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
                            ? OsmeaColors.black
                            : OsmeaColors.black,
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

  /// Woo-style: MY PROFILE block first, then ACCOUNT, ORDERS, GENERAL (bottom nav profile layout)
  Widget _buildProfileContent(
    BuildContext context,
    ProfileAuthenticated state,
    ProfileViewModel viewModel,
  ) {
    final user = state.user;
    final resources = context.resources;
    final theme = Theme.of(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildProfileHeader(context, user),
        _buildStatisticsRow(context, state),
        // Section: ACCOUNT
        _buildSectionHeaderWoo(context, resources.account),
        _buildMenuItem(
          context,
          resources.myInformation,
          Icons.person_outline,
          () => goRoute('/profile/info'),
        ),
        _buildMenuItem(
          context,
          resources.myAddresses,
          Icons.location_on_outlined,
          () => goRoute('/profile/addresses'),
        ),
        _buildMenuItem(
          context,
          resources.changePassword,
          Icons.lock_reset_outlined,
          () => goRoute('/profile/change-password'),
        ),
        _buildSectionHeaderWoo(context, resources.orders),
        _buildMenuItem(
          context,
          resources.myOrders,
          Icons.shopping_bag_outlined,
          () => goRoute('/profile/orders'),
          subtitle: '${state.orderCount} ${resources.orders}',
        ),
        _buildMenuItem(
          context,
          resources.myReviews,
          Icons.star_outline,
          () => goRoute('/profile/reviews'),
        ),
        _buildSectionHeaderWoo(context, resources.general),
        _buildMenuItem(
          context,
          resources.settings,
          Icons.settings_outlined,
          () => goRoute('/settings'),
        ),
        _buildMenuItem(
          context,
          resources.helpSupport,
          Icons.help_outline,
          () => goRoute('/profile/help-support'),
        ),
        if (user.role == 'admin') ...[
          _buildSectionHeaderWoo(context, resources.admin),
          _buildMenuItem(
            context,
            resources.adminDashboard,
            Icons.admin_panel_settings_outlined,
            () => goRoute('/admin/dashboard'),
          ),
        ],
        SizedBox(height: theme.textTheme.bodyLarge?.fontSize ?? 24),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, AppUser user) {
    final theme = Theme.of(context);
    final displayName = user.fullName ?? user.username ?? user.email ?? 'User';
    final email = user.email ?? '';
    final initials = _getInitials(displayName);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
            ),
            child: Center(
              child: Text(
                initials,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: context.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (email.isNotEmpty) ...[
                  SizedBox(height: context.spacing6),
                  Text(
                    email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow(BuildContext context, ProfileAuthenticated state) {
    final theme = Theme.of(context);
    final resources = context.resources;
    final borderColor = theme.colorScheme.outlineVariant;
    final user = state.user;
    final hasAddress = (user.address != null && user.address!.isNotEmpty) ||
        (user.city != null && user.city!.isNotEmpty) ||
        (user.country != null && user.country!.isNotEmpty);
    final addressCount = hasAddress ? 1 : 0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.spacing24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, resources.orders, state.orderCount),
          _buildStatDivider(context),
          _buildStatItem(context, resources.myAddresses, addressCount),
        ],
      ),
    );
  }

  Widget _buildStatDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int value) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: context.spacing6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeaderWoo(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        context.spacing24,
        context.spacing20,
        context.spacing12,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing20,
            vertical: context.spacing16,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant,
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: theme.colorScheme.onSurface, size: 22),
              SizedBox(width: context.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      SizedBox(height: context.spacing4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: context.spacing8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) {
      final s = words[0];
      return s.length > 2 ? s.substring(0, 2).toUpperCase() : s.toUpperCase();
    }
    return (words[0][0] + words[words.length - 1][0]).toUpperCase();
  }
}