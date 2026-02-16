import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📦 **OSMEA Positioned Examples**
///
/// This file demonstrates various ways to use the OSMEA Positioned component,
/// which enables precise placement of widgets within a Stack.
///
class PositionedExample extends StatelessWidget {
  const PositionedExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'positioned_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '📍 Basic Positioning',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic positioning example
            OsmeaComponents.text('Simple positioned elements:'),
            OsmeaComponents.sizedBox(height: 8),
            basicPositionedExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Corner positioning example
            OsmeaComponents.text('Positioning in corners:'),
            OsmeaComponents.sizedBox(height: 8),
            cornerPositioningExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for edge positioning
            OsmeaComponents.text(
              '📏 Edge Positioning',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Edge positioning
            OsmeaComponents.text('Positioning along edges:'),
            OsmeaComponents.sizedBox(height: 8),
            edgePositioningExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for fill and size
            OsmeaComponents.text(
              '📐 Fill and Size',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Fill example
            OsmeaComponents.text('Using positionedFill:'),
            OsmeaComponents.sizedBox(height: 8),
            fillPositioningExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Size example
            OsmeaComponents.text('Setting width and height:'),
            OsmeaComponents.sizedBox(height: 8),
            sizePositioningExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for fractional
            OsmeaComponents.text(
              '🔢 Fractional Positioning',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Fractional example
            OsmeaComponents.text('Using positionedFractional:'),
            OsmeaComponents.sizedBox(height: 8),
            fractionalPositioningExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for practical examples
            OsmeaComponents.text(
              '💡 Practical Use Cases',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Overlay example
            OsmeaComponents.text('Creating an overlay effect:'),
            OsmeaComponents.sizedBox(height: 8),
            overlayExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Badge example
            OsmeaComponents.text('Adding badges to elements:'),
            OsmeaComponents.sizedBox(height: 8),
            badgeExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Spacer example (new)
            OsmeaComponents.text('Spacer with positioned elements:'),
            OsmeaComponents.sizedBox(height: 8),
            spacerExample(context),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Basic positioning example
  Widget basicPositionedExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        children: [
          OsmeaComponents.positioned(
            left: 20,
            top: 20,
            child: _buildColorBox(context, OsmeaColors.red, 'Top Left'),
          ),
          OsmeaComponents.positioned(
            right: 20,
            top: 20,
            child: _buildColorBox(context, OsmeaColors.blue, 'Top Right'),
          ),
          OsmeaComponents.positioned(
            left: 20,
            bottom: 20,
            child: _buildColorBox(context, OsmeaColors.green, 'Bottom Left'),
          ),
          OsmeaComponents.positioned(
            right: 20,
            bottom: 20,
            child:
                _buildColorBox(context, OsmeaColors.sunsetGlow, 'Bottom Right'),
          ),
        ],
      ),
    );
  }

  // Corner positioning example
  Widget cornerPositioningExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        alignment: Alignment.center,
        children: [
          OsmeaComponents.text(
            'Center Content',
            textStyle: OsmeaTextStyle.titleMedium(context)
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          OsmeaComponents.positioned(
            left: 0,
            top: 0,
            child: _buildSmallColorBox(OsmeaColors.red),
          ),
          OsmeaComponents.positioned(
            right: 0,
            top: 0,
            child: _buildSmallColorBox(OsmeaColors.blue),
          ),
          OsmeaComponents.positioned(
            left: 0,
            bottom: 0,
            child: _buildSmallColorBox(OsmeaColors.green),
          ),
          OsmeaComponents.positioned(
            right: 0,
            bottom: 0,
            child: _buildSmallColorBox(OsmeaColors.purple),
          ),
        ],
      ),
    );
  }

  // Edge positioning example
  Widget edgePositioningExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        children: [
          // Center element for reference
          OsmeaComponents.align(
            alignment: Alignment.center,
            child: OsmeaComponents.container(
              width: 100,
              height: 100,
              color: OsmeaColors.white,
              child: OsmeaComponents.center(
                child: OsmeaComponents.text('Center'),
              ),
            ),
          ),

          // Top edge
          OsmeaComponents.positioned(
            left: 50,
            right: 50,
            top: 0,
            child: OsmeaComponents.container(
              height: 30,
              color: Colors.red.withValues(alpha: 0.5),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text('Top Edge'),
              ),
            ),
          ),

          // Bottom edge
          OsmeaComponents.positioned(
            left: 50,
            right: 50,
            bottom: 0,
            child: OsmeaComponents.container(
              height: 30,
              color: Colors.blue.withValues(alpha: 0.5),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text('Bottom Edge'),
              ),
            ),
          ),

          // Left edge
          OsmeaComponents.positioned(
            left: 0,
            top: 50,
            bottom: 50,
            child: OsmeaComponents.container(
              width: 30,
              color: Colors.green.withValues(alpha: 0.5),
              child: OsmeaComponents.center(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: OsmeaComponents.text('Left Edge'),
                ),
              ),
            ),
          ),

          // Right edge
          OsmeaComponents.positioned(
            right: 0,
            top: 50,
            bottom: 50,
            child: OsmeaComponents.container(
              width: 30,
              color: Colors.purple.withValues(alpha: 0.5),
              child: OsmeaComponents.center(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: OsmeaComponents.text('Right Edge'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fill positioning example
  Widget fillPositioningExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        children: [
          // Background element that fills the entire stack
          OsmeaComponents.positionedFill(
            child: OsmeaComponents.container(
              color: Colors.blue.withValues(alpha: 0.2),
            ),
          ),

          // Inset element with margins
          OsmeaComponents.positionedFill(
            left: 20,
            top: 20,
            right: 20,
            bottom: 20,
            child: OsmeaComponents.container(
              decoration: BoxDecoration(
                border: Border.all(color: OsmeaColors.sunsetGlow),
                color: Colors.pink.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'Inset with Margins (20px)',
                  textStyle: OsmeaTextStyle.titleSmall(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // Small element at the bottom-right
          OsmeaComponents.positioned(
            right: 8,
            bottom: 8,
            child: OsmeaComponents.container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: OsmeaComponents.text(
                'positionedFill',
                textStyle:
                    OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Size positioning example
  Widget sizePositioningExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        alignment: Alignment.center,
        children: [
          // Fixed size positioned in center
          OsmeaComponents.positioned(
            left: 50,
            top: 50,
            width: 100,
            height: 100,
            child: OsmeaComponents.container(
              color: OsmeaColors.goldenHour,
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'Fixed Size\n(100x100)',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Bottom right positioning with width only
          OsmeaComponents.positioned(
            right: 20,
            bottom: 20,
            width: 120,
            child: OsmeaComponents.container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: OsmeaColors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: OsmeaComponents.text(
                'Width: 120px',
                textStyle: OsmeaTextStyle.bodySmall(context)
                    .copyWith(color: OsmeaColors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fractional positioning example
  Widget fractionalPositioningExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        children: [
          // Half width, centered horizontally
          OsmeaComponents.center(
            child: OsmeaComponents.positioned(
              top: 20,
              width: 180, // Use fixed width instead of infinity
              height: 60, // Use fixed height instead of infinity
              child: OsmeaComponents.container(
                color: Colors.green.withValues(alpha: 0.5),
                child: OsmeaComponents.center(
                  child: OsmeaComponents.text(
                    'width: 180px\nheight: 60px',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // Bottom right, 30% width and height
          OsmeaComponents.positioned(
            right: 20,
            bottom: 20,
            width: 100, // Use fixed width instead of infinity
            height: 40, // Use fixed height instead of infinity
            child: OsmeaComponents.container(
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'Fixed Size',
                  textStyle: OsmeaTextStyle.bodySmall(context)
                      .copyWith(color: OsmeaColors.white),
                ),
              ),
            ),
          ),

          // Label
          OsmeaComponents.positioned(
            left: 10,
            bottom: 10,
            child: OsmeaComponents.container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: OsmeaComponents.text(
                'OsmeaPositioned',
                textStyle:
                    OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Overlay example
  Widget overlayExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      decoration: BoxDecoration(
        color:
            OsmeaColors.thunder, // Fallback color in case image fails to load
        image: DecorationImage(
          image: const NetworkImage('https://picsum.photos/seed/osmea/800/400'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            OsmeaColors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
          onError: (exception, stackTrace) {
            debugPrint('Error loading image: $exception');
          },
        ),
      ),
      child: OsmeaComponents.stack(
        children: [
          // Dark gradient overlay
          OsmeaComponents.positionedFill(
            child: OsmeaComponents.container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [OsmeaColors.transparent, OsmeaColors.black54],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),

          // Bottom text
          OsmeaComponents.positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.text(
                  'Beautiful Nature',
                  textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      color: OsmeaColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                OsmeaComponents.sizedBox(height: 4),
                OsmeaComponents.text(
                  'Using positioned for overlay text on images',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.white.withValues(alpha: 0.7),
                      fontSize: 14),
                ),
              ],
            ),
          ),

          // Top-right badge
          OsmeaComponents.positioned(
            top: 16,
            right: 16,
            child: OsmeaComponents.container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: OsmeaComponents.row(
                children: [
                  const Icon(Icons.photo_camera,
                      size: 16, color: OsmeaColors.white),
                  OsmeaComponents.sizedBox(width: 4),
                  OsmeaComponents.text(
                    'Featured',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: OsmeaColors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Spacer example with positioned elements
  Widget spacerExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        alignment: Alignment.center,
        children: [
          // Center content
          OsmeaComponents.text(
            'Content in the middle',
            textStyle: OsmeaTextStyle.titleMedium(context)
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          // Top spacer with positioned element
          OsmeaComponents.positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 40,
            child: OsmeaComponents.container(
              color: Colors.blue.withValues(alpha: 0.3),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'Top Spacer',
                  textStyle: OsmeaTextStyle.titleSmall(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // Bottom spacer with positioned element
          OsmeaComponents.positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 40,
            child: OsmeaComponents.container(
              color: Colors.green.withValues(alpha: 0.3),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'Bottom Spacer',
                  textStyle: OsmeaTextStyle.titleSmall(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // Left spacer with positioned element
          OsmeaComponents.positioned(
            top: 40,
            bottom: 40,
            left: 0,
            width: 40,
            child: OsmeaComponents.container(
              color: Colors.red.withValues(alpha: 0.3),
              child: OsmeaComponents.center(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: OsmeaComponents.text(
                    'Left Spacer',
                    textStyle: OsmeaTextStyle.titleSmall(context)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          // Right spacer with positioned element
          OsmeaComponents.positioned(
            top: 40,
            bottom: 40,
            right: 0,
            width: 40,
            child: OsmeaComponents.container(
              color: Colors.purple.withValues(alpha: 0.3),
              child: OsmeaComponents.center(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: OsmeaComponents.text(
                    'Right Spacer',
                    textStyle: OsmeaTextStyle.titleSmall(context)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Badge example
  Widget badgeExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 150,
      padding: const EdgeInsets.all(20),
      color: OsmeaColors.silver,
      child: OsmeaComponents.stack(
        alignment: Alignment.center,
        children: [
          // Main element
          OsmeaComponents.container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: OsmeaComponents.row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: OsmeaColors.blue,
                  child: Icon(Icons.person, color: OsmeaColors.white),
                ),
                OsmeaComponents.sizedBox(width: 16),
                OsmeaComponents.expanded(
                  child: OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OsmeaComponents.text(
                        'John Doe',
                        textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      OsmeaComponents.text(
                        'Software Developer',
                        textStyle: OsmeaTextStyle.bodySmall(context)
                            .copyWith(color: OsmeaColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Badge at top-right corner
          OsmeaComponents.positioned(
            top: 0,
            right: 0,
            child: OsmeaComponents.container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: OsmeaColors.green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: OsmeaComponents.text(
                'Online',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Badge at bottom-left corner
          OsmeaComponents.positioned(
            bottom: 0,
            left: 0,
            child: OsmeaComponents.container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: OsmeaComponents.text(
                'Pro Member',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for creating color boxes
  Widget _buildColorBox(BuildContext context, Color color, String text) {
    return OsmeaComponents.container(
      width: 80,
      height: 80,
      color: color,
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          text,
          textStyle: OsmeaTextStyle.bodyMedium(context)
              .copyWith(color: OsmeaColors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Helper for creating small color boxes
  Widget _buildSmallColorBox(Color color) {
    return OsmeaComponents.container(
      width: 30,
      height: 30,
      color: color,
    );
  }
}
