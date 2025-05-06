import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rule_discount_collection_request.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rule_discount_selected_customers_request.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rule_free_shipping_request.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rules_request.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/create_price_rule_discount_collection_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/create_price_rule_discount_selected_customers_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/create_price_rule_free_shipping_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_count_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_list_response.dart';

abstract class PriceRuleService {
  Future<PriceRuleResponse> createPriceRule({
    required String apiVersion,
    required CreatePriceRulesRequest model,
  });

  Future<CreatePriceRuleDiscountCollectionResponse>
      createPriceRuleDiscountCollection({
    required String apiVersion,
    required CreatePriceRuleDiscountCollectionRequest model,
  });

  Future<CreatePriceRuleDiscountSelectedCustomersResponse>
      createPriceRuleDiscountSelectedCustomers({
    required String apiVersion,
    required CreatePriceRuleDiscountSelectedCustomersRequest model,
  });

  Future<CreatePriceRuleFreeShippingResponse> createPriceRuleFreeShipping({
    required String apiVersion,
    required CreatePriceRuleFreeShippingRequest model,
  });

  /// 🚀 Gets a list of price rules.
  Future<PriceRuleListResponse> getPriceRules({
    required String apiVersion,
    int? limit,
    String? sinceId,
    String? createdAtMin,
    String? createdAtMax,
    String? updatedAtMin,
    String? updatedAtMax,
    String? startAtMin,
    String? startAtMax,
    String? endAtMin,
    String? endAtMax,
    String? timesUsed,
  });

  /// 🚀 Gets a single price rule.
  Future<PriceRuleResponse> singlePriceRule({
    required String apiVersion,
    required String priceRuleId,
  });

  /// 🚀 Updates a price rule.
  Future<PriceRuleResponse> updatePriceRule({
    required String apiVersion,
    required String priceRuleId,
    required PriceRuleResponse model,
  });

  /// 🚀 Gets the count of price rules.
  Future<PriceRuleCountResponse> countOfPriceRules({
    required String apiVersion,
  });

  /// 🚀 Deletes a price rule.
  Future<void> deletePriceRule({
    required String apiVersion,
    required String priceRuleId,
  });
}
