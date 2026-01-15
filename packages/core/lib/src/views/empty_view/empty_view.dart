import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/models/empty_view_models.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_cubit.dart';
import 'package:core/src/views/empty_view/cubit/empty_view_state.dart';
import 'package:core/src/views/empty_view/widgets/empty_view_startup_widget.dart';
import 'package:core/src/views/empty_view/widgets/empty_view_enterprise_widget.dart';
import 'package:core/src/views/empty_view/widgets/empty_view_space_widget.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🎯 **OSMEA Empty View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main empty view - supports 3 different styles
/// Gets its settings from app config and is shown when there are no items to display
///
/// {@category Views}
/// {@subCategory EmptyView}

class EmptyView
    extends MasterViewCubit<EmptyViewCubit, EmptyViewState> {
  /// Callback to be called when action button is pressed
  final VoidCallback? onActionPressed;

  /// Override empty view style - if null, uses config style
  final EmptyViewStyle? overrideStyle;

  /// Empty type to show
  final EmptyType emptyType;

  /// Custom title override
  final String? customTitle;

  /// Custom description override
  final String? customDescription;

  /// Custom image path override
  final String? customImagePath;

  /// Custom icon path override
  final String? customIconPath;

  EmptyView({
    required super.goRoute,
    required this.emptyType,
    super.arguments = const {'emptyView': true},
    this.onActionPressed,
    this.overrideStyle,
    this.customTitle,
    this.customDescription,
    this.customImagePath,
    this.customIconPath,
  }) : super(
          coreAppBar: (context, viewModel) => _buildEmptyViewAppBar(
            context,
            viewModel,
          ),
        );

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🎯 Empty View Start!');
    await viewModel.loadEmptyViewConfig();
    await viewModel.showEmpty(
      emptyType: emptyType,
      customTitle: customTitle,
      customDescription: customDescription,
      customImagePath: customImagePath,
      customIconPath: customIconPath,
    );
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    return _EmptyViewContent(
      viewModel: viewModel,
      state: state,
      onActionPressed: onActionPressed,
      overrideStyle: overrideStyle,
    );
  }

  /// Build default empty view app bar from config
  static PreferredSizeWidget _buildEmptyViewAppBar(
    BuildContext context,
    EmptyViewCubit viewModel,
  ) {
    final configHelper = AssetConfigHelper();
    final state = viewModel.state;
    
    final title = state.emptyTitle;
    final backgroundColor = _parseColor(
      configHelper.getString(
        'empty_view_configuration.app_bar.backgroundColor',
        '#FFFFFF',
      ),
    );
    final foregroundColor = _parseColor(
      configHelper.getString(
        'empty_view_configuration.app_bar.foregroundColor',
        '#000000',
      ),
    );
    final titleColor = _parseColor(
      configHelper.getString(
        'empty_view_configuration.app_bar.titleColor',
        '#000000',
      ),
    );
    final iconColor = _parseColor(
      configHelper.getString(
        'empty_view_configuration.app_bar.iconColor',
        '#000000',
      ),
    );
    final elevation = configHelper.getDouble(
      'empty_view_configuration.app_bar.elevation',
      0.0,
    );
    final showBackButton = configHelper.getBool(
      'empty_view_configuration.app_bar.show_back_button',
      true,
    );

    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        title,
        color: titleColor,
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      foregroundColor: foregroundColor,
      leading: showBackButton
          ? OsmeaComponents.iconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: iconColor,
                size: context.iconSizeNormal,
              ),
            )
          : null,
      actions: const [],
    );
  }

  /// Parse color string to Color
  static Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return OsmeaColors.white;
    }
  }
}

class _EmptyViewContent extends StatefulWidget {
  final EmptyViewCubit viewModel;
  final EmptyViewState state;
  final VoidCallback? onActionPressed;
  final EmptyViewStyle? overrideStyle;

  const _EmptyViewContent({
    required this.viewModel,
    required this.state,
    this.onActionPressed,
    this.overrideStyle,
  });

