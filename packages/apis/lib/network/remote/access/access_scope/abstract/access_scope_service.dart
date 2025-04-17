import 'package:apis/network/remote/access/access_scope/freezed_model/access_scope_response.dart';

/// 🔑 Abstract contract for Access Scope Service
/// Implement this to fetch access scopes from Shopify API! 🌐
abstract class AccessScopeService {
  /// 🚀 Fetches the access scope from the API.
  Future<AccessScopeResponse> accessScope();
}
