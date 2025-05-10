import 'package:apis/network/remote/billing/application_charge/freezed_model/response/get_all_application_charges_response.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/response/get_an_application_charge_response.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/response/create_application_charge_response.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/request/create_application_charge_request.dart';

/// 🔑 Abstract contract for getting all Application Charges
/// Implement this to fetch all application charges from Shopify API! 🌐
abstract class GetApplicationChargesService {
  /// 📋 Gets all application charges
  Future<GetAllApplicationChargesResponse> getApplicationCharges({
    required String apiVersion,
    String? fields,     // Comma-separated list of fields to include in the response
    String? sinceId,    // Only return charges after this ID (for pagination)
  });
}

/// 🔑 Abstract contract for getting a single Application Charge
/// Implement this to fetch a single application charge from Shopify API! 🌐
abstract class GetApplicationChargeService {
  /// 🔍 Gets a single application charge by ID
  Future<GetAnApplicationChargeResponse> getApplicationCharge({
    required String apiVersion,
    required int id,
  });
}

/// 🔑 Abstract contract for creating an Application Charge
/// Implement this to create a new application charge via Shopify API! 🌐
abstract class CreateApplicationChargeService {
  /// 💵 Creates a new application charge
  Future<CreateApplicationChargeResponse> createApplicationCharge({
    required String apiVersion,
    required CreateApplicationChargeRequest request,
  });
}