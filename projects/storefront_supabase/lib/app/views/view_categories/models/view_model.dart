import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import 'states.dart';

@injectable
class CategoriesViewModel extends BaseViewModelCubit<CategoriesState> {
  CategoriesViewModel() : super(CategoriesInitialState());

  Future<void> initial() async {
    try {
      // Simulate fetching categories
      await Future.delayed(const Duration(milliseconds: 500));
      stateChanger(
        CategoriesLoadedState(
          categories: ['Electronics', 'Books', 'Fashion', 'Home & Garden'],
        ),
      );
    } catch (e) {
      stateChanger(CategoriesErrorState('Failed to load categories: $e'));
    }
  }
}
