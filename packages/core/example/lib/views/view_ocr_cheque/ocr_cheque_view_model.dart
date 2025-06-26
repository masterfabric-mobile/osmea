import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'module/ocr_cheque_event.dart';
import 'module/ocr_cheque_state.dart';
import 'model/ocr_cheque_model.dart';

@injectable
class OcrChequeViewModel
    extends BaseViewModelBloc<OcrChequeEvent, OcrChequeState> {
  String? _lastImageRef;

  OcrChequeViewModel() : super(OcrChequeInitialState()) {
    on<OcrChequePickImageEvent>(_onPickImage);
    on<OcrChequeProcessImageEvent>(_onProcessImage);
  }

  Future<void> _onPickImage(
      OcrChequePickImageEvent event, Emitter<OcrChequeState> emit) async {
    try {
      emit(OcrChequeLoadingState());

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        if (kIsWeb) {
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            final base64String =
                'data:image/${result.files.single.extension};base64,${base64Encode(bytes)}';
            _lastImageRef = base64String;
            add(OcrChequeProcessImageEvent(base64String));
          } else {
            emit(OcrChequeErrorState('Dosya okunamadı'));
          }
        } else {
          _lastImageRef = result.files.single.path!;
          add(OcrChequeProcessImageEvent(result.files.single.path!));
        }
      } else {
        emit(OcrChequeInitialState());
      }
    } catch (e) {
      emit(OcrChequeErrorState('Dosya seçimi başarısız: ${e.toString()}'));
    }
  }

  Future<void> _onProcessImage(
      OcrChequeProcessImageEvent event, Emitter<OcrChequeState> emit) async {
    try {
      emit(OcrChequeLoadingState());

      Map<String, dynamic> data;

      if (kIsWeb) {
        data = await OcrHelper.readChequeInfoOptimized(event.imagePath);
      } else {
        data = await OcrHelper.readChequeInfo(event.imagePath);
      }

      _logOcrResults(data);

      final chequeFields = <String, String?>{
        'iban': data['iban'] as String?,
        'cekNo': data['cekNo'] as String?,
        'branchCode': data['branchCode'] as String?,
        'accountNumber': data['accountNumber'] as String?,
        'tcknVkn': data['tcknVkn'] as String?,
        'bankCode': data['bankCode'] as String?,
        'micrCode': data['micrCode'] as String?,
        'checkAmount': data['checkAmount'] as String?,
        'mersisNo': data['mersisNo'] as String?,
      };
      final chequeModel = OcrChequeModel.fromMap(chequeFields);
      final rawText = data['rawText'] as String?;
      emit(OcrChequeLoadedState(chequeModel,
          rawText: rawText, allFields: data, imageRef: _lastImageRef));
    } catch (e) {
      emit(OcrChequeErrorState('OCR işlemi başarısız: ${e.toString()}'));
    }
  }

  /// OCR sonuçlarını detaylı şekilde logla
  void _logOcrResults(Map<String, dynamic> data) {
    print('=== OCR SONUÇLARI ===');
    data.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        print('$key: $value');
      } else {
        print('$key: [Bulunamadı]');
      }
    });
    print('==================');
  }

  /// Görüntü önişleme testi için yardımcı method
  Future<void> testImagePreprocessing(String base64Image) async {
    try {
      if (kIsWeb) {
        // final processedImage = await OcrHelper.preprocessImage(base64Image);
        // if (processedImage != null) {
        //   print('Image preprocessing successful');
        //   // İşlenmiş görüntü ile OCR yapılabilir
        // } else {
        //   print('Image preprocessing failed');
        // }
      }
    } catch (e) {
      print('Image preprocessing error: $e');
    }
  }
}
