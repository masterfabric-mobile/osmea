import 'package:components_app/constants/components_list.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ModernComponentsScreen extends StatefulWidget {
  const ModernComponentsScreen({super.key});

  @override
  State<ModernComponentsScreen> createState() => _ModernComponentsScreenState();
}

class _ModernComponentsScreenState extends State<ModernComponentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredComponents = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _filteredComponents = components;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterComponents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredComponents = components;
      } else {
        _filteredComponents = components
            .where((component) => component['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchController.text.isNotEmpty;

    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      body: SafeArea(
        child: OsmeaComponents.column(
          children: [
            // Modern header with progress
            _buildModernHeader(),

            // Show tabbar only when not searching
            if (!isSearching) _buildModernTabBar(),

            // Content area
            OsmeaComponents.expanded(
              child: isSearching
                  ? _buildSearchResults()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildComponentsGrid(
                            'Layout Components', _getLayoutComponents()),
                        _buildComponentsGrid(
                            'Input Components', _getInputComponents()),
                        _buildComponentsGrid(
                            'Display Components', _getDisplayComponents()),
                        _buildComponentsGrid('Navigation Components',
                            _getNavigationComponents()),
                        _buildComponentsGrid(
                            'Feedback Components', _getFeedbackComponents()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with progress indicator
          OsmeaComponents.row(
            children: [
              OsmeaComponents.text(
                'Components',
                variant: OsmeaTextVariant.headlineLarge,
                color: OsmeaColors.black,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              OsmeaComponents.container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: OsmeaColors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: OsmeaComponents.container(
                  width: 60 * 0.8, // Fixed progress value
                  height: 4,
                  decoration: BoxDecoration(
                    color: OsmeaColors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),

          OsmeaComponents.sizedBox(height: 8),

          // Subtitle with count
          OsmeaComponents.text(
            '${_filteredComponents.length} components available',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.black,
            fontWeight: FontWeight.w400,
          ),

          OsmeaComponents.sizedBox(height: 16),

          // Ultra minimal search bar
          OsmeaComponents.searchbar(
            controller: _searchController,
            hint: 'Search...',
            onChanged: _filterComponents,
            searchbarVariant: SearchbarVariant.outlined,
            searchbarStyle: SearchbarStyle.minimal,
            backgroundColor: OsmeaColors.white,
            borderColor: OsmeaColors.black,
            textColor: OsmeaColors.black,
            hintColor: OsmeaColors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        isScrollable: true, // Enable horizontal scrolling
        tabs: const [
          Tab(text: 'Layout'),
          Tab(text: 'Input'),
          Tab(text: 'Display'),
          Tab(text: 'Navigation'),
          Tab(text: 'Feedback'),
        ],
        labelColor: OsmeaColors.black,
        unselectedLabelColor: OsmeaColors.black.withValues(alpha: 0.6),
        indicatorColor: OsmeaColors.black,
        indicatorWeight: 2,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabAlignment: TabAlignment.start,
      ),
    );
  }

  Widget _buildComponentsGrid(
      String title, List<Map<String, dynamic>> componentsList) {
    return OsmeaComponents.padding(
      padding: const EdgeInsets.all(20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scrollable grid with smaller cards
          OsmeaComponents.expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3, // Smaller cards
              ),
              itemCount: componentsList.length,
              itemBuilder: (context, index) {
                final component = componentsList[index];
                return _buildModernCard(
                    component, title == 'Featured Components');
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getLayoutComponents() {
    return _filteredComponents
        .where((c) => [
              'Align',
              'Center',
              'Column',
              'Row',
              'Stack',
              'Wrap',
              'Container',
              'SizedBox',
              'Padding',
              'Expanded',
              'Flexible',
              'FittedBox',
              'Spacer',
              'Positioned',
              'ClipRRect',
              'Scaffold',
              'SingleChildScrollView',
              'SoundDialog'
            ].contains(c['title']))
        .toList();
  }

  List<Map<String, dynamic>> _getInputComponents() {
    return _filteredComponents
        .where((c) => [
              'TextField',
              'Checkbox',
              'Radio Button',
              'RadioButton',
              'Switch',
              'Switch Button',
              'Dropdown',
              'Searchbar',
              'Phone Picker'
            ].contains(c['title']))
        .toList();
  }

  List<Map<String, dynamic>> _getDisplayComponents() {
    return _filteredComponents
        .where((c) => [
              'Text',
              'RichText',
              'Rich Text',
              'Image',
              'Avatar',
              'Badge',
              'Card',
              'Chips',
              'Progress',
              'Loading',
              'Toast',
              'Snackbar',
              'SoundDialog',
              'Colors',
              'Divider',
              'ListItem',
              'Footer',
              'Ticket'
            ].contains(c['title']))
        .toList();
  }

  List<Map<String, dynamic>> _getNavigationComponents() {
    return _filteredComponents
        .where((c) => [
              'AppBar',
              'AppBar with SearchBar',
              'Tabs',
              'TabBar',
              'BottomSheet',
              'Bottom Sheet',
              'Stepper',
              'Carousel',
              'DotIndicator',
              'Dot Indicator',
              'Collapse',
              'Popup'
            ].contains(c['title']))
        .toList();
  }

  List<Map<String, dynamic>> _getFeedbackComponents() {
    return _filteredComponents
        .where((c) => [
              'Toast',
              'Snackbar',
              'Loading',
              'Progress',
              'Sound Dialog',
              'Badge',
              'Counter',
              'Button',
              'URL Launcher',
              'Application Share Helper',
              'File Download Helper',
              'Viewer Helper'
            ].contains(c['title']))
        .toList();
  }

  Widget _buildSearchResults() {
    if (_filteredComponents.isEmpty) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: OsmeaColors.black.withValues(alpha: .3),
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              'No components found',
              variant: OsmeaTextVariant.titleMedium,
              color: OsmeaColors.black.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
            OsmeaComponents.sizedBox(height: 8),
            OsmeaComponents.text(
              'Try a different search term',
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.black.withValues(alpha: 0.4),
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      );
    }

    return OsmeaComponents.column(
      children: [
        // Fixed header
        OsmeaComponents.padding(
          padding: const EdgeInsets.all(20),
          child: OsmeaComponents.text(
            'Search Results (${_filteredComponents.length})',
            variant: OsmeaTextVariant.titleLarge,
            color: OsmeaColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Scrollable results list
        OsmeaComponents.expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filteredComponents.length,
            itemBuilder: (context, index) {
              final component = _filteredComponents[index];
              return _buildSearchResultItem(component);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> component) {
    return OsmeaComponents.container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: OsmeaColors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => component['route']()),
        ),
        borderRadius: BorderRadius.circular(8),
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.row(
            children: [
              Icon(
                component['icon'],
                size: 20,
                color: OsmeaColors.black.withValues(alpha: 0.7),
              ),
              OsmeaComponents.sizedBox(width: 16),
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.text(
                      component['title'],
                      variant: OsmeaTextVariant.bodyMedium,
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    OsmeaComponents.sizedBox(height: 4),
                    OsmeaComponents.text(
                      _getComponentDescription(component['title']),
                      variant: OsmeaTextVariant.bodySmall,
                      color: OsmeaColors.black.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: OsmeaColors.black.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(Map<String, dynamic> component, bool isFeatured) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => component['route']()),
        ),
        borderRadius: BorderRadius.circular(12),
        child: OsmeaComponents.padding(
          padding: const EdgeInsets.all(16),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon without container
              Icon(
                component['icon'],
                size: 24,
                color: OsmeaColors.black.withValues(alpha: 0.7),
              ),

              OsmeaComponents.sizedBox(height: 12),

              OsmeaComponents.text(
                component['title'],
                variant: OsmeaTextVariant.bodyMedium,
                color: OsmeaColors.black,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getComponentDescription(String componentName) {
    final descriptions = {
      'Align': 'Position widgets with precision',
      'AppBar': 'Top navigation and actions',
      'Avatar': 'User profile representation',
      'Badge': 'Status indicators and counts',
      'Bottom Sheet': 'Modal content presentation',
      'Button': 'Interactive action elements',
      'Card': 'Content containers with elevation',
      'Carousel': 'Horizontal scrolling content',
      'Center': 'Center-aligned widget positioning',
      'Checkbox': 'Binary selection control',
      'Chips': 'Compact selection tags',
      'ClipRRect': 'Clipped rounded rectangles',
      'Collapse': 'Expandable content sections',
      'Colors': 'OSMEA color palette',
      'Column': 'Vertical widget arrangement',
      'Container': 'Flexible layout container',
      'Counter': 'Numeric value display',
      'Divider': 'Visual separation lines',
      'Dot Indicator': 'Progress and pagination',
      'Dropdown': 'Selection from options',
      'Expanded': 'Fill available space',
      'FittedBox': 'Scale to fit content',
      'Flexible': 'Flexible space distribution',
      'Footer': 'Bottom content section',
      'Image': 'Visual content display',
      'List Item': 'Individual list elements',
      'Loading': 'Progress and loading states',
      'Padding': 'Space around widgets',
      'Popup': 'Overlay content display',
      'Positioned': 'Absolute positioning',
      'Progress': 'Linear progress indicators',
      'Radio Button': 'Single selection control',
      'Rich Text': 'Formatted text display',
      'Row': 'Horizontal widget arrangement',
      'Scaffold': 'Basic app structure',
      'Searchbar': 'Text search input',
      'SingleChildScrollView': 'Scrollable content',
      'SizedBox': 'Fixed size container',
      'Snackbar': 'Brief message display',
      'Sound Dialog': 'Record and play audio with dialog interface',
      'Spacer': 'Flexible space element',
      'Stack': 'Layered widget positioning',
      'Stepper': 'Step-by-step process',
      'Switch Button': 'Toggle control',
      'TabBar': 'Tab navigation',
      'Text': 'Text display widget',
      'TextField': 'Text input control',
      'Ticket Widget': 'Ticket-style display',
      'Toast': 'Notification messages',
      'Wrap': 'Wrapping widget layout',
    };

    return descriptions[componentName] ?? 'UI component for Flutter apps';
  }
}
