
import 'package:apis/network/remote/customers/customer/freezed_model/request/create_customer_request.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/count_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/create_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/customer_match_supplied_query_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/orders_belonging_to_customer_response.dart';
import 'package:apis/network/remote/customers/customer/freezed_model/response/single_customer_response.dart';

/// 🔑 Abstract contract for Access Scope Service
/// Implement this to fetch access scopes from Shopify API! 🌐
abstract class CustomerService {
  /// 🚀 Fetches the access scope from the API.
  Future<CustomerResponse> customer({
    required String apiVersion,
  });

  /// 🚀 Fetches a single customer from the API.
  Future<SingleCustomerResponse> singleCustomer({
    required String apiVersion,
    required String customerId,
  });

  /// 🚀 Fetches the orders of a single customer from the API.
  Future<OrdersBelongingToCustomerResponse> customerOrders({
    required String apiVersion,
    required String customerId,
  });

  Future<CountCustomerResponse> customerCounts({
    required String apiVersion,
  });

  Future<CustomerMatchSuppliedQueryResponse> customerMatchQuery({
    required String apiVersion,
  });

  /// 🚀 Creates a new customer in the API.
  Future<CreateCustomerResponse> createCustomer({
    required String apiVersion,
    required CreateCustomerRequest model,
  });
}
