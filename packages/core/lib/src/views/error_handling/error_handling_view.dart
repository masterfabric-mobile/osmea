import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/models/error_handling_models.dart';
import 'package:core/src/views/error_handling/cubit/error_handling_cubit.dart';
import 'package:core/src/views/error_handling/cubit/error_handling_state.dart';
import 'package:core/src/views/error_handling/widgets/error_handling_startup_widget.dart';
import 'package:core/src/views/error_handling/widgets/error_handling_enterprise_widget.dart';
import 'package:core/src/views/error_handling/widgets/error_handling_space_widget.dart';
import 'package:core/src/di/config/config_di.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🎯 **OSMEA Error Handling View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main error handling view - supports 3 different styles
/// Gets its settings from app config and is shown in error situations
///
/// {@category Views}
/// {@subCategory ErrorHandlingView}

class ErrorHandlingView
    extends MasterViewCubit<ErrorHandlingCubit, ErrorHandlingState> {
  /// Callback to be called when retry operation is successful
  final VoidCallback? onRetrySuccess;

  /// Callback for going to home page
  final VoidCallback? onGoHome;

  /// Callback for going back
  final VoidCallback? onGoBack;

  /// Callback to be called when error is dismissed
  final VoidCallback? onDismiss;

  /// Custom retry function - uses default retry behavior if null
  final Future<bool> Function()? customRetryFunction;

  /// Override error handling style - if null, uses config style
  final ErrorHandlingStyle? overrideStyle;

  ErrorHandlingView({
    required super.goRoute,
    super.arguments = const {'errorHandling': true},
    this.onRetrySuccess,
    this.onGoHome,
    this.onGoBack,
    this.onDismiss,
    this.customRetryFunction,
    this.overrideStyle,
  });

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🎯 Error Handling View Start!');
    await viewModel.loadErrorHandlingConfig();

    // Show a simple error for demonstration
    await viewModel.showError(
      errorType: ErrorType.general,
      errorMessage: 'Something went wrong. Please try again.',
    );
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    return _ErrorHandlingContent(
      viewModel: viewModel,
      state: state,
      onRetrySuccess: onRetrySuccess,
      onGoHome: onGoHome,
      onGoBack: onGoBack,
      onDismiss: onDismiss,
      customRetryFunction: customRetryFunction,
      overrideStyle: overrideStyle,
    );
  }
}

class _ErrorHandlingContent extends StatefulWidget {
  final ErrorHandlingCubit viewModel;
  final ErrorHandlingState state;
  final VoidCallback? onRetrySuccess;
  final VoidCallback? onGoHome;
  final VoidCallback? onGoBack;
  final VoidCallback? onDismiss;
  final Future<bool> Function()? customRetryFunction;
  final ErrorHandlingStyle? overrideStyle;

  const _ErrorHandlingContent({
    required this.viewModel,
    required this.state,
    this.onRetrySuccess,
    this.onGoHome,
    this.onGoBack,
    this.onDismiss,
    this.customRetryFunction,
    this.overrideStyle,
  });

  @override
  State<_ErrorHandlingContent> createState() => _ErrorHandlingContentState();
}

