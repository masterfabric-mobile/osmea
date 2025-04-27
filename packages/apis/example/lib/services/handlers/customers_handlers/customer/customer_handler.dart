import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/create_customer_request.dart'
    as create;
import 'package:apis/network/remote/customers/customer/freezed_model/request/updates_customer_request.dart'
    as update;
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///******************* 👥 CUSTOMER API HANDLER 👥 *******************
///*******************************************************************

class CustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        // 📌 GET request with optional query parameters
        try {
          // Extract query parameters

          // 📞 Call the customer service API with extended query parameters support
          final response = await GetIt.I.get<CustomerService>().RetrievesListOfCustomers(
                apiVersion: ApiNetwork.apiVersion,
                sinceId: params['since_id'],
                createdAtMin: params['created_at_min'],
                createdAtMax: params['created_at_max'],
                updatedAtMin: params['updated_at_min'],
                updatedAtMax: params['updated_at_max'],
                limit: int.tryParse(params['limit'] ?? ''),
                fields: params['fields'],
                ids: params['ids'],
              );

          // 📊 Organize customers by creation date
          try {
            final Map<String, List<dynamic>> customersByDate = {};
            final customers = response.customers;

            // 🧮 Process each customer in the response
            for (final customer in customers!) {
              // 🗓️ Use creation date as category, default to "Other" if not available
              String category = "Other";
              final date = DateTime.tryParse(customer.createdAt as String);
              if (date != null) {
                category = "${_getMonthName(date.month)} ${date.year}";
              }

              // ➕ Add customer to category
              if (!customersByDate.containsKey(category)) {
                customersByDate[category] = [];
              }
              customersByDate[category]!.add(customer.toJson());
            }

            // 🔄 Convert to categories list
            final List<Map<String, dynamic>> categories =
                customersByDate.entries.map((entry) {
              return {
                "category": entry.key,
                "customers": entry.value,
              };
            }).toList();

            return {
              "status": "success",
              "categories": categories,
              "timestamp": DateTime.now().toIso8601String(),
            };
          } catch (e) {
            // 🚨 Fall back to simpler format if categorization fails
            return {
              "status": "success",
              "customers": response.customers?.map((c) => c.toJson()).toList(),
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
        } catch (e) {
          // ❌ Error handling
          return {
            "status": "error",
            "message": "Failed to fetch customers: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'POST':
        // 📤 Create a new customer
        try {
          // 📝 Extract required fields from params
          final email = params['email'] ?? '';
          final firstName = params['first_name'] ?? '';
          final lastName = params['last_name'] ?? '';
          final phone = params['phone']; // Optional

          // ⚠️ Validate required fields
          if (email.isEmpty) {
            return {
              "status": "error",
              "message": "Email is required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // 🔧 Prepare request model
          final customerRequest = create.CreateCustomerRequest(
            customer: create.Customer(
              email: email,
              firstName: firstName,
              lastName: lastName,
              phone: phone,
              verifiedEmail: false,
              // You can add more fields as needed
            ),
          );

          // 📞 Call the API to create customer
          final response = await GetIt.I.get<CustomerService>().createCustomer(
                apiVersion: ApiNetwork.apiVersion,
                model: customerRequest,
              );

          // 🎉 Return successful response
          return {
            "status": "success",
            "message": "Customer created successfully",
            "customer": response.customer?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // ❌ Handle authentication errors specially
          if (e.toString().contains('session has expired') ||
              e.toString().contains('login?errorHint=no_identity_session')) {
            return {
              "status": "auth_error",
              "message":
                  "Your authentication session has expired. Please log in again to continue.",
              "details":
                  "This occurs when your admin authentication token is no longer valid.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // ❌ Handle other errors
          return {
            "status": "error",
            "message": "Failed to create customer: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'PUT':
        // 🔍 Check if customer ID is provided - required parameter
        final customerId = params['customer_id'] ?? '';
        if (customerId.isEmpty) {
          return {
            "status": "error",
            "message": "Customer ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // Extract metadata parameters
        final metafieldKey = params['metafield_key'];
        final metafieldValue = params['metafield_value'];
        if (metafieldKey == null ||
            metafieldValue == null ||
            metafieldValue.trim().isEmpty) {
          return {
            "status": "error",
            "message": "Metafield key and non-empty value are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        // 🔄 Create request model for customer update focusing on metadata
        final request = update.UpdatesCustomerRequest(
          customer: update.Customer(
            id: int.tryParse(customerId),
            metafields: [
              update.Metafield(
                key: metafieldKey,
                value: metafieldValue,
                type: params['metafield_type'] ?? 'single_line_text_field',
                namespace: params['namespace'] ?? 'global',
              ),
            ],
          ),
        );

        // 📞 Call the customer service API to update customer
        final updatedCustomer =
            await GetIt.I.get<CustomerService>().updatesCustomer(
                  apiVersion: ApiNetwork.apiVersion,
                  customerId: customerId,
                  model: request,
                );

        // 📋 Return the updated customer data
        return {
          "status": "success",
          "message": "Customer updated successfully",
          "customerId": customerId,
          "customer": updatedCustomer.toJson(),
          "timestamp": DateTime.now().toIso8601String(),
        };

      case 'DELETE':
        // 🗑️ Delete a customer
        try {
          // Check if customer ID is provided - required parameter
          final customerId = params['customer_id'] ?? '';
          if (customerId.isEmpty) {
            return {
              "status": "error",
              "message": "Customer ID is required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // Call the customer service API to delete customer
          await GetIt.I.get<CustomerService>().deleteCustomer(
                apiVersion: ApiNetwork.apiVersion,
                customerId: customerId,
              );

          // Return success response
          return {
            "status": "success",
            "message": "Customer deleted successfully",
            "deletedCustomerId": customerId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // Handle authentication errors specially
          if (e.toString().contains('session has expired') ||
              e.toString().contains('login?errorHint=no_identity_session')) {
            return {
              "status": "auth_error",
              "message":
                  "Your authentication session has expired. Please log in again to continue.",
              "details":
                  "This occurs when your admin authentication token is no longer valid.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // Handle other errors
          return {
            "status": "error",
            "message": "Failed to delete customer: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "error": "Method $method not supported for Customer API",
        };
    }
  }

  @override
  // 🔍 Support GET, POST, PUT, and DELETE methods
  List<String> get supportedMethods => ['GET', 'POST', 'PUT', 'DELETE'];

  @override
  // 📝 Define required fields for each method
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Show customers created after this ID',
          ),
          const ApiField(
            name: 'created_at_min',
            label: 'Created After',
            hint: 'Show customers created after this date (ISO format)',
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created Before',
            hint: 'Show customers created before this date (ISO format)',
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated After',
            hint: 'Show customers updated after this date (ISO format)',
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated Before',
            hint: 'Show customers updated before this date (ISO format)',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Maximum number of customers to return',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
          ),
          const ApiField(
            name: 'ids',
            label: 'IDs',
            hint: 'Comma-separated list of customer IDs to retrieve',
          ),
        ],
        'POST': [
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'Customer email address',
          ),
          const ApiField(
            name: 'first_name',
            label: 'First Name',
            hint: 'Customer first name',
          ),
          const ApiField(
            name: 'last_name',
            label: 'Last Name',
            hint: 'Customer last name',
          ),
          const ApiField(
            name: 'phone',
            label: 'Phone Number',
            hint: 'Customer phone number (optional)',
          ),
          const ApiField(
            name: 'accepts_marketing',
            label: 'Accepts Marketing',
            hint: 'Whether customer accepts marketing emails (true/false)',
          ),
        ],
        'PUT': [
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'Enter customer ID to update',
          ),
          const ApiField(
            name: 'metafield_key',
            label: 'Metafield Key',
            hint: 'Key for the metafield',
          ),
          const ApiField(
            name: 'metafield_value',
            label: 'Metafield Value',
            hint: 'Value for the metafield',
          ),
          const ApiField(
            name: 'metafield_type',
            label: 'Metafield Type',
            hint: 'Type for the metafield (default: single_line_text_field)',
          ),
          const ApiField(
            name: 'namespace',
            label: 'Namespace',
            hint: 'Namespace for the metafield (default: global)',
          ),
        ],
        'DELETE': [
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'Enter customer ID to delete',
          ),
        ],
      };

  // 📅 Helper method to convert month number to name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
