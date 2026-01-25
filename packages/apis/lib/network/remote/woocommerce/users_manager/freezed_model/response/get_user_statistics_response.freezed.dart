// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_statistics_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserStatisticsResponse _$GetUserStatisticsResponseFromJson(
    Map<String, dynamic> json) {
  return _GetUserStatisticsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserStatisticsResponse {
  @JsonKey(name: 'metadata_count')
  int get metadataCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'contracts_count')
  int get contractsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'addresses_count')
  int get addressesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferences_count')
  int get preferencesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_count')
  int get activityCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_count')
  int? get ordersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_total')
  double? get ordersTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_by_status')
  Map<String, int>? get ordersByStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetUserStatisticsResponseCopyWith<GetUserStatisticsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserStatisticsResponseCopyWith<$Res> {
  factory $GetUserStatisticsResponseCopyWith(GetUserStatisticsResponse value,
          $Res Function(GetUserStatisticsResponse) then) =
      _$GetUserStatisticsResponseCopyWithImpl<$Res, GetUserStatisticsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'metadata_count') int metadataCount,
      @JsonKey(name: 'contracts_count') int contractsCount,
      @JsonKey(name: 'addresses_count') int addressesCount,
      @JsonKey(name: 'preferences_count') int preferencesCount,
      @JsonKey(name: 'activity_count') int activityCount,
      @JsonKey(name: 'orders_count') int? ordersCount,
      @JsonKey(name: 'orders_total') double? ordersTotal,
      @JsonKey(name: 'orders_by_status') Map<String, int>? ordersByStatus});
}

/// @nodoc
class _$GetUserStatisticsResponseCopyWithImpl<$Res,
        $Val extends GetUserStatisticsResponse>
    implements $GetUserStatisticsResponseCopyWith<$Res> {
  _$GetUserStatisticsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadataCount = null,
    Object? contractsCount = null,
    Object? addressesCount = null,
    Object? preferencesCount = null,
    Object? activityCount = null,
    Object? ordersCount = freezed,
    Object? ordersTotal = freezed,
    Object? ordersByStatus = freezed,
  }) {
    return _then(_value.copyWith(
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
      contractsCount: null == contractsCount
          ? _value.contractsCount
          : contractsCount // ignore: cast_nullable_to_non_nullable
              as int,
      addressesCount: null == addressesCount
          ? _value.addressesCount
          : addressesCount // ignore: cast_nullable_to_non_nullable
              as int,
      preferencesCount: null == preferencesCount
          ? _value.preferencesCount
          : preferencesCount // ignore: cast_nullable_to_non_nullable
              as int,
      activityCount: null == activityCount
          ? _value.activityCount
          : activityCount // ignore: cast_nullable_to_non_nullable
              as int,
      ordersCount: freezed == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      ordersTotal: freezed == ordersTotal
          ? _value.ordersTotal
          : ordersTotal // ignore: cast_nullable_to_non_nullable
              as double?,
      ordersByStatus: freezed == ordersByStatus
          ? _value.ordersByStatus
          : ordersByStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetUserStatisticsResponseImplCopyWith<$Res>
    implements $GetUserStatisticsResponseCopyWith<$Res> {
  factory _$$GetUserStatisticsResponseImplCopyWith(
          _$GetUserStatisticsResponseImpl value,
          $Res Function(_$GetUserStatisticsResponseImpl) then) =
      __$$GetUserStatisticsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'metadata_count') int metadataCount,
      @JsonKey(name: 'contracts_count') int contractsCount,
      @JsonKey(name: 'addresses_count') int addressesCount,
      @JsonKey(name: 'preferences_count') int preferencesCount,
      @JsonKey(name: 'activity_count') int activityCount,
      @JsonKey(name: 'orders_count') int? ordersCount,
      @JsonKey(name: 'orders_total') double? ordersTotal,
      @JsonKey(name: 'orders_by_status') Map<String, int>? ordersByStatus});
}

