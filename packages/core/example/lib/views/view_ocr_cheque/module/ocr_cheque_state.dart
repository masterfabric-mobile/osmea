import 'package:core/core.dart';
import '../model/ocr_cheque_model.dart';

abstract class OcrChequeState {}

class OcrChequeInitialState extends OcrChequeState {}

class OcrChequeLoadingState extends OcrChequeState {}

class OcrChequeLoadedState extends OcrChequeState {
  final OcrChequeModel chequeData;
  final String? rawText;
  final Map<String, dynamic>? allFields;
  final String? imageRef;
  final List<Map<String, dynamic>>? batchResults;

  OcrChequeLoadedState(
    this.chequeData, {
    this.rawText,
    this.allFields,
    this.imageRef,
    this.batchResults,
  });
}

class OcrChequeErrorState extends OcrChequeState {
  final String message;
  final String? rawText;
  final DocumentType? documentType;

  OcrChequeErrorState(this.message, {this.rawText, this.documentType});
}
