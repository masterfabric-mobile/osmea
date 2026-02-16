import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🔢 **OSMEA Counter Examples**
///
/// Modern and UX-focused counter component demonstration.
/// Includes interactive examples, animations, and advanced UI design.

class CounterExample extends StatefulWidget {
  const CounterExample({super.key});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample>
    with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _heroScaleAnimation;
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;

  // State variables for different counter demonstrations
  int _heroCounter = 5;
  int _smallCounter = 3;
  int _mediumCounter = 7;
  int _largeCounter = 12;
  int _horizontalCounter = 8;
  int _verticalCounter = 4;
  int _outlinedCounter = 15;
  int _filledCounter = 6;
  int _customStepCounter = 50;
  int _constrainedCounter = 7;
  int _shoppingCartCounter = 1;
  int _likesCounter = 42;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: Curves.elasticOut,
    ));

    _heroFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _heroAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'counter_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.column(
          children: [
            _buildHeroSection(),
            _buildInteractiveShowcase(),
            _buildVariantsGrid(),
            _buildSizesShowcase(),
            _buildAdvancedFeatures(),
            _buildRealWorldExamples(),
            _buildCustomizationPlayground(),
            _buildIconVariants(),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _heroAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _heroFadeAnimation,
          child: ScaleTransition(
            scale: _heroScaleAnimation,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    OsmeaColors.crystalBay.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: OsmeaColors.crystalBay.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: OsmeaComponents.column(
                children: [
                  OsmeaComponents.text(
                    '✨ Interactive Counter Playground',
                    variant: OsmeaTextVariant.headlineLarge,
                    textAlign: TextAlign.center,
                    color: OsmeaColors.nordicBlue,
                  ),
                  OsmeaComponents.sizedBox(height: 12),
                  OsmeaComponents.text(
                    'Explore different styles, sizes, and behaviors of the OSMEA Counter component with smooth animations.',
                    variant: OsmeaTextVariant.bodyLarge,
                    textAlign: TextAlign.center,
                    color: OsmeaColors.slate,
                  ),
                  OsmeaComponents.sizedBox(height: 24),
                  // Hero Counter with special styling
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: OsmeaColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: OsmeaColors.nordicBlue.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: OsmeaComponents.column(
                      children: [
                        OsmeaComponents.text(
                          'Try me out! 👆',
                          variant: OsmeaTextVariant.labelLarge,
                          color: OsmeaColors.pewter,
                        ),
                        OsmeaComponents.sizedBox(height: 12),
                        OsmeaComponents.counter(
                          initialValue: _heroCounter,
                          onChanged: (value) {
                            setState(() => _heroCounter = value);
                            // Add haptic feedback for better UX
                            if (_heroCounter != value) {
                              // HapticFeedback.lightImpact();
                            }
                          },
                          variant: CounterVariant.filled,
                          size: CounterSize.large,
                          minValue: 0,
                          maxValue: 20,
                          buttonColor: OsmeaColors.nordicBlue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractiveShowcase() {
    return SlideTransition(
      position: _cardSlideAnimation,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModernSectionHeader(
              '🎨 Style Variants',
              'Different visual styles for every use case',
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildVariantCard(
              'Horizontal Layout',
              'Perfect for space-efficient designs',
              Icons.swap_horiz,
              OsmeaColors.forestHeart,
              OsmeaComponents.counter(
                initialValue: _horizontalCounter,
                onChanged: (value) =>
                    setState(() => _horizontalCounter = value),
                variant: CounterVariant.horizontal,
                minValue: 0,
                maxValue: 20,
              ),
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildVariantCard(
              'Vertical Layout',
              'Great for compact vertical spaces',
              Icons.swap_vert,
              OsmeaColors.sunsetGlow,
              OsmeaComponents.counter(
                initialValue: _verticalCounter,
                onChanged: (value) => setState(() => _verticalCounter = value),
                variant: CounterVariant.vertical,
                minValue: 0,
                maxValue: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantCard(
    String title,
    String description,
    IconData icon,
    Color accentColor,
    Widget counter,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: OsmeaComponents.row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          OsmeaComponents.sizedBox(width: 16),
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  title,
                  variant: OsmeaTextVariant.titleMedium,
                  color: OsmeaColors.thunder,
                ),
                OsmeaComponents.text(
                  description,
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(width: 16),
          counter,
        ],
      ),
    );
  }

  Widget _buildVariantsGrid() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionHeader(
            '🎭 Visual Styles',
            'Choose the perfect look for your design',
          ),
          OsmeaComponents.sizedBox(height: 20),
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildStyleCard(
                  'Outlined',
                  'Clean & minimal',
                  CounterVariant.outlined,
                  _outlinedCounter,
                  (value) => setState(() => _outlinedCounter = value),
                  OsmeaColors.nordicBlue,
                ),
              ),
              OsmeaComponents.sizedBox(width: 16),
              Expanded(
                child: _buildStyleCard(
                  'Filled',
                  'Bold & prominent',
                  CounterVariant.filled,
                  _filledCounter,
                  (value) => setState(() => _filledCounter = value),
                  OsmeaColors.forestHeart,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStyleCard(
    String title,
    String subtitle,
    CounterVariant variant,
    int value,
    ValueChanged<int> onChanged,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.05),
            accentColor.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.text(
            title,
            variant: OsmeaTextVariant.titleMedium,
            color: accentColor,
          ),
          OsmeaComponents.sizedBox(height: 4),
          OsmeaComponents.text(
            subtitle,
            variant: OsmeaTextVariant.bodySmall,
            color: OsmeaColors.pewter,
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.counter(
            initialValue: value,
            onChanged: onChanged,
            variant: variant,
            minValue: 0,
            maxValue: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSizesShowcase() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionHeader(
            '📏 Size Options',
            'Perfect sizing for every context',
          ),
          OsmeaComponents.sizedBox(height: 20),
          _buildSizeCard('Small', 'Compact interfaces', CounterSize.small,
              _smallCounter, (value) => setState(() => _smallCounter = value)),
          OsmeaComponents.sizedBox(height: 12),
          _buildSizeCard(
              'Medium',
              'Standard size',
              CounterSize.medium,
              _mediumCounter,
              (value) => setState(() => _mediumCounter = value)),
          OsmeaComponents.sizedBox(height: 12),
          _buildSizeCard('Large', 'Touch-friendly', CounterSize.large,
              _largeCounter, (value) => setState(() => _largeCounter = value)),
        ],
      ),
    );
  }

  Widget _buildSizeCard(String size, String description,
      CounterSize counterSize, int value, ValueChanged<int> onChanged) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OsmeaColors.silver),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.thunder.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                '$size Size',
                variant: OsmeaTextVariant.titleMedium,
                color: OsmeaColors.thunder,
              ),
              OsmeaComponents.text(
                description,
                variant: OsmeaTextVariant.bodySmall,
                color: OsmeaColors.pewter,
              ),
            ],
          ),
          OsmeaComponents.counter(
            initialValue: value,
            onChanged: onChanged,
            size: counterSize,
            variant: CounterVariant.outlined,
            minValue: 0,
            maxValue: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFeatures() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionHeader(
            '⚡ Advanced Features',
            'Powerful customization options',
          ),
          OsmeaComponents.sizedBox(height: 20),
          _buildFeatureCard(
            'Custom Step Value',
            'Increment by 5 instead of 1',
            Icons.fast_forward,
            OsmeaColors.sunsetGlow,
            'Current: $_customStepCounter',
            OsmeaComponents.counter(
              initialValue: _customStepCounter,
              onChanged: (value) => setState(() => _customStepCounter = value),
              variant: CounterVariant.filled,
              step: 5,
              minValue: 0,
              maxValue: 100,
              buttonColor: OsmeaColors.sunsetGlow,
            ),
          ),
          OsmeaComponents.sizedBox(height: 16),
          _buildFeatureCard(
            'Value Constraints',
            'Limited range: 5-10 only',
            Icons.settings_input_component,
            OsmeaColors.forestHeart,
            'Range: $_constrainedCounter',
            OsmeaComponents.counter(
              initialValue: _constrainedCounter,
              onChanged: (value) => setState(() => _constrainedCounter = value),
              variant: CounterVariant.outlined,
              iconVariant: CounterIconVariant.circles,
              minValue: 5,
              maxValue: 10,
              borderColor: OsmeaColors.forestHeart,
              buttonColor: OsmeaColors.forestHeart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color accentColor,
    String statusText,
    Widget counter,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.05),
            accentColor.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 20,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      title,
                      variant: OsmeaTextVariant.titleMedium,
                      color: OsmeaColors.thunder,
                    ),
                    OsmeaComponents.text(
                      description,
                      variant: OsmeaTextVariant.bodySmall,
                      color: OsmeaColors.pewter,
                    ),
                  ],
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 16),
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.text(
                statusText,
                variant: OsmeaTextVariant.labelLarge,
                color: accentColor,
              ),
              counter,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealWorldExamples() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionHeader(
            '🌍 Real-World Use Cases',
            'Common use cases in modern apps',
          ),
          OsmeaComponents.sizedBox(height: 20),
          _buildShoppingCard(),
          OsmeaComponents.sizedBox(height: 16),
          _buildSocialCard(),
        ],
      ),
    );
  }

  Widget _buildShoppingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OsmeaColors.silver),
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.thunder.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: OsmeaComponents.row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: OsmeaColors.crystalBay,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 24,
            ),
          ),
          OsmeaComponents.sizedBox(width: 16),
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Premium T-Shirt',
                  variant: OsmeaTextVariant.titleMedium,
                  color: OsmeaColors.thunder,
                ),
                OsmeaComponents.text(
                  '\$29.99',
                  variant: OsmeaTextVariant.bodyLarge,
                  color: OsmeaColors.forestHeart,
                ),
                OsmeaComponents.text(
                  'Free shipping included',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
          ),
          OsmeaComponents.counter(
            initialValue: _shoppingCartCounter,
            onChanged: (value) => setState(() => _shoppingCartCounter = value),
            variant: CounterVariant.outlined,
            size: CounterSize.small,
            iconVariant: CounterIconVariant.thumbs,
            minValue: 1,
            maxValue: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OsmeaColors.sunsetGlow.withValues(alpha: 0.1),
            OsmeaColors.amberFlame.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OsmeaColors.sunsetGlow.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [OsmeaColors.sunsetGlow, OsmeaColors.amberFlame],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 24,
            ),
          ),
          OsmeaComponents.sizedBox(width: 16),
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  'Post Engagement',
                  variant: OsmeaTextVariant.titleMedium,
                  color: OsmeaColors.thunder,
                ),
                OsmeaComponents.text(
                  'Show your appreciation',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
          ),
          OsmeaComponents.row(
            children: [
              OsmeaComponents.text(
                '$_likesCounter',
                variant: OsmeaTextVariant.titleLarge,
                color: OsmeaColors.sunsetGlow,
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.iconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                size: ButtonSize.medium,
                variant: ButtonVariant.primary,
                backgroundColor: OsmeaColors.sunsetGlow,
                onPressed: () => setState(() => _likesCounter++),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationPlayground() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionHeader(
            '🎨 Customization Playground',
            'Mix and match styles to create your perfect counter',
          ),
          OsmeaComponents.sizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  OsmeaColors.nordicBlue.withValues(alpha: 0.05),
                  OsmeaColors.crystalBay.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: OsmeaColors.crystalBay.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: OsmeaComponents.column(
              children: [
                OsmeaComponents.text(
                  'Custom Styled Counter',
                  variant: OsmeaTextVariant.titleLarge,
                  color: OsmeaColors.nordicBlue,
                  textAlign: TextAlign.center,
                ),
                OsmeaComponents.sizedBox(height: 8),
                OsmeaComponents.text(
                  'With custom colors and arrow icons',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.pewter,
                  textAlign: TextAlign.center,
                ),
                OsmeaComponents.sizedBox(height: 20),
                OsmeaComponents.counter(
                  initialValue: _heroCounter,
                  onChanged: (value) => setState(() => _heroCounter = value),
                  variant: CounterVariant.filled,
                  size: CounterSize.large,
                  iconVariant: CounterIconVariant.favorite,
                  backgroundColor: OsmeaColors.white,
                  borderRadius: BorderRadius.circular(12),
                  minValue: 0,
                  maxValue: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconVariants() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSectionHeader(
            '🎯 Icon Variants',
            'Predefined icon sets for easy use',
          ),
          OsmeaComponents.sizedBox(height: 20),

          // Favorite Icon Counter
          _buildSimpleIconVariantCard(
            'Favorite Counter',
            'CounterIconVariant.favorite',
            CounterIconVariant.favorite,
            _likesCounter,
            (value) => setState(() => _likesCounter = value),
          ),

          OsmeaComponents.sizedBox(height: 16),

          // Arrow Icon Counter
          _buildSimpleIconVariantCard(
            'Arrow Navigation',
            'CounterIconVariant.arrows',
            CounterIconVariant.arrows,
            _verticalCounter,
            (value) => setState(() => _verticalCounter = value),
          ),

          OsmeaComponents.sizedBox(height: 16),

          // Star Rating Counter
          _buildSimpleIconVariantCard(
            'Star Rating',
            'CounterIconVariant.stars',
            CounterIconVariant.stars,
            _customStepCounter ~/ 10, // Convert to star scale
            (value) => setState(() => _customStepCounter = value * 10),
            maxValue: 5,
          ),

          OsmeaComponents.sizedBox(height: 16),

          // Thumbs Counter
          _buildSimpleIconVariantCard(
            'Thumbs Voting',
            'CounterIconVariant.thumbs',
            CounterIconVariant.thumbs,
            _smallCounter,
            (value) => setState(() => _smallCounter = value),
          ),

          OsmeaComponents.sizedBox(height: 16),

          // Horizontal Arrows Counter
          _buildSimpleIconVariantCard(
            'Horizontal Arrows',
            'CounterIconVariant.horizontalArrows',
            CounterIconVariant.horizontalArrows,
            _mediumCounter,
            (value) => setState(() => _mediumCounter = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleIconVariantCard(
    String title,
    String codeExample,
    CounterIconVariant iconVariant,
    int value,
    ValueChanged<int> onChanged, {
    int minValue = 0,
    int maxValue = 20,
  }) {
    final iconConfig = iconVariant.config;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.silver.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          Expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  title,
                  variant: OsmeaTextVariant.titleMedium,
                  color: OsmeaColors.thunder,
                ),
                OsmeaComponents.text(
                  iconConfig.description ?? '',
                  variant: OsmeaTextVariant.bodySmall,
                  color: OsmeaColors.pewter,
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(width: 16),
          OsmeaComponents.counter(
            initialValue: value,
            onChanged: onChanged,
            variant: CounterVariant.outlined,
            size: CounterSize.medium,
            iconVariant: iconVariant,
            minValue: minValue,
            maxValue: maxValue,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSectionHeader(String title, String subtitle) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          title,
          variant: OsmeaTextVariant.headlineSmall,
          color: OsmeaColors.thunder,
        ),
        OsmeaComponents.sizedBox(height: 4),
        OsmeaComponents.text(
          subtitle,
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.pewter,
        ),
      ],
    );
  }
}
