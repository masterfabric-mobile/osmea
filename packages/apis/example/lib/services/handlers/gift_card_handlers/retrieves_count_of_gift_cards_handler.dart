import 'package:apis/apis.dart';
import 'package:apis/network/remote/gift_card/abstract/gift_card_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import './../../api_service_registry.dart';

///**************************************************************
///*************** 🔢 COUNT GIFT CARDS HANDLER ******************
///**************************************************************

class RetrievesCountOfGiftCardsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method != 'GET') {
      return {
        "error": "Method $method not supported. Only GET is allowed.",
      };
    }

    try {
      final onlyEnabled = params['enabled']?.toLowerCase() == 'true';

      final response = await GetIt.I
          .get<GiftCardService>()
          .retrievesListOfGiftCards(apiVersion: ApiNetwork.apiVersion);

      final filtered = onlyEnabled
          ? response.giftCards?.where((g) => g.disabledAt == null).toList()
          : response.giftCards;

      return {
        "status": "success",
        "count": filtered?.length ?? 0,
        "enabled_filter": onlyEnabled,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve count: ${e.toString()}",
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
            name: 'enabled',
            label: 'Only Enabled',
            hint: 'Set to true to count only enabled gift cards',
          ),
        ],
      };
}
