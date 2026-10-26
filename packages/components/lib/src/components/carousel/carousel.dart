import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/carousel/cubit/carousel_cubit.dart';
import 'package:osmea_components/src/components/carousel/cubit/carousel_state.dart';
import 'package:osmea_components/src/components/center/center.dart';
import 'package:osmea_components/src/components/container/container.dart';
import 'package:osmea_components/src/components/row/row.dart';
import 'package:osmea_components/src/components/single_child_scroll_view/single_child_scroll_view.dart';
import 'package:osmea_components/src/components/sized_box/sized_box.dart';
import 'package:osmea_components/src/core/container_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🎠 **OSMEA Carousel**
///
class OsmeaCarousel extends CoreContainer {
  final List<Widget>? items;
  final List<String>? imageUrls;
  final List<VoidCallback?>? onItemTaps;
  final double? viewportFraction;
  final CarouselVariant variant;
  final CarouselSize size;
  final CarouselNavigationType navigationType;
  final CarouselAutoPlay autoPlay;
  final CarouselTransitionType transitionType;
  final CarouselIndicatorPosition indicatorPosition;
  final CarouselArrowPosition arrowPosition;
  final int initialIndex;
  final int? currentIndex;
  final Duration autoPlayInterval;
  final ValueChanged<int>? onPageChanged;
  final Widget? defaultImageIcon;
  final bool disabled;
  final bool selected;
  final bool showIndicators;
  final bool showArrows;
  final Color? backgroundColor;
  final Color? borderColor;
  final ShapeBorder? customShape;
  final Duration animationDuration;
  final String? tooltip;
  final EdgeInsetsGeometry? customPadding;
  final BorderRadius? borderRadiusValue;
  final CarouselIndicatorType indicatorType;
  final Widget Function(BuildContext, int, int)? customIndicator;
  final Widget Function(BuildContext, bool isLeft)? customArrowBuilder;
  final bool loop;
  final CarouselArrowStyle arrowStyle;
  final double itemSpacing;
  final bool useDotIndicatorWidget;
  final DotIndicatorVariant? dotVariant;
  final DotIndicatorSize? dotIndicatorSize;
  final DotIndicatorShape? dotShape;
  final DotIndicatorStyle? dotStyle;
  final DotIndicatorAnimation? dotAnimation;
  final Color? dotCustomActiveColor;
  final Color? dotCustomInactiveColor;

  // Private fields for overridden properties
  final CoreTheme? _customTheme;
  final EdgeInsetsGeometry? _margin;
  final double? _height;
  final double? _width;

  const OsmeaCarousel({
    Key? key,
    CoreTheme? customTheme,
    this.items,
    this.imageUrls,
    this.onItemTaps,
    this.viewportFraction,
    this.variant = CarouselVariant.standard,
    this.size = CarouselSize.medium,
    this.navigationType = CarouselNavigationType.both,
    this.autoPlay = CarouselAutoPlay.none,
    this.transitionType = CarouselTransitionType.slide,
    this.indicatorPosition = CarouselIndicatorPosition.bottomCenter,
    this.arrowPosition = CarouselArrowPosition.inside,
    this.initialIndex = 0,
    this.currentIndex,
    double? height,
    double? width,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.onPageChanged,
    this.defaultImageIcon,
    this.disabled = false,
    this.selected = false,
    this.showIndicators = true,
    this.showArrows = true,
    this.backgroundColor,
    this.borderColor,
    this.customShape,
    this.animationDuration = const Duration(milliseconds: 300),
    this.tooltip,
    this.customPadding,
    EdgeInsetsGeometry? margin,
    this.borderRadiusValue,
    this.indicatorType = CarouselIndicatorType.dot,
    this.customIndicator,
    this.customArrowBuilder,
    this.loop = false,
    this.arrowStyle = CarouselArrowStyle.modern,
    this.itemSpacing = 12.0,
    this.useDotIndicatorWidget = false,
    this.dotVariant,
    this.dotIndicatorSize,
    this.dotShape,
    this.dotStyle,
    this.dotAnimation,
    this.dotCustomActiveColor,
    this.dotCustomInactiveColor,
  })  : _customTheme = customTheme,
        _margin = margin,
        _height = height,
        _width = width,
        super(
            key: key,
            customTheme: customTheme,
            margin: margin,
            height: height,
            width: width);

