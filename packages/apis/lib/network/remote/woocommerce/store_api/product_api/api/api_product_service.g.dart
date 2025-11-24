// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_product_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _ProductServiceClient implements ProductServiceClient {
  _ProductServiceClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<ListAllProductsResponseModel>> listAllProducts({
    required String apiVersion,
    int page = 1,
    int perPage = 10,
    String? search,
    String? orderBy,
    String? order,
    int? category,
    int? tag,
    String? status,
    bool? featured,
    bool? onSale,
    String? minPrice,
    String? maxPrice,
    String? stockStatus,
    String? attribute,
    String? attributeTerm,
    int? shippingClass,
    String? after,
    String? before,
    List<int>? exclude,
    List<int>? include,
    int? parent,
    List<int>? parentExclude,
    String? slug,
    String? type,
    String? sku,
    String? catalogVisibility,
    int? reviewCount,
    double? averageRating,
    double? minRating,
    double? maxRating,
    String? brand,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'per_page': perPage,
      r'search': search,
      r'orderby': orderBy,
      r'order': order,
      r'category': category,
      r'tag': tag,
      r'status': status,
      r'featured': featured,
      r'on_sale': onSale,
      r'min_price': minPrice,
      r'max_price': maxPrice,
      r'stock_status': stockStatus,
      r'attribute': attribute,
      r'attribute_term': attributeTerm,
      r'shipping_class': shippingClass,
      r'after': after,
      r'before': before,
      r'exclude': exclude,
      r'include': include,
      r'parent': parent,
      r'parent_exclude': parentExclude,
      r'slug': slug,
      r'type': type,
      r'sku': sku,
      r'catalog_visibility': catalogVisibility,
      r'review_count': reviewCount,
      r'average_rating': averageRating,
      r'min_rating': minRating,
      r'max_rating': maxRating,
      r'brand': brand,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ListAllProductsResponseModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/wc/store/${apiVersion}/products',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    var _value = _result.data!
        .map((dynamic i) =>
            ListAllProductsResponseModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return _value;
  }

  @override
  Future<RetrieveProductResponseModel> retrieveProduct({
    required String apiVersion,
    required int productId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RetrieveProductResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/wc/store/${apiVersion}/products/${productId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = RetrieveProductResponseModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<RetrieveProductBySlugResponseModel> retrieveProductBySlug({
    required String apiVersion,
    required String productSlug,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RetrieveProductBySlugResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/wc/store/${apiVersion}/products/${productSlug}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = RetrieveProductBySlugResponseModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<List<ListProductVariationsResponseModel>> listAllVariationsByType({
    required String apiVersion,
    required String type,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'type': type};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<ListProductVariationsResponseModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/wc/store/${apiVersion}/products',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    var _value = _result.data!
        .map((dynamic i) => ListProductVariationsResponseModel.fromJson(
            i as Map<String, dynamic>))
        .toList();
    return _value;
  }

  @override
  Future<GetFilterOptionsResponseModel> getFilterOptions({
    required String apiVersion,
    bool includeAttributes = false,
    bool includeCategories = false,
    bool includeTags = false,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'include_attributes': includeAttributes,
      r'include_categories': includeCategories,
      r'include_tags': includeTags,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetFilterOptionsResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/wp-json/wc/store/${apiVersion}/products/filter-options',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = GetFilterOptionsResponseModel.fromJson(_result.data!);
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
