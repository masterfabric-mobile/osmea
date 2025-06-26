import 'package:flutter/foundation.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'ocr_cheque_helper.dart';
import 'package:js/js.dart';
import 'dart:js_util';

@JS('flutter_tesseract_ocr.recognizeTextFromBase64')
external Object _recognizeTextFromBase64(String base64Image);

enum DocumentType { cheque, other }

class OcrHelper {
  /// Mobile: OCR + belge tipi kontrolü + alan çıkarımı
  static Future<Map<String, dynamic>> processImage(String imagePath) async {
    String ocrText = await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'tur',
    );
    // Anahtar kelime kontrolü (erken çıkış)
    final keywordGroups = [
      ['çek', 'cheque', 'check', 'çek', 'çeque', 'cek'],
      ['iban'],
      ['şube', 'sube'],
      ['banka', 'bank'],
      ['no', 'seri'],
      ['tl', '₺']
    ];
    final lowerText = ocrText.toLowerCase();
    bool hasAnyKeyword =
        keywordGroups.any((group) => group.any((k) => lowerText.contains(k)));
    if (!hasAnyKeyword) {
      return {
        'rawText': ocrText,
        'documentType': DocumentType.other,
        'keywordCheck': false,
      };
    }
    final fields = OcrChequeHelper.extractChequeFields(ocrText);
    final isCheque = OcrChequeHelper.isChequeText(ocrText, fields);
    return {
      'rawText': ocrText,
      'documentType': isCheque ? DocumentType.cheque : DocumentType.other,
      ...fields,
      'keywordCheck': true,
    };
  }

  /// Web: OCR + belge tipi kontrolü + alan çıkarımı
  static Future<Map<String, dynamic>> processImageWeb(
      String base64Image) async {
    if (!kIsWeb) throw Exception('processImageWeb sadece web içindir.');
    String ocrText = '';
    try {
      final result =
          await promiseToFuture<String>(_recognizeTextFromBase64(base64Image));
      ocrText = result;
    } catch (e) {
      ocrText = '';
    }
    // Anahtar kelime kontrolü (erken çıkış)
    final keywordGroups = [
      ['çek', 'cheque', 'check', 'çek', 'çeque', 'cek'],
      ['iban'],
      ['şube', 'sube'],
      ['banka', 'bank'],
      ['no', 'seri'],
      ['tl', '₺']
    ];
    final lowerText = ocrText.toLowerCase();
    bool hasAnyKeyword =
        keywordGroups.any((group) => group.any((k) => lowerText.contains(k)));
    if (!hasAnyKeyword) {
      return {
        'rawText': ocrText,
        'documentType': DocumentType.other,
        'keywordCheck': false,
      };
    }
    final fields = OcrChequeHelper.extractChequeFields(ocrText);
    final isCheque = OcrChequeHelper.isChequeText(ocrText, fields);
    return {
      'rawText': ocrText,
      'documentType': isCheque ? DocumentType.cheque : DocumentType.other,
      ...fields,
      'keywordCheck': true,
    };
  }

  /// Web: Toplu çek analizi
  static Future<List<Map<String, dynamic>>> analyzeImagesWeb(
      List<String> base64Images) async {
    if (!kIsWeb) throw Exception('analyzeImagesWeb sadece web içindir.');

    final results = <Map<String, dynamic>>[];
    for (final base64Image in base64Images) {
      try {
        final result = await processImageWeb(base64Image);
        results.add(result);
      } catch (e) {
        print('Image analysis error: $e');
        results.add({
          'rawText': '',
          'documentType': DocumentType.other,
          'error': e.toString()
        });
      }
    }
    return results;
  }
}
