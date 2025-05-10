import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_invoice_customized_response.freezed.dart';
part 'create_invoice_customized_response.g.dart';

CreateInvoiceCustomizedResponse createInvoiceCustomizedResponseFromJson(
        String str) =>
    CreateInvoiceCustomizedResponse.fromJson(json.decode(str));

String createInvoiceCustomizedResponseToJson(
        CreateInvoiceCustomizedResponse data) =>
    json.encode(data.toJson());

@freezed
class CreateInvoiceCustomizedResponse with _$CreateInvoiceCustomizedResponse {
  const factory CreateInvoiceCustomizedResponse({
    @JsonKey(name: "draft_order_invoice") DraftOrderInvoice? draftOrderInvoice,
  }) = _CreateInvoiceCustomizedResponse;

  factory CreateInvoiceCustomizedResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceCustomizedResponseFromJson(json);
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
