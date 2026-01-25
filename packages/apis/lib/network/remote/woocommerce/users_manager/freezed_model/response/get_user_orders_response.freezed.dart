// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_orders_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserOrdersResponse _$GetUserOrdersResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserOrdersResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserOrdersResponse {
  @JsonKey(name: 'orders')
  List<UserOrder> get orders => throw _privateConstructorUsedError;
  @JsonKey(name: 'pagination')
  PaginationInfo get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserOrdersResponseCopyWith<GetUserOrdersResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserOrdersResponseCopyWith<$Res> {
  factory $GetUserOrdersResponseCopyWith(GetUserOrdersResponse value,
          $Res Function(GetUserOrdersResponse) then) =
      _$GetUserOrdersResponseCopyWithImpl<$Res, GetUserOrdersResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'orders') List<UserOrder> orders,
      @JsonKey(name: 'pagination') PaginationInfo pagination});

  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$GetUserOrdersResponseCopyWithImpl<$Res,
        $Val extends GetUserOrdersResponse>
    implements $GetUserOrdersResponseCopyWith<$Res> {
  _$GetUserOrdersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<UserOrder>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res> get pagination {
    return $PaginationInfoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetUserOrdersResponseImplCopyWith<$Res>
    implements $GetUserOrdersResponseCopyWith<$Res> {
  factory _$$GetUserOrdersResponseImplCopyWith(
          _$GetUserOrdersResponseImpl value,
          $Res Function(_$GetUserOrdersResponseImpl) then) =
      __$$GetUserOrdersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'orders') List<UserOrder> orders,
      @JsonKey(name: 'pagination') PaginationInfo pagination});

  @override
  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$GetUserOrdersResponseImplCopyWithImpl<$Res>
    extends _$GetUserOrdersResponseCopyWithImpl<$Res,
        _$GetUserOrdersResponseImpl>
    implements _$$GetUserOrdersResponseImplCopyWith<$Res> {
  __$$GetUserOrdersResponseImplCopyWithImpl(_$GetUserOrdersResponseImpl _value,
      $Res Function(_$GetUserOrdersResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? pagination = null,
  }) {
    return _then(_$GetUserOrdersResponseImpl(
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<UserOrder>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserOrdersResponseImpl implements _GetUserOrdersResponse {
  const _$GetUserOrdersResponseImpl(
      {@JsonKey(name: 'orders') required final List<UserOrder> orders,
      @JsonKey(name: 'pagination') required this.pagination})
      : _orders = orders;

  factory _$GetUserOrdersResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserOrdersResponseImplFromJson(json);

  final List<UserOrder> _orders;
  @override
  @JsonKey(name: 'orders')
  List<UserOrder> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  @JsonKey(name: 'pagination')
  final PaginationInfo pagination;

  @override
  String toString() {
    return 'GetUserOrdersResponse(orders: $orders, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserOrdersResponseImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_orders), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserOrdersResponseImplCopyWith<_$GetUserOrdersResponseImpl>
      get copyWith => __$$GetUserOrdersResponseImplCopyWithImpl<
          _$GetUserOrdersResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserOrdersResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserOrdersResponse implements GetUserOrdersResponse {
  const factory _GetUserOrdersResponse(
      {@JsonKey(name: 'orders') required final List<UserOrder> orders,
      @JsonKey(name: 'pagination')
      required final PaginationInfo pagination}) = _$GetUserOrdersResponseImpl;

  factory _GetUserOrdersResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserOrdersResponseImpl.fromJson;

  @override
  @JsonKey(name: 'orders')
  List<UserOrder> get orders;
  @override
  @JsonKey(name: 'pagination')
  PaginationInfo get pagination;
  @override
  @JsonKey(ignore: true)
  _$$GetUserOrdersResponseImplCopyWith<_$GetUserOrdersResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) {
  return _PaginationInfo.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfo {
  @JsonKey(name: 'total')
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationInfoCopyWith<PaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoCopyWith<$Res> {
  factory $PaginationInfoCopyWith(
          PaginationInfo value, $Res Function(PaginationInfo) then) =
      _$PaginationInfoCopyWithImpl<$Res, PaginationInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total') int total,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'total_pages') int totalPages});
}

/// @nodoc
class _$PaginationInfoCopyWithImpl<$Res, $Val extends PaginationInfo>
    implements $PaginationInfoCopyWith<$Res> {
  _$PaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? perPage = null,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoImplCopyWith<$Res>
    implements $PaginationInfoCopyWith<$Res> {
  factory _$$PaginationInfoImplCopyWith(_$PaginationInfoImpl value,
          $Res Function(_$PaginationInfoImpl) then) =
      __$$PaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total') int total,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'total_pages') int totalPages});
}

/// @nodoc
class __$$PaginationInfoImplCopyWithImpl<$Res>
    extends _$PaginationInfoCopyWithImpl<$Res, _$PaginationInfoImpl>
    implements _$$PaginationInfoImplCopyWith<$Res> {
  __$$PaginationInfoImplCopyWithImpl(
      _$PaginationInfoImpl _value, $Res Function(_$PaginationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? perPage = null,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_$PaginationInfoImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoImpl implements _PaginationInfo {
  const _$PaginationInfoImpl(
      {@JsonKey(name: 'total') required this.total,
      @JsonKey(name: 'per_page') required this.perPage,
      @JsonKey(name: 'current_page') required this.currentPage,
      @JsonKey(name: 'total_pages') required this.totalPages});

  factory _$PaginationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoImplFromJson(json);

  @override
  @JsonKey(name: 'total')
  final int total;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;

  @override
  String toString() {
    return 'PaginationInfo(total: $total, perPage: $perPage, currentPage: $currentPage, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, total, perPage, currentPage, totalPages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      __$$PaginationInfoImplCopyWithImpl<_$PaginationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfo implements PaginationInfo {
  const factory _PaginationInfo(
          {@JsonKey(name: 'total') required final int total,
          @JsonKey(name: 'per_page') required final int perPage,
          @JsonKey(name: 'current_page') required final int currentPage,
          @JsonKey(name: 'total_pages') required final int totalPages}) =
      _$PaginationInfoImpl;

  factory _PaginationInfo.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoImpl.fromJson;

  @override
  @JsonKey(name: 'total')
  int get total;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(ignore: true)
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DetailedUserOrder _$DetailedUserOrderFromJson(Map<String, dynamic> json) {
  return _DetailedUserOrder.fromJson(json);
}

/// @nodoc
mixin _$DetailedUserOrder {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_created')
  String get dateCreated => throw _privateConstructorUsedError;
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  double get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'billing')
  UserBillingAddress? get billing => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping')
  UserShippingAddress? get shipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_items')
  List<OrderLineItem>? get lineItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'totals')
  OrderTotals? get totals => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DetailedUserOrderCopyWith<DetailedUserOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailedUserOrderCopyWith<$Res> {
  factory $DetailedUserOrderCopyWith(
          DetailedUserOrder value, $Res Function(DetailedUserOrder) then) =
      _$DetailedUserOrderCopyWithImpl<$Res, DetailedUserOrder>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'order_number') String orderNumber,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'date_created') String dateCreated,
      @JsonKey(name: 'total', fromJson: _totalFromJson) double total,
      @JsonKey(name: 'currency') String currency,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'billing') UserBillingAddress? billing,
      @JsonKey(name: 'shipping') UserShippingAddress? shipping,
      @JsonKey(name: 'line_items') List<OrderLineItem>? lineItems,
      @JsonKey(name: 'totals') OrderTotals? totals});

  $UserBillingAddressCopyWith<$Res>? get billing;
  $UserShippingAddressCopyWith<$Res>? get shipping;
  $OrderTotalsCopyWith<$Res>? get totals;
}

/// @nodoc
class _$DetailedUserOrderCopyWithImpl<$Res, $Val extends DetailedUserOrder>
    implements $DetailedUserOrderCopyWith<$Res> {
  _$DetailedUserOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? dateCreated = null,
    Object? total = null,
    Object? currency = null,
    Object? paymentMethod = freezed,
    Object? billing = freezed,
    Object? shipping = freezed,
    Object? lineItems = freezed,
    Object? totals = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dateCreated: null == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      billing: freezed == billing
          ? _value.billing
          : billing // ignore: cast_nullable_to_non_nullable
              as UserBillingAddress?,
      shipping: freezed == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as UserShippingAddress?,
      lineItems: freezed == lineItems
          ? _value.lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<OrderLineItem>?,
      totals: freezed == totals
          ? _value.totals
          : totals // ignore: cast_nullable_to_non_nullable
              as OrderTotals?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserBillingAddressCopyWith<$Res>? get billing {
    if (_value.billing == null) {
      return null;
    }

    return $UserBillingAddressCopyWith<$Res>(_value.billing!, (value) {
      return _then(_value.copyWith(billing: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserShippingAddressCopyWith<$Res>? get shipping {
    if (_value.shipping == null) {
      return null;
    }

    return $UserShippingAddressCopyWith<$Res>(_value.shipping!, (value) {
      return _then(_value.copyWith(shipping: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderTotalsCopyWith<$Res>? get totals {
    if (_value.totals == null) {
      return null;
    }

    return $OrderTotalsCopyWith<$Res>(_value.totals!, (value) {
      return _then(_value.copyWith(totals: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DetailedUserOrderImplCopyWith<$Res>
    implements $DetailedUserOrderCopyWith<$Res> {
  factory _$$DetailedUserOrderImplCopyWith(_$DetailedUserOrderImpl value,
          $Res Function(_$DetailedUserOrderImpl) then) =
      __$$DetailedUserOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'order_number') String orderNumber,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'date_created') String dateCreated,
      @JsonKey(name: 'total', fromJson: _totalFromJson) double total,
      @JsonKey(name: 'currency') String currency,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'billing') UserBillingAddress? billing,
      @JsonKey(name: 'shipping') UserShippingAddress? shipping,
      @JsonKey(name: 'line_items') List<OrderLineItem>? lineItems,
      @JsonKey(name: 'totals') OrderTotals? totals});

  @override
  $UserBillingAddressCopyWith<$Res>? get billing;
  @override
  $UserShippingAddressCopyWith<$Res>? get shipping;
  @override
  $OrderTotalsCopyWith<$Res>? get totals;
}

/// @nodoc
class __$$DetailedUserOrderImplCopyWithImpl<$Res>
    extends _$DetailedUserOrderCopyWithImpl<$Res, _$DetailedUserOrderImpl>
    implements _$$DetailedUserOrderImplCopyWith<$Res> {
  __$$DetailedUserOrderImplCopyWithImpl(_$DetailedUserOrderImpl _value,
      $Res Function(_$DetailedUserOrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? dateCreated = null,
    Object? total = null,
    Object? currency = null,
    Object? paymentMethod = freezed,
    Object? billing = freezed,
    Object? shipping = freezed,
    Object? lineItems = freezed,
    Object? totals = freezed,
  }) {
    return _then(_$DetailedUserOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      dateCreated: null == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      billing: freezed == billing
          ? _value.billing
          : billing // ignore: cast_nullable_to_non_nullable
              as UserBillingAddress?,
      shipping: freezed == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as UserShippingAddress?,
      lineItems: freezed == lineItems
          ? _value._lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<OrderLineItem>?,
      totals: freezed == totals
          ? _value.totals
          : totals // ignore: cast_nullable_to_non_nullable
              as OrderTotals?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailedUserOrderImpl implements _DetailedUserOrder {
  const _$DetailedUserOrderImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'order_number') required this.orderNumber,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'date_created') required this.dateCreated,
      @JsonKey(name: 'total', fromJson: _totalFromJson) required this.total,
      @JsonKey(name: 'currency') required this.currency,
      @JsonKey(name: 'payment_method') this.paymentMethod,
      @JsonKey(name: 'billing') this.billing,
      @JsonKey(name: 'shipping') this.shipping,
      @JsonKey(name: 'line_items') final List<OrderLineItem>? lineItems,
      @JsonKey(name: 'totals') this.totals})
      : _lineItems = lineItems;

  factory _$DetailedUserOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailedUserOrderImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'date_created')
  final String dateCreated;
  @override
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  final double total;
  @override
  @JsonKey(name: 'currency')
  final String currency;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @JsonKey(name: 'billing')
  final UserBillingAddress? billing;
  @override
  @JsonKey(name: 'shipping')
  final UserShippingAddress? shipping;
  final List<OrderLineItem>? _lineItems;
  @override
  @JsonKey(name: 'line_items')
  List<OrderLineItem>? get lineItems {
    final value = _lineItems;
    if (value == null) return null;
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'totals')
  final OrderTotals? totals;

  @override
  String toString() {
    return 'DetailedUserOrder(id: $id, orderNumber: $orderNumber, status: $status, dateCreated: $dateCreated, total: $total, currency: $currency, paymentMethod: $paymentMethod, billing: $billing, shipping: $shipping, lineItems: $lineItems, totals: $totals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailedUserOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateCreated, dateCreated) ||
                other.dateCreated == dateCreated) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.billing, billing) || other.billing == billing) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping) &&
            const DeepCollectionEquality()
                .equals(other._lineItems, _lineItems) &&
            (identical(other.totals, totals) || other.totals == totals));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      status,
      dateCreated,
      total,
      currency,
      paymentMethod,
      billing,
      shipping,
      const DeepCollectionEquality().hash(_lineItems),
      totals);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailedUserOrderImplCopyWith<_$DetailedUserOrderImpl> get copyWith =>
      __$$DetailedUserOrderImplCopyWithImpl<_$DetailedUserOrderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailedUserOrderImplToJson(
      this,
    );
  }
}

abstract class _DetailedUserOrder implements DetailedUserOrder {
  const factory _DetailedUserOrder(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'order_number') required final String orderNumber,
          @JsonKey(name: 'status') required final String status,
          @JsonKey(name: 'date_created') required final String dateCreated,
          @JsonKey(name: 'total', fromJson: _totalFromJson)
          required final double total,
          @JsonKey(name: 'currency') required final String currency,
          @JsonKey(name: 'payment_method') final String? paymentMethod,
          @JsonKey(name: 'billing') final UserBillingAddress? billing,
          @JsonKey(name: 'shipping') final UserShippingAddress? shipping,
          @JsonKey(name: 'line_items') final List<OrderLineItem>? lineItems,
          @JsonKey(name: 'totals') final OrderTotals? totals}) =
      _$DetailedUserOrderImpl;

  factory _DetailedUserOrder.fromJson(Map<String, dynamic> json) =
      _$DetailedUserOrderImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'date_created')
  String get dateCreated;
  @override
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  double get total;
  @override
  @JsonKey(name: 'currency')
  String get currency;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @JsonKey(name: 'billing')
  UserBillingAddress? get billing;
  @override
  @JsonKey(name: 'shipping')
  UserShippingAddress? get shipping;
  @override
  @JsonKey(name: 'line_items')
  List<OrderLineItem>? get lineItems;
  @override
  @JsonKey(name: 'totals')
  OrderTotals? get totals;
  @override
  @JsonKey(ignore: true)
  _$$DetailedUserOrderImplCopyWith<_$DetailedUserOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBillingAddress _$UserBillingAddressFromJson(Map<String, dynamic> json) {
  return _UserBillingAddress.fromJson(json);
}

/// @nodoc
mixin _$UserBillingAddress {
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company')
  String? get company => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_1')
  String? get address1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_2')
  String? get address2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'city')
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'state')
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'postcode')
  String? get postcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'country')
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone')
  String? get phone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserBillingAddressCopyWith<UserBillingAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBillingAddressCopyWith<$Res> {
  factory $UserBillingAddressCopyWith(
          UserBillingAddress value, $Res Function(UserBillingAddress) then) =
      _$UserBillingAddressCopyWithImpl<$Res, UserBillingAddress>;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'company') String? company,
      @JsonKey(name: 'address_1') String? address1,
      @JsonKey(name: 'address_2') String? address2,
      @JsonKey(name: 'city') String? city,
      @JsonKey(name: 'state') String? state,
      @JsonKey(name: 'postcode') String? postcode,
      @JsonKey(name: 'country') String? country,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'phone') String? phone});
}

/// @nodoc
class _$UserBillingAddressCopyWithImpl<$Res, $Val extends UserBillingAddress>
    implements $UserBillingAddressCopyWith<$Res> {
  _$UserBillingAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? company = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postcode = freezed,
    Object? country = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: freezed == address1
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postcode: freezed == postcode
          ? _value.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserBillingAddressImplCopyWith<$Res>
    implements $UserBillingAddressCopyWith<$Res> {
  factory _$$UserBillingAddressImplCopyWith(_$UserBillingAddressImpl value,
          $Res Function(_$UserBillingAddressImpl) then) =
      __$$UserBillingAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'company') String? company,
      @JsonKey(name: 'address_1') String? address1,
      @JsonKey(name: 'address_2') String? address2,
      @JsonKey(name: 'city') String? city,
      @JsonKey(name: 'state') String? state,
      @JsonKey(name: 'postcode') String? postcode,
      @JsonKey(name: 'country') String? country,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'phone') String? phone});
}

