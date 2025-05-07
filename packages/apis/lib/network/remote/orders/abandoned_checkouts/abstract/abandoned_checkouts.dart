import 'package:apis/network/remote/orders/abandoned_checkouts/freezed_model/response/abandoned_checkouts_count_response.dart';
import 'package:apis/network/remote/orders/abandoned_checkouts/freezed_model/response/abandoned_checkouts_list_response.dart';

abstract class AbandonedCheckoutsService {
  Future<AbandonedCheckoutsCountResponse> getAbandonedCheckoutsCount({
    required String apiVersion,
    String? sinceId,
    String? createdAtMin,
    String? createdAtMax,
    String? updatedAtMin,
    String? updatedAtMax,
    String? status,
  });

  Future<AbandonedCheckoutsListResponse> getAbandonedCheckoutsList({
    required String apiVersion,
    int? limit,
    String? sinceId,
    String? createdAtMin,
    String? createdAtMax,
    String? updatedAtMin,
    String? updatedAtMax,
    String? status,
  });
}
