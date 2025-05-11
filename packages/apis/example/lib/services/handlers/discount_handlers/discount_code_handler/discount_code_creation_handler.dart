import 'dart:convert';

import 'package:apis/apis.dart';
import 'package:apis/network/remote/discounts/discount_code/abstract/discount_code.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/request/create_discount_code_creation_request.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_creation_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class DiscountCodeCreationHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        try {
          final String priceRuleId = params['price_rule_id'] ?? '';
          final String batchId = params['batch_id'] ?? '';

          if (priceRuleId.isEmpty || batchId.isEmpty) {
            return {
              "status": "error",
              "message":
                  "Price Rule ID and Batch ID are required for getting discount code creation",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final DiscountCodeCreationResponse response =
              await GetIt.I.get<DiscountCodeService>().getDiscountCodeCreation(
                    apiVersion: ApiNetwork.apiVersion,
                    priceRuleId: priceRuleId,
                    batchId: batchId,
                  );

          return {
            "status": "success",
            "discount_code_creation": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to fetch discount code creation: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      case 'POST':
        final String priceRuleId = params['price_rule_id'] ?? '';
        final String? discountCodesJsonOrCsv = params['discount_codes_json'];

        if (priceRuleId.isEmpty ||
            discountCodesJsonOrCsv == null ||
            discountCodesJsonOrCsv.isEmpty) {
          return {
            "status": "error",
            "message":
                "Price Rule ID and Discount Codes list are required for batch creation",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          List<DiscountCode> discountCodeList;
          try {
            final List<dynamic> decodedList =
                json.decode(discountCodesJsonOrCsv);
            discountCodeList = decodedList
                .map((item) =>
                    DiscountCode.fromJson(item as Map<String, dynamic>))
                .toList();
          } catch (e) {
            final List<String> codes = discountCodesJsonOrCsv.split(',');
            discountCodeList =
                codes.map((code) => DiscountCode(code: code.trim())).toList();
          }

          final DiscountCodeCreationResponse response = await GetIt.I
              .get<DiscountCodeService>()
              .createDiscountCodeCreation(
                  apiVersion: ApiNetwork.apiVersion,
                  priceRuleId: priceRuleId,
                  model: CreateDiscountCodeCreationRequest(
                      discountCodes: discountCodeList));

          return {
            "status": "success",
            "message": "Discount code creation batch initiated successfully",
            "discount_code_creation": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to create multiple discount codes: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Discount Code API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET', 'POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'price_rule_id',
            label: 'Price Rule ID',
            hint: 'Enter the Price Rule ID',
          ),
          const ApiField(
            name: 'batch_id',
            label: 'Batch ID',
            hint:
                'Enter the Batch ID of the multiple creation operation you want to retrieve',
          ),
        ],
        'POST': [
          const ApiField(
            name: 'price_rule_id',
            label: 'Price Rule ID',
            hint: 'Enter the Price Rule ID',
          ),
          const ApiField(
            name: 'discount_codes_json',
            label: 'Discount Codes (JSON or CSV)',
            hint:
                'Enter a JSON array or comma-separated list of discount codes',
          ),
        ],
      };
}
