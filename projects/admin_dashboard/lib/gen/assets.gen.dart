// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsI18nGen {
  const $AssetsI18nGen();

  /// File path: assets/i18n/resources_en.i18n.json
  String get resourcesEnI18n => 'assets/i18n/resources_en.i18n.json';

  /// List of all assets
  List<String> get values => [resourcesEnI18n];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/mf_logo.png
  AssetGenImage get mfLogo => const AssetGenImage('assets/images/mf_logo.png');

  /// File path: assets/images/onboarding_page_one.png
  AssetGenImage get onboardingPageOne =>
      const AssetGenImage('assets/images/onboarding_page_one.png');

  /// File path: assets/images/onboarding_page_three.png
  AssetGenImage get onboardingPageThree =>
      const AssetGenImage('assets/images/onboarding_page_three.png');

  /// File path: assets/images/onboarding_page_two.png
  AssetGenImage get onboardingPageTwo =>
      const AssetGenImage('assets/images/onboarding_page_two.png');

  /// File path: assets/images/osmea_logo_black.png
  AssetGenImage get osmeaLogoBlack =>
      const AssetGenImage('assets/images/osmea_logo_black.png');

  /// File path: assets/images/osmea_logo_white.png
  AssetGenImage get osmeaLogoWhite =>
      const AssetGenImage('assets/images/osmea_logo_white.png');

  /// File path: assets/images/welcome.png
  AssetGenImage get welcome => const AssetGenImage('assets/images/welcome.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    mfLogo,
    onboardingPageOne,
    onboardingPageThree,
    onboardingPageTwo,
    osmeaLogoBlack,
    osmeaLogoWhite,
    welcome,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsI18nGen i18n = $AssetsI18nGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
