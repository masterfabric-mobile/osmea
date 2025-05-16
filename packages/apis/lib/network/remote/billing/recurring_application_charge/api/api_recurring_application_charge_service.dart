import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/abstract/recurring_application_charge_service.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/response/get_all_recurring_application_charges_response.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/response/get_a_recurring_application_charge_response.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/customize_recurring_application_charge_request.dart';  // Add this import
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/create_basic_recurring_application_charge_request.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/create_trial_recurring_application_charge_request.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/freezed_model/request/create_capped_recurring_application_charge_request.dart';


part 'api_recurring_application_charge_service.g.dart';

/// 🌐 GetRecurringApplicationChargesServiceClient
/// Retrofit client for retrieving a list of recurring application charges.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏬🔑
@RestApi()
@Injectable(as: GetRecurringApplicationChargesService)
abstract class GetRecurringApplicationChargesServiceClient implements GetRecurringApplicationChargesService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetRecurringApplicationChargesServiceClient(Dio dio) => _GetRecurringApplicationChargesServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📋 Get recurring application charges from API
  @override
  @GET('/api/{api_version}/recurring_application_charges.json')
  Future<GetAllRecurringApplicationChargesResponse> getRecurringApplicationCharges({
    @Path('api_version') required String apiVersion,
    @Query('fields') String? fields,
    @Query('since_id') String? sinceId,
  });
}

/// 🌐 GetRecurringApplicationChargeServiceClient
/// Retrofit client for retrieving a single recurring application charge.
@RestApi()
@Injectable(as: GetRecurringApplicationChargeService)
abstract class GetRecurringApplicationChargeServiceClient implements GetRecurringApplicationChargeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetRecurringApplicationChargeServiceClient(Dio dio) => _GetRecurringApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔍 Get a single recurring application charge by ID
  @override
  @GET('/api/{api_version}/recurring_application_charges/{id}.json')
  Future<GetARecurringApplicationChargeResponse> getRecurringApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Path('id') required int id,
    @Query('fields') String? fields,
  });
}

/// 🌐 CustomizeRecurringApplicationChargeServiceClient
/// Retrofit client for updating a recurring application charge capped amount.
@RestApi()
@Injectable(as: CustomizeRecurringApplicationChargeService)
abstract class CustomizeRecurringApplicationChargeServiceClient implements CustomizeRecurringApplicationChargeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CustomizeRecurringApplicationChargeServiceClient(Dio dio) => _CustomizeRecurringApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔧 Customize a recurring application charge (update capped_amount)
  @override
  @PUT('/api/{api_version}/recurring_application_charges/{id}/customize.json')
  Future<GetARecurringApplicationChargeResponse> customizeRecurringApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Path('id') required int id,
    @Body() required CustomizeRecurringApplicationChargeRequest request,
  });
}

/// 🌐 DeleteRecurringApplicationChargeServiceClient
/// Retrofit client for deleting a recurring application charge.
@RestApi()
@Injectable(as: DeleteRecurringApplicationChargeService)
abstract class DeleteRecurringApplicationChargeServiceClient implements DeleteRecurringApplicationChargeService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory DeleteRecurringApplicationChargeServiceClient(Dio dio) => _DeleteRecurringApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🗑️ Delete a recurring application charge by ID
  @override
  @DELETE('/api/{api_version}/recurring_application_charges/{id}.json')
  Future<void> deleteRecurringApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Path('id') required int id,
  });
}

/// 🌐 CreateBasicRecurringApplicationChargeServiceClient
@RestApi()
@Injectable(as: CreateBasicRecurringApplicationChargeService)
abstract class CreateBasicRecurringApplicationChargeServiceClient implements CreateBasicRecurringApplicationChargeService {
  @factoryMethod
  factory CreateBasicRecurringApplicationChargeServiceClient(Dio dio) => _CreateBasicRecurringApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @POST('/api/{api_version}/recurring_application_charges.json')
  Future<GetARecurringApplicationChargeResponse> createBasicRecurringApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Body() required CreateBasicRecurringApplicationChargeRequest request,
  });
}

/// 🌐 CreateTrialRecurringApplicationChargeServiceClient
@RestApi()
@Injectable(as: CreateTrialRecurringApplicationChargeService)
abstract class CreateTrialRecurringApplicationChargeServiceClient implements CreateTrialRecurringApplicationChargeService {
  @factoryMethod
  factory CreateTrialRecurringApplicationChargeServiceClient(Dio dio) => _CreateTrialRecurringApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @POST('/api/{api_version}/recurring_application_charges.json')
  Future<GetARecurringApplicationChargeResponse> createTrialRecurringApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Body() required CreateTrialRecurringApplicationChargeRequest request,
  });
}

/// 🌐 CreateCappedRecurringApplicationChargeServiceClient
@RestApi()
@Injectable(as: CreateCappedRecurringApplicationChargeService)
abstract class CreateCappedRecurringApplicationChargeServiceClient implements CreateCappedRecurringApplicationChargeService {
  @factoryMethod
  factory CreateCappedRecurringApplicationChargeServiceClient(Dio dio) => _CreateCappedRecurringApplicationChargeServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @POST('/api/{api_version}/recurring_application_charges.json')
  Future<GetARecurringApplicationChargeResponse> createCappedRecurringApplicationCharge({
    @Path('api_version') required String apiVersion,
    @Body() required CreateCappedRecurringApplicationChargeRequest request,
  });
}