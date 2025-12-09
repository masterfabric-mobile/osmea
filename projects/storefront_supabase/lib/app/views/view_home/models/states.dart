import 'package:storefront_supabase/app/models/product.dart';

abstract class SupabaseHomeState {}

class SupabaseHomeInitialState extends SupabaseHomeState {}

class SupabaseHomeLoadingState extends SupabaseHomeState {}

class SupabaseHomeLoadedState extends SupabaseHomeState {
  final List<Product> products;

  SupabaseHomeLoadedState({
    required this.products,
  });
}

class SupabaseHomeErrorState extends SupabaseHomeState {
  final String message;

  SupabaseHomeErrorState(this.message);
}


