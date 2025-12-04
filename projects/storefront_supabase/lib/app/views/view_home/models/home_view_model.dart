import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import 'states.dart';

/// Minimal Home ViewModel for Supabase storefront.
///
/// Uses `BaseViewModelCubit` from core so it fits perfectly into
/// `MasterViewCubit`-based views without hydration.
@injectable
class SupabaseHomeViewModel extends BaseViewModelCubit<SupabaseHomeState> {
  SupabaseHomeViewModel() : super(SupabaseHomeInitialState());

  /// Simple initial bootstrap – in a real app this is where you'd
  /// fetch featured products, categories, etc.
  Future<void> initial() async {
    try {
      // In the future this can be driven from remote config / Supabase.
      stateChanger(
        SupabaseHomeLoadedState(
          title: 'Welcome to Storefront Supabase',
          subtitle: 'Your Supabase powered store',
        ),
      );
    } catch (e) {
      stateChanger(SupabaseHomeErrorState('Failed to load home: $e'));
    }
  }

  // No hydration needed for plain BaseCubit usage.
}
