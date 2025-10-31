/*
 * AuthDebugView
 * -------------
 * Debug view to display JWT and Cart Token information for authenticated users.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_auth_debug/models/auth_debug_view_model.dart';
import 'package:storefront_woo/app/views/view_auth_debug/models/module/states.dart'
    as auth_debug_states;
// Direct import to ensure extension is available
import 'package:apis/models/auth/woo_jwt_token.dart';

/// Auth Debug View - Shows JWT and Cart Token information
class AuthDebugView
    extends
        MasterViewHydratedCubit<
          AuthDebugViewModel,
          auth_debug_states.AuthDebugState
        > {
  AuthDebugView({super.key, required super.goRoute})
    : super(
        arguments: const {'authDebug': true},
        appBarPadding: const AppBarPaddingVisibility.enabled(),
        verticalPadding: const PaddingVisibility.enabled(),
        horizontalPadding: const PaddingVisibility.enabled(),
        coreAppBar: (context, vm) => OsmeaComponents.appBar(
          title: OsmeaComponents.text(
            'Auth Debug',
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
              onPressed: () => vm.refreshTokens(),
              tooltip: 'Refresh Tokens',
            ),
          ],
          variant: AppBarVariant.standard,
          size: AppBarSize.standard,
        ),
      );

  @override
  void initialContent(AuthDebugViewModel viewModel, BuildContext context) {
    viewModel.loadTokens();
  }

  @override
  Widget viewContent(
    BuildContext context,
    AuthDebugViewModel viewModel,
    auth_debug_states.AuthDebugState state,
  ) {
    if (state is auth_debug_states.AuthDebugLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is auth_debug_states.AuthDebugErrorState) {
      return Center(
        child: OsmeaComponents.text(
          state.message,
          textStyle: OsmeaTextStyle.bodyMedium(context),
        ),
      );
    }

    if (state is auth_debug_states.AuthDebugLoadedState) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Authentication Status
            _buildAuthStatus(context, state),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // WooCommerce JWT Token Section
            _buildWooJwtSection(context, state.jwtToken),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // Core Auth JWT Token Section
            _buildCoreAuthJwtSection(context, state.authJwtToken),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // User Data Section
            if (state.authUserData != null) ...[
              _buildUserDataSection(context, state.authUserData!),
              OsmeaComponents.sizedBox(height: context.spacing16),
            ],

            // Cart Token Section
            _buildCartTokenSection(context, state.cartToken),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // Actions
            _buildActions(context, viewModel),
          ],
        ),
      );
    }

    // Initial state
    return const SizedBox.shrink();
  }

  Widget _buildAuthStatus(
    BuildContext context,
    auth_debug_states.AuthDebugLoadedState state,
  ) {
    final hasWooJwt = state.jwtToken != null && !state.jwtToken!.isExpired;
    final hasCoreJwt =
        state.authJwtToken != null && state.authJwtToken!.isNotEmpty;
    final hasCartToken =
        state.cartToken != null && state.cartToken!.cartToken.isNotEmpty;
    final isAuthenticated = hasWooJwt || hasCoreJwt;

    return _buildCardWrapper(
      context: context,
      backgroundColor: isAuthenticated ? OsmeaColors.white : OsmeaColors.ash,
      borderColor: isAuthenticated
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
                isAuthenticated ? Icons.check_circle : Icons.cancel,
                color: isAuthenticated
                    ? OsmeaColors.nordicBlue
                    : OsmeaColors.pewter,
                size: context.iconSizeMedium,
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              OsmeaComponents.text(
                isAuthenticated ? 'Authenticated' : 'Not Authenticated',
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: isAuthenticated
                      ? OsmeaColors.nordicBlue
                      : OsmeaColors.pewter,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          _buildStatusItem(context, 'WooCommerce JWT', hasWooJwt),
          _buildStatusItem(context, 'Core Auth JWT', hasCoreJwt),
          _buildStatusItem(context, 'Cart Token', hasCartToken),
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

  Widget _buildWooJwtSection(BuildContext context, WooJwtToken? jwtToken) {
    if (jwtToken == null) {
      return _buildEmptySection(
        context,
        'WooCommerce JWT Token',
        'No JWT token found',
      );
    }

    final isExpired = jwtToken.isExpired;
    final needsRefresh = jwtToken.needsRefresh;

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
                'WooCommerce JWT Token',
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
                )
              else if (needsRefresh)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: context.borderRadiusLow,
                  ),
                  child: OsmeaComponents.text(
                    'NEEDS REFRESH',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          _buildTokenValue(context, 'Access Token', jwtToken.accessToken),
          if (jwtToken.refreshToken != null)
            _buildTokenValue(context, 'Refresh Token', jwtToken.refreshToken!),
          _buildInfoItem(context, 'Token Type', jwtToken.tokenType),
          _buildInfoItem(
            context,
            'Issued At',
            jwtToken.issuedAt.toIso8601String(),
          ),
          _buildInfoItem(
            context,
            'Expires At',
            jwtToken.expiresAt.toIso8601String(),
          ),
          _buildInfoItem(
            context,
            'Expires In',
            '${jwtToken.expiresIn} seconds',
          ),
          if (jwtToken.scope != null && jwtToken.scope!.isNotEmpty)
            _buildInfoItem(context, 'Scope', jwtToken.scope!),
        ],
      ),
    );
  }

  Widget _buildCoreAuthJwtSection(BuildContext context, String? authJwtToken) {
    if (authJwtToken == null || authJwtToken.isEmpty) {
      return _buildEmptySection(
        context,
        'Core Auth JWT Token',
        'No JWT token found',
      );
    }

    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.silver,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Core Auth JWT Token',
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

  Widget _buildUserDataSection(
    BuildContext context,
    Map<String, dynamic> authUserData,
  ) {
    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.silver,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'User Data',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          Container(
            padding: EdgeInsets.all(context.spacing12),
            decoration: BoxDecoration(
              color: OsmeaColors.ash,
              borderRadius: context.borderRadiusNormal,
            ),
            child: OsmeaComponents.text(
              authUserData.toString(),
              textStyle: OsmeaTextStyle.bodySmall(context),
            ),
          ),
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

  Widget _buildActions(BuildContext context, AuthDebugViewModel viewModel) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OsmeaComponents.button(
          onPressed: () => viewModel.refreshTokens(),
          variant: ButtonVariant.primary,
          size: ButtonSize.large,
          text: 'Refresh Tokens',
          textStyle: OsmeaTextStyle.bodyMedium(
            context,
          ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
