import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_signup_request.freezed.dart';
part 'user_signup_request.g.dart';

/// 🔐 User Meta Model
@freezed
class UserMeta with _$UserMeta {
  const factory UserMeta({
    @Default(true) @JsonKey(name: 'accept_terms') bool acceptTerms,
    @Default(false)
    @JsonKey(name: 'subscribe_newsletter')
    bool subscribeNewsletter,
  }) = _UserMeta;

  factory UserMeta.fromJson(Map<String, dynamic> json) =>
      _$UserMetaFromJson(json);
}

/// 🔐 User Sign Up Request Model
@freezed
class UserSignUpRequest with _$UserSignUpRequest {
  const factory UserSignUpRequest({
    required String email,
    required String password,
    @JsonKey(name: 'AUTH_KEY') required String authKey,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    String? phone,
    String? company,
    @JsonKey(name: 'user_meta') required UserMeta userMeta,
    @JsonKey(name: 'referral_code') String? referralCode,
    Map<String, dynamic>? metadata,
  }) = _UserSignUpRequest;

  factory UserSignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$UserSignUpRequestFromJson(json);
}