/// @nodoc
class __$$UserBillingAddressImplCopyWithImpl<$Res>
    extends _$UserBillingAddressCopyWithImpl<$Res, _$UserBillingAddressImpl>
    implements _$$UserBillingAddressImplCopyWith<$Res> {
  __$$UserBillingAddressImplCopyWithImpl(_$UserBillingAddressImpl _value,
      $Res Function(_$UserBillingAddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? company = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postcode = freezed,
    Object? country = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(_$UserBillingAddressImpl(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: freezed == address1
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postcode: freezed == postcode
          ? _value.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBillingAddressImpl implements _UserBillingAddress {
  const _$UserBillingAddressImpl(
      {@JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'company') this.company,
      @JsonKey(name: 'address_1') this.address1,
      @JsonKey(name: 'address_2') this.address2,
      @JsonKey(name: 'city') this.city,
      @JsonKey(name: 'state') this.state,
      @JsonKey(name: 'postcode') this.postcode,
      @JsonKey(name: 'country') this.country,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'phone') this.phone});

  factory _$UserBillingAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBillingAddressImplFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'company')
  final String? company;
  @override
  @JsonKey(name: 'address_1')
  final String? address1;
  @override
  @JsonKey(name: 'address_2')
  final String? address2;
  @override
  @JsonKey(name: 'city')
  final String? city;
  @override
  @JsonKey(name: 'state')
  final String? state;
  @override
  @JsonKey(name: 'postcode')
  final String? postcode;
  @override
  @JsonKey(name: 'country')
  final String? country;
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'phone')
  final String? phone;

  @override
  String toString() {
    return 'UserBillingAddress(firstName: $firstName, lastName: $lastName, company: $company, address1: $address1, address2: $address2, city: $city, state: $state, postcode: $postcode, country: $country, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBillingAddressImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, company,
      address1, address2, city, state, postcode, country, email, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBillingAddressImplCopyWith<_$UserBillingAddressImpl> get copyWith =>
      __$$UserBillingAddressImplCopyWithImpl<_$UserBillingAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBillingAddressImplToJson(
      this,
    );
  }
}

abstract class _UserBillingAddress implements UserBillingAddress {
  const factory _UserBillingAddress(
      {@JsonKey(name: 'first_name') final String? firstName,
      @JsonKey(name: 'last_name') final String? lastName,
      @JsonKey(name: 'company') final String? company,
      @JsonKey(name: 'address_1') final String? address1,
      @JsonKey(name: 'address_2') final String? address2,
      @JsonKey(name: 'city') final String? city,
      @JsonKey(name: 'state') final String? state,
      @JsonKey(name: 'postcode') final String? postcode,
      @JsonKey(name: 'country') final String? country,
      @JsonKey(name: 'email') final String? email,
      @JsonKey(name: 'phone') final String? phone}) = _$UserBillingAddressImpl;

  factory _UserBillingAddress.fromJson(Map<String, dynamic> json) =
      _$UserBillingAddressImpl.fromJson;

  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'company')
  String? get company;
  @override
  @JsonKey(name: 'address_1')
  String? get address1;
  @override
  @JsonKey(name: 'address_2')
  String? get address2;
  @override
  @JsonKey(name: 'city')
  String? get city;
  @override
  @JsonKey(name: 'state')
  String? get state;
  @override
  @JsonKey(name: 'postcode')
  String? get postcode;
  @override
  @JsonKey(name: 'country')
  String? get country;
  @override
  @JsonKey(name: 'email')
  String? get email;
  @override
  @JsonKey(name: 'phone')
  String? get phone;
  @override
  @JsonKey(ignore: true)
  _$$UserBillingAddressImplCopyWith<_$UserBillingAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserShippingAddress _$UserShippingAddressFromJson(Map<String, dynamic> json) {
  return _UserShippingAddress.fromJson(json);
}

/// @nodoc
mixin _$UserShippingAddress {
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company')
  String? get company => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_1')
  String? get address1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_2')
  String? get address2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'city')
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'state')
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'postcode')
  String? get postcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'country')
  String? get country => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserShippingAddressCopyWith<UserShippingAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserShippingAddressCopyWith<$Res> {
  factory $UserShippingAddressCopyWith(
          UserShippingAddress value, $Res Function(UserShippingAddress) then) =
      _$UserShippingAddressCopyWithImpl<$Res, UserShippingAddress>;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'company') String? company,
      @JsonKey(name: 'address_1') String? address1,
      @JsonKey(name: 'address_2') String? address2,
      @JsonKey(name: 'city') String? city,
      @JsonKey(name: 'state') String? state,
      @JsonKey(name: 'postcode') String? postcode,
      @JsonKey(name: 'country') String? country});
}

