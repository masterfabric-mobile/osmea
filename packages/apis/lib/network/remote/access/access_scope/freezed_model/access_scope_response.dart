// To parse this JSON data, do
//
//     final accessScopeResponse = accessScopeResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'access_scope_response.freezed.dart';
part 'access_scope_response.g.dart';

AccessScopeResponse accessScopeResponseFromJson(String str) => AccessScopeResponse.fromJson(json.decode(str));

String accessScopeResponseToJson(AccessScopeResponse data) => json.encode(data.toJson());

@freezed
class AccessScopeResponse with _$AccessScopeResponse {
    const factory AccessScopeResponse({
        @JsonKey(name: "access_scopes")
        required List<AccessScope> accessScopes,
    }) = _AccessScopeResponse;

    factory AccessScopeResponse.fromJson(Map<String, dynamic> json) => _$AccessScopeResponseFromJson(json);
}

@freezed
class AccessScope with _$AccessScope {
    const factory AccessScope({
        @JsonKey(name: "handle")
        required String handle,
    }) = _AccessScope;

    factory AccessScope.fromJson(Map<String, dynamic> json) => _$AccessScopeFromJson(json);
}
