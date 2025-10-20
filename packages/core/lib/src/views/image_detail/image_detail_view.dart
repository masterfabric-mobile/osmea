import 'package:flutter/material.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/views/image_detail/cubit/image_detail_cubit.dart';
import 'package:core/src/views/image_detail/cubit/image_detail_state.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/carousel/carousel.dart';

/// 📷 Image Detail View
/// Uses MasterViewCubit for lifecycle and Cubit-based state for navigation/selection.
class ImageDetailView extends MasterViewCubit<ImageDetailCubit, ImageDetailState> {
  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTag;
  final Color? backgroundColor;

  ImageDetailView({
    required Function(String path) goRoute,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
    this.backgroundColor,
    Map<String, dynamic> arguments = const {},
  }) : super(
          goRoute: goRoute,
          arguments: arguments,
          useSafeArea: false, // We handle SafeArea manually for better control
        );

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    final media = MediaQuery.of(context);
    final double screenWidth = media.size.width;
    await viewModel.initialize(
      images: imageUrls, 
      initialIndex: initialIndex, 
      heroTag: heroTag,
      screenWidth: screenWidth,
    );
  }

  @override
  Widget viewContent(BuildContext context, ImageDetailCubit viewModel, ImageDetailState state) {
    final hasImages = state.images.isNotEmpty;
    final media = MediaQuery.of(context);
    final double screenWidth = media.size.width;

    const double thumbnailsHeight = 88; // Fixed thumbnail height
    const double fixedSpacing = 12; // Fixed 12px padding as per design

    // Update image heights if screen width changed (e.g., orientation change)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.status == ImageDetailStatus.ready) {
        viewModel.updateImageHeights(screenWidth);
      }
    });

    return state.status == ImageDetailStatus.loading
        ? _buildLoadingState(context)
        : hasImages
            ? Column(
                children: [
                  // Top spacing
                  SizedBox(height: fixedSpacing),

                  // Main Image - Simple and clean
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6, // 60% of screen height
                    child: Stack(
                      children: [
                        PageView.builder(
                          key: ValueKey('pageview_${state.currentIndex}'),
                          itemCount: state.images.length,
                          controller: PageController(initialPage: state.currentIndex),
                          onPageChanged: (index) => viewModel.goTo(index),
                          itemBuilder: (context, index) {
                            return InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 4.0,
                              child: Container(
                                alignment: Alignment.topCenter, // Align content to top
                                child: OsmeaComponents.image(
                                  imageUrl: state.images[index],
                                  variant: ImageVariant.normal,
                                  size: ImageSize.custom,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                  heroTag: state.heroTag,
                                ),
                              ),
                            );
                          },
                        ),
                        // Page indicators - positioned at bottom center of main image
                        if (state.images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: OsmeaComponents.row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(state.images.length, (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == state.currentIndex
                                        ? OsmeaColors.black
                                        : OsmeaColors.black.withValues(alpha: 0.5),
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Middle spacing
                  SizedBox(height: fixedSpacing),

                  // Thumbnails - Simple layout
                  SizedBox(
                    height: thumbnailsHeight,
                    child: OsmeaCarousel(
                      variant: CarouselVariant.multi,
                      size: CarouselSize.large,
                      height: thumbnailsHeight,
                      width: double.infinity,
                      showArrows: state.images.length > 5,
                      showIndicators: true,
                      items: List.generate(state.images.length, (i) {
                        final isActive = i == state.currentIndex;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: OsmeaComponents.container(
                            decoration: BoxDecoration(
                              color: OsmeaColors.white,
                              borderRadius: context.borderRadiusMinStandard,
                              border: Border.all(
                                color: isActive ? OsmeaColors.black : OsmeaColors.silver,
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: OsmeaComponents.image(
                              imageUrl: state.images[i],
                              variant: ImageVariant.card,
                              size: ImageSize.custom,
                              width: 140,
                              height: thumbnailsHeight,
                              fit: BoxFit.cover,
                              heroTag: isActive ? state.heroTag : null,
                            ),
                          ),
                        );
                      }),
                      onItemTaps: List.generate(state.images.length, (i) => () => viewModel.goTo(i)),
                    ),
                  ),

                  // Bottom spacing - larger space as requested
                  SizedBox(height: fixedSpacing * 2),
                ],
              )
            : _buildEmptyState(context);
  }

  Widget _buildLoadingState(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: OsmeaColors.black,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.text(
            'Loading images...',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.black.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 48,
            color: OsmeaColors.black.withValues(alpha: .3),
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.text(
            'No images to show',
            variant: OsmeaTextVariant.titleMedium,
            color: OsmeaColors.black.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
          OsmeaComponents.sizedBox(height: 6),
          OsmeaComponents.text(
            'Please provide at least one image URL.',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.black.withValues(alpha: 0.5),
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

/// Convenience widget to use the view like a screen
class ImageDetailScreen extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTag;
  final Color? backgroundColor;
  final Function(String path) goRoute;

  const ImageDetailScreen({
    super.key,
    required this.goRoute,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ImageDetailView(
      goRoute: goRoute,
      imageUrls: imageUrls,
      initialIndex: initialIndex,
      heroTag: heroTag,
      backgroundColor: backgroundColor,
    );
  }
}


