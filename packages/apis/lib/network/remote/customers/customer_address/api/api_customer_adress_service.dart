import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/customers/customer_address/abstract/customer_adress_service.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/request/creates_new_address_for_customer_request.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/request/update_postal_code_of_customer_address_request.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/creates_new_address_for_customer_response.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/retrieves_details_for_single_customer_address_response.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/retrieves_list_of_addresses_for_customer_response.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/sets_default_address_for_customer_response.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/update_postal_code_of_customer_address_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_customer_adress_service.g.dart';

@RestApi()
@Injectable(as: CustomerAddressService)
abstract class CustomerAddressServiceClient implements CustomerAddressService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CustomerAddressServiceClient(Dio dio) =>
      _CustomerAddressServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @POST('/api/{api_version}/customers/{customer_id}/addresses.json')
  Future<CreatesNewAddressForCustomerResponse> createNewAddress({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Body() required CreatesNewAddressForCustomerRequest model,
  });

  @GET('/api/{api_version}/customers/{customer_id}/addresses.json')
  Future<RetrievesListOfAddressesForCustomerResponse> retrieveListOfAddresses({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Query('limit') int? limit,
  });

  @GET('/api/{api_version}/customers/{customer_id}/addresses/{address_id}.json')
  Future<RetrievesDetailsForSingleCustomerAddressResponse>
      retrieveListOfSingleAddresses({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Path('address_id') required String addressId,
  });

  @PUT('/api/{api_version}/customers/{customer_id}/addresses/{address_id}.json')
  Future<UpdatePostalCodeOfCustomerAddressResponse>
      updatePostalCodeOfCustomerAddress({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Path('address_id') required String addressId,
    @Body() required UpdatePostalCodeOfCustomerAddressRequest model,
  });

  @PUT('/api/{api_version}/customers/{customer_id}/addresses/{address_id}/default.json')
  Future<SetsDefaultAddressForCustomerResponse> setsDefaultAddressForCustomer({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Path('address_id') required String addressId,
  });

}
