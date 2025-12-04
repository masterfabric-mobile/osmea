import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import 'states.dart';

@injectable
class ProductDetailViewModel extends BaseViewModelCubit<ProductDetailState> {
  ProductDetailViewModel() : super(ProductDetailInitialState());

  Future<void> initial({String? productId}) async {
    try {
      // Simulate fetching product details
      await Future.delayed(const Duration(milliseconds: 500));
      if (productId == null) {
        stateChanger(ProductDetailErrorState('Product ID is missing.'));
        return;
      }
      stateChanger(
        ProductDetailLoadedState(
          productName: 'Sample Product $productId',
          productDescription: 'This is a detailed description for product $productId.',
        ),
      );
    } catch (e) {
      stateChanger(ProductDetailErrorState('Failed to load product details: $e'));
    }
  }
}
