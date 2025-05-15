// Model for creating an application charge request

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_application_charge_request.freezed.dart';
part 'create_application_charge_request.g.dart';

CreateApplicationChargeRequest createApplicationChargeRequestFromJson(String str) => 
    CreateApplicationChargeRequest.fromJson(json.decode(str));

String createApplicationChargeRequestToJson(CreateApplicationChargeRequest data) => 
    json.encode(data.toJson());

@freezed
class CreateApplicationChargeRequest with _$CreateApplicationChargeRequest {
  const factory CreateApplicationChargeRequest({
    @JsonKey(name: "application_charge") 
    required ApplicationCharge applicationCharge,
  }) = _CreateApplicationChargeRequest;

  factory CreateApplicationChargeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateApplicationChargeRequestFromJson(json);
}

@freezed
class ApplicationCharge with _$ApplicationCharge {
  const factory ApplicationCharge({
    /// The name of the application charge 
    @JsonKey(name: "name") required String name,
    
    /// The price as a string or number
    @JsonKey(name: "price") required dynamic price,
    
    /// URL where the customer is redirected after accepting/declining the charge
    @JsonKey(name: "return_url") required String returnUrl,
    
    /// Whether this is a test charge (true) or a real charge (false)
    @JsonKey(name: "test") bool? test,
    
    /// The 3-letter currency code (e.g., "USD", "EUR", "GBP")
    @JsonKey(name: "currency") String? currency,
  }) = _ApplicationCharge;

  factory ApplicationCharge.fromJson(Map<String, dynamic> json) =>
      _$ApplicationChargeFromJson(json);
}