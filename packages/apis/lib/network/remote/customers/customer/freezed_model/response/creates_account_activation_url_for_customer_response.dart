// To parse this JSON data, do
//
//     final createsAccountActivationUrlForCustomerResponse = createsAccountActivationUrlForCustomerResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_account_activation_url_for_customer_response.freezed.dart';
part 'creates_account_activation_url_for_customer_response.g.dart';

CreatesAccountActivationUrlForCustomerResponse createsAccountActivationUrlForCustomerResponseFromJson(String str) => CreatesAccountActivationUrlForCustomerResponse.fromJson(json.decode(str));

String createsAccountActivationUrlForCustomerResponseToJson(CreatesAccountActivationUrlForCustomerResponse data) => json.encode(data.toJson());

@freezed
class CreatesAccountActivationUrlForCustomerResponse with _$CreatesAccountActivationUrlForCustomerResponse {
    const factory CreatesAccountActivationUrlForCustomerResponse({
        @JsonKey(name: "account_activation_url")
        String? accountActivationUrl,
        @JsonKey(name: "errors")
        List<String>? errors,
    }) = _CreatesAccountActivationUrlForCustomerResponse;

    factory CreatesAccountActivationUrlForCustomerResponse.fromJson(Map<String, dynamic> json) => _$CreatesAccountActivationUrlForCustomerResponseFromJson(json);
}
