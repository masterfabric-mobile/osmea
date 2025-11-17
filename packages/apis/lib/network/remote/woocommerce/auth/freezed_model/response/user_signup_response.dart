import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_signup_response.freezed.dart';
part 'user_signup_response.g.dart';

/// 🔐 User Sign Up Response Model
@freezed
class UserSignUpResponse with _$UserSignUpResponse {
  const factory UserSignUpResponse({
    required bool success,
    String? message, // Made nullable as server sometimes doesn't send message
    UserSignUpData? data,
    String? error,
    Map<String, dynamic>? metadata,
  }) = _UserSignUpResponse;

  factory UserSignUpResponse.fromJson(Map<String, dynamic> json) {
    // Backend sends "user" field but we expect "data"
    // Map "user" to "data" if it exists
    if (json['user'] != null && json['data'] == null) {
      json = Map<String, dynamic>.from(json);
      final userMap = json['user'] as Map<String, dynamic>;

      // Transform WordPress user format to our UserSignUpData format
      json['data'] = {
        'user_id': userMap['ID']?.toString() ?? '',
        'email': userMap['user_email'] ?? '',
        'first_name':
            (userMap['display_name'] as String?)?.split(' ').first ?? '',
        'last_name': (userMap['display_name'] as String?)
                ?.split(' ')
                .skip(1)
                .join(' ') ??
            '',
        'created_at': userMap['user_registered'],
      };
    }

    return _$UserSignUpResponseFromJson(json);
  }
}

/// 🔐 User Sign Up Data Model
@freezed
class UserSignUpData with _$UserSignUpData {
  const factory UserSignUpData({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    String? phone,
    String? company,
    bool? requiresVerification,
    String? verificationToken,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) = _UserSignUpData;

  factory UserSignUpData.fromJson(Map<String, dynamic> json) =>
      _$UserSignUpDataFromJson(json);
}
