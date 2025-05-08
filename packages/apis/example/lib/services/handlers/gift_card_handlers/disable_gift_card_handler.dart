import 'package:apis/apis.dart';
import 'package:apis/network/remote/gift_card/abstract/gift_card_service.dart';
import 'package:apis/network/remote/gift_card/freezed_model/request/disable_gift_card_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import './../../api_service_registry.dart';

///*******************************************************************
///**************** 🚫 DISABLE GIFT CARD HANDLER 🚫 ******************
///*******************************************************************

class DisableGiftCardHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    switch (method) {
      case 'POST':
        try {
          final giftCardId = params['gift_card_id'] ?? '';

          if (giftCardId.isEmpty) {
            return {
              "status": "error",
              "message": "Gift card ID is required",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final giftCardIntId = int.tryParse(giftCardId);
          if (giftCardIntId == null) {
            return {
              "status": "error",
              "message": "Gift card ID must be a valid integer",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final payload = DisableGiftCardRequest(
            giftCard: GiftCard(
              id: giftCardIntId,
              disabledAt: DateTime.now().toIso8601String(),
            ),
          );

          print("📤 Disable Gift Card Payload: ${payload.toJson()}");

          await GetIt.I.get<GiftCardService>().disableGiftCard(
                apiVersion: ApiNetwork.apiVersion,
                giftCardId: giftCardId,
                model: payload,
              );

          return {
            "status": "success",
            "message": "Gift card disabled successfully",
            "gift_card_id": giftCardId,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to disable gift card: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Disable Gift Card API. Only POST is allowed.",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'gift_card_id',
            label: 'Gift Card ID',
            hint: 'ID of the gift card to disable',
            isRequired: true,
            type: ApiFieldType.text,
          ),
        ],
      };
}
