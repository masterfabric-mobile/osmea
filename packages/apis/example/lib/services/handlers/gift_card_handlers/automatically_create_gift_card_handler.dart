import 'package:apis/network/remote/gift_card/freezed_model/request/automatically_create_gift_card_request.dart';
import 'package:example/services/api_request_handler.dart';
import './../../api_service_registry.dart';

///*******************************************************************
///*************** 🤖 AUTO CREATE GIFT CARD HANDLER 🤖 ***************
///*******************************************************************

class AutomaticallyCreateGiftCardHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        try {
          final idStr = params['id'];
          final balance = params['balance'];
          final createdAt = params['created_at'];
          final updatedAt = params['updated_at'];
          final currency = params['currency'];
          final initialValue = params['initial_value'];
          final code = params['code'];
          final lastCharacters = params['last_characters'];

          if (idStr == null || initialValue == null || currency == null) {
            return {
              "status": "error",
              "message":
                  "Fields 'id', 'initial_value' and 'currency' are required.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final request = AutomaticallyCreateGiftCardRequest(
            giftCard: GiftCard(
              id: int.tryParse(idStr),
              balance: balance,
              createdAt: createdAt,
              updatedAt: updatedAt,
              currency: currency,
              initialValue: initialValue,
              code: code,
              lastCharacters: lastCharacters,
            ),
          );

          return {
            "status": "success",
            "message": "Auto-created gift card prepared (simulation).",
            "gift_card": request.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to auto-create gift card: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported. Only POST is allowed for auto-create.",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'id',
            label: 'Gift Card ID',
            hint: 'Unique gift card ID',
            isRequired: true,
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'initial_value',
            label: 'Initial Value',
            hint: 'Gift card value',
            isRequired: true,
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'currency',
            label: 'Currency',
            hint: 'Currency code (e.g. USD)',
            isRequired: true,
          ),
          const ApiField(
            name: 'balance',
            label: 'Balance',
            hint: 'Remaining balance',
          ),
          const ApiField(
            name: 'created_at',
            label: 'Created At',
            hint: 'Date created (optional)',
          ),
          const ApiField(
            name: 'updated_at',
            label: 'Updated At',
            hint: 'Date updated (optional)',
          ),
          const ApiField(
            name: 'code',
            label: 'Code',
            hint: 'Generated gift card code',
          ),
          const ApiField(
            name: 'last_characters',
            label: 'Last Characters',
            hint: 'Last 4 characters of the gift card',
          ),
        ],
      };
}
