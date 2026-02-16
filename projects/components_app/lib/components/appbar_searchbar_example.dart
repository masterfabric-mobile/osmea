import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// 🎯 **AppBar with SearchBar**
///
/// Demonstrates the usage of OsmeaAppBarWithSearchBar component
/// with various configurations and features.
class AppBarSearchBarExample extends StatefulWidget {
  const AppBarSearchBarExample({super.key});

  @override
  State<AppBarSearchBarExample> createState() => _AppBarSearchBarExampleState();
}

class _AppBarSearchBarExampleState extends State<AppBarSearchBarExample> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  final List<String> _searchHistory = [];
  List<String> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isNotEmpty && !_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory.removeLast();
        }
      }

      // Simulate search results
      _searchResults = query.isEmpty
          ? []
          : [
              'Result 1 for "$query"',
              'Result 2 for "$query"',
              'Result 3 for "$query"',
            ];
    });
  }

  Future<List<String>> _getSearchSuggestions(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) return _searchHistory;

    return [
      '$query suggestion 1',
      '$query suggestion 2',
      '$query suggestion 3',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OsmeaComponents.appBarWithSearchBar(
        title: const Text('AppBar with SearchBar'),
        searchHint: 'Search products, users, or anything...',
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onSearch: _performSearch,
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        onSearchSubmitted: _performSearch,
        onSearchClear: () {
          setState(() {
            _searchQuery = '';
            _searchResults = [];
          });
        },
        searchSuggestionProvider: _getSearchSuggestions,
        searchBarVariant: SearchbarVariant.outlined,
        searchBarStyle: SearchbarStyle.standard,
        searchBarSize: TextFieldSize.medium,
        showClearButton: true,
        showSearchIcon: true,
        showSuggestions: true,
        maxHistoryItems: 10,
        minQueryLength: 2,
        debounceDuration: const Duration(milliseconds: 300),
        // SearchBar action buttons
        searchBarActions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Barcode scanner clicked!')),
              );
            },
            tooltip: 'Scan barcode',
          ),
          IconButton(
            icon: const Icon(Icons.mic, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice search clicked!')),
              );
            },
            tooltip: 'Voice search',
          ),
        ],
        searchBarActionMargin: EdgeInsets.zero,
        searchBarActionAlignment: MainAxisAlignment.end,
        // AppBar action buttons
        actions: [
          AppBarWithSearchBarAction(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications clicked!')),
              );
            },
            tooltip: 'Notifications',
            badge: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AppBarWithSearchBarAction(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMoreOptions(context);
            },
            tooltip: 'More options',
          ),
        ],
        appBarVariant: AppBarVariant.primary,
        appBarSize: AppBarSize.comfortable,
        centerTitle: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Search Results Section
        if (_searchQuery.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Results for "$_searchQuery"',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_searchResults.length} results found',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(_searchResults[index]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Selected: ${_searchResults[index]}')),
                    );
                  },
                );
              },
            ),
          ),
        ] else ...[
          // Default Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to AppBar with SearchBar',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This shows the OsmeaAppBarWithSearchBar component with integrated search functionality.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Features Section
                  Text(
                    'Features:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  const FeatureItem(
                    icon: Icons.search,
                    title: 'Integrated Search',
                    description: 'Search functionality built into the AppBar',
                  ),
                  const FeatureItem(
                    icon: Icons.history,
                    title: 'Search History',
                    description: 'Automatic search history management',
                  ),
                  const FeatureItem(
                    icon: Icons.lightbulb_outline,
                    title: 'Smart Suggestions',
                    description: 'Dynamic search suggestions as you type',
                  ),
                  const FeatureItem(
                    icon: Icons.notifications,
                    title: 'Action Buttons',
                    description: 'Customizable action buttons with badges',
                  ),
                  const FeatureItem(
                    icon: Icons.tune,
                    title: 'Customizable',
                    description: 'Multiple variants, sizes, and styles',
                  ),

                  const SizedBox(height: 16),

                  // Usage Instructions
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to Use:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '1. Tap the search field in the AppBar\n'
                            '2. Start typing to see suggestions\n'
                            '3. Tap on suggestions or press search\n'
                            '4. View search results below\n'
                            '5. Use action buttons for additional features',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings clicked!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help clicked!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('About clicked!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
