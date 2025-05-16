import 'package:apis/network/remote/tendertransaction/tendertransaction/freezed_model/response/get_all_tender_transactions_response.dart';

/// 🔑 Abstract contract for getting Tender Transactions
/// Implement this to fetch tender transactions from Shopify API! 🌐
abstract class GetTenderTransactionsService {
  /// 📋 Gets all tender transactions
  Future<GetAllTenderTransactionsResponse> getTenderTransactions({
    required String apiVersion,
    int? limit,
    int? sinceId,
    String? processedAt,
    String? processedAtMin,
    String? processedAtMax,
    String? order,
  });
}