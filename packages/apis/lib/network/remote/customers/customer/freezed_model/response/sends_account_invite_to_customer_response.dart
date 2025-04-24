// To parse this JSON data, do
//
//     final sendsAccountInviteToCustomerResponse = sendsAccountInviteToCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'sends_account_invite_to_customer_response.freezed.dart';
part 'sends_account_invite_to_customer_response.g.dart';

SendsAccountInviteToCustomerResponse sendsAccountInviteToCustomerResponseFromJson(String str) => SendsAccountInviteToCustomerResponse.fromJson(json.decode(str));

String sendsAccountInviteToCustomerResponseToJson(SendsAccountInviteToCustomerResponse data) => json.encode(data.toJson());

@freezed
class SendsAccountInviteToCustomerResponse with _$SendsAccountInviteToCustomerResponse {
    const factory SendsAccountInviteToCustomerResponse({
        @JsonKey(name: "customer_invite")
        CustomerInvite? customerInvite,
    }) = _SendsAccountInviteToCustomerResponse;

    factory SendsAccountInviteToCustomerResponse.fromJson(Map<String, dynamic> json) => _$SendsAccountInviteToCustomerResponseFromJson(json);
}

@freezed
class CustomerInvite with _$CustomerInvite {
    const factory CustomerInvite({
        @JsonKey(name: "to")
        String? to,
        @JsonKey(name: "from")
        String? from,
        @JsonKey(name: "subject")
        String? subject,
        @JsonKey(name: "custom_message")
        String? customMessage,
        @JsonKey(name: "bcc")
        List<String>? bcc,
    }) = _CustomerInvite;

    factory CustomerInvite.fromJson(Map<String, dynamic> json) => _$CustomerInviteFromJson(json);
}
