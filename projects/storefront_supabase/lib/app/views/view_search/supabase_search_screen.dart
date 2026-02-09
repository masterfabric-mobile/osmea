/*
 * SupabaseSearchScreen
 * --------------------
 * Search screen built entirely in storefront_supabase.
 * Uses the same OsmeaComponents.searchbar as home (home_view.search config).
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/utils/config_utils.dart';
import 'package:storefront_supabase/app/views/view_search/widgets/search_empty_state_widget.dart';
import 'package:storefront_supabase/app/views/view_search/widgets/search_results_grid_widget.dart';

class SupabaseSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final bool fromHome;
  final void Function(String path) goRoute;
  final Future<List<dynamic>> Function(String query) searchProvider;

  const SupabaseSearchScreen({
    super.key,
    this.initialQuery,
    this.fromHome = false,
    required this.goRoute,
    required this.searchProvider,
  });

  @override
  State<SupabaseSearchScreen> createState() => _SupabaseSearchScreenState();
}

class _SupabaseSearchScreenState extends State<SupabaseSearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  late final SearchCubit _searchCubit;
  late final AssetConfigHelper _configHelper;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();
    _searchCubit = SearchCubit();
    _configHelper = AssetConfigHelper();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _searchCubit.performSearch(
            widget.initialQuery!,
            searchProvider: widget.searchProvider,
            immediate: true,
          );
        }
      });
    }
    if (widget.fromHome && _focusNode.canRequestFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _searchCubit.close();
    super.dispose();
  }

  Map<String, dynamic>? _loadSearchConfig() {
    try {
      return _configHelper.getObject('home_view.search');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadSearchConfig();
    final placeholder = configString(config?['placeholder']) ??
        context.resources.searchProductsHint;
    final variant = configString(config?['variant']) ?? 'outlined';

    return BlocProvider<SearchCubit>.value(
      value: _searchCubit,
      child: OsmeaComponents.scaffold(
        backgroundColor: OsmeaColors.white,
        appBar: AppBar(
          backgroundColor: OsmeaColors.white,
          foregroundColor: OsmeaColors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: OsmeaColors.black),
            onPressed: () => widget.goRoute('/home'),
            padding: EdgeInsets.symmetric(horizontal: context.spacing8),
            style: IconButton.styleFrom(
              minimumSize: const Size(48, 48),
              maximumSize: const Size(48, 48),
            ),
          ),
          title: Text(
            context.resources.searchProducts,
            style: const TextStyle(
              color: OsmeaColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OsmeaComponents.padding(
              padding: EdgeInsets.fromLTRB(
                context.spacing20,
                context.spacing16,
                context.spacing20,
                context.spacing16,
              ),
              child: OsmeaComponents.searchbar(
                controller: _searchController,
                focusNode: _focusNode,
                hint: placeholder,
                size: TextFieldSize.medium,
                searchbarStyle: SearchbarStyle.minimal,
                searchbarVariant: variant == 'outlined'
                    ? SearchbarVariant.outlined
                    : SearchbarVariant.borderless,
                state: TextFieldState.enabled,
                showSearchIcon: true,
                showClearButton: true,
                showBackButton: false,
                backgroundColor: OsmeaColors.white,
                borderColor: OsmeaColors.pewter,
                focusColor: _configHelper.getSearchViewFocusColor(
                  OsmeaColors.black,
                ),
                textColor: OsmeaColors.thunder,
                hintColor: OsmeaColors.pewter,
                onChanged: (q) {
                  _searchCubit.updateQuery(q);
                  if (q.length >= 2) {
                    _searchCubit.performSearch(
                      q,
                      searchProvider: widget.searchProvider,
                    );
                  } else if (q.isEmpty) {
                    _searchCubit.clearSearch();
                  }
                },
                onSubmitted: (q) {
                  _searchCubit.performSearch(
                    q,
                    searchProvider: widget.searchProvider,
                    immediate: true,
                  );
                },
                onSearch: (q) {
                  _searchCubit.performSearch(
                    q,
                    searchProvider: widget.searchProvider,
                    immediate: true,
                  );
                },
                onClear: () {
                  _searchController.clear();
                  _searchCubit.clearSearch();
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                bloc: _searchCubit,
                builder: (context, state) {
                  if (state.isLoading && state.results.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.hasResults) {
                    return SearchResultsGridWidget(products: state.results);
                  }
                  return SearchEmptyStateWidget(
                    searchCubit: _searchCubit,
                    searchProvider: widget.searchProvider,
                    showSkeleton: !widget.fromHome,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
