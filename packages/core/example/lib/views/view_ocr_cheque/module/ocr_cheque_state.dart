import '../model/ocr_cheque_model.dart';

abstract class OcrChequeState {}

class OcrChequeInitialState extends OcrChequeState {}

class OcrChequeLoadingState extends OcrChequeState {}

class OcrChequeLoadedState extends OcrChequeState {
  final OcrChequeModel chequeData;
  final String? rawText;
  final Map<String, dynamic>? allFields;
  final String? imageRef;
  OcrChequeLoadedState(this.chequeData,
      {this.rawText, this.allFields, this.imageRef});
}

class OcrChequeErrorState extends OcrChequeState {
  final String message;
  OcrChequeErrorState(this.message);
}
