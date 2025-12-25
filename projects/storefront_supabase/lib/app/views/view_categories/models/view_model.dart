import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'states.dart';

@injectable
class CategoriesViewModel extends BaseViewModelCubit<CategoriesState> {
  final SupabaseClient _supabaseClient;

  CategoriesViewModel(this._supabaseClient) : super(CategoriesInitialState());

  Future<void> initial() async {
    stateChanger(CategoriesLoadingState());
    try {
      final response = await _supabaseClient.from('categories').select();
      final categories = (response as List)
          .map((data) => Category.fromJson(data as Map<String, dynamic>))
          .toList();
      
      final rootCategories = categories.where((c) => c.parentId == null).toList();
      
      stateChanger(CategoriesLoadedState(
        categories: categories,
        rootCategories: rootCategories,
      ));
    } catch (e) {
      stateChanger(CategoriesErrorState('Failed to load categories: $e'));
    }
  }
}
