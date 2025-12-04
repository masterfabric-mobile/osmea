/// Simple home states for Supabase storefront.
///
/// Kept intentionally minimal – the goal is just to demonstrate the
/// `BaseViewModelHydratedCubit` + `MasterViewHydratedCubit` flow using
/// core's base infrastructure.

abstract class SupabaseHomeState {}

class SupabaseHomeInitialState extends SupabaseHomeState {}

class SupabaseHomeLoadedState extends SupabaseHomeState {
  final String title;
  final String subtitle;

  SupabaseHomeLoadedState({
    required this.title,
    required this.subtitle,
  });
}

class SupabaseHomeErrorState extends SupabaseHomeState {
  final String message;

  SupabaseHomeErrorState(this.message);
}


