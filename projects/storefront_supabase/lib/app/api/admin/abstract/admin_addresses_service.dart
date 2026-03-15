import 'package:storefront_supabase/app/models/user_address.dart';

/// Admin user addresses API contract.
abstract class AdminAddressesService {
  /// List addresses (optionally filter by user).
  Future<List<UserAddress>> listAddresses({
    int? limit,
    int? offset,
    String? userId,
  });
}
