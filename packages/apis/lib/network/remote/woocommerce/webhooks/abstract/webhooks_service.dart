import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/request/create_webhook_request.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/create_webhook_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/delete_webhook_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/list_all_webhooks_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/retrieve_webhook_response.dart';
import 'package:apis/network/remote/woocommerce/webhooks/freezed_model/response/update_webhook_response.dart';

abstract class WebhooksService {
  /// List all webhooks
  Future<List<ListAllWebhooksResponse>> listAllWebhooks({
    required String apiVersion,
    String? context,
    int? page,
    int? perPage,
    String? search,
    List<int>? exclude,
    List<int>? include,
    String? order,
    String? orderby,
    String? status,
  });

  /// Create a new webhook
  Future<CreateWebhookResponse> createWebhook({
    required String apiVersion,
    required Map<String, dynamic> webhookData,
  });

  /// Retrieve a specific webhook
  Future<RetrieveWebhookResponse> retrieveWebhook({
    required String apiVersion,
    required int webhookId,
  });

  /// Update a webhook
  Future<UpdateWebhookResponse> updateWebhook({
    required String apiVersion,
    required int webhookId,
    required Map<String, dynamic> webhookData,
  });

  /// Delete a webhook
  Future<DeleteWebhookResponse> deleteWebhook({
    required String apiVersion,
    required int webhookId,
    bool? force,
  });
}
