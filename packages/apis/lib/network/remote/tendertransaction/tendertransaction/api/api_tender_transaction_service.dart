import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/tendertransaction/tendertransaction/abstract/tender_transaction_service.dart';
import 'package:apis/network/remote/tendertransaction/tendertransaction/freezed_model/response/get_all_tender_transactions_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_tender_transaction_service.g.dart';

/// 🌐 GetTenderTransactionsServiceClient
/// Retrofit client for retrieving a list of tender transactions.
/// Make sure ApiNetwork.storeName and shopifyAccessToken are set before using! 🏬🔑
@RestApi()
@Injectable(as: GetTenderTransactionsService)
abstract class GetTenderTransactionsServiceClient implements GetTenderTransactionsService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory GetTenderTransactionsServiceClient(Dio dio) => _GetTenderTransactionsServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📋 Get tender transactions from API
  @override
  @GET('/api/{api_version}/tender_transactions.json')
  Future<GetAllTenderTransactionsResponse> getTenderTransactions({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('since_id') int? sinceId,
    @Query('processed_at') String? processedAt,
    @Query('processed_at_min') String? processedAtMin,
    @Query('processed_at_max') String? processedAtMax,
    @Query('order') String? order,
  });
}