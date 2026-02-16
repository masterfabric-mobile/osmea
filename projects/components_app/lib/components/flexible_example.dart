import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🔄 **OSMEA Flexible Examples**
///
/// This file demonstrates various ways to use the OSMEA Flexible component,
/// which enables flexible space allocation within Row and Column layouts.
///
class FlexibleExample extends StatelessWidget {
  const FlexibleExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'flexible_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '🔄 Basic Flexible in Row',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Basic row with flexible example
            OsmeaComponents.text('Flexible with different flex factors:'),
            OsmeaComponents.sizedBox(height: 8),
            basicRowFlexibleExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Flexible with fit example
            OsmeaComponents.text('Flexible with different fit types:'),
            OsmeaComponents.sizedBox(height: 8),
            flexibleFitExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for column flexibles
            OsmeaComponents.text(
              '🔄 Flexible in Column',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Column with flexibles example
            OsmeaComponents.text('Flexibles in a column:'),
            OsmeaComponents.sizedBox(height: 8),
            columnFlexiblesExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for comparison with expanded
            OsmeaComponents.text(
              '🔄 Flexible vs Expanded',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Flexible vs expanded example
            OsmeaComponents.text('Comparing Flexible with Expanded:'),
            OsmeaComponents.sizedBox(height: 8),
            flexibleVsExpandedExample(context),
            OsmeaComponents.sizedBox(height: 24),

            // Section title for practical examples
            OsmeaComponents.text(
              '💡 Practical Use Cases',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Form layout example
            OsmeaComponents.text('Form layout with flexible elements:'),
            OsmeaComponents.sizedBox(height: 8),
            formLayoutExample(),
            OsmeaComponents.sizedBox(height: 24),

            // Dashboard layout example
            OsmeaComponents.text('Dashboard layout with flexible panels:'),
            OsmeaComponents.sizedBox(height: 8),
            dashboardLayoutExample(context),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Basic row with flexible example
  Widget basicRowFlexibleExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 60,
      width: double.infinity, // Set width to prevent overflow
      color: OsmeaColors.grey.shade200,
      child: OsmeaComponents.row(
        mainAxisSize: MainAxisSize.max, // Ensure row takes full width
        children: [
          OsmeaComponents.flexible(
            flex: 1, // 1 part of space
            child: _buildColorBox(context, OsmeaColors.red, 'flex: 1'),
          ),
          OsmeaComponents.flexible(
            flex: 2, // 2 parts of space (twice as much)
            child: _buildColorBox(context, OsmeaColors.green, 'flex: 2'),
          ),
          OsmeaComponents.flexible(
            flex: 1, // 1 part of space
            child: _buildColorBox(context, OsmeaColors.blue, 'flex: 1'),
          ),
        ],
      ),
    );
  }

  // Flexible fit example
  Widget flexibleFitExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 60,
      width: double.infinity, // Set width to prevent overflow
      color: OsmeaColors.grey.shade200,
      child: OsmeaComponents.row(
        mainAxisSize: MainAxisSize.max, // Ensure row takes full width
        children: [
          OsmeaComponents.flexible(
            flex: 1,
            fit: FlexFit.loose, // Default - takes needed space
            child: OsmeaComponents.container(
              color: OsmeaColors.red,
              padding: const EdgeInsets.all(8),
              child: OsmeaComponents.text(
                'FlexFit.loose',
                textStyle: OsmeaTextStyle.bodySmall(context)
                    .copyWith(color: OsmeaColors.white, fontSize: 12),
              ),
            ),
          ),
          OsmeaComponents.flexible(
            flex: 1,
            fit: FlexFit.tight, // Forces to fill available space
            child: OsmeaComponents.container(
              color: OsmeaColors.blue,
              padding: const EdgeInsets.all(8),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'FlexFit.tight',
                  textStyle: OsmeaTextStyle.bodySmall(context)
                      .copyWith(color: OsmeaColors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Column with flexibles example
  Widget columnFlexiblesExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 300,
      width: double.infinity,
      color: OsmeaColors.grey.shade200,
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.flexible(
            flex: 1, // 1 part of space
            child: OsmeaComponents.container(
              color: OsmeaColors.red,
              width: double.infinity,
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'flex: 1',
                  textStyle: OsmeaTextStyle.bodySmall(context)
                      .copyWith(color: OsmeaColors.white),
                ),
              ),
            ),
          ),
          OsmeaComponents.flexible(
            flex: 2, // 2 parts of space (twice as much)
            child: OsmeaComponents.container(
              color: OsmeaColors.green,
              width: double.infinity,
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'flex: 2',
                  textStyle: OsmeaTextStyle.bodySmall(context)
                      .copyWith(color: OsmeaColors.white),
                ),
              ),
            ),
          ),
          OsmeaComponents.flexible(
            flex: 1, // 1 part of space
            child: OsmeaComponents.container(
              color: OsmeaColors.blue,
              width: double.infinity,
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'flex: 1',
                  textStyle: OsmeaTextStyle.bodySmall(context)
                      .copyWith(color: OsmeaColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Flexible vs expanded example
  Widget flexibleVsExpandedExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 60,
      width: double.infinity, // Set width to prevent overflow
      color: OsmeaColors.grey.shade200,
      child: OsmeaComponents.row(
        mainAxisSize: MainAxisSize.max, // Ensure row takes full width
        children: [
          OsmeaComponents.flexible(
            flex: 1,
            child: OsmeaComponents.container(
              color: OsmeaColors.sunsetGlow, // amber yerine benzer bir renk
              padding: const EdgeInsets.all(8),
              // Center text to prevent overflow
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'Flexible',
                  textStyle:
                      OsmeaTextStyle.bodySmall(context).copyWith(fontSize: 12),
                ),
              ),
            ),
          ),
          OsmeaComponents.expanded(
            flex: 1,
            child: OsmeaComponents.container(
              color: Colors.deepPurple.withValues(alpha: 0.7),
              child: OsmeaComponents.center(
                child: OsmeaComponents.text(
                  'Expanded',
                  textStyle: OsmeaTextStyle.bodySmall(context)
                      .copyWith(color: OsmeaColors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Form layout example using flexibles
  Widget formLayoutExample() {
    return Card(
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          children: [
            OsmeaComponents.row(
              mainAxisSize: MainAxisSize.max, // Ensure row takes full width
              children: [
                // Fixed width container for label to prevent overflow
                OsmeaComponents.container(
                  width: 60,
                  child: OsmeaComponents.text('Name:'),
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.expanded(
                  // Use expanded instead of flexible
                  child: OsmeaComponents.textField(
                    variant: TextFieldVariant.outlined,
                    size: TextFieldSize.medium,
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.row(
              mainAxisSize: MainAxisSize.max, // Ensure row takes full width
              children: [
                // Fixed width container for label to prevent overflow
                OsmeaComponents.container(
                  width: 60,
                  child: OsmeaComponents.text('Email:'),
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.expanded(
                  // Use expanded instead of flexible
                  flex: 2, // Takes more space
                  child: OsmeaComponents.textField(
                    variant: TextFieldVariant.outlined,
                    size: TextFieldSize.medium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dashboard layout example using flexibles
  Widget dashboardLayoutExample(BuildContext context) {
    return OsmeaComponents.container(
      height: 200,
      width: double.infinity,
      color: OsmeaColors.grey.shade200,
      child: OsmeaComponents.row(
        mainAxisSize: MainAxisSize.max, // Ensure row takes full width
        children: [
          // Sidebar
          OsmeaComponents.flexible(
            flex: 1,
            child: OsmeaComponents.container(
              color: OsmeaColors.slate, // blueGrey yerine benzer bir renk
              child: OsmeaComponents.padding(
                padding: const EdgeInsets.all(12),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      'Dashboard',
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    OsmeaComponents.sizedBox(height: 16),
                    _buildSidebarItem(context, 'Home', Icons.home),
                    _buildSidebarItem(context, 'Analytics', Icons.insert_chart),
                    _buildSidebarItem(context, 'Settings', Icons.settings),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          OsmeaComponents.expanded(
            // Use expanded to fill remaining space
            flex: 3, // Takes 3x the space of the sidebar
            child: OsmeaComponents.column(
              children: [
                // Header
                OsmeaComponents.container(
                  color: OsmeaColors.white,
                  padding: const EdgeInsets.all(16),
                  child: OsmeaComponents.row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Use a constrained width or Expanded for text
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.text(
                          'Analytics Dashboard',
                          textStyle: OsmeaTextStyle.titleLarge(context)
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      OsmeaComponents.spacer(),
                      const Icon(Icons.notifications),
                      OsmeaComponents.sizedBox(width: 16),
                      const Icon(Icons.person),
                    ],
                  ),
                ),

                // Content area
                OsmeaComponents.expanded(
                  child: OsmeaComponents.row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      OsmeaComponents.expanded(
                        // Use expanded instead of flexible
                        flex: 1,
                        child: _buildDashboardCard(
                          context,
                          'Users',
                          '1,254',
                          Icons.people,
                          OsmeaColors.nordicBlue,
                        ),
                      ),
                      OsmeaComponents.expanded(
                        // Use expanded instead of flexible
                        flex: 1,
                        child: _buildDashboardCard(
                          context,
                          'Revenue',
                          '\$12,345',
                          Icons.attach_money,
                          OsmeaColors.meadow,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for sidebar item - fix overflow
  Widget _buildSidebarItem(BuildContext context, String label, IconData icon) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OsmeaComponents.row(
        mainAxisSize: MainAxisSize.min, // Use min size to avoid overflow
        children: [
          Icon(icon, color: OsmeaColors.white, size: 16),
          OsmeaComponents.sizedBox(width: 8),
          // Use Expanded to contain text
          OsmeaComponents.expanded(
            child: OsmeaComponents.text(
              label,
              textStyle: OsmeaTextStyle.bodySmall(context)
                  .copyWith(color: OsmeaColors.white),
              overflow: TextOverflow.ellipsis, // Add ellipsis for long text
            ),
          ),
        ],
      ),
    );
  }

  // Helper for dashboard card
  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        // Use SizedBox with constrained height to prevent overflow
        child: OsmeaComponents.sizedBox(
          height: 85, // Fixed height to ensure no overflow
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Wrap text in Expanded to prevent overflow
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.text(
                      title,
                      textStyle: OsmeaTextStyle.bodySmall(context)
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  OsmeaComponents.spacer(),
                  Icon(icon, color: color),
                ],
              ),
              // Use Expanded to ensure the value gets proper space
              OsmeaComponents.expanded(
                child: OsmeaComponents.align(
                  alignment: Alignment.centerLeft,
                  child: OsmeaComponents.text(
                    value,
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for creating color boxes
  Widget _buildColorBox(BuildContext context, Color color, String text) {
    return OsmeaComponents.container(
      color: color,
      child: OsmeaComponents.center(
        child: OsmeaComponents.text(
          text,
          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12),
          textAlign: TextAlign.center, // Center text to avoid overflow
          overflow: TextOverflow.ellipsis, // Add ellipsis for long text
        ),
      ),
    );
  }
}