/// @nodoc
class __$$GetUserStatisticsResponseImplCopyWithImpl<$Res>
    extends _$GetUserStatisticsResponseCopyWithImpl<$Res,
        _$GetUserStatisticsResponseImpl>
    implements _$$GetUserStatisticsResponseImplCopyWith<$Res> {
  __$$GetUserStatisticsResponseImplCopyWithImpl(
      _$GetUserStatisticsResponseImpl _value,
      $Res Function(_$GetUserStatisticsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadataCount = null,
    Object? contractsCount = null,
    Object? addressesCount = null,
    Object? preferencesCount = null,
    Object? activityCount = null,
    Object? ordersCount = freezed,
    Object? ordersTotal = freezed,
    Object? ordersByStatus = freezed,
  }) {
    return _then(_$GetUserStatisticsResponseImpl(
      metadataCount: null == metadataCount
          ? _value.metadataCount
          : metadataCount // ignore: cast_nullable_to_non_nullable
              as int,
      contractsCount: null == contractsCount
          ? _value.contractsCount
          : contractsCount // ignore: cast_nullable_to_non_nullable
              as int,
      addressesCount: null == addressesCount
          ? _value.addressesCount
          : addressesCount // ignore: cast_nullable_to_non_nullable
              as int,
      preferencesCount: null == preferencesCount
          ? _value.preferencesCount
          : preferencesCount // ignore: cast_nullable_to_non_nullable
              as int,
      activityCount: null == activityCount
          ? _value.activityCount
          : activityCount // ignore: cast_nullable_to_non_nullable
              as int,
      ordersCount: freezed == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      ordersTotal: freezed == ordersTotal
          ? _value.ordersTotal
          : ordersTotal // ignore: cast_nullable_to_non_nullable
              as double?,
      ordersByStatus: freezed == ordersByStatus
          ? _value._ordersByStatus
          : ordersByStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserStatisticsResponseImpl implements _GetUserStatisticsResponse {
  const _$GetUserStatisticsResponseImpl(
      {@JsonKey(name: 'metadata_count') required this.metadataCount,
      @JsonKey(name: 'contracts_count') required this.contractsCount,
      @JsonKey(name: 'addresses_count') required this.addressesCount,
      @JsonKey(name: 'preferences_count') required this.preferencesCount,
      @JsonKey(name: 'activity_count') required this.activityCount,
      @JsonKey(name: 'orders_count') this.ordersCount,
      @JsonKey(name: 'orders_total') this.ordersTotal,
      @JsonKey(name: 'orders_by_status')
      final Map<String, int>? ordersByStatus})
      : _ordersByStatus = ordersByStatus;

  factory _$GetUserStatisticsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserStatisticsResponseImplFromJson(json);

  @override
  @JsonKey(name: 'metadata_count')
  final int metadataCount;
  @override
  @JsonKey(name: 'contracts_count')
  final int contractsCount;
  @override
  @JsonKey(name: 'addresses_count')
  final int addressesCount;
  @override
  @JsonKey(name: 'preferences_count')
  final int preferencesCount;
  @override
  @JsonKey(name: 'activity_count')
  final int activityCount;
  @override
  @JsonKey(name: 'orders_count')
  final int? ordersCount;
  @override
  @JsonKey(name: 'orders_total')
  final double? ordersTotal;
  final Map<String, int>? _ordersByStatus;
  @override
  @JsonKey(name: 'orders_by_status')
  Map<String, int>? get ordersByStatus {
    final value = _ordersByStatus;
    if (value == null) return null;
    if (_ordersByStatus is EqualUnmodifiableMapView) return _ordersByStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GetUserStatisticsResponse(metadataCount: $metadataCount, contractsCount: $contractsCount, addressesCount: $addressesCount, preferencesCount: $preferencesCount, activityCount: $activityCount, ordersCount: $ordersCount, ordersTotal: $ordersTotal, ordersByStatus: $ordersByStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserStatisticsResponseImpl &&
            (identical(other.metadataCount, metadataCount) ||
                other.metadataCount == metadataCount) &&
            (identical(other.contractsCount, contractsCount) ||
                other.contractsCount == contractsCount) &&
            (identical(other.addressesCount, addressesCount) ||
                other.addressesCount == addressesCount) &&
            (identical(other.preferencesCount, preferencesCount) ||
                other.preferencesCount == preferencesCount) &&
            (identical(other.activityCount, activityCount) ||
                other.activityCount == activityCount) &&
            (identical(other.ordersCount, ordersCount) ||
                other.ordersCount == ordersCount) &&
            (identical(other.ordersTotal, ordersTotal) ||
                other.ordersTotal == ordersTotal) &&
            const DeepCollectionEquality()
                .equals(other._ordersByStatus, _ordersByStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      metadataCount,
      contractsCount,
      addressesCount,
      preferencesCount,
      activityCount,
      ordersCount,
      ordersTotal,
      const DeepCollectionEquality().hash(_ordersByStatus));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserStatisticsResponseImplCopyWith<_$GetUserStatisticsResponseImpl>
      get copyWith => __$$GetUserStatisticsResponseImplCopyWithImpl<
          _$GetUserStatisticsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserStatisticsResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserStatisticsResponse implements GetUserStatisticsResponse {
  const factory _GetUserStatisticsResponse(
      {@JsonKey(name: 'metadata_count') required final int metadataCount,
      @JsonKey(name: 'contracts_count') required final int contractsCount,
      @JsonKey(name: 'addresses_count') required final int addressesCount,
      @JsonKey(name: 'preferences_count') required final int preferencesCount,
      @JsonKey(name: 'activity_count') required final int activityCount,
      @JsonKey(name: 'orders_count') final int? ordersCount,
      @JsonKey(name: 'orders_total') final double? ordersTotal,
      @JsonKey(name: 'orders_by_status')
      final Map<String, int>?
          ordersByStatus}) = _$GetUserStatisticsResponseImpl;

  factory _GetUserStatisticsResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserStatisticsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'metadata_count')
  int get metadataCount;
  @override
  @JsonKey(name: 'contracts_count')
  int get contractsCount;
  @override
  @JsonKey(name: 'addresses_count')
  int get addressesCount;
  @override
  @JsonKey(name: 'preferences_count')
  int get preferencesCount;
  @override
  @JsonKey(name: 'activity_count')
  int get activityCount;
  @override
  @JsonKey(name: 'orders_count')
  int? get ordersCount;
  @override
  @JsonKey(name: 'orders_total')
  double? get ordersTotal;
  @override
  @JsonKey(name: 'orders_by_status')
  Map<String, int>? get ordersByStatus;
  @override
  @JsonKey(ignore: true)
  _$$GetUserStatisticsResponseImplCopyWith<_$GetUserStatisticsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