  @override
  CoreTheme? get customTheme => _customTheme;
  @override
  EdgeInsetsGeometry? get margin => _margin;
  @override
  double? get height => _height;
  @override
  double? get width => _width;

  @override
  Widget buildWidget(BuildContext context) {
    final sizeConfig = size.config(context);
    final variantConfig = variant.config(context);
    final BorderRadius effectiveBorderRadius = context.borderRadiusMinStandard;
    final List<Widget> children = items != null
        ? List.generate(items!.length, (i) {
            final child = items![i];
            final onTap = onItemTaps != null && i < onItemTaps!.length
                ? onItemTaps![i]
                : null;
            Widget decorated = child;
            if (child is Icon) {
              decorated = OsmeaContainer(
                decoration: BoxDecoration(
                  border: Border.all(color: OsmeaColors.steel, width: 2),
                  borderRadius: context.borderRadiusMinStandard,
                ),
                padding: context.paddingNormal,
                child: child,
              );
            }
            if (onTap != null) {
              return GestureDetector(
                onTap: onTap,
                child: decorated,
              );
            } else {
              return decorated;
            }
          })
        : (imageUrls != null
            ? imageUrls!.map((url) => _buildImage(context, url)).toList()
            : []);
    final int itemCount = children.length;
    final double responsiveWidth = width ??
        (size == CarouselSize.large
            ? context.allWidth * 0.9
            : (size == CarouselSize.medium
                ? context.allWidth * 0.7
                : sizeConfig.width));
    final double responsiveHeight = height ?? sizeConfig.height;
    final bool effectiveShowIndicators =
        variant == CarouselVariant.multi ? false : showIndicators;

    return BlocProvider<CarouselCubit>(
      create: (_) {
        double effectiveViewportFraction;
        if (variant == CarouselVariant.multi) {
          effectiveViewportFraction = viewportFraction ?? (1 / 2.2);
        } else {
          effectiveViewportFraction = viewportFraction ?? 1.0;
        }
        return CarouselCubit(
            CarouselState(
              activeIndex: initialIndex,
              itemCount: itemCount,
              isLooping: loop,
              isAutoPlaying: autoPlay == CarouselAutoPlay.continuous,
              enabled: !disabled,
              selected: selected,
              transitionType: transitionType,
              indicatorType: indicatorType,
              navigationType: navigationType,
              autoPlayInterval: autoPlayInterval,
            ),
            viewportFraction: effectiveViewportFraction);
      },
      child: _OsmeaCarouselAutoplayWrapper(
        parent: this,
        itemCount: itemCount,
        sizeConfig: sizeConfig,
        variantConfig: variantConfig,
        effectiveBorderRadius: effectiveBorderRadius,
        responsiveWidth: responsiveWidth,
        responsiveHeight: responsiveHeight,
        itemSpacing: itemSpacing,
        showIndicators: effectiveShowIndicators,
        children: children,
      ),
    );
  }

