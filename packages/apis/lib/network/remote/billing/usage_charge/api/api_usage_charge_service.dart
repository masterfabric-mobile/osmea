import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/billing/usage_charge/abstract/usage_charge_service.dart';
import 'package:apis/network/remote/billing/usage_charge/freezed_model/response/get_all_usage_charges_response.dart';
import 'package:apis/network/remote/billing/usage_charge/freezed_model/response/get_a_usage_charge_response.dart';
import 'package:apis/network/remote/billing/usage_charge/freezed_model/request/create_usage_charge_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_usage_charge_service.g.dart';

/// 🌐 GetUsageChargesServiceClient
/// Retrofit client for retrieving a list of usage charges.
@RestApi()
@Injectable(as: GetUsageChargesService)
abstract class GetUsageChargesServiceClient implements GetUsageChargesService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetUsageChargesServiceClient(Dio dio) => _GetUsageChargesServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📋 Get usage charges from API
  @override
  @GET('/api/{api_version}/recurring_application_charges/{recurring_application_charge_id}/usage_charges.json')
  Future<GetAllUsageChargesResponse> getUsageCharges({
    @Path('api_version') required String apiVersion,
    @Path('recurring_application_charge_id') required int recurringApplicationChargeId,
    @Query('fields') String? fields,
  });
}

/// 🌐 GetUsageChargeServiceClient
/// Retrofit client for retrieving a single usage charge.
@RestApi()
@Injectable(as: GetUsageChargeService)
abstract class GetUsageChargeServiceClient implements GetUsageChargeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetUsageChargeServiceClient(Dio dio) => _GetUsageChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔍 Get a single usage charge by ID
  @override
  @GET('/api/{api_version}/recurring_application_charges/{recurring_application_charge_id}/usage_charges/{id}.json')
  Future<GetAUsageChargeResponse> getUsageCharge({
    @Path('api_version') required String apiVersion,
    @Path('recurring_application_charge_id') required int recurringApplicationChargeId,
    @Path('id') required int id,
    @Query('fields') String? fields,
  });
}

/// 🌐 CreateUsageChargeServiceClient
/// Retrofit client for creating a usage charge.
@RestApi()
@Injectable(as: CreateUsageChargeService)
abstract class CreateUsageChargeServiceClient implements CreateUsageChargeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CreateUsageChargeServiceClient(Dio dio) => _CreateUsageChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🆕 Create a new usage charge
  @override
  @POST('/api/{api_version}/recurring_application_charges/{recurring_application_charge_id}/usage_charges.json')
  Future<GetAUsageChargeResponse> createUsageCharge({
    @Path('api_version') required String apiVersion,
    @Path('recurring_application_charge_id') required int recurringApplicationChargeId,
    @Body() required CreateUsageChargeRequest request,
  });
}