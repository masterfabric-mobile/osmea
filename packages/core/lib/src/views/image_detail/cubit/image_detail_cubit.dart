import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/views/image_detail/cubit/image_detail_state.dart';

class ImageDetailCubit extends BaseViewModelCubit<ImageDetailState> {
  ImageDetailCubit() : super(const ImageDetailState());

  Future<void> initialize({required List<String> images, int initialIndex = 0, String? heroTag, double? screenWidth}) async {
    if (images.isEmpty) {
      stateChanger(state.copyWith(status: ImageDetailStatus.empty, images: images, currentIndex: 0, heroTag: heroTag));
      return;
    }

    final safeIndex = initialIndex.clamp(0, images.length - 1);
    stateChanger(state.copyWith(status: ImageDetailStatus.loading, images: List.unmodifiable(images), currentIndex: safeIndex, heroTag: heroTag));
    
    // Load image dimensions for all images with actual screen width
    await _loadImageDimensions(images, screenWidth: screenWidth);
    
    stateChanger(state.copyWith(status: ImageDetailStatus.ready));
  }

  Future<void> _loadImageDimensions(List<String> images, {double? screenWidth}) async {
    final Map<String, Size> newImageSizes = {};
    final Map<String, double> newImageHeights = {};
    
    // Use actual screen width or fallback to default
    final double actualScreenWidth = screenWidth ?? 400.0;
    
    for (final imageUrl in images) {
      try {
        final size = await _getImageSize(imageUrl);
        if (size != null) {
          newImageSizes[imageUrl] = size;
          // Calculate height based on aspect ratio and actual screen width
          final calculatedHeight = _calculateImageHeight(size, screenWidth: actualScreenWidth);
          newImageHeights[imageUrl] = calculatedHeight;
        }
      } catch (e) {
        // If we can't get the size, use a default
        newImageSizes[imageUrl] = const Size(800, 600); // Default aspect ratio
        newImageHeights[imageUrl] = 400.0; // Default height
      }
    }
    
    stateChanger(state.copyWith(
      imageSizes: newImageSizes,
      imageHeights: newImageHeights,
    ));
  }

  Future<Size?> _getImageSize(String imageUrl) async {
    try {
      final ImageProvider imageProvider = NetworkImage(imageUrl);
      final ImageStream stream = imageProvider.resolve(const ImageConfiguration());
      
      final Completer<Size> completer = Completer<Size>();
      
      late ImageStreamListener listener;
      listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
        final size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        stream.removeListener(listener);
        completer.complete(size);
      });
      
      stream.addListener(listener);
      
      // Add timeout to prevent hanging
      return await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => const Size(800, 600), // Return default size instead of null
      );
    } catch (e) {
      return null;
    }
  }

  double _calculateImageHeight(Size imageSize, {double screenWidth = 400}) {
    // Calculate aspect ratio
    final double aspectRatio = imageSize.height / imageSize.width;
    final double calculatedHeight = screenWidth * aspectRatio;
    
    // Ensure the height is within reasonable bounds
    const double minHeight = 600.0;
    const double maxHeight = 800.0; // Maximum height to prevent overflow
    
    return math.max(minHeight, math.min(calculatedHeight, maxHeight));
  }

  void next() {
    if (state.images.isEmpty) return;
    final nextIndex = (state.currentIndex + 1).clamp(0, state.images.length - 1);
    stateChanger(state.copyWith(currentIndex: nextIndex));
  }

  void previous() {
    if (state.images.isEmpty) return;
    final prevIndex = (state.currentIndex - 1).clamp(0, state.images.length - 1);
    stateChanger(state.copyWith(currentIndex: prevIndex));
  }

  void goTo(int index) {
    if (state.images.isEmpty) return;
    final safeIndex = index.clamp(0, state.images.length - 1);
    stateChanger(state.copyWith(currentIndex: safeIndex));
  }

  // Update image heights when screen size changes (e.g., orientation change)
  void updateImageHeights(double newScreenWidth) {
    final Map<String, double> updatedHeights = {};
    
    for (final entry in state.imageSizes.entries) {
      final imageUrl = entry.key;
      final imageSize = entry.value;
      final newHeight = _calculateImageHeight(imageSize, screenWidth: newScreenWidth);
      updatedHeights[imageUrl] = newHeight;
    }
    
    stateChanger(state.copyWith(imageHeights: updatedHeights));
  }
}


