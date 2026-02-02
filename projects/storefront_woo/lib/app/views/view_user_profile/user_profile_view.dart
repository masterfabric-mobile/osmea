import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_user_profile/models/user_profile_view_model.dart';
import 'package:storefront_woo/app/views/view_user_profile/models/module/states.dart';
import 'package:storefront_woo/app/views/view_user_profile/widgets/delete_account_dialog.dart';
import 'package:storefront_woo/app/views/view_user_profile/widgets/account_danger_zone.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';

/// User Profile View - Displays complete user profile from OSMEA Users Manager plugin
class UserProfileView
    extends MasterViewHydratedCubit<UserProfileViewModel, UserProfileState> {
  UserProfileView({
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
  }) : super(coreAppBar: (context, viewModel) => _buildAppBar(context));

  @override
  void initialContent(UserProfileViewModel viewModel, BuildContext context) {
    viewModel.setArguments(arguments);
    viewModel.loadProfile();
  }

  @override
  Widget viewContent(
    BuildContext context,
    UserProfileViewModel viewModel,
    UserProfileState state,
  ) {
    debugPrint(
      '👤 UserProfileView: viewContent called with state: ${state.runtimeType}',
    );

    if (state is UserProfileInitialState) {
      debugPrint('👤 UserProfileView: Initial state, triggering load...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadProfile();
      });
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is UserProfileLoadingState) {
      debugPrint('👤 UserProfileView: Loading state');
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is UserProfileErrorState) {
      debugPrint('👤 UserProfileView: Error state: ${state.message}');
      return buildError(state.message, onRetry: () => viewModel.loadProfile());
    }

    if (state is UserProfileLoadedState) {
      debugPrint('👤 UserProfileView: Loaded state');
      debugPrint('👤 UserProfileView: Profile: ${state.profile.displayName}');
      debugPrint('👤 UserProfileView: Metadata: ${state.metadata.length}');
      debugPrint('👤 UserProfileView: Addresses: ${state.addresses.length}');
      debugPrint(
        '👤 UserProfileView: Preferences: ${state.preferences.length}',
      );
      debugPrint('👤 UserProfileView: Contracts: ${state.contracts.length}');
      return _buildProfileContent(context, state, viewModel);
    }

    debugPrint('👤 UserProfileView: Unknown state, showing loading');
    return UnifiedLoadingWidget(goRoute: goRoute);
  }

  Widget _buildProfileContent(
    BuildContext context,
    UserProfileLoadedState state,
    UserProfileViewModel viewModel,
  ) {
    return RefreshIndicator(
      onRefresh: () => viewModel.loadProfile(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Profile Header - Simple and minimal
          _buildProfileHeader(context, state.profile),
          
          // Statistics Row - Simple inline display
          _buildStatisticsRow(context, state.statistics),
          
          // Menu Items - minimal design
          _buildSectionHeader(context, 'Account'),
          _buildMenuItem(
            context,
            'Edit Profile',
            Icons.edit_outlined,
            () => context.go('/user-profile/edit'),
          ),
          _buildMenuItem(
            context,
            'Addresses',
            Icons.location_on_outlined,
            () => context.go('/user-profile/addresses'),
            subtitle: state.addresses.isNotEmpty 
                ? '${state.addresses.length} saved'
                : null,
          ),
          // _buildMenuItem(
          //   context,
          //   'Settings',
          //   Icons.settings_outlined,
          //   () => context.go('/user-profile/settings'),
          // ),

          _buildSectionHeader(context, 'Orders'),
          _buildMenuItem(
            context,
            'Order History',
            Icons.shopping_bag_outlined,
            () => context.go('/orders-history'),
            subtitle: '${state.statistics.ordersCount ?? 0} orders',
          ),

          if (state.contracts.isNotEmpty) ...[
            _buildSectionHeader(context, 'Contracts'),
            _buildMenuItem(
              context,
              'My Contracts',
              Icons.description_outlined,
              () => context.go('/user-profile/contracts'),
              subtitle: '${state.contracts.length} contracts',
            ),
          ],

          if (state.metadata.isNotEmpty || state.preferences.isNotEmpty) ...[
            _buildSectionHeader(context, 'More'),
            if (state.metadata.isNotEmpty)
              _buildMenuItem(
                context,
                'Metadata',
                Icons.info_outline,
                () => context.go('/user-profile/metadata'),
                subtitle: '${state.metadata.length} items',
              ),
            if (state.preferences.isNotEmpty)
              _buildMenuItem(
                context,
                'Preferences',
                Icons.tune_outlined,
                () => context.go('/user-profile/preferences'),
                subtitle: '${state.preferences.length} preferences',
              ),
          ],
          
          // Danger Zone - Account Deletion
          OsmeaComponents.sizedBox(height: context.spacing32),
          AccountDangerZone(
            onDeleteAccount: () => _handleDeleteAccount(context, state, viewModel),
            isLoading: false,
          ),
          
          // Bottom spacing
          OsmeaComponents.sizedBox(height: context.spacing32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    UserProfile profile,
  ) {
    final initials = _getInitials(profile.displayName);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing24,
      ),
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar - minimal black circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: OsmeaColors.black,
            ),
            child: Center(
              child: OsmeaComponents.text(
                initials,
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing16),
          // User Info
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.text(
                  profile.displayName,
                  textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                    color: OsmeaColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                OsmeaComponents.sizedBox(height: context.spacing6),
                OsmeaComponents.text(
                  profile.email,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    color: OsmeaColors.pewter,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow(
    BuildContext context,
    UserStatistics stats,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.spacing24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: OsmeaColors.silver,
            width: 1,
          ),
          bottom: BorderSide(
            color: OsmeaColors.silver,
            width: 1,
          ),
        ),
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Orders', stats.ordersCount ?? 0),
          _buildStatDivider(context),
          _buildStatItem(context, 'Addresses', stats.addressesCount),
          _buildStatDivider(context),
          _buildStatItem(context, 'Contracts', stats.contractsCount),
        ],
      ),
    );
  }

  Widget _buildStatDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: OsmeaColors.silver,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        context.spacing24,
        context.spacing20,
        context.spacing12,
      ),
      child: OsmeaComponents.text(
        title.toUpperCase(),
        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
          color: OsmeaColors.pewter,
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
    return Material(
      color: OsmeaColors.white,
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
                color: OsmeaColors.silver,
                width: 1,
              ),
            ),
          ),
          child: OsmeaComponents.row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: OsmeaColors.black,
                size: 22,
              ),
              OsmeaComponents.sizedBox(width: context.spacing16),
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.text(
                      title,
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w500,
                        color: OsmeaColors.black,
                      ),
                    ),
                    if (subtitle != null) ...[
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.text(
                        subtitle,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.pewter,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              Icon(
                Icons.chevron_right,
                color: OsmeaColors.steel,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int value,
  ) {
    return Expanded(
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OsmeaComponents.text(
            value.toString(),
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontWeight: FontWeight.w600,
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing6),
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].substring(0, words[0].length > 2 ? 2 : 1).toUpperCase();
    }
    return (words[0][0] + words[words.length - 1][0]).toUpperCase();
  }

  void _handleDeleteAccount(
    BuildContext context,
    UserProfileLoadedState state,
    UserProfileViewModel viewModel,
  ) {
    DeleteAccountDialog.show(
      context: context,
      userEmail: state.profile.email,
      onConfirmDelete: () async {
        // Capture router early before any async operations
        final router = GoRouter.of(context);
        
        // Show loading indicator - use rootNavigator to prevent issues
        showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          builder: (loadingContext) => PopScope(
            canPop: false,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(loadingContext.spacing24),
                decoration: BoxDecoration(
                  color: OsmeaColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: OsmeaComponents.column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    OsmeaComponents.sizedBox(height: loadingContext.spacing16),
                    OsmeaComponents.text(
                      'Deleting account...',
                      textStyle: OsmeaTextStyle.bodyMedium(loadingContext),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Call delete account
        debugPrint('🗑️ Starting account deletion...');
        final success = await viewModel.deleteAccount();
        debugPrint('🗑️ Account deletion result: $success');

        // Always close the loading dialog first
        try {
          // Use root navigator to close the dialog
          Navigator.of(context, rootNavigator: true).pop();
          debugPrint('✅ Loading dialog closed');
        } catch (e) {
          debugPrint('⚠️ Failed to close loading dialog: $e');
        }

        // Wait a moment for dialog to fully close
        await Future.delayed(const Duration(milliseconds: 200));

        if (success) {
          // Account deleted successfully
          debugPrint('✅ Account deleted successfully, navigating to home...');
          
          // Navigate to home
          router.go('/home');
          debugPrint('✅ Navigated to home');
          
          // Show success message after navigation completes
          Future.delayed(const Duration(milliseconds: 1000), () {
            try {
              final currentContext = router.routerDelegate.navigatorKey.currentContext;
              if (currentContext != null && currentContext.mounted) {
                ScaffoldMessenger.of(currentContext).showSnackBar(
                  SnackBar(
                    content: OsmeaComponents.text(
                      'Your account has been successfully deleted',
                      textStyle: OsmeaTextStyle.bodyMedium(currentContext).copyWith(
                        color: OsmeaColors.white,
                      ),
                    ),
                    backgroundColor: OsmeaColors.black,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            } catch (e) {
              debugPrint('⚠️ Failed to show success message: $e');
            }
          });
        } else {
          // Failed to delete account
          debugPrint('❌ Account deletion failed');
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: OsmeaComponents.text(
                  'Failed to delete account. Please try again or contact support.',
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    color: OsmeaColors.white,
                  ),
                ),
                backgroundColor: OsmeaColors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: OsmeaColors.white,
                  onPressed: () => _handleDeleteAccount(context, state, viewModel),
                ),
              ),
            );
          }
        }
      },
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  final configHelper = AssetConfigHelper();

  Color getColor(String key, Color fallback) {
    try {
      final colorString = configHelper.getString(
        'user_profile_view.app_bar.$key',
      );
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load app bar color $key: $e');
    }
    return fallback;
  }

  final title = configHelper.getString(
    'user_profile_view.app_bar.title',
    'My Profile',
  );
  final backgroundColor = getColor('backgroundColor', OsmeaColors.paperWhite);
  final foregroundColor = getColor('foregroundColor', OsmeaColors.thunder);
  final titleColor = getColor('titleColor', OsmeaColors.thunder);
  final iconColor = getColor('iconColor', OsmeaColors.thunder);
  final elevation = configHelper.getDouble(
    'user_profile_view.app_bar.elevation',
    0.0,
  );

  return OsmeaComponents.appBar(
    title: OsmeaComponents.text(
      title,
      color: titleColor,
      textStyle: OsmeaTextStyle.titleLarge(context),
    ),
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    elevation: elevation,
    leading: OsmeaComponents.iconButton(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/profile');
        }
      },
      icon: Icon(Icons.arrow_back, color: iconColor),
      backgroundColor: OsmeaColors.transparent,
    ),
  );
}