  Widget _buildImage(BuildContext context, String url) {
    return OsmeaContainer(
      decoration: BoxDecoration(
        color: OsmeaColors.transparent,
        border: Border.all(color: OsmeaColors.silver, width: .5),
        borderRadius: context.borderRadiusMinStandard,
      ),
      clipBehavior: clipAntiAlias,
      child: Image.network(
        url,
        fit: cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return OsmeaContainer(
            decoration: BoxDecoration(
              color: OsmeaColors.silver,
              borderRadius: context.borderRadiusMinStandard,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Center(
            child: defaultImageIcon ??
                Icon(Icons.image_outlined,
                    size: context.iconSizeExtraHigh,
                    color: OsmeaColors.silver)),
      ),
    );
  }

  /// Factory: Numbered black card carousel (for demo/testing)
  static OsmeaCarousel exampleNumberCarousel({
    int itemCount = 5,
    int currentIndex = 0,
    double? width,
    double? height,
    CarouselSize size = CarouselSize.medium,
  }) {
    return OsmeaCarousel(
      items: List.generate(
        itemCount,
        (i) => OsmeaContainer(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: OsmeaColors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            "${i + 1}",
            style: const TextStyle(color: OsmeaColors.white, fontSize: 24),
          ),
        ),
      ),
      currentIndex: currentIndex,
      size: size,
      width: width,
      height: height,
      showIndicators: true,
      showArrows: true,
      loop: false,
      backgroundColor: OsmeaColors.transparent,
    );
  }
}

class _OsmeaCarouselAutoplayWrapper extends StatelessWidget {
  final OsmeaCarousel parent;
  final List<Widget> children;
  final int itemCount;
  final CarouselSizeConfig sizeConfig;
  final CarouselVariantConfig variantConfig;
  final BorderRadius effectiveBorderRadius;
  final double responsiveWidth;
  final double responsiveHeight;
  final double itemSpacing;
  final bool showIndicators;

  const _OsmeaCarouselAutoplayWrapper({
    required this.parent,
    required this.children,
    required this.itemCount,
    required this.sizeConfig,
    required this.variantConfig,
    required this.effectiveBorderRadius,
    required this.responsiveWidth,
    required this.responsiveHeight,
    required this.itemSpacing,
    required this.showIndicators,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure autoplay is started/stopped by the Cubit
    final cubit = context.read<CarouselCubit>();
    if (parent.autoPlay == CarouselAutoPlay.continuous && itemCount > 1) {
      cubit.startAutoPlay();
    } else {
      cubit.stopAutoPlay();
    }
    return _OsmeaCarouselView(
      parent: parent,
      itemCount: itemCount,
      sizeConfig: sizeConfig,
      variantConfig: variantConfig,
      effectiveBorderRadius: effectiveBorderRadius,
      responsiveWidth: responsiveWidth,
      responsiveHeight: responsiveHeight,
      itemSpacing: itemSpacing,
      showIndicators: showIndicators,
      children: children,
    );
  }
}

class _OsmeaCarouselView extends StatelessWidget {
  final OsmeaCarousel parent;
  final List<Widget> children;
  final int itemCount;
  final CarouselSizeConfig sizeConfig;
  final CarouselVariantConfig variantConfig;
  final BorderRadius effectiveBorderRadius;
  final double responsiveWidth;
  final double responsiveHeight;
  final double itemSpacing;
  final bool showIndicators;

