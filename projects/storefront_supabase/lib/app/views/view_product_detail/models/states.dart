abstract class ProductDetailState {}

class ProductDetailInitialState extends ProductDetailState {}

class ProductDetailLoadedState extends ProductDetailState {
  final String productName;
  final String productDescription;

  ProductDetailLoadedState({
    required this.productName,
    required this.productDescription,
  });
}

class ProductDetailErrorState extends ProductDetailState {
  final String message;

  ProductDetailErrorState(this.message);
}
