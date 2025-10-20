import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ImageDetailStatus { initial, ready, empty, loading }

class ImageDetailState extends Equatable {
  final ImageDetailStatus status;
  final List<String> images;
  final int currentIndex;
  final String? heroTag;
  final Map<String, Size> imageSizes; // Store actual image dimensions
  final Map<String, double> imageHeights; // Store calculated heights for each image

  const ImageDetailState({
    this.status = ImageDetailStatus.initial,
    this.images = const [],
    this.currentIndex = 0,
    this.heroTag,
    this.imageSizes = const {},
    this.imageHeights = const {},
  });

  bool get hasImages => images.isNotEmpty;
  
  // Get the current image's calculated height
  double? getCurrentImageHeight() {
    if (images.isEmpty || currentIndex >= images.length) return null;
    final currentImageUrl = images[currentIndex];
    return imageHeights[currentImageUrl];
  }
  
  // Get the current image's actual size
  Size? getCurrentImageSize() {
    if (images.isEmpty || currentIndex >= images.length) return null;
    final currentImageUrl = images[currentIndex];
    return imageSizes[currentImageUrl];
  }

  ImageDetailState copyWith({
    ImageDetailStatus? status,
    List<String>? images,
    int? currentIndex,
    String? heroTag,
    Map<String, Size>? imageSizes,
    Map<String, double>? imageHeights,
  }) {
    return ImageDetailState(
      status: status ?? this.status,
      images: images ?? this.images,
      currentIndex: currentIndex ?? this.currentIndex,
      heroTag: heroTag ?? this.heroTag,
      imageSizes: imageSizes ?? this.imageSizes,
      imageHeights: imageHeights ?? this.imageHeights,
    );
  }

  @override
  List<Object?> get props => [status, images, currentIndex, heroTag, imageSizes, imageHeights];
}


