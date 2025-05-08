import 'package:apis/apis.dart';
import 'package:apis/network/remote/gift_card/abstract/gift_card_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import './../../api_service_registry.dart';

class SearchesForGiftCardsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    switch (method) {
      case 'GET':
        try {
          final query = params['query'] ?? '';
          final limit = int.tryParse(params['limit'] ?? '');
          final order = params['order'];
          final fields = params['fields'];
          final createdAtMin = params['created_at_min'];
          final createdAtMax = params['created_at_max'];
          final updatedAtMin = params['updated_at_min'];
          final updatedAtMax = params['updated_at_max'];

          final response =
              await GetIt.I.get<GiftCardService>().searchesForGiftCards(
                    apiVersion: ApiNetwork.apiVersion,
                    query: query,
                    limit: limit,
                    order: order,
                    fields: fields,
                    createdAtMin: createdAtMin,
                    createdAtMax: createdAtMax,
                    updatedAtMin: updatedAtMin,
                    updatedAtMax: updatedAtMax,
                  );

          final resultList =
              response.giftCards?.map((gc) => gc.toJson()).toList() ?? [];

          return {
            "status": "success",
            "message": "Gift cards search completed.",
            "results": resultList,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Search failed: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Search Gift Cards API. Only GET is allowed.",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'query',
            label: 'Search Query',
            hint: 'e.g., code:h99g*',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Max number of results to return',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'order',
            label: 'Order',
            hint: 'Sort field and direction (e.g. created_at DESC)',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to return',
          ),
          const ApiField(
            name: 'created_at_min',
            label: 'Created At Min',
            hint:
                'Only include gift cards created after this date (YYYY-MM-DD)',
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'created_at_max',
            label: 'Created At Max',
            hint:
                'Only include gift cards created before this date (YYYY-MM-DD)',
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'updated_at_min',
            label: 'Updated At Min',
            hint:
                'Only include gift cards updated after this date (YYYY-MM-DD)',
            type: ApiFieldType.date,
          ),
          const ApiField(
            name: 'updated_at_max',
            label: 'Updated At Max',
            hint:
                'Only include gift cards updated before this date (YYYY-MM-DD)',
            type: ApiFieldType.date,
          ),
        ],
      };
}
