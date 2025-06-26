abstract class OcrChequeEvent {}

class OcrChequePickImageEvent extends OcrChequeEvent {
  final bool isMultiple;
  OcrChequePickImageEvent({this.isMultiple = false});
}

class OcrChequeProcessImageEvent extends OcrChequeEvent {
  final String imagePath;
  OcrChequeProcessImageEvent(this.imagePath);
}
