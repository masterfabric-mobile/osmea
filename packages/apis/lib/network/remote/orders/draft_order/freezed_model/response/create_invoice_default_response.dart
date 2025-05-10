// To parse this JSON data, do
//
//     final createInvoiceDefaultResponse = createInvoiceDefaultResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_invoice_default_response.freezed.dart';
part 'create_invoice_default_response.g.dart';

CreateInvoiceDefaultResponse createInvoiceDefaultResponseFromJson(String str) =>
    CreateInvoiceDefaultResponse.fromJson(json.decode(str));

String createInvoiceDefaultResponseToJson(CreateInvoiceDefaultResponse data) =>
    json.encode(data.toJson());

@freezed
class CreateInvoiceDefaultResponse with _$CreateInvoiceDefaultResponse {
  const factory CreateInvoiceDefaultResponse({
    @JsonKey(name: "draft_order_invoice") DraftOrderInvoice? draftOrderInvoice,
  }) = _CreateInvoiceDefaultResponse;

  factory CreateInvoiceDefaultResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceDefaultResponseFromJson(json);
}

@freezed
class DraftOrderInvoice with _$DraftOrderInvoice {
  const factory DraftOrderInvoice({
    @JsonKey(name: "to") String? to,
    @JsonKey(name: "from") String? from,
    @JsonKey(name: "subject") String? subject,
    @JsonKey(name: "custom_message") String? customMessage,
    @JsonKey(name: "bcc") List<dynamic>? bcc,
  }) = _DraftOrderInvoice;

  factory DraftOrderInvoice.fromJson(Map<String, dynamic> json) =>
      _$DraftOrderInvoiceFromJson(json);
}
