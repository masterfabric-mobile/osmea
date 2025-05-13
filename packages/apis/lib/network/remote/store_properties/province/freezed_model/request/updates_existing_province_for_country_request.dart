import 'package:freezed_annotation/freezed_annotation.dart';

part 'updates_existing_province_for_country_request.freezed.dart';
part 'updates_existing_province_for_country_request.g.dart';

@freezed
class UpdatesExistingProvinceForCountryRequest
    with _$UpdatesExistingProvinceForCountryRequest {
  const factory UpdatesExistingProvinceForCountryRequest({
    @JsonKey(name: 'province') required ProvinceUpdate province,
  }) = _UpdatesExistingProvinceForCountryRequest;

  factory UpdatesExistingProvinceForCountryRequest.fromJson(
          Map<String, dynamic> json) =>
      _$UpdatesExistingProvinceForCountryRequestFromJson(json);
}

@freezed
class ProvinceUpdate with _$ProvinceUpdate {
  const factory ProvinceUpdate({
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax") double? tax,
  }) = _ProvinceUpdate;

  factory ProvinceUpdate.fromJson(Map<String, dynamic> json) =>
      _$ProvinceUpdateFromJson(json);
}