class _ErrorHandlingContentState extends State<_ErrorHandlingContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// 🎮 Initialize animations
  void _initializeAnimations() {
    // Get animation duration from config or use default
    final animationDuration =
        widget.viewModel.state.config?.animationDuration ?? 400;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ErrorHandlingCubit, ErrorHandlingState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: OsmeaComponents.container(
              color: _getBackgroundColor(context, widget.state),
              child: SafeArea(
                bottom: false,
                child: OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing16,
                    vertical: context.spacing8,
                  ),
                  child: OsmeaComponents.row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: OsmeaComponents.container(
                          padding: EdgeInsets.all(context.spacing8),
                          child: Icon(
                            Icons.arrow_back,
                            color: OsmeaColors.slate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: _getBackgroundColor(context, widget.state),
          body: _buildBody(context, widget.state),
        );
      },
    );
  }

  /// 🎯 Listen to state changes
  void _handleStateChanges(BuildContext context, ErrorHandlingState state) {
    switch (state.status) {
      case ErrorHandlingStatus.showingError:
        _animationController.forward();
        break;
      case ErrorHandlingStatus.retrying:
        // Call custom retry function when retry operation starts
        if (widget.customRetryFunction != null) {
          _performCustomRetry();
        }
        break;
      case ErrorHandlingStatus.resolved:
        widget.onRetrySuccess?.call();
        break;
      default:
        break;
    }
  }

  /// 🔄 Perform custom retry operation
  Future<void> _performCustomRetry() async {
    try {
      final success = await widget.customRetryFunction!();
      if (success) {
        if (mounted) {
          widget.viewModel.markResolved();
        }
      } else {
        // Retry failed, return to error state
        if (mounted) {
          widget.viewModel.showError(
            errorType: widget.viewModel.state.currentErrorType,
            errorMessage: 'Retry operation failed',
          );
        }
      }
    } catch (e) {
      // Error occurred during retry
      if (mounted) {
        widget.viewModel.showError(
          errorType: ErrorType.general,
          errorMessage: 'Error during retry: ${e.toString()}',
          originalException: e is Exception ? e : Exception(e.toString()),
        );
      }
    }
  }

  /// 🎨 Determine background color
  Color _getBackgroundColor(BuildContext context, ErrorHandlingState state) {
    // Use current error page color if available
    final currentPageColor = state.currentErrorPage?.getBackgroundColor();
    if (currentPageColor != null) return currentPageColor;

    // Use primary color from config as background
    final configPrimaryColor = state.config?.getPrimaryColor();
    if (configPrimaryColor != null) return configPrimaryColor;

    // Default color
    return OsmeaColors.paperWhite;
  }

  /// 🏗️ Build main body
  Widget _buildBody(BuildContext context, ErrorHandlingState state) {
    switch (state.status) {
      case ErrorHandlingStatus.loading:
        return _buildLoadingView(context);
      case ErrorHandlingStatus.showingError:
      case ErrorHandlingStatus.retrying:
        return _buildErrorContent(context, state);
      case ErrorHandlingStatus.resolved:
        return _buildResolvedView(context);
      default:
        return _buildInitialView(context);
    }
  }

  /// ⏳ Loading view - minimalist, no text
  Widget _buildLoadingView(BuildContext context) {
    return OsmeaComponents.container(
      padding: context.paddingNormal,
      child: OsmeaComponents.center(
        child: OsmeaComponents.loading(
          type: LoadingType.circularFade,
          size: 48,
          color: OsmeaColors.nordicBlue,
        ),
      ),
    );
  }

  /// 📱 Initial view (when no error is being shown)
  Widget _buildInitialView(BuildContext context) {
    return OsmeaComponents.container(
      padding: context.paddingNormal,
      child: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: context.iconSizeExtraHigh,
              color: OsmeaColors.forestHeart,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'Everything looks good!',
              variant: OsmeaTextVariant.titleLarge,
              color: OsmeaColors.thunder,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              'No errors found at the moment.',
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.pewter,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Resolved view (when error is resolved)
  Widget _buildResolvedView(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: OsmeaComponents.container(
          padding: context.paddingNormal,
          child: OsmeaComponents.center(
            child: OsmeaComponents.column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: context.iconSizeExtraHigh,
                  color: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.text(
                  'Problem Resolved!',
                  variant: OsmeaTextVariant.titleLarge,
                  color: OsmeaColors.thunder,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                OsmeaComponents.sizedBox(height: context.spacing8),
                OsmeaComponents.text(
                  'Error has been successfully resolved.',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.pewter,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🚨 Error content
  Widget _buildErrorContent(BuildContext context, ErrorHandlingState state) {
    if (!state.hasConfig) {
      return _buildLoadingView(context);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildErrorByStyle(context, state),
      ),
    );
  }

  /// 🎨 Build error view based on config style
  Widget _buildErrorByStyle(BuildContext context, ErrorHandlingState state) {
    // Get style from config or use override
    final configStyle = widget.overrideStyle ?? state.config?.style;

    // Debug print to see what style is being used
    debugPrint('🎨 Error handling style: $configStyle');
    debugPrint('🔧 Config available: ${state.config != null}');
    if (state.config != null) {
      debugPrint('📋 Config style value: ${state.config!.style}');
    }

    // Select widget based on style
    switch (configStyle) {
      case ErrorHandlingStyle.enterprise:
        debugPrint('🏢 Using Enterprise Widget');
        return ErrorHandlingEnterpriseWidget(
          onRetry: _onRetry,
          onGoHome: _onGoHome,
          onContactSupport: _onContactSupport,
          onGoBack: _onGoBack,
          onDismiss: _onDismiss,
        );
      case ErrorHandlingStyle.space:
        debugPrint('🌌 Using Space Widget');
        return ErrorHandlingSpaceWidget(
          onRetry: _onRetry,
          onGoHome: _onGoHome,
          onContactSupport: _onContactSupport,
          onGoBack: _onGoBack,
          onDismiss: _onDismiss,
        );
      case ErrorHandlingStyle.startup:
      default:
        debugPrint('🚀 Using Startup Widget (default)');
        return ErrorHandlingStartupWidget(
          onRetry: _onRetry,
          onGoHome: _onGoHome,
          onContactSupport: _onContactSupport,
          onGoBack: _onGoBack,
          onDismiss: _onDismiss,
        );
    }
  }

  /// 🔄 Retry button pressed
  void _onRetry() {
    context.read<ErrorHandlingCubit>().retry();
  }

  /// 🏠 Home button pressed
  void _onGoHome() {
    context.read<ErrorHandlingCubit>().goHome();
    widget.onGoHome?.call();
  }

  /// 📞 Contact support button pressed
  void _onContactSupport() {
    context.read<ErrorHandlingCubit>().contactSupport();
    _showSupportOptions(context);
  }

  /// ⬅️ Back button pressed
  void _onGoBack() {
    context.read<ErrorHandlingCubit>().goBack();
    widget.onGoBack?.call();
  }

  /// ❌ Dismiss button pressed
  void _onDismiss() {
    context.read<ErrorHandlingCubit>().dismissError();
    widget.onDismiss?.call();
  }

  /// 📞 Show support options
  void _showSupportOptions(BuildContext context) {
    final state = context.read<ErrorHandlingCubit>().state;

    showModalBottomSheet(
      context: context,
      builder: (context) => OsmeaComponents.container(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OsmeaComponents.text(
              'Support Options',
              variant: OsmeaTextVariant.titleMedium,
              color: OsmeaColors.thunder,
              fontWeight: FontWeight.bold,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // Email Support
            if (state.hasSupportEmail)
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Send Email'),
                subtitle: Text(state.config!.supportEmail!),
                onTap: () => _launchEmail(state.config!.supportEmail!),
              ),

            // Phone Support
            if (state.hasSupportPhone)
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call'),
                subtitle: Text(state.config!.supportPhone!),
                onTap: () => _launchPhone(state.config!.supportPhone!),
              ),

            // Close Button
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.button(
              text: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              variant: ButtonVariant.secondary,
              size: ButtonSize.medium,
            ),
          ],
        ),
      ),
    );
  }

  /// 📧 Email launcher
  Future<void> _launchEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=Application Error Report&body=Hello,\n\nI encountered an error while using the application.\n\nError Details:\n${_getErrorDetailsForEmail()}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// 📱 Phone launcher
  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// 📝 Prepare error details for email
  String _getErrorDetailsForEmail() {
    final state = context.read<ErrorHandlingCubit>().state;
    final buffer = StringBuffer();

    buffer.writeln('Error Type: ${state.currentErrorType}');
    if (state.errorCode != null) {
      buffer.writeln('Error Code: ${state.errorCode}');
    }
    if (state.errorMessage != null) {
      buffer.writeln('Error Message: ${state.errorMessage}');
    }
    buffer.writeln('Retry Count: ${state.retryCount}');
    buffer.writeln('Date: ${DateTime.now().toLocal()}');

    return buffer.toString();
  }
}

/// 🎯 Error Handling Provider Widget
/// This widget provides ErrorHandlingCubit and wraps the view
class ErrorHandlingProvider extends StatelessWidget {
  final Widget child;

  const ErrorHandlingProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ErrorHandlingCubit(),
      child: child,
    );
  }
}