  const _OsmeaCarouselView({
    required this.parent,
    required this.children,
    required this.itemCount,
    required this.sizeConfig,
    required this.variantConfig,
    required this.effectiveBorderRadius,
    required this.responsiveWidth,
    required this.responsiveHeight,
    required this.itemSpacing,
    required this.showIndicators,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarouselCubit, CarouselState>(
      builder: (context, state) {
        final cubit = context.read<CarouselCubit>();
        final bool isMulti = parent.variant == CarouselVariant.multi;
        final bool isDisabled = parent.disabled || !state.enabled;
        final bool isSelected = parent.selected || state.selected;
        final Color finalBackgroundColor =
            parent.backgroundColor ?? variantConfig.backgroundColor;

        Widget carouselContent = AnimatedContainer(
          duration: parent.animationDuration,
          height: responsiveHeight,
          width: responsiveWidth,
          margin: parent.margin,
          decoration: ShapeDecoration(
            color: finalBackgroundColor,
            shape: parent.customShape ??
                RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            shadows: null,
          ),
          padding: parent.customPadding ?? context.horizontalMarginNormal / 2,
          child: ClipRRect(
            borderRadius: effectiveBorderRadius,
            clipBehavior: clipAntiAlias,
            child: PageView.builder(
              controller: cubit.pageController,
              itemCount: itemCount,
              padEnds: isMulti ? false : true,
              onPageChanged: (index) {
                cubit.jumpTo(index);
                parent.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: itemSpacing / 2),
                child: children[index],
              ),
            ),
          ),
        );

        List<Widget> stackChildren = [carouselContent];
        if (parent.showArrows &&
            (parent.navigationType == CarouselNavigationType.arrows ||
                parent.navigationType == CarouselNavigationType.both)) {
          stackChildren.add(_buildArrows(context, itemCount, sizeConfig,
              variantConfig, isDisabled, state));
        }
        if (showIndicators &&
            (parent.navigationType == CarouselNavigationType.dots ||
                parent.navigationType == CarouselNavigationType.both)) {
          Widget indicator = _buildIndicators(
              context, itemCount, sizeConfig, variantConfig, state);
          switch (parent.indicatorPosition) {
            case CarouselIndicatorPosition.topCenter:
              stackChildren
                  .add(Positioned(top: 8, left: 0, right: 0, child: indicator));
              break;
            case CarouselIndicatorPosition.topLeft:
              stackChildren.add(Positioned(top: 8, left: 8, child: indicator));
              break;
            case CarouselIndicatorPosition.topRight:
              stackChildren.add(Positioned(top: 8, right: 8, child: indicator));
              break;
            case CarouselIndicatorPosition.bottomLeft:
              stackChildren
                  .add(Positioned(bottom: 13, left: 8, child: indicator));
              break;
            case CarouselIndicatorPosition.bottomRight:
              stackChildren
                  .add(Positioned(bottom: 13, right: 8, child: indicator));
              break;
            case CarouselIndicatorPosition.bottomCenter:
              stackChildren.add(
                  Positioned(bottom: 13, left: 0, right: 0, child: indicator));
              break;
          }
        }

        Widget result = OsmeaSizedBox(
          height: responsiveHeight,
          width: responsiveWidth,
          child: Stack(
            alignment: center,
            children: stackChildren,
          ),
        );

        result = Semantics(
          button: true,
          selected: isSelected,
          enabled: !isDisabled,
          label: parent.tooltip ?? 'Carousel',
          child: AnimatedOpacity(
            duration: parent.animationDuration,
            opacity: isDisabled ? 0.6 : 1.0,
            child: parent.tooltip != null
                ? Tooltip(message: parent.tooltip!, child: result)
                : result,
          ),
        );
        return result;
      },
    );
  }

