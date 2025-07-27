import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🎨 **OSMEA Colors Documentation Page**
/// 
/// A comprehensive showcase of the OSMEA Color System displaying all color palettes
/// in an organized, visual format similar to design system documentation.

class ColorsDocumentationPage extends StatelessWidget {
  const ColorsDocumentationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      OsmeaColors.nordicBlue,
                      OsmeaColors.deepSea,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: OsmeaColors.nordicBlue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.palette,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'OSMEA Color System',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A comprehensive color system for maintaining consistent visual design across the OSMEA UI Kit.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Click any color to copy hex code',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Core Colors Section
              _buildColorSection(
                title: 'Core Colors',
                description: 'Essential base colors for fundamental elements',
                colors: [
                  _ColorInfo('White', OsmeaColors.white, '#FFFFFF'),
                  _ColorInfo('Black', OsmeaColors.black, '#000000'),
                  _ColorInfo('Transparent', OsmeaColors.transparent, '#00000000'),
                ],
              ),
              const SizedBox(height: 40),

              // Gray Palette Section
              _buildColorSection(
                title: 'Gray Palette',
                description: 'Neutral colors for backgrounds, text, and subtle elements',
                colors: [
                  _ColorInfo('Paper White', OsmeaColors.paperWhite, '#FCFCFD'),
                  _ColorInfo('Snow', OsmeaColors.snow, '#F9FAFB'),
                  _ColorInfo('Ash', OsmeaColors.ash, '#F3F4F6'),
                  _ColorInfo('Silver', OsmeaColors.silver, '#E5E7EB'),
                  _ColorInfo('Platinum', OsmeaColors.platinum, '#D1D5DB'),
                  _ColorInfo('Steel', OsmeaColors.steel, '#9CA3AF'),
                  _ColorInfo('Pewter', OsmeaColors.pewter, '#6B7280'),
                  _ColorInfo('Slate', OsmeaColors.slate, '#4B5563'),
                  _ColorInfo('Thunder', OsmeaColors.thunder, '#374151'),
                  _ColorInfo('Shark', OsmeaColors.shark, '#1F2937'),
                  _ColorInfo('Eclipse', OsmeaColors.eclipse, '#111827'),
                  _ColorInfo('Void', OsmeaColors.void_, '#030712'),
                ],
              ),
              const SizedBox(height: 40),

              // Blue Palette Section
              _buildColorSection(
                title: 'Blue Palette',
                description: 'Primary brand colors for key interface elements',
                colors: [
                  _ColorInfo('Crystal Bay', OsmeaColors.crystalBay, '#BBDDF2'),
                  _ColorInfo('Ocean Mist', OsmeaColors.oceanMist, '#BBDDF2'),
                  _ColorInfo('Azure Wave', OsmeaColors.azureWave, '#04B2D9'),
                  _ColorInfo('Nordic Blue', OsmeaColors.nordicBlue, '#1B80BF'),
                  _ColorInfo('Deep Sea', OsmeaColors.deepSea, '#1F3B73'),
                  _ColorInfo('Atlantic', OsmeaColors.atlantic, '#1F3B73'),
                  _ColorInfo('Night Ocean', OsmeaColors.nightOcean, '#021859'),
                  _ColorInfo('Marine Depth', OsmeaColors.marineDepth, '#021859'),
                  _ColorInfo('Abyss', OsmeaColors.abyss, '#021859'),
                ],
              ),
              const SizedBox(height: 40),

              // Orange Palette Section
              _buildColorSection(
                title: 'Orange Palette',
                description: 'Warm accent colors for highlights and call-to-action elements',
                colors: [
                  _ColorInfo('Desert Sand', OsmeaColors.desertSand, '#F2D49B'),
                  _ColorInfo('Golden Hour', OsmeaColors.goldenHour, '#F2D06B'),
                  _ColorInfo('Sunset Glow', OsmeaColors.sunsetGlow, '#F29422'),
                  _ColorInfo('Amber Flame', OsmeaColors.amberFlame, '#F2762E'),
                ],
              ),
              const SizedBox(height: 40),

              // Green Palette Section
              _buildColorSection(
                title: 'Green Palette',
                description: 'Natural colors for success states and organic elements',
                colors: [
                  _ColorInfo('Spring Leaf', OsmeaColors.springLeaf, '#DEF2B3'),
                  _ColorInfo('Meadow', OsmeaColors.meadow, '#BFD962'),
                  _ColorInfo('Forest Heart', OsmeaColors.forestHeart, '#55A605'),
                  _ColorInfo('Pine Grove', OsmeaColors.pineGrove, '#488C04'),
                ],
              ),
              const SizedBox(height: 40),

              // Shadow System Section
              _buildColorSection(
                title: 'Shadow System',
                description: 'Predefined shadow colors for depth and elevation',
                colors: [
                  _ColorInfo('Shadow Light', OsmeaColors.shadowLight, '#1A000000'),
                  _ColorInfo('Shadow Dark', OsmeaColors.shadowDark, '#4D000000'),
                ],
              ),
              const SizedBox(height: 40),

              // Material Colors Section
              _buildColorSection(
                title: 'Material Colors',
                description: 'Predefined material colors for quick use',
                colors: [
                  _ColorInfo('Grey', OsmeaColors.grey, '#6B7280'),
                  _ColorInfo('Green', OsmeaColors.green, '#55A605'),
                  _ColorInfo('Red', OsmeaColors.red, '#FF0000'),
                  _ColorInfo('Orange', OsmeaColors.orange, '#FFA500'),
                ],
              ),
              const SizedBox(height: 40),

              // Common Colors Section
              _buildColorSection(
                title: 'Common Colors',
                description: 'Frequently used colors for various elements',
                colors: [
                  _ColorInfo('Black 54', OsmeaColors.black54, '#8A000000'),
                  _ColorInfo('Blue', OsmeaColors.blue, '#0000FF'),
                  _ColorInfo('Purple', OsmeaColors.purple, '#800080'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSection({
    required String title,
    required String description,
    required List<_ColorInfo> colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Color Grid
        Wrap(
          spacing: 16,
          runSpacing: 20,
          children: colors.map((colorInfo) => _buildColorCard(colorInfo)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorCard(_ColorInfo colorInfo) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => _copyToClipboard(context, colorInfo.hex),
        child: Container(
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color Swatch
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: colorInfo.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: colorInfo.color == OsmeaColors.white || 
                           colorInfo.color == OsmeaColors.transparent
                        ? Colors.grey.shade300
                        : Colors.transparent,
                  ),
                ),
                child: colorInfo.color == OsmeaColors.transparent
                    ? _buildTransparentPattern()
                    : null,
              ),
              
              // Color Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      colorInfo.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      colorInfo.hex,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransparentPattern() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: CustomPaint(
        painter: _TransparentPatternPainter(),
        size: const Size(double.infinity, 80),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String hex) {
    Clipboard.setData(ClipboardData(text: hex));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Copied $hex to clipboard'),
          ],
        ),
        backgroundColor: OsmeaColors.forestHeart,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _ColorInfo {
  final String name;
  final Color color;
  final String hex;

  _ColorInfo(this.name, this.color, this.hex);
}

class _TransparentPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const squareSize = 8.0;
    
    for (double x = 0; x < size.width; x += squareSize) {
      for (double y = 0; y < size.height; y += squareSize) {
        final isEven = ((x / squareSize).floor() + (y / squareSize).floor()) % 2 == 0;
        paint.color = isEven ? Colors.grey.shade200 : Colors.white;
        
        canvas.drawRect(
          Rect.fromLTWH(x, y, squareSize, squareSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
