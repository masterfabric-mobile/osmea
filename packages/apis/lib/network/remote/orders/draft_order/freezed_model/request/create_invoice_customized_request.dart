import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_invoice_customized_request.freezed.dart';
part 'create_invoice_customized_request.g.dart';

CreateInvoiceCustomizedRequest createInvoiceCustomizedRequestFromJson(
        String str) =>
    CreateInvoiceCustomizedRequest.fromJson(json.decode(str));

String createInvoiceCustomizedRequestToJson(
        CreateInvoiceCustomizedRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateInvoiceCustomizedRequest with _$CreateInvoiceCustomizedRequest {
  const factory CreateInvoiceCustomizedRequest({
    @JsonKey(name: "draft_order_invoice") DraftOrderInvoice? draftOrderInvoice,
  }) = _CreateInvoiceCustomizedRequest;

  factory CreateInvoiceCustomizedRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceCustomizedRequestFromJson(json);
}

@freezed
class DraftOrderInvoice with _$DraftOrderInvoice {
  const factory DraftOrderInvoice({
    @JsonKey(name: "to") String? to,
    @JsonKey(name: "from") String? from,
    @JsonKey(name: "bcc") List<dynamic>? bcc,
    @JsonKey(name: "subject") String? subject,
    @JsonKey(name: "custom_message") String? customMessage,
  }) = _DraftOrderInvoice;

  factory DraftOrderInvoice.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderInvoiceFromJson(json);
}
