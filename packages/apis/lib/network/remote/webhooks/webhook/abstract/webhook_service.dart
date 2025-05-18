import 'package:apis/network/remote/webhooks/webhook/freezed_model/request/create_webhook_request.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/request/update_webhook_request.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/response/get_a_webhook_response.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/response/get_all_webhooks_response.dart';
import 'package:apis/network/remote/webhooks/webhook/freezed_model/response/get_count_of_webhooks_response.dart';

/// 🔑 Abstract contract for getting all Webhooks
abstract class GetWebhooksService {
  Future<GetAllWebhooksResponse> getWebhooks({
    required String apiVersion,
    String? fields,
    String? address,
    String? topic,
    String? since_id,
    String? created_at_min,
    String? created_at_max,
    String? updated_at_min,
    String? updated_at_max,
    int? limit,
  });
}

/// 🔑 Abstract contract for getting a single Webhook
abstract class GetWebhookService {
  Future<GetAWebhookResponse> getWebhook({
    required String apiVersion,
    required int id,
    String? fields,
  });
}

/// 🔑 Abstract contract for getting the count of Webhooks
abstract class GetWebhooksCountService {
  Future<GetCountOfWebhooksResponse> getWebhooksCount({
    required String apiVersion,
    String? address,
    String? topic,
  });
}

/// 🔑 Abstract contract for creating a Webhook
abstract class CreateWebhookService {
  Future<GetAWebhookResponse> createWebhook({
    required String apiVersion,
    required CreateWebhookRequest request,
  });
}

/// 🔑 Abstract contract for updating a Webhook
abstract class UpdateWebhookService {
  Future<GetAWebhookResponse> updateWebhook({
    required String apiVersion,
    required int id,
    required UpdateWebhookRequest request,
  });
}

/// 🔑 Abstract contract for deleting a Webhook
abstract class DeleteWebhookService {
  Future<void> deleteWebhook({
    required String apiVersion,
    required int id,
  });
}