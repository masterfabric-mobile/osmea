import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

/// 🏗️ **OSMEA Scaffold Examples**
///
/// This file demonstrates various ways to use the OSMEA Scaffold component.
/// Each example showcases different properties and customization options.
///
class ScaffoldExample extends StatefulWidget {
  const ScaffoldExample({Key? key}) : super(key: key);

  @override
  State<ScaffoldExample> createState() => _ScaffoldExampleState();
}

class _ScaffoldExampleState extends State<ScaffoldExample> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'scaffold_example',
      ),
      body: OsmeaComponents.singleChildScrollView(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            OsmeaComponents.text(
              '🏗️ Basic Scaffold',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Standard scaffold
            _buildExampleCard(
              'Standard Scaffold',
              'Basic scaffold with appBar and body',
              _buildStandardScaffold(),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Scaffold with bottom navigation
            _buildExampleCard(
              'Scaffold with Bottom Navigation',
              'Scaffold with navigation bar at the bottom',
              _buildScaffoldWithBottomNav(),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Scaffold with drawer
            _buildExampleCard(
              'Scaffold with Drawer',
              'Scaffold with side drawer for navigation',
              _buildScaffoldWithDrawer(),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Scaffold with FAB
            _buildExampleCard(
              'Scaffold with Floating Action Button',
              'Scaffold with floating action button for primary actions',
              _buildScaffoldWithFab(),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Scaffold with custom color
            _buildExampleCard(
              'Scaffold with Custom Colors',
              'Scaffold with customized background and styling',
              _buildScaffoldWithCustomColors(),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Advanced Scaffold
            OsmeaComponents.text(
              '🧰 Advanced Scaffold',
              textStyle: OsmeaTextStyle.titleLarge(context)
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 16),

            // Combined features
            _buildExampleCard(
              'Combined Features',
              'Scaffold with all features combined',
              _buildAdvancedScaffold(),
            ),
            OsmeaComponents.sizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(String title, String description, Widget example) {
    return Card(
      elevation: 2,
      child: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              title,
              textStyle: OsmeaTextStyle.titleMedium(context)
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              description,
              textStyle:
                  OsmeaTextStyle.bodyMedium(context).copyWith(fontSize: 14),
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: OsmeaColors.silver),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OsmeaComponents.clipRRect(
                borderRadius: BorderRadius.circular(8),
                child: example,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Standard scaffold example
  Widget _buildStandardScaffold() {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Standard Scaffold'),
        backgroundColor: OsmeaColors.nordicBlue,
        foregroundColor: OsmeaColors.white,
      ),
      body: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Basic scaffold with appBar and body',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Scaffold with bottom navigation
  Widget _buildScaffoldWithBottomNav() {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Bottom Navigation'),
        backgroundColor: OsmeaColors.forestHeart,
        foregroundColor: OsmeaColors.white,
      ),
      body: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Tab ${_currentIndex + 1} Content',
          textStyle: OsmeaTextStyle.titleLarge(context).copyWith(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Scaffold with drawer
  Widget _buildScaffoldWithDrawer() {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      key: _scaffoldKey,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('With Drawer'),
        backgroundColor: OsmeaColors.sunsetGlow,
        foregroundColor: OsmeaColors.white,
        leading: OsmeaComponents.iconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // This would open the drawer in a real app
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue,
              ),
              child: OsmeaComponents.text(
                'Navigation Drawer',
                textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                  color: OsmeaColors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: OsmeaComponents.text('Home'),
              onTap: () {
                // Navigate to home screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: OsmeaComponents.text('Settings'),
              onTap: () {
                // Navigate to settings screen
              },
            ),
          ],
        ),
      ),
      body: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Scaffold with side drawer for navigation',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Scaffold with FAB
  Widget _buildScaffoldWithFab() {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('With FAB'),
        backgroundColor: OsmeaColors.deepSea,
        foregroundColor: OsmeaColors.white,
      ),
      body: OsmeaComponents.center(
        child: OsmeaComponents.text(
          'Scaffold with floating action button',
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_example_1',
        onPressed: () {
          // Action when FAB is pressed
        },
        backgroundColor: OsmeaColors.sunsetGlow,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Scaffold with custom colors
  Widget _buildScaffoldWithCustomColors() {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Custom Colors'),
        backgroundColor: OsmeaColors.amberFlame,
        foregroundColor: OsmeaColors.white,
      ),
      body: OsmeaComponents.container(
        color: OsmeaColors.ash.withValues(alpha: 0.1),
        child: OsmeaComponents.center(
          child: OsmeaComponents.container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: OsmeaColors.shadowLight,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: OsmeaComponents.text(
              'Scaffold with custom background color',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Advanced scaffold with combined features
  Widget _buildAdvancedScaffold() {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('Complete Scaffold'),
        backgroundColor: OsmeaColors.nordicBlue,
        foregroundColor: OsmeaColors.white,
        actions: [
          AppBarAction(
            type: AppBarActionType.search,
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          AppBarAction(
            type: AppBarActionType.search,
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue,
              ),
              child: OsmeaComponents.text(
                'Navigation',
                textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                  color: OsmeaColors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: OsmeaComponents.text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: OsmeaComponents.text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: OsmeaComponents.text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: OsmeaComponents.container(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.center(
          child: OsmeaComponents.text('Main Content Area'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_example_2',
        onPressed: () {
          // Action when FAB is pressed
        },
        backgroundColor: OsmeaColors.forestHeart,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
