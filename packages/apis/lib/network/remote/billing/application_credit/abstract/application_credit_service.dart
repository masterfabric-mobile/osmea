import 'package:apis/network/remote/billing/application_credit/freezed_model/response/get_all_application_credits_response.dart';
import 'package:apis/network/remote/billing/application_credit/freezed_model/response/get_an_application_credit_response.dart';

/// 🔑 Abstract contract for getting all Application Credits
/// Implement this to fetch all application credits from Shopify API! 🌐
abstract class GetApplicationCreditsService {
  /// 📋 Gets all application credits
  Future<GetAllApplicationCreditsResponse> getApplicationCredits({
    required String apiVersion,
    String? fields,     // Comma-separated list of fields to include in the response
  });
}

/// 🔑 Abstract contract for getting a single Application Credit
/// Implement this to fetch a single application credit from Shopify API! 🌐
abstract class GetApplicationCreditService {
  /// 🔍 Gets a single application credit by ID
  Future<GetAnApplicationCreditResponse> getApplicationCredit({
    required String apiVersion,
    required int id,
    String? fields,     // Added fields parameter
  });
}