/// @nodoc
class _$UserShippingAddressCopyWithImpl<$Res, $Val extends UserShippingAddress>
    implements $UserShippingAddressCopyWith<$Res> {
  _$UserShippingAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? company = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postcode = freezed,
    Object? country = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: freezed == address1
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postcode: freezed == postcode
          ? _value.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserShippingAddressImplCopyWith<$Res>
    implements $UserShippingAddressCopyWith<$Res> {
  factory _$$UserShippingAddressImplCopyWith(_$UserShippingAddressImpl value,
          $Res Function(_$UserShippingAddressImpl) then) =
      __$$UserShippingAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'company') String? company,
      @JsonKey(name: 'address_1') String? address1,
      @JsonKey(name: 'address_2') String? address2,
      @JsonKey(name: 'city') String? city,
      @JsonKey(name: 'state') String? state,
      @JsonKey(name: 'postcode') String? postcode,
      @JsonKey(name: 'country') String? country});
}

/// @nodoc
class __$$UserShippingAddressImplCopyWithImpl<$Res>
    extends _$UserShippingAddressCopyWithImpl<$Res, _$UserShippingAddressImpl>
    implements _$$UserShippingAddressImplCopyWith<$Res> {
  __$$UserShippingAddressImplCopyWithImpl(_$UserShippingAddressImpl _value,
      $Res Function(_$UserShippingAddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? company = freezed,
    Object? address1 = freezed,
    Object? address2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postcode = freezed,
    Object? country = freezed,
  }) {
    return _then(_$UserShippingAddressImpl(
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      address1: freezed == address1
          ? _value.address1
          : address1 // ignore: cast_nullable_to_non_nullable
              as String?,
      address2: freezed == address2
          ? _value.address2
          : address2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postcode: freezed == postcode
          ? _value.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserShippingAddressImpl implements _UserShippingAddress {
  const _$UserShippingAddressImpl(
      {@JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'company') this.company,
      @JsonKey(name: 'address_1') this.address1,
      @JsonKey(name: 'address_2') this.address2,
      @JsonKey(name: 'city') this.city,
      @JsonKey(name: 'state') this.state,
      @JsonKey(name: 'postcode') this.postcode,
      @JsonKey(name: 'country') this.country});

  factory _$UserShippingAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserShippingAddressImplFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'company')
  final String? company;
  @override
  @JsonKey(name: 'address_1')
  final String? address1;
  @override
  @JsonKey(name: 'address_2')
  final String? address2;
  @override
  @JsonKey(name: 'city')
  final String? city;
  @override
  @JsonKey(name: 'state')
  final String? state;
  @override
  @JsonKey(name: 'postcode')
  final String? postcode;
  @override
  @JsonKey(name: 'country')
  final String? country;

  @override
  String toString() {
    return 'UserShippingAddress(firstName: $firstName, lastName: $lastName, company: $company, address1: $address1, address2: $address2, city: $city, state: $state, postcode: $postcode, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserShippingAddressImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.address1, address1) ||
                other.address1 == address1) &&
            (identical(other.address2, address2) ||
                other.address2 == address2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, company,
      address1, address2, city, state, postcode, country);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserShippingAddressImplCopyWith<_$UserShippingAddressImpl> get copyWith =>
      __$$UserShippingAddressImplCopyWithImpl<_$UserShippingAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserShippingAddressImplToJson(
      this,
    );
  }
}

abstract class _UserShippingAddress implements UserShippingAddress {
  const factory _UserShippingAddress(
          {@JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          @JsonKey(name: 'company') final String? company,
          @JsonKey(name: 'address_1') final String? address1,
          @JsonKey(name: 'address_2') final String? address2,
          @JsonKey(name: 'city') final String? city,
          @JsonKey(name: 'state') final String? state,
          @JsonKey(name: 'postcode') final String? postcode,
          @JsonKey(name: 'country') final String? country}) =
      _$UserShippingAddressImpl;

  factory _UserShippingAddress.fromJson(Map<String, dynamic> json) =
      _$UserShippingAddressImpl.fromJson;

  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'company')
  String? get company;
  @override
  @JsonKey(name: 'address_1')
  String? get address1;
  @override
  @JsonKey(name: 'address_2')
  String? get address2;
  @override
  @JsonKey(name: 'city')
  String? get city;
  @override
  @JsonKey(name: 'state')
  String? get state;
  @override
  @JsonKey(name: 'postcode')
  String? get postcode;
  @override
  @JsonKey(name: 'country')
  String? get country;
  @override
  @JsonKey(ignore: true)
  _$$UserShippingAddressImplCopyWith<_$UserShippingAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderLineItem _$OrderLineItemFromJson(Map<String, dynamic> json) {
  return _OrderLineItem.fromJson(json);
}

/// @nodoc
mixin _$OrderLineItem {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity')
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  double get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_image')
  String? get productImage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderLineItemCopyWith<OrderLineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderLineItemCopyWith<$Res> {
  factory $OrderLineItemCopyWith(
          OrderLineItem value, $Res Function(OrderLineItem) then) =
      _$OrderLineItemCopyWithImpl<$Res, OrderLineItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'subtotal', fromJson: _totalFromJson) double subtotal,
      @JsonKey(name: 'total', fromJson: _totalFromJson) double total,
      @JsonKey(name: 'product_id') int productId,
      @JsonKey(name: 'product_image') String? productImage});
}

