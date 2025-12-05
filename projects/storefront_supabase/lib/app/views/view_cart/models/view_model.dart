import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'states.dart';

@injectable
class CartViewModel extends BaseViewModelCubit<CartState> {
  CartViewModel() : super(CartInitialState());
  Future<void> initial() async {
    stateChanger(CartLoadedState());
  }
}
