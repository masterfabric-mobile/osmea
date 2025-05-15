import 'package:apis/network/remote/billing/usage_charge/freezed_model/response/get_all_usage_charges_response.dart';
import 'package:apis/network/remote/billing/usage_charge/freezed_model/response/get_a_usage_charge_response.dart';
import 'package:apis/network/remote/billing/usage_charge/freezed_model/request/create_usage_charge_request.dart';

/// 🔑 Abstract contract for getting all Usage Charges
abstract class GetUsageChargesService {
  Future<GetAllUsageChargesResponse> getUsageCharges({
    required String apiVersion,
    required int recurringApplicationChargeId,
    String? fields,
  });
}

/// 🔑 Abstract contract for getting a single Usage Charge
abstract class GetUsageChargeService {
  Future<GetAUsageChargeResponse> getUsageCharge({
    required String apiVersion,
    required int recurringApplicationChargeId,
    required int id,
    String? fields,
  });
}

/// 🆕 Abstract contract for creating a Usage Charge
abstract class CreateUsageChargeService {
  Future<GetAUsageChargeResponse> createUsageCharge({
    required String apiVersion,
    required int recurringApplicationChargeId,
    required CreateUsageChargeRequest request,
  });
}