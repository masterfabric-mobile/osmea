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
  List<String> _selectedImages = [];

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
        allowMultiple: event.isMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        if (kIsWeb) {
          _selectedImages.clear();
          for (final file in result.files) {
            if (file.bytes != null) {
              final base64String =
                  'data:image/${file.extension};base64,${base64Encode(file.bytes!)}';
              _selectedImages.add(base64String);
            }
          }
          if (_selectedImages.isEmpty) {
            emit(OcrChequeErrorState('Dosyalar okunamadı'));
            return;
          }
          _lastImageRef = _selectedImages.first;
          add(OcrChequeProcessImageEvent(_selectedImages.first));
        } else {
          _selectedImages = result.files.map((f) => f.path!).toList();
          _lastImageRef = _selectedImages.first;
          add(OcrChequeProcessImageEvent(_selectedImages.first));
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

      if (_selectedImages.length > 1) {
        // Toplu işlem
        final results = await OcrHelper.analyzeImagesWeb(_selectedImages);
        final chequeModels = <OcrChequeModel>[];
        final allFields = <Map<String, dynamic>>[];

        for (int i = 0; i < results.length; i++) {
          final data = results[i];
          // Her item'a imageRef ekle
          data['imageRef'] = _selectedImages[i];
          if (data['documentType'] == DocumentType.cheque ||
              data['documentType'] == 'cheque' ||
              data['documentType']?.toString() == 'DocumentType.cheque') {
            final chequeFields = <String, String?>{
              'iban': data['iban'] as String?,
              'cekNo': data['cekNo'] as String?,
              'branchCode': data['branchCode'] as String?,
              'accountNumber': data['accountNumber'] as String?,
              'tcknVkn': data['tcknVkn'] as String?,
              'bankCode': data['bankCode'] as String?,
              'micrCode': data['micrCode'] as String?,
              'mersisNo': data['mersisNo'] as String?,
            };
            chequeModels.add(OcrChequeModel.fromMap(chequeFields));
            allFields.add(data);
          }
        }

        if (chequeModels.isEmpty) {
          emit(OcrChequeErrorState('Hiçbir çek bulunamadı'));
          return;
        }

        emit(OcrChequeLoadedState(chequeModels.first,
            rawText: results.first['rawText'] as String?,
            allFields: allFields.first,
            imageRef: _lastImageRef,
            batchResults: results));
      } else {
        // Tekli işlem
        Map<String, dynamic> data;
        if (kIsWeb) {
          data = await OcrChequeHelper.readChequeInfoOptimized(event.imagePath);
        } else {
          data = await OcrChequeHelper.readChequeInfo(event.imagePath);
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
          'mersisNo': data['mersisNo'] as String?,
        };
        final chequeModel = OcrChequeModel.fromMap(chequeFields);
        final rawText = data['rawText'] as String?;
        emit(OcrChequeLoadedState(chequeModel,
            rawText: rawText, allFields: data, imageRef: _lastImageRef));
      }
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
