// To parse this JSON data, do
//
//     final getAllTenderTransactionsResponse = getAllTenderTransactionsResponseFromJson(jsonString);

import 'package:apis/network/remote/tendertransaction/tendertransaction/freezed_model/tender_transaction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_all_tender_transactions_response.freezed.dart';
part 'get_all_tender_transactions_response.g.dart';

GetAllTenderTransactionsResponse getAllTenderTransactionsResponseFromJson(String str) =>
    GetAllTenderTransactionsResponse.fromJson(json.decode(str));

String getAllTenderTransactionsResponseToJson(GetAllTenderTransactionsResponse data) =>
    json.encode(data.toJson());

@freezed
class GetAllTenderTransactionsResponse with _$GetAllTenderTransactionsResponse {
  const factory GetAllTenderTransactionsResponse({
    @JsonKey(name: "tender_transactions") List<TenderTransaction>? tenderTransactions,
  }) = _GetAllTenderTransactionsResponse;

  factory GetAllTenderTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllTenderTransactionsResponseFromJson(json);
}