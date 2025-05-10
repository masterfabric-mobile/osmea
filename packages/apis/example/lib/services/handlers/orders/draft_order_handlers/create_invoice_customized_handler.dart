import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_invoice_customized_request.dart'
    as create_request;
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_invoice_customized_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateInvoiceCustomizedHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? draftOrderId = params['draft_order_id'];
        final String? to = params['to'];
        final String? from = params['from'];
        final String? subject = params['subject'];
        final String? customMessage = params['custom_message'];
        final List<String>? bccList =
            params['bcc']?.split(',').map((e) => e.trim()).toList();

        if (draftOrderId == null ||
            draftOrderId.isEmpty ||
            to == null ||
            to.isEmpty ||
            subject == null ||
            subject.isEmpty) {
          return {
            "status": "error",
            "message":
                "Draft Order ID, To (Recipient), and Subject are required.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = create_request.CreateInvoiceCustomizedRequest(
            draftOrderInvoice: create_request.DraftOrderInvoice(
              to: to,
              from: from,
              bcc: bccList,
              subject: subject,
              customMessage: customMessage,
            ),
          );

          final CreateInvoiceCustomizedResponse response =
              await GetIt.I.get<DraftOrderService>().createInvoiceCustomized(
                    apiVersion: apiVersion,
                    draftOrderId: draftOrderId,
                    model: model,
                  );

          return {
            "status": "success",
            "message": "Customized draft order invoice sent successfully",
            "draft_order_invoice": response.draftOrderInvoice?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to send customized draft order invoice: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Send Customized Draft Order Invoice API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'draft_order_id',
            label: 'Draft Order ID',
            hint: 'Enter the ID of the draft order',
          ),
          const ApiField(
            name: 'to',
            label: 'To (Recipient Email)',
            hint: 'Enter the email address of the recipient',
          ),
          const ApiField(
            name: 'subject',
            label: 'Subject',
            hint: 'Enter the subject of the invoice',
          ),
        ],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'POST': [
          const ApiField(
            name: 'from',
            label: 'From (Sender Email)',
            hint: 'Enter the sender\'s email address (optional)',
          ),
          const ApiField(
            name: 'bcc',
            label: 'BCC (Blind Carbon Copy Emails)',
            hint:
                'Enter a comma-separated list of BCC email addresses (optional)',
          ),
          const ApiField(
            name: 'custom_message',
            label: 'Custom Message',
            hint:
                'Enter a custom message to include in the invoice email (optional)',
          ),
        ],
      };
}
