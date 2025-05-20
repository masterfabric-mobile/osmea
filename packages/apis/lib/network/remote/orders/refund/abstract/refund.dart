import 'package:apis/network/remote/orders/refund/freezed_model/response/get_single_refund_response.dart';

abstract class RefundService {
  Future<GetSingleRefundResponse> getSingleRefund({
    required String apiVersion,
    required String orderId,
    required String refundId,
  });
}
