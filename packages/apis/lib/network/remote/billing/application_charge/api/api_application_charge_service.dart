import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/billing/application_charge/abstract/application_charge_service.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/response/get_all_application_charges_response.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/response/get_an_application_charge_response.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/response/create_application_charge_response.dart';
import 'package:apis/network/remote/billing/application_charge/freezed_model/request/create_application_charge_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_application_charge_service.g.dart';

/// 🌐 GetApplicationChargesServiceClient
/// Retrofit client for retrieving a list of application charges.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏬🔑
@RestApi()
@Injectable(as: GetApplicationChargesService)
abstract class GetApplicationChargesServiceClient implements GetApplicationChargesService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetApplicationChargesServiceClient(Dio dio) => _GetApplicationChargesServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📋 Get application charges from API
  @override
  @GET('/api/{api_version}/application_charges.json')
  Future<GetAllApplicationChargesResponse> getApplicationCharges({
    @Path('api_version') required String apiVersion,
    @Query('fields') String? fields,
    @Query('since_id') String? sinceId,
  });
}

/// 🌐 GetApplicationChargeServiceClient
/// Retrofit client for retrieving a single application charge.
@RestApi()
@Injectable(as: GetApplicationChargeService)
abstract class GetApplicationChargeServiceClient implements GetApplicationChargeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetApplicationChargeServiceClient(Dio dio) => _GetApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔍 Get a single application charge by ID
  @override
  @GET('/api/{api_version}/application_charges/{id}.json')
  Future<GetAnApplicationChargeResponse> getApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Path('id') required int id,
  });
}

/// 🌐 CreateApplicationChargeServiceClient
/// Retrofit client for creating a new application charge.
@RestApi()
@Injectable(as: CreateApplicationChargeService)
abstract class CreateApplicationChargeServiceClient implements CreateApplicationChargeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CreateApplicationChargeServiceClient(Dio dio) => _CreateApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 💵 Create a new application charge
  @override
  @POST('/api/{api_version}/application_charges.json')
  Future<CreateApplicationChargeResponse> createApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Body() required CreateApplicationChargeRequest request,
  });
}