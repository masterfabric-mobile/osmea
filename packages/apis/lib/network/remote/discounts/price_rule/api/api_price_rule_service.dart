import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/discounts/price_rule/abstract/price_rule.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rule_discount_collection_request.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rule_discount_selected_customers_request.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/request/create_price_rules_request.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/create_price_rule_discount_collection_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/create_price_rule_discount_selected_customers_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_count_response.dart';
import 'package:apis/network/remote/discounts/price_rule/freezed_model/response/price_rule_list_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_price_rule_service.g.dart';

@RestApi()
@Injectable(as: PriceRuleService)
abstract class PriceRuleServiceClient implements PriceRuleService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory PriceRuleServiceClient(Dio dio) => _PriceRuleServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔓 Get price rules from API
  @override
  @POST('/api/{api_version}/price_rules.json')
  Future<PriceRuleResponse> createPriceRule({
    @Body() required CreatePriceRulesRequest model,
    @Path('api_version') required String apiVersion,
  });
  @override
  @POST('/api/{api_version}/price_rules.json')
  Future<CreatePriceRuleDiscountCollectionResponse>
      createPriceRuleDiscountCollection({
    @Path('api_version') required String apiVersion,
    @Body() required CreatePriceRuleDiscountCollectionRequest model,
  });

  @override
  @POST('/api/{api_version}/price_rules.json')
  Future<CreatePriceRuleDiscountSelectedCustomersResponse>
      createPriceRuleDiscountSelectedCustomers({
    @Path('api_version') required String apiVersion,
    @Body() required CreatePriceRuleDiscountSelectedCustomersRequest model,
  });

  @override
  @GET('/api/{api_version}/price_rules.json')
  Future<PriceRuleListResponse> getPriceRules({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
    @Query('updated_at_min') String? updatedAtMin,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('start_at_min') String? startAtMin,
    @Query('start_at_max') String? startAtMax,
    @Query('end_at_min') String? endAtMin,
    @Query('end_at_max') String? endAtMax,
    @Query('times_used') String? timesUsed,
  });
  @override
  @GET('/api/{api_version}/price_rules/{price_rule_id}.json')
  Future<PriceRuleResponse> singlePriceRule({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
  });

  @override
  @GET('/api/{api_version}/price_rules/count.json')
  Future<PriceRuleCountResponse> countOfPriceRules({
    @Path('api_version') required String apiVersion,
  });

  @override
  @PUT('/api/{api_version}/price_rules/{price_rule_id}.json')
  Future<PriceRuleResponse> updatePriceRule({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
    @Body() required PriceRuleResponse model,
  });

  @override
  @DELETE('/api/{api_version}/price_rules/{price_rule_id}.json')
  Future<void> deletePriceRule({
    @Path('api_version') required String apiVersion,
    @Path('price_rule_id') required String priceRuleId,
  });
}
