import 'package:equatable/equatable.dart';
import 'package:core/src/models/empty_view_models.dart';

/// 🎯 **OSMEA Empty View State**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// State management for Empty View Cubit
///
/// {@category States}
/// {@subCategory EmptyViewState}

/// 📭 Empty view state class
class EmptyViewState extends Equatable {
  /// Current status
  final EmptyViewStatus status;

  /// Empty view configuration
  final EmptyViewConfigModel? config;

  /// Current empty type
  final EmptyType currentEmptyType;

  /// Current empty page
  final EmptyPageModel? currentEmptyPage;

  /// Custom title override
  final String? customTitle;

  /// Custom description override
  final String? customDescription;

  /// Custom image path override
  final String? customImagePath;

  /// Custom icon path override
  final String? customIconPath;

  const EmptyViewState({
    this.status = EmptyViewStatus.initial,
    this.config,
    this.currentEmptyType = EmptyType.general,
    this.currentEmptyPage,
    this.customTitle,
    this.customDescription,
    this.customImagePath,
    this.customIconPath,
  });

  /// State copy method
  EmptyViewState copyWith({
    EmptyViewStatus? status,
    EmptyViewConfigModel? config,
    EmptyType? currentEmptyType,
    EmptyPageModel? currentEmptyPage,
    String? customTitle,
    String? customDescription,
    String? customImagePath,
    String? customIconPath,
  }) {
    return EmptyViewState(
      status: status ?? this.status,
      config: config ?? this.config,
      currentEmptyType: currentEmptyType ?? this.currentEmptyType,
      currentEmptyPage: currentEmptyPage ?? this.currentEmptyPage,
      customTitle: customTitle ?? this.customTitle,
      customDescription: customDescription ?? this.customDescription,
      customImagePath: customImagePath ?? this.customImagePath,
      customIconPath: customIconPath ?? this.customIconPath,
    );
  }

  /// Initial status check
  bool get isInitial => status == EmptyViewStatus.initial;

  /// Loading status check
  bool get isLoading => status == EmptyViewStatus.loading;

  /// Showing empty status check
  bool get isShowingEmpty => status == EmptyViewStatus.showingEmpty;

  /// Hidden status check
  bool get isHidden => status == EmptyViewStatus.hidden;

  /// Is config loaded check
  bool get hasConfig => config != null;

  /// Is empty page available check
  bool get hasEmptyPage => currentEmptyPage != null;

  /// Empty title getter
  String get emptyTitle {
    // Priority: custom > empty page > config > default
    return customTitle ??
        currentEmptyPage?.title ??
        config?.defaultEmptyMessage ??
        'No items found';
  }

  /// Empty description getter
  String get emptyDescription {
    // Priority: custom > empty page > default
    return customDescription ??
        currentEmptyPage?.description ??
        'There are no items to display at the moment.';
  }

  /// Image path getter
  String? get imagePath {
    return customImagePath ?? currentEmptyPage?.imagePath;
  }

  /// Icon path getter
  String? get iconPath {
    return customIconPath ?? currentEmptyPage?.iconPath;
  }

  /// Action button text getter
  String? get actionButtonText {
    return currentEmptyPage?.actionButtonText;
  }

  @override
  List<Object?> get props => [
        status,
        config,
        currentEmptyType,
        currentEmptyPage,
        customTitle,
        customDescription,
        customImagePath,
        customIconPath,
      ];

  @override
  String toString() {
    return '''EmptyViewState(
      status: $status,
      currentEmptyType: $currentEmptyType,
      hasConfig: $hasConfig,
      hasEmptyPage: $hasEmptyPage,
    )''';
  }
}
