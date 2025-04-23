// To parse this JSON data, do
//
//     final createsAccountActivationUrlForCustomerRequest = createsAccountActivationUrlForCustomerRequestFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'creates_account_activation_url_for_customer_request.freezed.dart';
part 'creates_account_activation_url_for_customer_request.g.dart';

CreatesAccountActivationUrlForCustomerRequest createsAccountActivationUrlForCustomerRequestFromJson(String str) => CreatesAccountActivationUrlForCustomerRequest.fromJson(json.decode(str));

String createsAccountActivationUrlForCustomerRequestToJson(CreatesAccountActivationUrlForCustomerRequest data) => json.encode(data.toJson());

@freezed
class CreatesAccountActivationUrlForCustomerRequest with _$CreatesAccountActivationUrlForCustomerRequest {
  const factory CreatesAccountActivationUrlForCustomerRequest() = _CreatesAccountActivationUrlForCustomerRequest;

  factory CreatesAccountActivationUrlForCustomerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatesAccountActivationUrlForCustomerRequestFromJson(json);

  /// Serializes this model as an empty map for Shopify's API
  Map<String, dynamic> toJson() => {};
}