/// 🚀 Ready-to-use widget for easy implementation
class ErrorHandlingScreen extends StatelessWidget {
  /// Callback to be called when retry operation is successful
  final VoidCallback? onRetrySuccess;

  /// Callback for going to home page
  final VoidCallback? onGoHome;

  /// Callback for going back
  final VoidCallback? onGoBack;

  /// Callback to be called when error is dismissed
  final VoidCallback? onDismiss;

  /// Custom retry function
  final Future<bool> Function()? customRetryFunction;

  /// Override error handling style - if null, uses config style
  final ErrorHandlingStyle? overrideStyle;

  const ErrorHandlingScreen({
    super.key,
    this.onRetrySuccess,
    this.onGoHome,
    this.onGoBack,
    this.onDismiss,
    this.customRetryFunction,
    this.overrideStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorHandlingProvider(
      child: ErrorHandlingView(
        goRoute: (path) {}, // Default empty implementation
        onRetrySuccess: onRetrySuccess,
        onGoHome: onGoHome,
        onGoBack: onGoBack,
        onDismiss: onDismiss,
        customRetryFunction: customRetryFunction,
        overrideStyle: overrideStyle,
      ),
    );
  }
}

/// 🎯 Global Error Handler - Can be called from anywhere in the application
class GlobalErrorHandler {
  /// Get ErrorHandlingCubit from DI container
  static ErrorHandlingCubit? get _cubit {
    try {
      return getIt<ErrorHandlingCubit>();
    } catch (e) {
      debugPrint('Failed to get ErrorHandlingCubit from DI: $e');
      return null;
    }
  }

  /// Show global error
  static Future<void> showGlobalError({
    required ErrorType errorType,
    String? errorMessage,
    String? errorCode,
    String? stackTrace,
    Exception? originalException,
  }) async {
    final cubit = _cubit;
    if (cubit != null) {
      await cubit.showError(
        errorType: errorType,
        errorMessage: errorMessage,
        errorCode: errorCode,
        stackTrace: stackTrace,
        originalException: originalException,
      );
    } else {
      debugPrint('ErrorHandlingCubit not available in DI container');
    }
  }

  /// Quick error methods
  static Future<void> showNetworkError([String? message]) async {
    await showGlobalError(errorType: ErrorType.network, errorMessage: message);
  }

  static Future<void> showServerError(
      [String? message, String? errorCode]) async {
    await showGlobalError(
        errorType: ErrorType.server,
        errorMessage: message,
        errorCode: errorCode);
  }

  static Future<void> showAuthError([String? message]) async {
    await showGlobalError(
        errorType: ErrorType.authentication, errorMessage: message);
  }
}
