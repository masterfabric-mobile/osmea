import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 📑 TabBar Examples
class TabBarExample extends StatefulWidget {
  const TabBarExample({Key? key}) : super(key: key);

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample> {
  // Tab selection indices
  int primaryIndex = 0;
  int secondaryIndex = 0;
  int outlinedIndex = 0;
  int glassIndex = 0;
  int transparentIndex = 0;

  int scrollableIndex = 0;
  int lineIndicatorIndex = 0;
  int dotIndicatorIndex = 0;
  int fillIndicatorIndex = 0;
  int borderIndicatorIndex = 0;
  int noIndicatorIndex = 0;

  final List<TabItem> _basicTabs = const [
    TabItem(text: 'Home', icon: Icon(Icons.home)),
    TabItem(text: 'Search', icon: Icon(Icons.search)),
    TabItem(text: 'Profile', icon: Icon(Icons.person)),
  ];

  final List<TabItem> _scrollableTabs = const [
    TabItem(text: 'Dashboard', icon: Icon(Icons.dashboard)),
    TabItem(text: 'Analytics', icon: Icon(Icons.analytics)),
    TabItem(text: 'Reports', icon: Icon(Icons.report)),
    TabItem(text: 'Settings', icon: Icon(Icons.settings)),
    TabItem(text: 'Users', icon: Icon(Icons.people)),
    TabItem(text: 'Projects', icon: Icon(Icons.work)),
  ];

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'tabbar_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('TabBar Variants'),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Primary TabBar',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                variant: TabBarVariant.primary,
                currentIndex: primaryIndex,
                onTabTap: (index) => setState(() => primaryIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Secondary TabBar',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                variant: TabBarVariant.secondary,
                currentIndex: secondaryIndex,
                onTabTap: (index) => setState(() => secondaryIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Outlined TabBar',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                variant: TabBarVariant.outlined,
                currentIndex: outlinedIndex,
                onTabTap: (index) => setState(() => outlinedIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Glass TabBar',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                variant: TabBarVariant.glass,
                currentIndex: glassIndex,
                onTabTap: (index) => setState(() => glassIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Transparent TabBar',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                variant: TabBarVariant.transparent,
                currentIndex: transparentIndex,
                onTabTap: (index) => setState(() => transparentIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Scrollable TabBar'),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Scrollable with Many Items',
              OsmeaComponents.tabBar(
                tabs: _scrollableTabs,
                style: TabBarStyle.scrollable,
                currentIndex: scrollableIndex,
                onTabTap: (index) => setState(() => scrollableIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 24),
            _buildSectionTitle('Indicator Styles'),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Line Indicator',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                indicatorStyle: TabBarIndicatorStyle.line,
                currentIndex: lineIndicatorIndex,
                onTabTap: (index) => setState(() => lineIndicatorIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Dot Indicator',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                indicatorStyle: TabBarIndicatorStyle.dot,
                currentIndex: dotIndicatorIndex,
                onTabTap: (index) => setState(() => dotIndicatorIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Fill Indicator',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                indicatorStyle: TabBarIndicatorStyle.fill,
                activeFillColor: OsmeaColors.white,
                currentIndex: fillIndicatorIndex,
                onTabTap: (index) => setState(() => fillIndicatorIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'Border Indicator',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                indicatorStyle: TabBarIndicatorStyle.border,
                currentIndex: borderIndicatorIndex,
                onTabTap: (index) =>
                    setState(() => borderIndicatorIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 16),
            _buildShowcaseCard(
              context,
              'No Indicator',
              OsmeaComponents.tabBar(
                tabs: _basicTabs,
                indicatorStyle: TabBarIndicatorStyle.none,
                currentIndex: noIndicatorIndex,
                onTabTap: (index) => setState(() => noIndicatorIndex = index),
              ),
            ),
            OsmeaComponents.sizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return OsmeaComponents.text(
      title,
      textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: OsmeaColors.nordicBlue,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildShowcaseCard(BuildContext context, String title, Widget child) {
    return OsmeaComponents.container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: OsmeaColors.ash),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            title,
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: 12),
          child,
          // Prevents "BOTTOM OVERFLOWED BY 1.00 PIXELS" for Primary/Outlined/Glass TabBar variants
          OsmeaComponents.sizedBox(height: 2),
        ],
      ),
    );
  }
}
