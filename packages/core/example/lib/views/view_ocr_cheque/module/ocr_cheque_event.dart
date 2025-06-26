abstract class OcrChequeEvent {}

class OcrChequePickImageEvent extends OcrChequeEvent {}

class OcrChequeProcessImageEvent extends OcrChequeEvent {
  final String imagePath;
  OcrChequeProcessImageEvent(this.imagePath);
}