  @override
  State<_EmptyViewContent> createState() => _EmptyViewContentState();
}

class _EmptyViewContentState extends State<_EmptyViewContent>
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
        widget.state.config?.animationDuration ?? 400;

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
    return BlocConsumer<EmptyViewCubit, EmptyViewState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return _buildBody(context, state);
      },
    );
  }

  /// 🎯 Listen to state changes
  void _handleStateChanges(BuildContext context, EmptyViewState state) {
    switch (state.status) {
      case EmptyViewStatus.showingEmpty:
        _animationController.forward();
        break;
      case EmptyViewStatus.hidden:
        _animationController.reverse();
        break;
      default:
        break;
    }
  }

  /// 🏗️ Build main body
  Widget _buildBody(BuildContext context, EmptyViewState state) {
    switch (state.status) {
      case EmptyViewStatus.loading:
        return _buildLoadingView(context);
      case EmptyViewStatus.showingEmpty:
        return _buildEmptyContent(context, state);
      case EmptyViewStatus.hidden:
        return const SizedBox.shrink();
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

  /// 📱 Initial view (when no empty is being shown)
  Widget _buildInitialView(BuildContext context) {
    return const SizedBox.shrink();
  }

  /// 📭 Empty content
  Widget _buildEmptyContent(BuildContext context, EmptyViewState state) {
    if (!state.hasConfig) {
      return _buildLoadingView(context);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildEmptyByStyle(context, state),
      ),
    );
  }

  /// 🎨 Build empty view based on config style
  Widget _buildEmptyByStyle(BuildContext context, EmptyViewState state) {
    // Get style from config or use override
    final configStyle = widget.overrideStyle ?? state.config?.style;

    // Debug print to see what style is being used
    debugPrint('🎨 Empty view style: $configStyle');
    debugPrint('🔧 Config available: ${state.config != null}');
    if (state.config != null) {
      debugPrint('📋 Config style value: ${state.config!.style}');
    }

    // Select widget based on style
    switch (configStyle) {
      case EmptyViewStyle.enterprise:
        debugPrint('🏢 Using Enterprise Widget');
        return EmptyViewEnterpriseWidget(
          onActionPressed: widget.onActionPressed,
        );
      case EmptyViewStyle.space:
        debugPrint('🌌 Using Space Widget');
        return EmptyViewSpaceWidget(
          onActionPressed: widget.onActionPressed,
        );
      case EmptyViewStyle.startup:
      default:
        debugPrint('🚀 Using Startup Widget (default)');
        return EmptyViewStartupWidget(
          onActionPressed: widget.onActionPressed,
        );
    }
  }
}

/// 🎯 Empty View Provider Widget
/// This widget provides EmptyViewCubit and wraps the view
class EmptyViewProvider extends StatelessWidget {
  final Widget child;

  const EmptyViewProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmptyViewCubit(),
      child: child,
    );
  }
}

/// 🚀 Ready-to-use widget for easy implementation
class EmptyViewWidget extends StatelessWidget {
  /// Empty type to show
  final EmptyType emptyType;

  /// Callback to be called when action button is pressed
  final VoidCallback? onActionPressed;

  /// Override empty view style - if null, uses config style
  final EmptyViewStyle? overrideStyle;

  /// Custom title override
  final String? customTitle;

  /// Custom description override
  final String? customDescription;

  /// Custom image path override
  final String? customImagePath;

  /// Custom icon path override
  final String? customIconPath;

  const EmptyViewWidget({
    super.key,
    required this.emptyType,
    this.onActionPressed,
    this.overrideStyle,
    this.customTitle,
    this.customDescription,
    this.customImagePath,
    this.customIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyViewProvider(
      child: EmptyView(
        goRoute: (path) {}, // Default empty implementation
        emptyType: emptyType,
        onActionPressed: onActionPressed,
        overrideStyle: overrideStyle,
        customTitle: customTitle,
        customDescription: customDescription,
        customImagePath: customImagePath,
        customIconPath: customIconPath,
      ),
    );
  }
}
