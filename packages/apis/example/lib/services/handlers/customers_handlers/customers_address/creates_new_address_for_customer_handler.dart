import 'package:apis/apis.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/request/creates_new_address_for_customer_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///*******************************************************************
///*************** 📍 CUSTOMER ADDRESS CREATOR HANDLER 📍 *************
///*******************************************************************

class CreateNewAddressForCustomerHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        // ✅ Create a new address for a customer
        try {
          // 🔍 Validate required parameters
          final customerId = params['customer_id'] ?? '';
          if (customerId.isEmpty) {
            return {
              "status": "error",
              "message": "Customer ID is required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // 📋 Extract address fields
          final address1 = params['address1'] ?? '';
          final address2 = params['address2'];
          final city = params['city'] ?? '';
          final company = params['company'];
          final countryCode = params['country_code'] ?? '';
          final provinceCode = params['province_code'];
          final zip = params['zip'] ?? '';
          final firstName = params['first_name'] ?? '';
          final lastName = params['last_name'] ?? '';
          final phone = params['phone'];
          
          // ⚠️ Validate essential address fields
          if (address1.isEmpty ||
              city.isEmpty ||
              countryCode.isEmpty ||
              zip.isEmpty) {
            return {
              "status": "error",
              "message":
                  "Address, city, country code and ZIP/postal code are required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // 📞 Call the API to create the address
          final response =
              await GetIt.I.get<CustomerAddressService>().createNewAddress(
                apiVersion: ApiNetwork.apiVersion,
                customerId: customerId,
                model: CreatesNewAddressForCustomerRequest(
                  address: Address(
                    address1: address1,
                    address2: address2,
                    city: city,
                    company: company,
                    countryCode: countryCode,
                    provinceCode: provinceCode,
                    zip: zip,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone,
                  ),
                ),
              );

          // 🎉 Return successful response
          return {
            "status": "success",
            "message": "Address created successfully",
            "address": response.customerAddress?.toJson(),
            "customerId": customerId,
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
            "message": "Failed to create address: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        // ⚠️ Return error for unsupported methods
        return {
          "error":
              "Method $method not supported for Customer Address API. Only POST is allowed.",
        };
    }
  }

  @override
  // 🔍 Only POST method is supported for address creation
  List<String> get supportedMethods => ['POST'];

  @override
  // 📝 Define required fields for creating an address
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'ID of the customer to create address for',
          ),
          const ApiField(
            name: 'address1',
            label: 'Address Line 1',
            hint: 'Primary address line',
          ),
          const ApiField(
            name: 'address2',
            label: 'Address Line 2',
            hint: 'Apartment, suite, etc. (optional)',
          ),
          const ApiField(
            name: 'city',
            label: 'City',
            hint: 'City name',
          ),
          const ApiField(
            name: 'company',
            label: 'Company',
            hint: 'Company name (optional)',
          ),
          const ApiField(
            name: 'country_code',
            label: 'Country Code',
            hint: 'Two-letter country code (e.g., US, UK)',
          ),
          const ApiField(
            name: 'province_code',
            label: 'Province/State Code',
            hint: 'Province or state code (optional)',
          ),
          const ApiField(
            name: 'zip',
            label: 'ZIP/Postal Code',
            hint: 'ZIP or postal code',
          ),
          const ApiField(
            name: 'first_name',
            label: 'First Name',
            hint: 'First name for this address',
          ),
          const ApiField(
            name: 'last_name',
            label: 'Last Name',
            hint: 'Last name for this address',
          ),
          const ApiField(
            name: 'phone',
            label: 'Phone',
            hint: 'Phone number for this address (optional)',
          ),
          const ApiField(
            name: 'default',
            label: 'Default Address',
            hint: 'Set as default address (true/false)',
          ),
        ],
      };
}
