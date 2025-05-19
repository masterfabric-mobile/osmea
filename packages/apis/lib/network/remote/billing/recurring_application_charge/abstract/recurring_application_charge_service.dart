import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/response/get_all_recurring_application_charges_response.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/response/get_a_recurring_application_charge_response.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/customize_recurring_application_charge_request.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/create_basic_recurring_application_charge_request.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/create_trial_recurring_application_charge_request.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/create_capped_recurring_application_charge_request.dart';

/// 🔑 Abstract contract for getting all Recurring Application Charges
abstract class GetRecurringApplicationChargesService {
  Future<GetAllRecurringApplicationChargesResponse> getRecurringApplicationCharges({
    required String apiVersion,
    String? fields,
    String? sinceId,
  });
}

/// 🔑 Abstract contract for getting a single Recurring Application Charge
abstract class GetRecurringApplicationChargeService {
  Future<GetARecurringApplicationChargeResponse> getRecurringApplicationCharge({
    required String apiVersion,
    required int id,
    String? fields,
  });
}

/// 🔧 Abstract contract for customizing a Recurring Application Charge
abstract class CustomizeRecurringApplicationChargeService {
  Future<GetARecurringApplicationChargeResponse> customizeRecurringApplicationCharge({
    required String apiVersion,
    required int id,
    required CustomizeRecurringApplicationChargeRequest request,
  });
}

/// 🗑️ Abstract contract for deleting a Recurring Application Charge
abstract class DeleteRecurringApplicationChargeService {
  Future<void> deleteRecurringApplicationCharge({
    required String apiVersion,
    required int id,
  });
}

/// 🆕 Abstract contract for creating a basic Recurring Application Charge
abstract class CreateBasicRecurringApplicationChargeService {
  Future<GetARecurringApplicationChargeResponse> createBasicRecurringApplicationCharge({
    required String apiVersion,
    required CreateBasicRecurringApplicationChargeRequest request,
  });
}

/// 🆕 Abstract contract for creating a Recurring Application Charge with trial period
abstract class CreateTrialRecurringApplicationChargeService {
  Future<GetARecurringApplicationChargeResponse> createTrialRecurringApplicationCharge({
    required String apiVersion,
    required CreateTrialRecurringApplicationChargeRequest request,
  });
}

/// 🆕 Abstract contract for creating a Recurring Application Charge with terms and capped amount
abstract class CreateCappedRecurringApplicationChargeService {
  Future<GetARecurringApplicationChargeResponse> createCappedRecurringApplicationCharge({
    required String apiVersion,
    required CreateCappedRecurringApplicationChargeRequest request,
  });
}