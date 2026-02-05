import 'package:flutter/material.dart';
import 'package:core/core.dart' hide SearchState, BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_supabase/app/core/bloc/currency/currency_cubit.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
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
              context.resources.searchProducts, // Changed to English
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
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
    final resources = context.resources;
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.padding(
          padding: const EdgeInsets.all(16.0),
          child: OsmeaComponents.textField(
            controller: viewModel.searchController,
            label: resources.search,
            prefixIcon: const Icon(Icons.search),
            onChanged: (query) {
              viewModel.search(query);
            },
            variant: TextFieldVariant.outlined,
            focusColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        OsmeaComponents.expanded(
          child: _buildBody(context, viewModel, state),
        ),
      ],
    );
  }

  Widget _buildBody(
      BuildContext context, SearchViewModel viewModel, SearchState state) {
    final resources = context.resources;
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
          child: OsmeaComponents.text(
              '${resources.noResultsFor} "${viewModel.searchController.text}"'), // Changed to English
        );
      } else if (state.searchResults.isEmpty &&
          viewModel.searchController.text.isEmpty) {
        return OsmeaComponents.center(
          child: OsmeaComponents.text(resources.startTyping), // Changed to English
        );
      }
      return ListView.builder(
        itemCount: state.searchResults.length,
        itemBuilder: (context, index) {
          final product = state.searchResults[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OsmeaComponents.listItem(
              leading: OsmeaComponents.image(
                imageUrl: product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorWidget: const Icon(Icons.error),
              ),
              title: OsmeaComponents.text(product.name),
              subtitle: BlocBuilder<CurrencyCubit, String>(
                builder: (context, currency) {
                  return OsmeaComponents.text(PriceHelper.format(product.price,
                      currency, Localizations.localeOf(context).toString()));
                },
              ),
              onTap: () {
                goRoute('/product-detail/${product.id}');
              },
            ),
          );
        },
      );
    }
    return const Center(
        child:
            CircularProgressIndicator()); // Should not happen in normal flow
  }
}