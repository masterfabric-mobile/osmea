import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';

/// 📝 **OSMEA Typography Documentation Page**
/// 
/// A comprehensive showcase of the OSMEA Text System displaying all text variants
/// in a clean web format similar to design system documentation.

class TypographyDocumentationPage extends StatelessWidget {
  const TypographyDocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  const Text(
                    'Typography',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Page Description
                  Text(
                    'OSMEA typography includes body and heading text styles. The body and header text styles have a set font size, while the heading text style also includes a semibold font weight.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Display Section
                  _buildTypographySection(
                    title: 'Display',
                    variants: [
                      _TypographyVariant('Display Large', OsmeaTextVariant.displayLarge),
                      _TypographyVariant('Display Medium', OsmeaTextVariant.displayMedium),
                      _TypographyVariant('Display Small', OsmeaTextVariant.displaySmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Headline Section  
                  _buildTypographySection(
                    title: 'Headline',
                    variants: [
                      _TypographyVariant('Headline Large', OsmeaTextVariant.headlineLarge),
                      _TypographyVariant('Headline Medium', OsmeaTextVariant.headlineMedium),
                      _TypographyVariant('Headline Small', OsmeaTextVariant.headlineSmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Title Section
                  _buildTypographySection(
                    title: 'Title',
                    variants: [
                      _TypographyVariant('Title Large', OsmeaTextVariant.titleLarge),
                      _TypographyVariant('Title Medium', OsmeaTextVariant.titleMedium),
                      _TypographyVariant('Title Small', OsmeaTextVariant.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Body Section
                  _buildTypographySection(
                    title: 'Body',
                    variants: [
                      _TypographyVariant('Body Large', OsmeaTextVariant.bodyLarge),
                      _TypographyVariant('Body Medium', OsmeaTextVariant.bodyMedium),
                      _TypographyVariant('Body Small', OsmeaTextVariant.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Label Section
                  _buildTypographySection(
                    title: 'Label',
                    variants: [
                      _TypographyVariant('Label Large', OsmeaTextVariant.labelLarge),
                      _TypographyVariant('Label Medium', OsmeaTextVariant.labelMedium),
                      _TypographyVariant('Label Small', OsmeaTextVariant.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Caption Section
                  _buildTypographySection(
                    title: 'Caption',
                    variants: [
                      _TypographyVariant('Caption Large', OsmeaTextVariant.captionLarge),
                      _TypographyVariant('Caption Medium', OsmeaTextVariant.captionMedium),
                      _TypographyVariant('Caption Small', OsmeaTextVariant.captionSmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Button Section
                  _buildTypographySection(
                    title: 'Button',
                    variants: [
                      _TypographyVariant('Button Large', OsmeaTextVariant.buttonLarge),
                      _TypographyVariant('Button Medium', OsmeaTextVariant.buttonMedium),
                      _TypographyVariant('Button Small', OsmeaTextVariant.buttonSmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Link Section
                  _buildTypographySection(
                    title: 'Link',
                    variants: [
                      _TypographyVariant('Link Large', OsmeaTextVariant.linkLarge),
                      _TypographyVariant('Link Medium', OsmeaTextVariant.linkMedium),
                      _TypographyVariant('Link Small', OsmeaTextVariant.linkSmall),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Special Section
                  _buildTypographySection(
                    title: 'Special',
                    variants: [
                      _TypographyVariant('Overline', OsmeaTextVariant.overline),
                      _TypographyVariant('Code', OsmeaTextVariant.code),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypographySection({
    required String title,
    required List<_TypographyVariant> variants,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 40),
        
        // Typography Variants
        Column(
          children: variants.map((variant) => _buildTypographyRow(variant)).toList(),
        ),
      ],
    );
  }

  Widget _buildTypographyRow(_TypographyVariant variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Label
          SizedBox(
            width: 200,
            child: Text(
              variant.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          
          const SizedBox(width: 60),
          
          // Right side - Text sample
          Expanded(
            child: OsmeaComponents.text(
              _getSampleText(variant.textVariant),
              variant: variant.textVariant,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getSampleText(OsmeaTextVariant variant) {
    // Return different sample text based on variant type
    switch (variant) {
      case OsmeaTextVariant.displayLarge:
      case OsmeaTextVariant.displayMedium:
      case OsmeaTextVariant.displaySmall:
        return 'The quick brown fox jumps';
      
      case OsmeaTextVariant.headlineLarge:
      case OsmeaTextVariant.headlineMedium:
      case OsmeaTextVariant.headlineSmall:
        return 'The quick brown fox jumps over';
      
      case OsmeaTextVariant.titleLarge:
      case OsmeaTextVariant.titleMedium:
      case OsmeaTextVariant.titleSmall:
        return 'The quick brown fox jumps over the lazy';
      
      case OsmeaTextVariant.bodyLarge:
      case OsmeaTextVariant.bodyMedium:
      case OsmeaTextVariant.bodySmall:
        return 'The quick brown fox jumps over the lazy dog';
      
      case OsmeaTextVariant.labelLarge:
      case OsmeaTextVariant.labelMedium:
      case OsmeaTextVariant.labelSmall:
        return 'The quick brown fox jumps over the lazy dog';
      
      case OsmeaTextVariant.captionLarge:
      case OsmeaTextVariant.captionMedium:
      case OsmeaTextVariant.captionSmall:
        return 'The quick brown fox jumps over the lazy dog and beyond';
        
      case OsmeaTextVariant.buttonLarge:
      case OsmeaTextVariant.buttonMedium:
      case OsmeaTextVariant.buttonSmall:
        return 'Button Text';
        
      case OsmeaTextVariant.linkLarge:
      case OsmeaTextVariant.linkMedium:
      case OsmeaTextVariant.linkSmall:
        return 'Link Text';
        
      case OsmeaTextVariant.overline:
        return 'OVERLINE TEXT';
        
      case OsmeaTextVariant.code:
        return 'function() { return "Hello World"; }';
        
      default:
        return 'Sample Text';
    }
  }
}

class _TypographyVariant {
  final String name;
  final OsmeaTextVariant textVariant;

  _TypographyVariant(this.name, this.textVariant);
}