  Widget _buildArrows(
      BuildContext context,
      int itemCount,
      CarouselSizeConfig config,
      CarouselVariantConfig variantConfig,
      bool isDisabled,
      CarouselState state) {
    final parent = this.parent;
    if (!parent.showArrows) return const SizedBox.shrink();
    bool isLoop = parent.loop;
    final bool showLeftArrow = isLoop || !state.isAtStart;
    final bool showRightArrow = isLoop || !state.isAtEnd;
    if (parent.customArrowBuilder != null) {
      return Stack(
        children: [
          if (showRightArrow)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        if (isLoop && itemCount > 1) {
                          int nextIndex = (state.activeIndex + 1) % itemCount;
                          context.read<CarouselCubit>().jumpTo(nextIndex);
                        } else if (!state.isAtEnd) {
                          context.read<CarouselCubit>().next();
                        }
                      },
                child: parent.customArrowBuilder!(context, false),
              ),
            ),
          if (showLeftArrow)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        if (isLoop && itemCount > 1) {
                          int prevIndex =
                              (state.activeIndex - 1 + itemCount) % itemCount;
                          context.read<CarouselCubit>().jumpTo(prevIndex);
                        } else if (!state.isAtStart) {
                          context.read<CarouselCubit>().previous();
                        }
                      },
                child: parent.customArrowBuilder!(context, true),
              ),
            ),
        ],
      );
    }
    return Stack(
      children: [
        if (showRightArrow)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      if (isLoop && itemCount > 1) {
                        int nextIndex = (state.activeIndex + 1) % itemCount;
                        context.read<CarouselCubit>().jumpTo(nextIndex);
                      } else if (!state.isAtEnd) {
                        context.read<CarouselCubit>().next();
                      }
                    },
              child: _minimalArrowIcon(context, false),
            ),
          ),
        if (showLeftArrow)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      if (isLoop && itemCount > 1) {
                        int prevIndex =
                            (state.activeIndex - 1 + itemCount) % itemCount;
                        context.read<CarouselCubit>().jumpTo(prevIndex);
                      } else if (!state.isAtStart) {
                        context.read<CarouselCubit>().previous();
                      }
                    },
              child: _minimalArrowIcon(context, true),
            ),
          ),
      ],
    );
  }

  Widget _minimalArrowIcon(BuildContext context, bool isLeft) {
    return OsmeaContainer(
      width: context.width24,
      height: context.height24,
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: OsmeaColors.shadowLight, width: 1),
      ),
      child: Icon(
        isLeft ? Icons.chevron_left : Icons.chevron_right,
        size: context.iconSizeNormal,
        color: OsmeaColors.slate,
      ),
    );
  }

  Widget _buildIndicators(
      BuildContext context,
      int itemCount,
      CarouselSizeConfig config,
      CarouselVariantConfig variantConfig,
      CarouselState state) {
    // Never rotate indicators in multi-item carousel
    if (parent.variant == CarouselVariant.multi) {
      return const SizedBox.shrink();
    }
    int activeIndex = state.activeIndex;
    final BorderRadius indicatorRadius = context.borderRadiusMinStandard;
    if (parent.useDotIndicatorWidget) {
      // Debug: activeIndex değişimini kontrol et
      debugPrint(
          '🔘 DotIndicator - activeIndex: $activeIndex, itemCount: $itemCount');
      return OsmeaComponents.dotIndicator(
        key: ValueKey(
            'carousel_dot_indicator_$activeIndex'), // 🔑 Key ile widget'ı yeniden oluştur
        itemCount: itemCount,
        currentIndex: activeIndex,
        size: parent.dotIndicatorSize ?? DotIndicatorSize.medium,
        variant: parent.dotVariant ?? DotIndicatorVariant.primary,
        shape: parent.dotShape ?? DotIndicatorShape.circle,
        style: parent.dotStyle ?? DotIndicatorStyle.filled,
        animation: parent.dotAnimation ?? DotIndicatorAnimation.scale,
        customActiveColor: parent.dotCustomActiveColor,
        customInactiveColor: parent.dotCustomInactiveColor,
        onDotTapped: (index) {
          context.read<CarouselCubit>().jumpTo(index);
          if (parent.onPageChanged != null) {
            parent.onPageChanged!(index);
          }
        },
      );
    }

    Widget indicatorRow;
    switch (parent.indicatorType) {
      case CarouselIndicatorType.dot:
        indicatorRow = OsmeaRow(
          mainAxisSize: min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            return GestureDetector(
              onTap: () {
                context.read<CarouselCubit>().jumpTo(index);
                if (parent.onPageChanged != null) {
                  parent.onPageChanged!(index);
                }
              },
              child: AnimatedContainer(
                duration: context.animationMedium,
                margin: context.horizontalMarginNormal,
                width: index == activeIndex
                    ? config.dotSize * 1.5
                    : config.dotSize,
                height: config.dotSize,
                decoration: BoxDecoration(
                  color: index == activeIndex
                      ? variantConfig.activeDotColor
                      : variantConfig.dotColor,
                  borderRadius: indicatorRadius,
                ),
              ),
            );
          }),
        );
        break;
      case CarouselIndicatorType.bar:
        indicatorRow = OsmeaRow(
          mainAxisSize: min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            return GestureDetector(
              onTap: () {
                context.read<CarouselCubit>().jumpTo(index);
                if (parent.onPageChanged != null) {
                  parent.onPageChanged!(index);
                }
              },
              child: AnimatedContainer(
                duration: context.animationMedium,
                margin: context.horizontalMarginNormal,
                width: index == activeIndex
                    ? config.dotSize * 2.5
                    : config.dotSize,
                height: config.dotSize * 0.5,
                decoration: BoxDecoration(
                  color: index == activeIndex
                      ? variantConfig.activeDotColor
                      : variantConfig.dotColor,
                  borderRadius: indicatorRadius,
                ),
              ),
            );
          }),
        );
        break;
      case CarouselIndicatorType.rectangle:
        indicatorRow = OsmeaRow(
          mainAxisSize: min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            return GestureDetector(
              onTap: () {
                context.read<CarouselCubit>().jumpTo(index);
                if (parent.onPageChanged != null) {
                  parent.onPageChanged!(index);
                }
              },
              child: AnimatedContainer(
                duration: context.animationMedium,
                margin: context.horizontalMarginNormal,
                width: config.dotSize * 1.2,
                height: config.dotSize * 0.7,
                decoration: BoxDecoration(
                  color: index == activeIndex
                      ? variantConfig.activeDotColor
                      : variantConfig.dotColor,
                  borderRadius: indicatorRadius,
                ),
              ),
            );
          }),
        );
        break;
      case CarouselIndicatorType.gradient:
        indicatorRow = OsmeaRow(
          mainAxisSize: min,
          mainAxisAlignment: centerMain,
          children: List.generate(itemCount, (index) {
            return GestureDetector(
              onTap: () {
                context.read<CarouselCubit>().jumpTo(index);
                if (parent.onPageChanged != null) {
                  parent.onPageChanged!(index);
                }
              },
              child: AnimatedContainer(
                duration: context.animationMedium,
                margin: context.horizontalMarginNormal,
                width: config.dotSize * 1.5,
                height: config.dotSize * 0.5,
                decoration: BoxDecoration(
                  gradient: index == activeIndex
                      ? LinearGradient(colors: [
                          variantConfig.activeDotColor,
                          variantConfig.dotColor
                        ])
                      : null,
                  color: index == activeIndex ? null : variantConfig.dotColor,
                  borderRadius: indicatorRadius,
                ),
              ),
            );
          }),
        );
        break;
      case CarouselIndicatorType.minimal:
        indicatorRow = Row(
          mainAxisSize: min,
          mainAxisAlignment: centerMain,
          children: List.generate(itemCount, (index) {
            return Flexible(
              fit: FlexFit.loose,
              child: GestureDetector(
                onTap: () {
                  context.read<CarouselCubit>().jumpTo(index);
                  if (parent.onPageChanged != null) {
                    parent.onPageChanged!(index);
                  }
                },
                child: OsmeaContainer(
                  margin: context.horizontalMarginNormal,
                  height: context.allHeight * .2,
                  decoration: BoxDecoration(
                    color: index == activeIndex
                        ? variantConfig.activeDotColor
                        : variantConfig.dotColor.withValues(alpha: 0.3),
                    borderRadius: indicatorRadius,
                  ),
                ),
              ),
            );
          }),
        );
        break;
      case CarouselIndicatorType.custom:
        if (parent.customIndicator != null) {
          return parent.customIndicator!(context, this.itemCount, activeIndex);
        }
        return const SizedBox.shrink();
    }
    return OsmeaCenter(
      child: OsmeaSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: indicatorRow,
      ),
    );
  }
}
