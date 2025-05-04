// To parse this JSON data, do
//
//     final updatesCustomerRequest = updatesCustomerRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'updates_customer_request.freezed.dart';
part 'updates_customer_request.g.dart';

UpdatesCustomerRequest updatesCustomerRequestFromJson(String str) => UpdatesCustomerRequest.fromJson(json.decode(str));

String updatesCustomerRequestToJson(UpdatesCustomerRequest data) => json.encode(data.toJson());

@freezed
class UpdatesCustomerRequest with _$UpdatesCustomerRequest {
    const factory UpdatesCustomerRequest({
        @JsonKey(name: "customer")
        Customer? customer,
    }) = _UpdatesCustomerRequest;

    factory UpdatesCustomerRequest.fromJson(Map<String, dynamic> json) => _$UpdatesCustomerRequestFromJson(json);
}

@freezed
class Customer with _$Customer {
    const factory Customer({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "metafields")
        List<Metafield>? metafields,
    }) = _Customer;

    factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
class Metafield with _$Metafield {
    const factory Metafield({
        @JsonKey(name: "key")
        String? key,
        @JsonKey(name: "value")
        String? value,
        @JsonKey(name: "type")
        String? type,
        @JsonKey(name: "namespace")
        String? namespace,
    }) = _Metafield;

    factory Metafield.fromJson(Map<String, dynamic> json) => _$MetafieldFromJson(json);
}
