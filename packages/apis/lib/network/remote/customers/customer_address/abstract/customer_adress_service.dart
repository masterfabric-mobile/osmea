import 'package:apis/network/remote/customers/customer_address/freezed_model/request/creates_new_address_for_customer_request.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/creates_new_address_for_customer_response.dart';
import 'package:apis/network/remote/customers/customer_address/freezed_model/response/retrieves_list_of_addresses_for_customer_response.dart';

abstract class CustomerAddressService {
  /// 🚀 Fetches the access scope from the API.
  Future<CreatesNewAddressForCustomerResponse> createNewAddress({
    required String apiVersion,
    required String customerId,
    required CreatesNewAddressForCustomerRequest model,
  });

  Future<RetrievesListOfAddressesForCustomerResponse> retrieveListOfAddresses({
    required String apiVersion,
    required String customerId,
    int? limit,
  });
}
