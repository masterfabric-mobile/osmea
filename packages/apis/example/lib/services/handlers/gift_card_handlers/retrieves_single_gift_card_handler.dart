import 'package:apis/apis.dart';
import 'package:apis/network/remote/gift_card/abstract/gift_card_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import './../../api_service_registry.dart';

///***************************************************************
///************* 🎯 SINGLE GIFT CARD RETRIEVER HANDLER ************
///***************************************************************

class RetrievesSingleGiftCardHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "error":
            "Method $method not supported. Only GET is allowed for single gift card retrieval.",
      };
    }

    final giftCardId = params['id'] ?? '';
    if (giftCardId.isEmpty) {
      return {
        "status": "error",
        "message": "Gift Card ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final response =
          await GetIt.I.get<GiftCardService>().retrievesSingleGiftCard(
                apiVersion: ApiNetwork.apiVersion,
                giftCardId: giftCardId,
              );

      return {
        "status": "success",
        "giftCard": response.giftCard?.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve gift card: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'id',
            label: 'Gift Card ID',
            hint: 'Enter the gift card ID to fetch details',
            isRequired: true,
            type: ApiFieldType.text,
          ),
        ],
      };
}
