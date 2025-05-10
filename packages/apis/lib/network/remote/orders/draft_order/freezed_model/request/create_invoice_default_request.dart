// To parse this JSON data, do
//
//     final createInvoiceDefaultRequest = createInvoiceDefaultRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_invoice_default_request.freezed.dart';
part 'create_invoice_default_request.g.dart';

CreateInvoiceDefaultRequest createInvoiceDefaultRequestFromJson(String str) =>
    CreateInvoiceDefaultRequest.fromJson(json.decode(str));

String createInvoiceDefaultRequestToJson(CreateInvoiceDefaultRequest data) =>
    json.encode(data.toJson());

@freezed
class CreateInvoiceDefaultRequest with _$CreateInvoiceDefaultRequest {
  const factory CreateInvoiceDefaultRequest({
    @JsonKey(name: "draft_order_invoice") DraftOrderInvoice? draftOrderInvoice,
  }) = _CreateInvoiceDefaultRequest;

  factory CreateInvoiceDefaultRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceDefaultRequestFromJson(json);
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
