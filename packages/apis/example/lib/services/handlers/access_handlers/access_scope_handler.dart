import 'package:apis/network/remote/access/access_scope/abstract/access_scope_service.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';
import '../../api_request_handler.dart';

///*******************************************************************
///******************* 🔐 ACCESS SCOPE HANDLER 🔐 *******************
///*******************************************************************

class AccessScopeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method == 'GET') {
      final response = await GetIt.I.get<AccessScopeService>().accessScope();

      try {
        // 📊 Group scopes by subcategory
        final Map<String, List<Map<String, String>>> categorizedScopes = {};

        for (final scope in response.accessScopes) {
          // 🔍 Extract subcategory from handle (e.g., "read_products" -> "products")
          final handle = scope.handle;
          String subcategory = "other"; // Default category

          // 🧩 Try to extract category from handle
          if (handle.contains('_')) {
            final parts = handle.split('_');
            if (parts.length > 1) {
              // 📑 Use the second part as the subcategory (after "read_", "write_", etc.)
              subcategory = parts[1];
            }
          }

          // 🔤 Ensure subcategory name is capitalized
          subcategory = subcategory[0].toUpperCase() + subcategory.substring(1);

          // ➕ Add scope to appropriate subcategory
          if (!categorizedScopes.containsKey(subcategory)) {
            categorizedScopes[subcategory] = [];
          }

          categorizedScopes[subcategory]!.add({
            "handle": handle,
            "scope": scope.toString(),
            "permission": handle.split('_').first,
          });
        }

        // 🔄 Convert map to list format for the response
        final List<Map<String, dynamic>> categories =
            categorizedScopes.entries.map((entry) {
          return {
            "category": entry.key,
            "scopes": entry.value,
          };
        }).toList();

        return {
          "status": "success",
          "categories": categories,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // 🚨 Fallback to simpler format if extraction fails
        return {
          "status": "success",
          "data": response.toString(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    return {
      "error": "Method $method not supported for Access Scope API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {};
}