/// @nodoc
class _$OrderLineItemCopyWithImpl<$Res, $Val extends OrderLineItem>
    implements $OrderLineItemCopyWith<$Res> {
  _$OrderLineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? subtotal = null,
    Object? total = null,
    Object? productId = null,
    Object? productImage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderLineItemImplCopyWith<$Res>
    implements $OrderLineItemCopyWith<$Res> {
  factory _$$OrderLineItemImplCopyWith(
          _$OrderLineItemImpl value, $Res Function(_$OrderLineItemImpl) then) =
      __$$OrderLineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'subtotal', fromJson: _totalFromJson) double subtotal,
      @JsonKey(name: 'total', fromJson: _totalFromJson) double total,
      @JsonKey(name: 'product_id') int productId,
      @JsonKey(name: 'product_image') String? productImage});
}

/// @nodoc
class __$$OrderLineItemImplCopyWithImpl<$Res>
    extends _$OrderLineItemCopyWithImpl<$Res, _$OrderLineItemImpl>
    implements _$$OrderLineItemImplCopyWith<$Res> {
  __$$OrderLineItemImplCopyWithImpl(
      _$OrderLineItemImpl _value, $Res Function(_$OrderLineItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? subtotal = null,
    Object? total = null,
    Object? productId = null,
    Object? productImage = freezed,
  }) {
    return _then(_$OrderLineItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderLineItemImpl implements _OrderLineItem {
  const _$OrderLineItemImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'quantity') required this.quantity,
      @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
      required this.subtotal,
      @JsonKey(name: 'total', fromJson: _totalFromJson) required this.total,
      @JsonKey(name: 'product_id') required this.productId,
      @JsonKey(name: 'product_image') this.productImage});

  factory _$OrderLineItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderLineItemImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'quantity')
  final int quantity;
  @override
  @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
  final double subtotal;
  @override
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  final double total;
  @override
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  @JsonKey(name: 'product_image')
  final String? productImage;

  @override
  String toString() {
    return 'OrderLineItem(id: $id, name: $name, quantity: $quantity, subtotal: $subtotal, total: $total, productId: $productId, productImage: $productImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderLineItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, subtotal,
      total, productId, productImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderLineItemImplCopyWith<_$OrderLineItemImpl> get copyWith =>
      __$$OrderLineItemImplCopyWithImpl<_$OrderLineItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderLineItemImplToJson(
      this,
    );
  }
}

