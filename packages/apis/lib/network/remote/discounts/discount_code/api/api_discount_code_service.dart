import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/discounts/discount_code/abstract/discount_code.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/request/create_discount_code_creation_request.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/request/create_discount_code_request.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/request/update_discount_code_request.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_count_response.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_creation_response.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_list_creation_response.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_list_response.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_location_response.dart';
import 'package:apis/network/remote/discounts/discount_code/freezed_model/response/discount_code_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_discount_code_service.g.dart';

@RestApi()
@Injectable(as: DiscountCodeService)
abstract class DiscountServiceClient implements DiscountCodeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory DiscountServiceClient(Dio dio) => _DiscountServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @POST('/api/{api_version}/price_rules/{price_rule_id}/discount_codes.json')
  Future<DiscountCodeResponse> createDiscountCode({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
    @Body() required CreateDiscountCodeRequest model,
  });

  @override
  @POST('/api/{api_version}/price_rules/{price_rule_id}/batch.json')
  Future<DiscountCodeCreationResponse> createDiscountCodeCreation({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
    @Body() required CreateDiscountCodeCreationRequest model,
  });

  @override
  @GET(
      '/api/{api_version}/price_rules/{price_rule_id}/discount_codes/{discount_code_id}.json')
  Future<DiscountCodeResponse> getSingleDiscountCode({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
    @Path('discount_code_id') required String discountCodeId,
  });

  @override
  @GET('/api/{api_version}/price_rules/{price_rule_id}/batch/{batch_id}.json')
  Future<DiscountCodeCreationResponse> getDiscountCodeCreation({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
    @Path('batch_id') required String batchId,
  });

  /// 🚀 Gets a list of discount codes.
  @override
  @GET('/api/{api_version}/price_rules/{price_rule_id}/discount_codes.json')
  Future<DiscountCodeListResponse> getListDiscountCodes({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
  });

  /// 🚀 Gets a list of discount code creations.
  @override
  @GET(
      '/api/{api_version}/price_rules/{price_rule_id}/batch/{batch_id}/discount_codes.json')
  Future<DiscountCodeListCreationResponse> getListDiscountCodeCreations({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
    @Path('batch_id') required String batchId,
  });
  @override
  @GET('/api/{api_version}/discount_codes/lookup.json?code={code}')
  Future<DiscountCodeLocationResponse> getDiscountCodeLocation({
    @Path('api_version') required String apiVersion,
    @Query('code') required String code,
  });

  @override
  @GET('/api/{api_version}/discount_codes/count.json')
  Future<DiscountCodeCountResponse> getCountDiscountCodes({
    @Path('api_version') required String apiVersion,
    @Query('times_used') int? timesUsed,
    @Query('times_used_max') String? timesUsedMax,
    @Query('times_used_min') String? timesUsedMin,
  });

  @override
  @PUT(
      '/api/{api_version}/price_rules/{price_rule_id}/discount_codes/{discount_code_id}.json')
  Future<DiscountCodeResponse> updateDiscountCode({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
    @Path('discount_code_id') required String discountCodeId,
    @Body() required UpdateDiscountCodeRequest model,
  });

  @override
  @DELETE(
      '/api/{api_version}/price_rules/{price_rule_id}/discount_codes/{discount_code_id}.json')
  Future<void> deleteDiscountCode({
    @Path('api_version') required String apiVersion,
    @Path('discount_code_id') required String discountCodeId,
    @Path('price_rule_id') required String priceRuleId,
  });
}
