// To parse this JSON data, do
//
//     final sendsAccountInviteToCustomerRequest = sendsAccountInviteToCustomerRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'sends_account_invite_to_customer_request.freezed.dart';
part 'sends_account_invite_to_customer_request.g.dart';

SendsAccountInviteToCustomerRequest sendsAccountInviteToCustomerRequestFromJson(String str) => SendsAccountInviteToCustomerRequest.fromJson(json.decode(str));

String sendsAccountInviteToCustomerRequestToJson(SendsAccountInviteToCustomerRequest data) => json.encode(data.toJson());

@freezed
class SendsAccountInviteToCustomerRequest with _$SendsAccountInviteToCustomerRequest {
    const factory SendsAccountInviteToCustomerRequest({
        @JsonKey(name: "customer_invite")
        @Default(CustomerInvite())
        CustomerInvite customerInvite,
    }) = _SendsAccountInviteToCustomerRequest;

    factory SendsAccountInviteToCustomerRequest.fromJson(Map<String, dynamic> json) => _$SendsAccountInviteToCustomerRequestFromJson(json);
}

@freezed
class CustomerInvite with _$CustomerInvite {
    const factory CustomerInvite({
        @JsonKey(name: "subject")
        String? subject,
        @JsonKey(name: "custom_message")
        String? customMessage,
    }) = _CustomerInvite;

    factory CustomerInvite.fromJson(Map<String, dynamic> json) => _$CustomerInviteFromJson(json);
}
