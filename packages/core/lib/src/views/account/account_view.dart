/*
 * AccountView
 * -----------
 * Account view for OSMEA architecture.
 * Uses MasterViewCubit pattern with state management.
 *
 * Copyright (c) 2025, OSMEA Team
 * https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
 *
 * {@category Views}
 * {@subCategory AccountView}
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

/// 👤 **OSMEA Account View**
///
/// Displays the user account information and menu
/// Supports loading from app_config.json or mock data fallback
///
/// **Features:**
/// * 👤 User profile display with avatar
/// * 📋 Dynamic menu sections from configuration
/// * 🎨 Customizable icons and colors
/// * 🔄 State management with cubit
/// * 📱 Responsive design
///
/// **Usage:**
/// ```dart
/// AccountView(
///   goRoute: goRoute,
///   arguments: {'account': true},
/// )
/// ```
class AccountView extends MasterViewCubit<AccountCubit, AccountState>
    with AccountWidget {
  final Function(String)? _goRouteCallback;
  final Future<void> Function()? _onSignOutCallback;

  AccountView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.bottomNavigationBar,
    required super.goRoute,
    Future<void> Function()? onSignOut,
  }) : _goRouteCallback = goRoute,
        _onSignOutCallback = onSignOut,
        super(
          coreAppBar: (context, viewModel) =>
              _buildAccountAppBar(context, viewModel),
        ) {
    debugPrint('👤 AccountView: Constructor called');
  }

  @override
  Function(String)? get goRouteCallback => _goRouteCallback;

  @override
  Future<void> Function()? get onSignOutCallback => _onSignOutCallback;

  @override
  void initialContent(AccountCubit viewModel, BuildContext context) {
    debugPrint('👤 AccountView: initialContent called');
    // Always initialize to get latest profile from auth storage
    viewModel.initialize();
  }

  @override
  Widget viewContent(
    BuildContext context,
    AccountCubit viewModel,
    AccountState state,
  ) {
    debugPrint(
      '👤 AccountView: viewContent called with status: ${state.status}',
    );

    // Listen to AuthCubit state changes and refresh profile when authenticated
    // This handles the case where AccountView loads before AuthCubit state is updated after signin
    try {
      final authCubit = GetIt.I<AuthCubit>();
      return BlocListener<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, authState) {
          // If AuthCubit becomes authenticated, refresh profile data
          if (authState is AuthAuthenticatedState) {
            debugPrint(
              '👤 AccountView: AuthCubit authenticated, refreshing profile...',
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.refreshProfile();
            });
          }
        },
        child: _buildBody(context, viewModel, state),
      );
    } catch (e) {
      debugPrint('⚠️ AccountView: Could not access AuthCubit: $e');
      return _buildBody(context, viewModel, state);
    }
  }

  Widget _buildBody(
    BuildContext context,
    AccountCubit viewModel,
    AccountState state,
  ) {
    // Error state
    if (state.isError) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AccountErrorWidget(
            message: state.errorMessage ?? 'Unknown error',
            onRetry: () => viewModel.initialize(),
          ),
        ),
      );
    }

    // Loading state
    if (state.isLoading) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: const AccountLoadingWidget(),
        ),
      );
    }

    // Ready state
    if (state.isReady) {
      return buildAccountContent(context, viewModel, state);
    }

    // Initial state
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: const AccountLoadingWidget(),
      ),
    );
  }
}

/// Builds account app bar following OSMEA standards (same as cart)
PreferredSizeWidget _buildAccountAppBar(
  BuildContext context,
  AccountCubit? viewModel,
) {
  return AppBar(
    title: OsmeaComponents.text(
      'Account',
      color: OsmeaColors.thunder,
      textStyle: OsmeaTextStyle.titleLarge(context),
    ),
    backgroundColor: OsmeaColors.paperWhite,
    elevation: 0,
    foregroundColor: OsmeaColors.thunder,
    leading: OsmeaComponents.iconButton(
      onPressed: () => context.go('/home'),
      icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
    ),
  );
}

/// Loading widget for account view
class AccountLoadingWidget extends StatelessWidget {
  const AccountLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Error widget for account view
class AccountErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AccountErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: OsmeaColors.red),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.button(onPressed: onRetry, text: 'Retry'),
        ],
      ),
    );
  }
}



