import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📦 **OSMEA Container Examples**
///
/// This file demonstrates various ways to use the OSMEA Container component.
/// Each example showcases different properties and customization options.
///
class ContainerExample extends StatelessWidget {
  const ContainerExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'container_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '📦 Basic Containers',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic container example
            OsmeaComponents.text(
              'Simple container with color:',
              fontSize: 16,
            ),
            OsmeaComponents.sizedBox(height: 8),
            basicContainerExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Container with border radius
            OsmeaComponents.text(
              'Container with border radius:',
              fontSize: 16,
            ),
            OsmeaComponents.sizedBox(height: 8),
            roundedContainerExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Container with shadow
            OsmeaComponents.text(
              'Container with shadow:',
              fontSize: 16,
            ),
            OsmeaComponents.sizedBox(height: 8),
            shadowContainerExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for layout containers
            OsmeaComponents.text(
              '📐 Layout & Positioning',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Containers with alignment
            OsmeaComponents.text('Containers with different alignments:'),
            OsmeaComponents.sizedBox(height: 8),
            alignmentContainerExamples(context),
            OsmeaComponents.sizedBox(height: 24),

            // Containers with padding and margin
            OsmeaComponents.text('Containers with padding and margin:'),
            OsmeaComponents.sizedBox(height: 8),
            paddingMarginContainerExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Size constrained containers
            OsmeaComponents.text('Size constrained containers:'),
            OsmeaComponents.sizedBox(height: 8),
            sizeConstrainedContainerExamples(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for styling containers
            OsmeaComponents.text(
              '🎨 Styling & Effects',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Containers with borders
            OsmeaComponents.text('Containers with borders:'),
            OsmeaComponents.sizedBox(height: 8),
            borderedContainerExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Containers with gradients
            OsmeaComponents.text('Containers with gradients:'),
            OsmeaComponents.sizedBox(height: 8),
            gradientContainerExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Containers with background images
            OsmeaComponents.text('Containers with background images:'),
            OsmeaComponents.sizedBox(height: 8),
            backgroundImageContainerExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for interactive containers
            OsmeaComponents.text(
              '👆 Interactive Containers',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Interactive containers
            OsmeaComponents.text('Interactive containers with tap events:'),
            OsmeaComponents.sizedBox(height: 8),
            interactiveContainerExamples(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for shape variants
            OsmeaComponents.text(
              '🔳 Shape Variants',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Shape variant containers
            OsmeaComponents.text('Different container shapes:'),
            OsmeaComponents.sizedBox(height: 8),
            shapeVariantContainerExamples(),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for advanced examples
            OsmeaComponents.text(
              '🚀 Advanced',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Complex container combinations
            OsmeaComponents.text('Complex container combinations:'),
            OsmeaComponents.sizedBox(height: 8),
            complexContainerExamples(),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Basic container example
  Widget basicContainerExample(BuildContext context) {
    return OsmeaComponents.container(
      width: double.infinity,
      height: 100,
      color: OsmeaColors.nordicBlue,
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Basic Container',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(color: OsmeaColors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Rounded container example
  Widget roundedContainerExample(BuildContext context) {
    return OsmeaComponents.container(
      width: double.infinity,
      height: 100,
      borderRadius: BorderRadius.circular(16),
      color: OsmeaColors.sunsetGlow,
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Rounded Container',
          textStyle: OsmeaTextStyle.bodyLarge(context)
              .copyWith(color: OsmeaColors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Container with shadow example
  Widget shadowContainerExample(BuildContext context) {
    return OsmeaComponents.container(
      width: double.infinity,
      height: 100,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: OsmeaColors.black
              .withValues(red: 0, green: 0, blue: 0, alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      color: OsmeaColors.white,
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Shadow Container',
          textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(fontSize: 16),
        ),
      ),
    );
  }

  // Container alignment examples
  Widget alignmentContainerExamples(BuildContext context) {
    return OsmeaComponents.row(
      children: [
        OsmeaComponents.expanded(
          child: OsmeaComponents.container(
            height: 100,
            color: OsmeaColors.springLeaf,
            alignment: Alignment.topLeft,
            child: OsmeaComponents.text('Top Left',
                textStyle: OsmeaTextStyle.bodyMedium(context)
                    .copyWith(color: OsmeaColors.white)),
          ),
        ),
        OsmeaComponents.sizedBox(width: 8),
        OsmeaComponents.expanded(
          child: OsmeaComponents.container(
            height: 100,
            color: OsmeaColors.forestHeart,
            alignment: Alignment.center,
            child: OsmeaComponents.text('Center',
                textStyle: OsmeaTextStyle.bodyMedium(context)
                    .copyWith(color: OsmeaColors.white)),
          ),
        ),
        OsmeaComponents.sizedBox(width: 8),
        OsmeaComponents.expanded(
          child: OsmeaComponents.container(
            height: 100,
            color: OsmeaColors.pineGrove,
            alignment: Alignment.bottomRight,
            child: OsmeaComponents.text('Bottom Right',
                textStyle: OsmeaTextStyle.bodyMedium(context)
                    .copyWith(color: OsmeaColors.white)),
          ),
        ),
      ],
    );
  }

  // Container padding and margin examples
  Widget paddingMarginContainerExamples() {
    return OsmeaComponents.container(
      width: double.infinity,
      color: OsmeaColors.silver,
      padding: const EdgeInsets.all(16),
      child: OsmeaComponents.container(
        width: double.infinity,
        color: OsmeaColors.deepSea,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        child: OsmeaComponents.text(
          'Container with padding (16) and margin (8)',
          color: OsmeaColors.white,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Size constrained container examples
  Widget sizeConstrainedContainerExamples(BuildContext context) {
    return OsmeaComponents.wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        OsmeaComponents.container(
          width: 100,
          height: 100,
          color: OsmeaColors.amberFlame,
          child: OsmeaComponents.center(
              child:
                  OsmeaComponents.text('Fixed Size', color: OsmeaColors.white)),
        ),
        OsmeaComponents.container(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 150,
            minHeight: 50,
            maxHeight: 100,
          ),
          color: OsmeaColors.goldenHour,
          child: OsmeaComponents.center(
            child: OsmeaComponents.padding(
              padding: context.paddingLow,
              child: OsmeaComponents.text('Constrained Size',
                  color: OsmeaColors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Containers with borders examples
  Widget borderedContainerExamples() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.container(
          width: double.infinity,
          height: 100,
          border: Border.all(color: OsmeaColors.nordicBlue, width: 2),
          borderRadius: BorderRadius.circular(8),
          child:
              OsmeaComponents.center(child: OsmeaComponents.text('Border All')),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          width: double.infinity,
          height: 100,
          border: Border(
            top: BorderSide(color: OsmeaColors.amberFlame, width: 4),
            bottom: BorderSide(color: OsmeaColors.forestHeart, width: 4),
          ),
          child: OsmeaComponents.center(
              child: OsmeaComponents.text('Custom Border')),
        ),
      ],
    );
  }

  // Gradient container examples
  Widget gradientContainerExamples() {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.container(
          width: double.infinity,
          height: 120,
          gradient: LinearGradient(
            colors: [OsmeaColors.nordicBlue, OsmeaColors.deepSea],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          child: OsmeaComponents.center(
            child: OsmeaComponents.text(
              'Linear Gradient',
              color: OsmeaColors.white,
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          width: double.infinity,
          height: 120,
          gradient: RadialGradient(
            colors: [OsmeaColors.goldenHour, OsmeaColors.amberFlame],
            center: Alignment.center,
            radius: 0.7,
          ),
          borderRadius: BorderRadius.circular(8),
          child: OsmeaComponents.center(
            child: OsmeaComponents.text(
              'Radial Gradient',
              color: OsmeaColors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Background image container example
  Widget backgroundImageContainerExample() {
    return OsmeaComponents.container(
      width: double.infinity,
      height: 150,
      borderRadius: BorderRadius.circular(12),
      backgroundImage: const DecorationImage(
        image: NetworkImage('https://picsum.photos/500/300'),
        fit: BoxFit.cover,
      ),
      child: OsmeaComponents.container(
        borderRadius: BorderRadius.circular(12),
        alignment: Alignment.center,
        color:
            OsmeaColors.black.withValues(red: 0, green: 0, blue: 0, alpha: 0.5),
        child: OsmeaComponents.text(
          'Container with Background Image',
          color: OsmeaColors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  // Interactive container examples
  Widget interactiveContainerExamples(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.container(
          width: double.infinity,
          height: 100,
          color: OsmeaColors.nordicBlue,
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: OsmeaComponents.text('Container tapped!')),
            );
          },
          child: OsmeaComponents.center(
            child: OsmeaComponents.text(
              'Tap Me',
              color: OsmeaColors.white,
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 8),
        OsmeaComponents.container(
          width: double.infinity,
          height: 100,
          color: OsmeaColors.deepSea,
          borderRadius: BorderRadius.circular(8),
          onLongPress: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: OsmeaComponents.text('Container long pressed!')),
            );
          },
          child: OsmeaComponents.center(
            child: OsmeaComponents.text(
              'Long Press Me',
              color: OsmeaColors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Shape variant container examples
  Widget shapeVariantContainerExamples() {
    return OsmeaComponents.wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        OsmeaComponents.container(
          width: 100,
          height: 100,
          color: OsmeaColors.forestHeart,
          shape: BoxShape.circle,
          child: OsmeaComponents.center(
            child: OsmeaComponents.text(
              'Circle',
              color: OsmeaColors.white,
            ),
          ),
        ),
        OsmeaComponents.container(
          width: 100,
          height: 100,
          color: OsmeaColors.deepSea,
          borderRadius: BorderRadius.circular(20),
          child: OsmeaComponents.center(
            child: OsmeaComponents.text(
              'Rounded',
              color: OsmeaColors.white,
            ),
          ),
        ),
        OsmeaComponents.container(
          width: 100,
          height: 100,
          color: OsmeaColors.goldenHour,
          child: OsmeaComponents.center(
            child: OsmeaComponents.text('Square'),
          ),
        ),
      ],
    );
  }

  // Complex container combination examples
  Widget complexContainerExamples() {
    return OsmeaComponents.container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        colors: [OsmeaColors.atlantic, OsmeaColors.nordicBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: OsmeaColors.oceanMist
              .withValues(red: 187, green: 221, blue: 242, alpha: 0.6),
          blurRadius: 15,
          offset: const Offset(0, 8),
          spreadRadius: 2,
        ),
      ],
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            'Premium Card',
            color: OsmeaColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          OsmeaComponents.sizedBox(height: 8),
          OsmeaComponents.text(
            'This card shows multiple container properties combined',
            color: OsmeaColors.white
                .withValues(red: 255, green: 255, blue: 255, alpha: 0.7),
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.row(
            children: [
              OsmeaComponents.container(
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(12),
                color: OsmeaColors.white
                    .withValues(red: 255, green: 255, blue: 255, alpha: 0.2),
                child: const Icon(
                  Icons.star,
                  color: OsmeaColors.white,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              OsmeaComponents.expanded(
                child: OsmeaComponents.text(
                  'Advanced styling with nested containers',
                  color: OsmeaColors.white,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: OsmeaColors.black
                    .withValues(red: 0, green: 0, blue: 0, alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            color: OsmeaColors.white,
            child: OsmeaComponents.text(
              'DETAILS',
              color: OsmeaColors.nordicBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Main entry point for the container examples
void main() {
  runApp(const MaterialApp(
    title: 'OSMEA Container',
    home: ContainerExample(),
  ));
}