abstract class _OrderLineItem implements OrderLineItem {
  const factory _OrderLineItem(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'quantity') required final int quantity,
          @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
          required final double subtotal,
          @JsonKey(name: 'total', fromJson: _totalFromJson)
          required final double total,
          @JsonKey(name: 'product_id') required final int productId,
          @JsonKey(name: 'product_image') final String? productImage}) =
      _$OrderLineItemImpl;

  factory _OrderLineItem.fromJson(Map<String, dynamic> json) =
      _$OrderLineItemImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'quantity')
  int get quantity;
  @override
  @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
  double get subtotal;
  @override
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  double get total;
  @override
  @JsonKey(name: 'product_id')
  int get productId;
  @override
  @JsonKey(name: 'product_image')
  String? get productImage;
  @override
  @JsonKey(ignore: true)
  _$$OrderLineItemImplCopyWith<_$OrderLineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderTotals _$OrderTotalsFromJson(Map<String, dynamic> json) {
  return _OrderTotals.fromJson(json);
}

/// @nodoc
mixin _$OrderTotals {
  @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping', fromJson: _totalFromJson)
  double get shipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax', fromJson: _totalFromJson)
  double get tax => throw _privateConstructorUsedError;
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  double get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderTotalsCopyWith<OrderTotals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderTotalsCopyWith<$Res> {
  factory $OrderTotalsCopyWith(
          OrderTotals value, $Res Function(OrderTotals) then) =
      _$OrderTotalsCopyWithImpl<$Res, OrderTotals>;
  @useResult
  $Res call(
      {@JsonKey(name: 'subtotal', fromJson: _totalFromJson) double subtotal,
      @JsonKey(name: 'shipping', fromJson: _totalFromJson) double shipping,
      @JsonKey(name: 'tax', fromJson: _totalFromJson) double tax,
      @JsonKey(name: 'total', fromJson: _totalFromJson) double total});
}

/// @nodoc
class _$OrderTotalsCopyWithImpl<$Res, $Val extends OrderTotals>
    implements $OrderTotalsCopyWith<$Res> {
  _$OrderTotalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? shipping = null,
    Object? tax = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: null == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderTotalsImplCopyWith<$Res>
    implements $OrderTotalsCopyWith<$Res> {
  factory _$$OrderTotalsImplCopyWith(
          _$OrderTotalsImpl value, $Res Function(_$OrderTotalsImpl) then) =
      __$$OrderTotalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'subtotal', fromJson: _totalFromJson) double subtotal,
      @JsonKey(name: 'shipping', fromJson: _totalFromJson) double shipping,
      @JsonKey(name: 'tax', fromJson: _totalFromJson) double tax,
      @JsonKey(name: 'total', fromJson: _totalFromJson) double total});
}

