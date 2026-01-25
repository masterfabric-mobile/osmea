// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_woo_wishlist_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _ApiWooWishlistService implements ApiWooWishlistService {
  _ApiWooWishlistService(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetAllWishlistGroupsResponse> getAllGroups({
    required String namespace,
    required String apiVersion,
    int? page,
    int? perPage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'per_page': perPage,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetAllWishlistGroupsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/groups',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = GetAllWishlistGroupsResponse.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<CreateWishlistGroupResponse> createGroup({
    required String namespace,
    required String apiVersion,
    required CreateWishlistGroupRequest request,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = request;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CreateWishlistGroupResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/group',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = CreateWishlistGroupResponse.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<WishlistApiResponse<WishlistGroupResponse>> updateGroup({
    required String namespace,
    required String apiVersion,
    required int groupId,
    required UpdateWishlistGroupRequest request,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = request;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WishlistApiResponse<WishlistGroupResponse>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/group/${groupId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = WishlistApiResponse<WishlistGroupResponse>.fromJson(
      _result.data!,
      (json) => WishlistGroupResponse.fromJson(json as Map<String, dynamic>),
    );
    return _value;
  }

  @override
  Future<WishlistApiResponse<dynamic>> deleteGroup({
    required String namespace,
    required String apiVersion,
    required int groupId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WishlistApiResponse<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/group/${groupId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = WishlistApiResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return _value;
  }

  @override
  Future<WishlistPaginatedResponse<WishlistItemResponse>> getWishlistItems({
    required String namespace,
    required String apiVersion,
    int? groupId,
    int? page,
    int? perPage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'group_id': groupId,
      r'page': page,
      r'per_page': perPage,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WishlistPaginatedResponse<WishlistItemResponse>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/items',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = WishlistPaginatedResponse<WishlistItemResponse>.fromJson(
      _result.data!,
      (json) => WishlistItemResponse.fromJson(json as Map<String, dynamic>),
    );
    return _value;
  }

  @override
  Future<WishlistApiResponse<WishlistItemResponse>> addItemToWishlist({
    required String namespace,
    required String apiVersion,
    required AddWishlistItemRequest request,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = request;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WishlistApiResponse<WishlistItemResponse>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/item',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = WishlistApiResponse<WishlistItemResponse>.fromJson(
      _result.data!,
      (json) => WishlistItemResponse.fromJson(json as Map<String, dynamic>),
    );
    return _value;
  }

  @override
  Future<WishlistApiResponse<dynamic>> deleteItemById({
    required String namespace,
    required String apiVersion,
    required int itemId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WishlistApiResponse<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/item/${itemId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = WishlistApiResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return _value;
  }

  @override
  Future<WishlistApiResponse<dynamic>> deleteItemByProduct({
    required String namespace,
    required String apiVersion,
    required DeleteWishlistItemRequest request,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = request;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WishlistApiResponse<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/${namespace}/${apiVersion}/item',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = WishlistApiResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
