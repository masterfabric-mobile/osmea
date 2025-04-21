import 'package:flutter/material.dart';

/// 🖥️ WideLayoutView
///
/// 📐 Designed for large desktop screens and monitors
/// 📏 Features a fixed-width control panel with expandable response area
/// 🔍 Optimizes horizontal space for detailed API interactions
class WideLayoutView extends StatelessWidget {
  // 🎛️ Control panel widget showing configuration options
  final Widget controlPanel;

  // 📋 Response panel displaying API results
  final Widget responsePanel;

  // 🏗️ Constructor requiring both panels
  const WideLayoutView({
    super.key,
    required this.controlPanel,
    required this.responsePanel,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Access theme for consistent styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // 📏 Get full height for panels
    final screenHeight = MediaQuery.of(context).size.height;

    // 📐 Make width adaptive based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    // ↔️ Larger screens get slightly wider control panel
    final controlPanelWidth = screenWidth < 1400 ? 320.0 : 360.0;

    // Remove the SingleChildScrollView and directly use Row for better layout
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Control panel with fixed width and full height
        Container(
          width: controlPanelWidth,
          height: screenHeight,
          color: colorScheme.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: controlPanel,
          ),
        ),
        // Response panel takes remaining width and full height
        Expanded(
          child: Container(
            height: screenHeight,
            color: colorScheme.surface,
            child: responsePanel,
          ),
        ),
      ],
    );
  }
}

/// 💻 MediumLayoutView
///
/// 📱 Designed for tablets and smaller laptops
/// ⚖️ Uses flex ratio to balance panel sizes
/// 🔄 Adapts proportionally to available screen width
class MediumLayoutView extends StatelessWidget {
  // 🎛️ Control panel with configuration options
  final Widget controlPanel;

  // 📊 Response panel showing results
  final Widget responsePanel;

  // 🏗️ Constructor requiring both panels
  const MediumLayoutView({
    super.key,
    required this.controlPanel,
    required this.responsePanel,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Access theme for styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // 📏 Get full screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // ⚖️ Calculate proportional widths based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    // 📊 Create balanced ratio - more space for response on smaller screens
    final controlPanelFlex = screenWidth < 900 ? 4 : 5;
    final responsePanelFlex = screenWidth < 900 ? 5 : 7;

    // Remove the SingleChildScrollView and directly use Row for better layout
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Control panel with flex and full height
        Expanded(
          flex: controlPanelFlex,
          child: Container(
            height: screenHeight,
            color: colorScheme.surface,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: controlPanel,
            ),
          ),
        ),
        // Response panel with flex and full height
        Expanded(
          flex: responsePanelFlex,
          child: Container(
            height: screenHeight,
            color: colorScheme.surface,
            child: responsePanel,
          ),
        ),
      ],
    );
  }
}

/// 📱 NarrowLayoutView
///
/// 📲 Designed for mobile phones and narrow viewports
/// 🔝 Stacks panels vertically to maximize readability
/// 🔍 Features collapsible control panel to maximize response space
class NarrowLayoutView extends StatelessWidget {
  // ⚙️ Collapsible control panel at the top
  final Widget controlPanel;

  // 📄 Response display taking remaining space
  final Widget responsePanel;

  // 🏗️ Constructor requiring both panels
  const NarrowLayoutView({
    super.key,
    required this.controlPanel,
    required this.responsePanel,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Access theme for styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // 📏 Determine screen constraints
    final screenWidth = MediaQuery.of(context).size.width;
    // 🧩 Adjust spacing for very small screens
    final cardPadding = screenWidth < 400 ? 8.0 : 12.0;

    // 📐 Vertical layout for narrow screens
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🎛️ Control panel in collapsible card
        Card(
          margin: EdgeInsets.all(cardPadding),
          elevation: 2, // 🔲 Subtle shadow for depth
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // 🔄 Rounded corners
          ),
          color: colorScheme.surface,
          child: Theme(
            // 📌 Remove divider for cleaner look
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              // 📝 Header row with icon and title
              title: Row(
                children: [
                  // ⚙️ Settings icon
                  Icon(
                    Icons.settings_rounded,
                    color: colorScheme.primary,
                    // 🔍 Smaller icon on tiny screens
                    size: screenWidth < 400 ? 18 : 20,
                  ),
                  // ↔️ Responsive spacing
                  SizedBox(width: screenWidth < 400 ? 6 : 8),
                  // 📝 Title text that truncates if needed
                  Expanded(
                    child: Text(
                      'API Configuration',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        // 🔤 Smaller font on tiny screens
                        fontSize: screenWidth < 400 ? 14 : null,
                      ),
                      overflow: TextOverflow.ellipsis, // ✂️ Truncate if needed
                    ),
                  ),
                ],
              ),
              // 📂 Start expanded by default
              initiallyExpanded: true,
              children: [
                // 📑 Content with padding
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: controlPanel,
                ),
              ],
            ),
          ),
        ),

        // 📊 Response panel takes remaining vertical space
        Expanded(
          child: Container(
            margin: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              // 🔄 Rounded corners to match control panel
              borderRadius: BorderRadius.circular(16),
            ),
            child: responsePanel, // 📋 Actual response content
          ),
        ),
      ],
    );
  }
}
