/*
 * SearchBarWidget
 * ---------------
 * Search bar widget for home view.
 * Positioned below AppBar, navigates to search view on tap or submit.
 * Configured via app_config.json.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Search bar widget for home view
class SearchBarWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;

  const SearchBarWidget({
    super.key,
    required this.configHelper,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Loads search configuration
  Map<String, dynamic>? _loadSearchConfig() {
    try {
      return widget.configHelper.getObject('home_view.search');
    } catch (e) {
      debugPrint('⚠️ Failed to load search config: $e');
      return null;
    }
  }

  /// Navigates to search view with query
  void _navigateToSearch(String? query) {
    if (query != null && query.trim().isNotEmpty) {
      context.push('/search?query=${Uri.encodeComponent(query.trim())}');
    } else {
      context.push('/search');
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadSearchConfig();
    final showSearch = config?['enabled'] as bool? ?? true;

    if (!showSearch) return const SizedBox.shrink();

    final placeholder = config?['placeholder'] as String? ??
        'Search products, brands, categories...';
    final variant = config?['variant'] as String? ?? 'outlined';

    return OsmeaComponents.padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        context.spacing16,
        context.spacing20,
        context.spacing16,
      ),
      child: OsmeaComponents.searchbar(
        controller: _controller,
        hint: placeholder,
        size: TextFieldSize.small, // Daha kompakt yükseklik için küçük boyut
        searchbarStyle: SearchbarStyle.minimal,
        searchbarVariant: variant == 'outlined'
            ? SearchbarVariant.outlined
            : SearchbarVariant.borderless,
        state: TextFieldState.enabled,
        showSearchIcon: true,
        showClearButton: true,
        backgroundColor: OsmeaColors.white,
        borderColor: OsmeaColors.pewter,
        focusColor: OsmeaColors.nordicBlue,
        textColor: OsmeaColors.thunder,
        hintColor: OsmeaColors.pewter,
        onTap: () {
          _navigateToSearch(null);
        },
        onSubmitted: (query) {
          _navigateToSearch(query);
        },
        onSearch: (query) {
          _navigateToSearch(query);
        },
        onClear: () {
          _controller.clear();
        },
      ),
    );
  }
}

