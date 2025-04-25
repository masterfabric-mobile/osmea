import 'package:example/services/api_request_handler.dart';

// 📁 Import handlers from their new locations
import 'handlers/access_handlers/access_scope_handler.dart';
import 'handlers/access_handlers/storefront_access_token_handler.dart';
import 'handlers/customers_handlers/customer/customer_handler.dart'; // Import customer handler
import 'handlers/customers_handlers/customer/sigle_customer_handler.dart'; // Import the new handler
import 'handlers/customers_handlers/customer/orders_belonging_to_customer_handler.dart'; // Added import
import 'handlers/customers_handlers/customer/customer_match_query.dart'; // Import customer match query handler

// ♻️ Re-export types for backward compatibility
export 'handlers/access_handlers/access_scope_handler.dart';
export 'handlers/access_handlers/storefront_access_token_handler.dart';

///**************************************************************
///****************** 🏭 API HANDLER FACTORY 🏭 *****************
///**************************************************************
/// Factory for creating API handler instances
/// Register new handlers in the _handlers map
///**************************************************************

class ApiHandlerFactory {
  static final Map<String, ApiRequestHandler> _handlers = {
    'Access Scope': AccessScopeHandler(),
    'Storefront Access Token': StorefrontAccessTokenHandler(),
    'Customer List': CustomerHandler(),
    'Single Customer': SingleCustomerHandler(), // Add the new handler
    'Customers': CustomerHandler(),
    'Customer Orders': OrdersBelongingToCustomerHandler(), // Added handler
    'Customer Search': CustomerMatchQueryHandler(), // Added handler
    // ➕ Add more handlers here
  };

  static ApiRequestHandler? getHandler(String serviceName) {
    return _handlers[serviceName];
  }

  static List<String> get availableServices => _handlers.keys.toList();
}