/// @nodoc
class __$$OrderTotalsImplCopyWithImpl<$Res>
    extends _$OrderTotalsCopyWithImpl<$Res, _$OrderTotalsImpl>
    implements _$$OrderTotalsImplCopyWith<$Res> {
  __$$OrderTotalsImplCopyWithImpl(
      _$OrderTotalsImpl _value, $Res Function(_$OrderTotalsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? shipping = null,
    Object? tax = null,
    Object? total = null,
  }) {
    return _then(_$OrderTotalsImpl(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: null == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderTotalsImpl implements _OrderTotals {
  const _$OrderTotalsImpl(
      {@JsonKey(name: 'subtotal', fromJson: _totalFromJson)
      required this.subtotal,
      @JsonKey(name: 'shipping', fromJson: _totalFromJson)
      required this.shipping,
      @JsonKey(name: 'tax', fromJson: _totalFromJson) required this.tax,
      @JsonKey(name: 'total', fromJson: _totalFromJson) required this.total});

  factory _$OrderTotalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderTotalsImplFromJson(json);

  @override
  @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
  final double subtotal;
  @override
  @JsonKey(name: 'shipping', fromJson: _totalFromJson)
  final double shipping;
  @override
  @JsonKey(name: 'tax', fromJson: _totalFromJson)
  final double tax;
  @override
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  final double total;

  @override
  String toString() {
    return 'OrderTotals(subtotal: $subtotal, shipping: $shipping, tax: $tax, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderTotalsImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, subtotal, shipping, tax, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderTotalsImplCopyWith<_$OrderTotalsImpl> get copyWith =>
      __$$OrderTotalsImplCopyWithImpl<_$OrderTotalsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderTotalsImplToJson(
      this,
    );
  }
}

abstract class _OrderTotals implements OrderTotals {
  const factory _OrderTotals(
      {@JsonKey(name: 'subtotal', fromJson: _totalFromJson)
      required final double subtotal,
      @JsonKey(name: 'shipping', fromJson: _totalFromJson)
      required final double shipping,
      @JsonKey(name: 'tax', fromJson: _totalFromJson) required final double tax,
      @JsonKey(name: 'total', fromJson: _totalFromJson)
      required final double total}) = _$OrderTotalsImpl;

  factory _OrderTotals.fromJson(Map<String, dynamic> json) =
      _$OrderTotalsImpl.fromJson;

  @override
  @JsonKey(name: 'subtotal', fromJson: _totalFromJson)
  double get subtotal;
  @override
  @JsonKey(name: 'shipping', fromJson: _totalFromJson)
  double get shipping;
  @override
  @JsonKey(name: 'tax', fromJson: _totalFromJson)
  double get tax;
  @override
  @JsonKey(name: 'total', fromJson: _totalFromJson)
  double get total;
  @override
  @JsonKey(ignore: true)
  _$$OrderTotalsImplCopyWith<_$OrderTotalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
