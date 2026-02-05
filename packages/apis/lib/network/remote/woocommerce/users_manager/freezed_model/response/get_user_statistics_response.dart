import 'package:freezed_annotation/freezed_annotation.dart';
import 'get_user_dashboard_response.dart';

part 'get_user_statistics_response.freezed.dart';
part 'get_user_statistics_response.g.dart';

/// 📈 Get User Statistics Response Model
@freezed
class GetUserStatisticsResponse with _$GetUserStatisticsResponse {
  const factory GetUserStatisticsResponse({
    @JsonKey(name: 'metadata_count') required int metadataCount,
    @JsonKey(name: 'contracts_count') required int contractsCount,
    @JsonKey(name: 'addresses_count') required int addressesCount,
    @JsonKey(name: 'preferences_count') required int preferencesCount,
    @JsonKey(name: 'activity_count') required int activityCount,
    @JsonKey(name: 'orders_count') int? ordersCount,
    @JsonKey(name: 'orders_total') double? ordersTotal,
    @JsonKey(name: 'orders_by_status') Map<String, int>? ordersByStatus,
  }) = _GetUserStatisticsResponse;

  factory GetUserStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserStatisticsResponseFromJson(json);
}
