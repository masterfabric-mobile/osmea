import 'package:apis/apis.dart';
import 'package:apis/network/remote/gift_card/abstract/gift_card_service.dart';
import 'package:apis/network/remote/gift_card/freezed_model/request/updates_gift_card_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import './../../api_service_registry.dart';

///*******************************************************************
///**************** ✏️ UPDATE GIFT CARD HANDLER ✏️ ******************
///*******************************************************************

class UpdatesGiftCardHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'PUT':
        try {
          final giftCardId = params['gift_card_id'] ?? '';
          final note = params['note'];
          final templateSuffix = params['template_suffix'];
          final expiresOn = params['expires_on'];

          if (giftCardId.isEmpty) {
            return {
              "status": "error",
              "message": "Gift Card ID is required.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final request = UpdatesGiftCardRequest(
            giftCard: GiftCardUpdate(
              note: note,
              templateSuffix: templateSuffix,
              expiresOn: expiresOn,
            ),
          );

          final response = await GetIt.I.get<GiftCardService>().updateGiftCard(
                apiVersion: ApiNetwork.apiVersion,
                giftCardId: giftCardId,
                model: request,
              );

          return {
            "status": "success",
            "message": "Gift card updated successfully",
            "giftCard": response.giftCard?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to update gift card: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Update Gift Card API. Only PUT is allowed.",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'gift_card_id',
            label: 'Gift Card ID',
            hint: 'ID of the gift card to update',
            isRequired: true,
          ),
          const ApiField(
            name: 'note',
            label: 'Note',
            hint: 'Update note (optional)',
          ),
          const ApiField(
            name: 'template_suffix',
            label: 'Template Suffix',
            hint: 'Update template suffix (optional)',
          ),
          const ApiField(
            name: 'expires_on',
            label: 'Expires On',
            hint: 'Expiration date (optional - YYYY-MM-DD)',
          ),
        ],
      };
}
