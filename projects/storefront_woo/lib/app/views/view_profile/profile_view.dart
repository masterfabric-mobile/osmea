/*
 * ProfileView
 * -----------
 * Profile view to display user authentication status and token information.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_profile/models/profile_view_model.dart';
import 'package:storefront_woo/app/views/view_profile/models/module/states.dart'
    as profile_states;

/// Profile View - Shows user authentication status and token information
class ProfileView
    extends
        MasterViewHydratedCubit<ProfileViewModel, profile_states.ProfileState> {
  ProfileView({super.key, required super.goRoute, super.bottomNavigationBar})
    : super(
        arguments: const {'profile': true},
        appBarPadding: const AppBarPaddingVisibility.disabled(),
        verticalPadding: const PaddingVisibility.disabled(),
        navbarSpacer: const SpacerVisibility.disabled(),
        coreAppBar: (context, vm) => OsmeaComponents.appBar(
          title: OsmeaComponents.text(
            'Profile',
            textStyle: OsmeaTextStyle.titleLarge(context),
          ),
          leading: OsmeaComponents.iconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
          ),
          actions: [
            AppBarAction(
              type: AppBarActionType.secondary,
              icon: const Icon(Icons.refresh),
              onPressed: () => vm.refreshProfile(),
              tooltip: 'Refresh',
            ),
          ],
          variant: AppBarVariant.standard,
          size: AppBarSize.standard,
        ),
      ) {
    debugPrint('👤 ProfileView: Constructor called');
  }

  @override
  void initialContent(ProfileViewModel viewModel, BuildContext context) {
    debugPrint('👤 ProfileView: initialContent called');
    // Set arguments to ViewModel
    viewModel.setArguments(arguments);
    // Load profile - ViewModel handles authentication check internally
    viewModel.loadProfile();
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProfileViewModel viewModel,
    profile_states.ProfileState state,
  ) {
    // Initial state - show loading (initialContent will trigger loadProfile)
    if (state is profile_states.ProfileInitialState) {
      return buildLoading();
    }

    if (state is profile_states.ProfileLoadingState) {
      return buildLoading();
    }

    if (state is profile_states.ProfileErrorState) {
      return buildError(state.message, onRetry: () => viewModel.loadProfile());
    }

    if (state is profile_states.ProfileSignedOutState) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        debugPrint('👤 ProfileView: Sign out completed, navigating to home');
        // Don't reset state to initial - that would trigger loadProfile() again
        // Just navigate away - ProfileView will be disposed
        // Small delay to ensure signout is complete
        await Future.delayed(const Duration(milliseconds: 100));
        // Navigate to home page (user doesn't need to go to auth page)
        context.go('/home');
        debugPrint('👤 ProfileView: Navigated to /home');
      });
      return buildLoading();
    }

    if (state is profile_states.ProfileLoadedState) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Authentication Status
            _buildAuthStatus(context, state),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // User Info Section
            if (state.authUserData != null) ...[
              _buildUserInfoSection(context, state.authUserData!),
              OsmeaComponents.sizedBox(height: context.spacing16),
            ],

            // JWT Token Section (Core Auth JWT - single source of truth)
            _buildJwtTokenSection(context, state.authJwtToken),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // Cart Token Section
            _buildCartTokenSection(context, state.cartToken),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // Actions
            _buildActions(context, viewModel, state.isAuthenticated),

            // Bottom spacing for safe area
            OsmeaComponents.sizedBox(height: context.spacing32),
          ],
        ),
      );
    }

    // Initial state
    return const SizedBox.shrink();
  }

  Widget _buildAuthStatus(
    BuildContext context,
    profile_states.ProfileLoadedState state,
  ) {
    final hasJwt = state.authJwtToken != null && state.authJwtToken!.isNotEmpty;
    final hasCartToken =
        state.cartToken != null && state.cartToken!.cartToken.isNotEmpty;

    return _buildCardWrapper(
      context: context,
      backgroundColor: state.isAuthenticated
          ? OsmeaColors.white
          : OsmeaColors.ash,
      borderColor: state.isAuthenticated
          ? OsmeaColors.nordicBlue
          : OsmeaColors.pewter,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Authentication Status',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          Row(
            children: [
              Icon(
                state.isAuthenticated ? Icons.check_circle : Icons.cancel,
                color: state.isAuthenticated
                    ? OsmeaColors.nordicBlue
                    : OsmeaColors.pewter,
                size: context.iconSizeMedium,
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              OsmeaComponents.text(
                state.isAuthenticated ? 'Authenticated' : 'Not Authenticated',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: state.isAuthenticated
                      ? OsmeaColors.nordicBlue
                      : OsmeaColors.pewter,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          _buildStatusItem(context, 'JWT Token', hasJwt),
          _buildStatusItem(context, 'Cart Token', hasCartToken),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(
    BuildContext context,
    Map<String, dynamic> userData,
  ) {
    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.nordicBlue,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'User Information',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),

          // Display user info in a structured way
          if (userData['email'] != null)
            _buildInfoItem(context, 'Email', userData['email'].toString()),
          if (userData['username'] != null)
            _buildInfoItem(
              context,
              'Username',
              userData['username'].toString(),
            ),
          if (userData['displayName'] != null ||
              userData['display_name'] != null)
            _buildInfoItem(
              context,
              'Display Name',
              (userData['displayName'] ?? userData['display_name']).toString(),
            ),
          if (userData['firstName'] != null || userData['first_name'] != null)
            _buildInfoItem(
              context,
              'First Name',
              (userData['firstName'] ?? userData['first_name']).toString(),
            ),
          if (userData['lastName'] != null || userData['last_name'] != null)
            _buildInfoItem(
              context,
              'Last Name',
              (userData['lastName'] ?? userData['last_name']).toString(),
            ),
          if (userData['id'] != null)
            _buildInfoItem(context, 'User ID', userData['id'].toString()),
        ],
      ),
    );
  }

  Widget _buildJwtTokenSection(BuildContext context, String? authJwtToken) {
    if (authJwtToken == null || authJwtToken.isEmpty) {
      return _buildEmptySection(context, 'JWT Token', 'No JWT token found');
    }

    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.silver,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'JWT Token',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          _buildTokenValue(context, 'Token', authJwtToken),
        ],
      ),
    );
  }

  Widget _buildCartTokenSection(BuildContext context, dynamic cartToken) {
    if (cartToken == null) {
      return _buildEmptySection(context, 'Cart Token', 'No cart token found');
    }

    final isExpired =
        cartToken.expiresAt != null &&
        DateTime.now().isAfter(cartToken.expiresAt!);

    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: isExpired ? Colors.red : OsmeaColors.silver,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OsmeaComponents.text(
                'Cart Token',
                textStyle: OsmeaTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              if (isExpired)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: context.borderRadiusLow,
                  ),
                  child: OsmeaComponents.text(
                    'EXPIRED',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          _buildTokenValue(context, 'Cart Token', cartToken.cartToken),
          if (cartToken.cartId != null && cartToken.cartId!.isNotEmpty)
            _buildTokenValue(context, 'Cart ID', cartToken.cartId!),
          if (cartToken.expiresAt != null)
            _buildInfoItem(
              context,
              'Expires At',
              cartToken.expiresAt!.toIso8601String(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptySection(
    BuildContext context,
    String title,
    String message,
  ) {
    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.ash,
      borderColor: OsmeaColors.pewter,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            title,
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.pewter),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ?? EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor ?? OsmeaColors.white,
        border: Border.all(color: borderColor ?? OsmeaColors.silver, width: 1),
        borderRadius: context.borderRadiusNormal,
      ),
      child: child,
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String label,
    bool isAvailable,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: context.spacing4),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: context.iconSizeSmall,
            color: isAvailable ? OsmeaColors.nordicBlue : OsmeaColors.pewter,
          ),
          OsmeaComponents.sizedBox(width: context.spacing8),
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.bodySmall(context),
          ),
          const Spacer(),
          OsmeaComponents.text(
            isAvailable ? 'Available' : 'Not Available',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: isAvailable ? OsmeaColors.nordicBlue : OsmeaColors.pewter,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenValue(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing12),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            label,
            textStyle: OsmeaTextStyle.bodySmall(
              context,
            ).copyWith(fontWeight: FontWeight.w600, color: OsmeaColors.thunder),
          ),
          OsmeaComponents.sizedBox(height: context.spacing4),
          Container(
            padding: EdgeInsets.all(context.spacing12),
            decoration: BoxDecoration(
              color: OsmeaColors.ash,
              borderRadius: context.borderRadiusNormal,
            ),
            child: SelectableText(
              value,
              style: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: OsmeaComponents.text(
              label,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontWeight: FontWeight.w600,
                color: OsmeaColors.thunder,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: OsmeaComponents.text(
              value,
              textStyle: OsmeaTextStyle.bodySmall(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    ProfileViewModel viewModel,
    bool isAuthenticated,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isAuthenticated)
          OsmeaComponents.button(
            onPressed: () => viewModel.signOut(),
            variant: ButtonVariant.secondary,
            size: ButtonSize.large,
            text: 'Sign Out',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
          ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        OsmeaComponents.button(
          onPressed: () => viewModel.refreshProfile(),
          variant: ButtonVariant.primary,
          size: ButtonSize.large,
          text: 'Refresh',
          textStyle: OsmeaTextStyle.bodyMedium(
            context,
          ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
