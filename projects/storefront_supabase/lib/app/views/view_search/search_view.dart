import 'package:flutter/material.dart';
import 'package:core/core.dart' hide SearchState;
import 'models/view_model.dart';
import 'models/states.dart';

class SearchView extends MasterViewCubit<SearchViewModel, SearchState> {
  SearchView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              'Search Products',
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            size: AppBarSize.large,
            elevation: 0,
            titleSpacing: 0.0,
          ),
        );

  @override
  void initialContent(
    SearchViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    SearchViewModel viewModel,
    SearchState state,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OsmeaComponents.textField(
            controller: viewModel.searchController,
            label: 'Search',
            prefixIcon: const Icon(Icons.search),
            onChanged: (query) {
              viewModel.search(query);
            },
            variant: TextFieldVariant.outlined,
            focusColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        Expanded(
          child: _buildBody(context, viewModel, state),
        ),
      ],
    );
  }

  Widget _buildBody(
      BuildContext context, SearchViewModel viewModel, SearchState state) {
    if (state is SearchLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SearchErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.search(viewModel.searchController.text),
      );
    } else if (state is SearchLoadedState) {
      if (state.searchResults.isEmpty &&
          viewModel.searchController.text.isNotEmpty) {
        return OsmeaComponents.center(
          child: OsmeaComponents.text('No results found for "${viewModel.searchController.text}"'),
        );
      } else if (state.searchResults.isEmpty && viewModel.searchController.text.isEmpty) {
        return OsmeaComponents.center(
          child: OsmeaComponents.text('Start typing to search...'),
        );
      }
      return ListView.builder(
        itemCount: state.searchResults.length,
        itemBuilder: (context, index) {
          final result = state.searchResults[index];
          return OsmeaComponents.listItem(
            title: OsmeaComponents.text(result),
            onTap: () {
              // Navigate to product detail or handle selection
              goRoute('/product-detail/$result');
            },
          );
        },
      );
    }
    return const Center(child: CircularProgressIndicator()); // Should not happen
  }
}
