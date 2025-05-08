import 'package:apis/apis.dart';
import 'package:apis/network/remote/gift_card/abstract/gift_card_service.dart';
import 'package:apis/network/remote/gift_card/freezed_model/request/create_new_gift_card_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import './../../api_service_registry.dart';

///*******************************************************************
///*************** 🎁 CREATE NEW GIFT CARD HANDLER 🎁 ***************
///*******************************************************************

class CreateNewGiftCardHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        try {
          final initialValueStr = params['initial_value'] ?? '';
          final currency = params['currency'] ?? '';

          // ✅ Convert initialValue to double
          final initialValue = double.tryParse(initialValueStr);

          if (initialValue == null || currency.isEmpty) {
            return {
              "status": "error",
              "message":
                  "Initial value must be a valid number and currency is required.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          // 📋 Optional fields
          final note = params['note'];
          final code = params['code'];
          final expiresOn = params['expires_on'];

          final giftCardModel = GiftCard(
            initialValue: initialValue,
            currency: currency.toUpperCase(),
            note: note,
            code: code,
            expiresOn: expiresOn,
          );

          print(
              '🎯 JSON being sent: ${CreateNewGiftCardRequest(giftCard: giftCardModel).toJson()}');

          await GetIt.I.get<GiftCardService>().createNewGiftCard(
                apiVersion: ApiNetwork.apiVersion,
                model: CreateNewGiftCardRequest(giftCard: giftCardModel),
              );

          return {
            "status": "success",
            "message": "Gift card created successfully",
            "giftCard": {
              "initial_value": initialValue,
              "currency": currency,
              "note": note,
              "code": code ?? 'Auto-generated',
              "expires_on": expiresOn,
            },
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          if (e.toString().contains('session has expired') ||
              e.toString().contains('login?errorHint=no_identity_session')) {
            return {
              "status": "auth_error",
              "message":
                  "Your session has expired. Please re-authenticate to continue.",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          return {
            "status": "error",
            "message": "Failed to create gift card: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Gift Card API. Only POST is allowed.",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'initial_value',
            label: 'Initial Value',
            hint: 'Gift card value (e.g. 100.00)',
            type: ApiFieldType.number,
            isRequired: true,
          ),
          const ApiField(
            name: 'currency',
            label: 'Currency',
            hint: 'Currency code (e.g. USD)',
            isRequired: true,
          ),
          const ApiField(
            name: 'note',
            label: 'Note',
            hint: 'Optional note about this card',
          ),
          const ApiField(
            name: 'code',
            label: 'Code',
            hint: 'Add custom gift card code',
          ),
          const ApiField(
            name: 'expires_on',
            label: 'Expires On',
            hint: 'Optional expiration date (YYYY-MM-DD)',
            type: ApiFieldType.date,
          ),
        ],
      };
}
