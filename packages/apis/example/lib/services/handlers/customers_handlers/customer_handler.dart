import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/create_customer_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../api_service_registry.dart';

///*******************************************************************
///******************* 👥 CUSTOMER API HANDLER 👥 *******************
///*******************************************************************

class CustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        // 📌 Simple GET request without parameters
        try {
          // 📞 Call the customer service API - no parameters needed
          final response = await GetIt.I.get<CustomerService>().customer(
                apiVersion: ApiNetwork.apiVersion,
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
          final customerRequest = CreateCustomerRequest(
            customer: Customer(
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

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "error": "Method $method not supported for Customer API",
        };
    }
  }

  @override
  // 🔍 Support both GET and POST methods
  List<String> get supportedMethods => ['GET', 'POST'];

  @override
  // 📝 Define required fields for each method
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [], // Empty list as no fields are required for GET
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
