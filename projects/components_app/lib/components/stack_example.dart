import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class StackExample extends StatelessWidget {
  const StackExample({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'stack_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Basic Stack'),
            _buildBasicStackExamples(context),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle(context, 'Styled Stack'),
            _buildStyledStackExamples(context),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle(context, 'Interactive Stack'),
            _buildInteractiveStackExamples(context),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle(context, 'Positioned Children'),
            _buildPositionedChildrenExamples(context),
            OsmeaComponents.sizedBox(height: 32),
            _buildSectionTitle(context, 'Practical Use Cases'),
            _buildPracticalExamples(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: OsmeaComponents.text(
        title,
        textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBasicStackExamples(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExampleWithCaption(
          context,
          'Simple Stack with Default Alignment',
          _buildContainer(
            OsmeaComponents.stack(
              children: [
                _buildColoredBox(context,
                    color: OsmeaColors.sunsetGlow, size: 150),
                _buildColoredBox(context,
                    color: OsmeaColors.green.withValues(alpha: 0.7), size: 120),
                _buildColoredBox(context,
                    color: OsmeaColors.blue.withValues(alpha: 0.7), size: 90),
              ],
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildExampleWithCaption(
          context,
          'Stack with Center Alignment',
          _buildContainer(
            OsmeaComponents.stack(
              alignment: Alignment.center,
              children: [
                _buildColoredBox(context, color: OsmeaColors.purple, size: 150),
                _buildColoredBox(context,
                    color: OsmeaColors.goldenHour.withValues(alpha: 0.7),
                    size: 100),
                OsmeaComponents.text(
                  'Centered Text',
                  textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                    color: OsmeaColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildExampleWithCaption(
          context,
          'Stack with Bottom-Right Alignment',
          _buildContainer(
            OsmeaComponents.stack(
              alignment: Alignment.bottomRight,
              children: [
                _buildColoredBox(context,
                    color: OsmeaColors.forestHeart, size: 150),
                _buildColoredBox(context,
                    color: OsmeaColors.sunsetGlow.withValues(alpha: 0.7),
                    size: 80),
                _buildColoredBox(context, color: OsmeaColors.meadow, size: 150),
                _buildColoredBox(context,
                    color: OsmeaColors.sunsetGlow.withValues(alpha: 0.7),
                    size: 80),
                OsmeaComponents.padding(
                  padding: const EdgeInsets.all(8),
                  child: OsmeaComponents.text(
                    'Bottom-Right',
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledStackExamples(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExampleWithCaption(
          context,
          'Stack with ClipBehavior.none',
          _buildContainer(
            OsmeaComponents.container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: OsmeaColors.sunsetGlow),
                borderRadius: BorderRadius.circular(12),
              ),
              child: OsmeaComponents.stack(
                clipBehavior: Clip.none,
                children: [
                  OsmeaComponents.container(
                    decoration: BoxDecoration(
                      color: OsmeaColors.ash,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  OsmeaComponents.positioned(
                    top: -20,
                    right: -20,
                    child: _buildColoredBox(context,
                        color: OsmeaColors.sunsetGlow, size: 50),
                  ),
                  OsmeaComponents.positioned(
                    bottom: -20,
                    left: -20,
                    child: _buildColoredBox(context,
                        color: OsmeaColors.nordicBlue, size: 50),
                  ),
                ],
              ),
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildExampleWithCaption(
          context,
          'Stack with StackFit.expand',
          _buildContainer(
            OsmeaComponents.sizedBox(
              width: double.infinity,
              height: 200,
              child: OsmeaComponents.stack(
                fit: StackFit.expand,
                children: [
                  OsmeaComponents.container(
                      color: OsmeaColors.forestHeart.withValues(alpha: 0.3)),
                  OsmeaComponents.align(
                    alignment: Alignment.center,
                    child: OsmeaComponents.container(
                      color: OsmeaColors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  OsmeaComponents.align(
                    alignment: Alignment.center,
                    child: OsmeaComponents.container(
                      width: 100,
                      height: 100,
                      color: OsmeaColors.forestHeart,
                      child: OsmeaComponents.center(
                        child: OsmeaComponents.text(
                          'Expanded',
                          textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                            color: OsmeaColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveStackExamples(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExampleWithCaption(
          context,
          'Stack with Gesture Detection',
          _buildContainer(
            GestureDetector(
              onTap: () {
                debugPrint('Stack tapped!');
              },
              child: OsmeaComponents.stack(
                alignment: Alignment.center,
                children: [
                  _buildColoredBox(context,
                      color: OsmeaColors.nordicBlue, size: 150),
                  OsmeaComponents.text(
                    'Tap Me!',
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPositionedChildrenExamples(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExampleWithCaption(
          context,
          'Stack with Positioned Children',
          _buildContainer(
            OsmeaComponents.sizedBox(
              width: double.infinity,
              height: 200,
              child: OsmeaComponents.stack(
                children: [
                  OsmeaComponents.container(color: OsmeaColors.ash),
                  OsmeaComponents.positioned(
                    top: 10,
                    left: 10,
                    child: _buildColoredBox(context,
                        color: OsmeaColors.sunsetGlow, size: 50),
                  ),
                  OsmeaComponents.positioned(
                    top: 10,
                    right: 10,
                    child: _buildColoredBox(context,
                        color: OsmeaColors.forestHeart, size: 50),
                  ),
                  OsmeaComponents.positioned(
                    bottom: 10,
                    left: 10,
                    child: _buildColoredBox(context,
                        color: OsmeaColors.nordicBlue, size: 50),
                  ),
                  OsmeaComponents.positioned(
                    bottom: 10,
                    right: 10,
                    child: OsmeaComponents.container(
                      height: 40,
                      color: OsmeaColors.black.withValues(alpha: 0.5),
                      alignment: Alignment.center,
                      child: OsmeaComponents.text(
                        'Overlay Caption',
                        textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                          color: OsmeaColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildExampleWithCaption(
          context,
          'Stack with positionedFill and positionedFractional',
          _buildContainer(
            OsmeaComponents.sizedBox(
              width: double.infinity,
              height: 200,
              child: OsmeaComponents.stack(
                children: [
                  OsmeaComponents.container(color: OsmeaColors.ash),
                  OsmeaComponents.positionedFill(
                    child: OsmeaComponents.container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            OsmeaColors.nordicBlue.withValues(alpha: 0.2),
                            OsmeaColors.purple.withValues(alpha: 0.2),
                            OsmeaColors.blue.withValues(alpha: 0.2),
                            OsmeaColors.purple.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  OsmeaComponents.positionedFractional(
                    left: 0.1,
                    top: 0.1,
                    widthFactor: 0.8,
                    heightFactor: 0.3,
                    child: OsmeaComponents.container(
                      color: OsmeaColors.amberFlame.withValues(alpha: 0.3),
                      child: OsmeaComponents.center(
                        child: OsmeaComponents.text(
                            'Fractional Position (80% × 30%)'),
                      ),
                    ),
                  ),
                  OsmeaComponents.positioned(
                    right: 20,
                    bottom: 20,
                    child: Icon(
                      Icons.info,
                      color: OsmeaColors.nordicBlue,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPracticalExamples(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExampleWithCaption(
          context,
          'Image Card with Overlay',
          _buildContainer(
            OsmeaComponents.sizedBox(
              width: double.infinity,
              height: 200,
              child: OsmeaComponents.clipRRect(
                borderRadius: BorderRadius.circular(8),
                child: OsmeaComponents.stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://picsum.photos/500/300',
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: OsmeaComponents.container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              OsmeaColors.transparent,
                              OsmeaColors.black.withValues(alpha: 0.7),
                              OsmeaColors.transparent,
                              OsmeaColors.black.withValues(alpha: 0.7),
                              OsmeaColors.black.withValues(alpha: 0.5),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                    OsmeaComponents.positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: OsmeaComponents.column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OsmeaComponents.text(
                            'Beautiful Landscape',
                            textStyle:
                                OsmeaTextStyle.titleMedium(context).copyWith(
                              color: OsmeaColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          OsmeaComponents.sizedBox(height: 4),
                          OsmeaComponents.text(
                            'Nature Photography',
                            textStyle:
                                OsmeaTextStyle.bodyMedium(context).copyWith(
                              color: OsmeaColors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OsmeaComponents.positioned(
                      top: 16,
                      right: 16,
                      child: OsmeaComponents.container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: OsmeaColors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: OsmeaComponents.text(
                          'Featured',
                          textStyle:
                              OsmeaTextStyle.labelSmall(context).copyWith(
                            color: OsmeaColors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        OsmeaComponents.sizedBox(height: 16),
        _buildExampleWithCaption(
          context,
          'Profile Card with Badge',
          _buildContainer(
            OsmeaComponents.container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: OsmeaColors.grey.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: OsmeaComponents.stack(
                clipBehavior: Clip.none,
                children: [
                  OsmeaComponents.row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: OsmeaColors.ash,
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: OsmeaColors.silver,
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: 16),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OsmeaComponents.text(
                              'John Doe',
                              textStyle:
                                  OsmeaTextStyle.titleMedium(context).copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            OsmeaComponents.sizedBox(height: 4),
                            OsmeaComponents.text(
                              'Senior Developer',
                              textStyle:
                                  OsmeaTextStyle.bodyMedium(context).copyWith(
                                fontSize: 14,
                                color: OsmeaColors.steel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.positioned(
                    top: -8,
                    right: -8,
                    child: OsmeaComponents.container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: OsmeaColors.forestHeart,
                        shape: BoxShape.circle,
                      ),
                      child: OsmeaComponents.text(
                        'Online',
                        textStyle: OsmeaTextStyle.labelSmall(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleWithCaption(
      BuildContext context, String caption, Widget child) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OsmeaComponents.text(
            caption,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildColoredBox(BuildContext context,
      {required Color color, required double size, String? text}) {
    return OsmeaComponents.container(
      width: size,
      height: size,
      color: color,
      alignment: Alignment.center,
      child: text != null
          ? OsmeaComponents.text(
              text,
              textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                color: color.computeLuminance() > 0.5
                    ? OsmeaColors.black
                    : OsmeaColors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  Widget _buildContainer(Widget child) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
