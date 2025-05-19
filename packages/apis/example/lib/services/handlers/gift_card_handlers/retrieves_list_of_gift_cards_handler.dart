import 'package:apis/apis.dart';
import 'package:apis/network/remote/gift_card/abstract/gift_card_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import './../../api_service_registry.dart';

///**************************************************************
///*************** 📋 LIST GIFT CARDS HANDLER *******************
///**************************************************************

class RetrievesListOfGiftCardsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method != 'GET') {
      return {
        "error": "Method $method not supported. Only GET is allowed.",
      };
    }

    try {
      // 🔍 Optional filters
      final onlyEnabled = params['enabled']?.toLowerCase() == 'true';
      final status = params['status'];
      final limit = int.tryParse(params['limit'] ?? '');
      final sinceId = int.tryParse(params['since_id'] ?? '');
      final fields = params['fields'];

      final response =
          await GetIt.I.get<GiftCardService>().retrievesListOfGiftCards(
                apiVersion: ApiNetwork.apiVersion,
                limit: limit,
                page: null, // page parameter is not being used currently
                fields: fields,
              );

      var cards = response.giftCards ?? [];

      // 🚫 enabled filtering (active if disabled_at is null)
      if (onlyEnabled) {
        cards = cards.where((card) => card.disabledAt == null).toList();
      }

      // ✅ status filter (example: 'enabled', 'disabled')
      if (status == 'enabled') {
        cards = cards.where((card) => card.disabledAt == null).toList();
      } else if (status == 'disabled') {
        cards = cards.where((card) => card.disabledAt != null).toList();
      }

      // ⏩ since_id filter
      if (sinceId != null) {
        cards = cards.where((card) => (card.id ?? 0) > sinceId).toList();
      }

      return {
        "status": "success",
        "gift_cards": cards.map((e) => e.toJson()).toList(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve gift cards: ${e.toString()}",
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
            hint: 'Filter only enabled cards (true/false)',
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint: 'enabled or disabled',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Max number of results to return',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Return results after this ID',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to return',
          ),
        ],
      };
}
