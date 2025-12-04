import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import 'states.dart';

@injectable
class FavoritesViewModel extends BaseViewModelCubit<FavoritesState> {
  FavoritesViewModel() : super(FavoritesInitialState());

  Future<void> initial() async {
    try {
      // Simulate fetching favorite items
      await Future.delayed(const Duration(milliseconds: 500));
      stateChanger(
        FavoritesLoadedState(
          favoriteItems: ['Item 1', 'Item 2', 'Item 3'],
        ),
      );
    } catch (e) {
      stateChanger(FavoritesErrorState('Failed to load favorites: $e'));
    }
  }
}
