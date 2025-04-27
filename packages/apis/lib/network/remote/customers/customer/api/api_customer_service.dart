import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/customers/customer/abstract/customer_service.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/create_customer_request.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/creates_account_activation_url_for_customer_request.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/sends_account_invite_to_customer_request.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/request/updates_customer_request.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/count_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/create_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/creates_account_activation_url_for_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/customer_match_supplied_query_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/retrieves_all_orders_belonging_to_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/retrieves_list_of_customers_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/retrieves_single_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/sends_account_invite_to_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/updates_customer_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_customer_service.g.dart';

@RestApi()
@Injectable(as: CustomerService)
abstract class CustomerServiceClient implements CustomerService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory CustomerServiceClient(Dio dio) => _CustomerServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔓 Get access scopes from API
  @override
  @GET('/api/{api_version}/customers.json')
  Future<RetrievesListOfCustomersResponse> RetrievesListOfCustomers({
    @Path('api_version') required String apiVersion,
    @Query('created_at_max') String? createdAtMax,
    @Query('created_at_min') String? createdAtMin,
    @Query('fields') String? fields,
    @Query('ids') String? ids,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('updated_at_min') String? updatedAtMin,
  });

  @override
  @GET('/api/{api_version}/customers/{customer_id}.json')
  Future<RetrievesSingleCustomerResponse> RetrievesSingleCustomer({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
  });

  @override
  @GET('/api/{api_version}/customers/{customer_id}/orders.json')
  Future<RetrievesAllOrdersBelongingToCustomerResponse> RetrievesAllOrdersBelongingToCustomer({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
  });

  @override
  @GET('/api/{api_version}/customers/count.json')
  Future<CountCustomerResponse> customerCounts({
    @Path('api_version') required String apiVersion,
  });

  @override
  @GET('/api/{api_version}/customers/search.json')
  Future<CustomerMatchSuppliedQueryResponse> customerMatchQuery({
    @Path('api_version') required String apiVersion,
  });

  @override
  @POST(
      '/api/{api_version}/customers.json')
  Future<CreateCustomerResponse> createCustomer({
    @Path('api_version') required String apiVersion,
    @Body() required CreateCustomerRequest model,
  });

  @override
  @POST(
      '/api/{api_version}/customers/{customer_id}/account_activation_url.json')
  Future<CreatesAccountActivationUrlForCustomerResponse>
      createsAccountActivationUrlForCustomer({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Body() required CreatesAccountActivationUrlForCustomerRequest model,
  });

  @override
  @POST(
      '/api/{api_version}/customers/{customer_id}/send_invite.json')
  Future<SendsAccountInviteToCustomerResponse> sendsAccountInviteToCustomer({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Body() required SendsAccountInviteToCustomerRequest model,
  });

  @override
  @PUT('/api/{api_version}/customers/{customer_id}.json')
  Future<UpdatesCustomerResponse> updatesCustomer({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
    @Body() required UpdatesCustomerRequest model,
  });

  @DELETE('/api/{api_version}/customers/{customer_id}.json')
  Future<void> deleteCustomer({
    @Path('api_version') required String apiVersion,
    @Path('customer_id') required String customerId,
  });
  
}
