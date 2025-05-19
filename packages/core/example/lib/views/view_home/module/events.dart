abstract class HomeViewEvent {}

class HomeViewInitialEvent extends HomeViewEvent {}

class HomeViewLoadProductsEvent extends HomeViewEvent {}

class HomeViewAddProductEvent extends HomeViewEvent {
  final String name;
  final double price;
  final String description;

  HomeViewAddProductEvent({
    required this.name,
    required this.price,
    required this.description,
  });
}

class HomeViewDeleteProductEvent extends HomeViewEvent {
  final String productId;

  HomeViewDeleteProductEvent({required this.productId});
}