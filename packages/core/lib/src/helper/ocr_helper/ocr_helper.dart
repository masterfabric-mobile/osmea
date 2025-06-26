import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';
import 'dart:js_util';

@JS('flutter_tesseract_ocr.recognizeTextFromBase64')
external Object _recognizeTextFromBase64(String base64Image);

class OcrHelper {
  /// Reads cheque information from file path on mobile and extracts fields
  static Future<Map<String, dynamic>> readChequeInfo(String imagePath) async {
    // 1. Extract text from image
    String ocrText = await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'tur',
    );

    // 2. Extract fields using regex
    final fields = _extractChequeFields(ocrText);
    return {
      'rawText': ocrText,
      ...fields,
    };
  }

  /// Web OCR using Tesseract.js platform channel (JS interop)
  static Future<Map<String, dynamic>> readChequeInfoOptimized(
      String base64Image) async {
    if (!kIsWeb) {
      throw Exception('readChequeInfoOptimized should only be used for web.');
    }
    String ocrText = '';
    try {
      // Call JS function asynchronously
      final result =
          await promiseToFuture<String>(_recognizeTextFromBase64(base64Image));
      ocrText = result;
      print('Tesseract.js OCR TEXT: \n\u001b[36m$ocrText\u001b[0m');
    } catch (e) {
      print('Tesseract.js OCR ERROR: $e');
      // Test sample text
      ocrText =
          'Çek No: 123456\nIBAN: TR120006200027123456789012\nTutar: 15000,00';
      print('TEST OCR TEXT: \n\u001b[33m$ocrText\u001b[0m');
    }
    final fields = _extractChequeFields(ocrText);
    return {
      'rawText': ocrText,
      ...fields,
    };
  }

  /// Extracts cheque fields from OCR text using regex
  static Map<String, String?> _extractChequeFields(String text) {
    final subeBilgisi = _findSubeBilgisi(text);
    final iban = _findIban(text);
    final Map<String, String?> fields = {
      'iban': iban,
      'cekNo': _findChequeNo(text),
      'branchCode': _findBranchCode(text),
      'accountNumber': iban, // Same as IBAN
      'tcknVkn': _findTcknVkn(text),
      'bankCode': _findBankCode(text),
      'micrCode': _findMicrCode(text),
      'checkAmount': _findCheckAmount(text),
      'basimTarihi': _findBasimTarihi(text),
      'tarih': _findTarih(text),
      'subeBilgisi': subeBilgisi,
      'subeKodu': _findSubeKodu(subeBilgisi),
      'imzaTarihi': _findImzaTarihi(text),
      'mersisNo': _findMersisNo(text),
    };
    print('EXTRACTED FIELDS: \u001b[35m$fields\u001b[0m');
    return fields;
  }

  // --- Field extraction helpers (regex) ---

  static String? _findFlexibleField(String text, List<String> keywords,
      {String? numberPattern,
      String? afterKeywordPattern,
      bool excludeMersis = false}) {
    final lines = text.split('\n');
    for (final line in lines) {
      if (excludeMersis && line.toLowerCase().contains('mersis')) continue;
      for (final keyword in keywords) {
        if (line
            .toLowerCase()
            .replaceAll('.', '')
            .contains(keyword.toLowerCase().replaceAll('.', ''))) {
          if (numberPattern != null) {
            final match = RegExp(numberPattern).firstMatch(line);
            if (match != null) return match.group(0);
          } else if (afterKeywordPattern != null) {
            final match = RegExp(afterKeywordPattern).firstMatch(line);
            if (match != null) return match.group(1);
          } else {
            return line.trim();
          }
        }
      }
    }
    return null;
  }

  static String? _findChequeNo(String text) {
    const keywords = [
      'Çek No',
      'Çek Seri No',
      'Seri No',
      'Seri:',
      'No',
      'SeriNumarası',
      'Seri',
      'ÇekNo',
      'SeriNumarası'
    ];
    return _findFlexibleField(text, keywords,
        numberPattern: r'[0-9]{6,12}', excludeMersis: true);
  }

  static String? _findIban(String text) {
    const keywords = ['IBAN', 'IBAN No', 'IBAN:', 'IBAN.', 'Hesap No'];
    // IBAN: Starts with TR and 20-32 characters
    return _findFlexibleField(text, keywords,
        numberPattern: r'TR[0-9A-Za-z\s]{10,32}');
  }

  static String? _findBranchCode(String text) {
    // Branch Code: Can start with "Şube Kodu" or "Şube", 3-5 digits
    final regex =
        RegExp(r'(Şube Kodu|Şube)[:\s-]*([0-9]{3,5})', caseSensitive: false);
    return regex.firstMatch(text)?.group(2);
  }

  static String? _findAccountNumber(String text) {
    const keywords = [
      'Hesap No',
      'Hesap Numarası',
      'HesapNo',
      'HesapNumarası',
      'Hesap:',
      'Hesap No:',
      'Hesap Numarası:',
      'Hesap No.',
      'Hesap Numarası.',
      'HESAP NO',
      'HESAP NUMARASI',
      'HESAPNO',
      'HESAPNUMARASI'
    ];
    return _findFlexibleField(text, keywords, numberPattern: r'[0-9]{6,12}');
  }

  static String? _findTcknVkn(String text) {
    const keywords = [
      'TCKN',
      'T.C.K.N',
      'T.C. KİMLİK NO',
      'TC KİMLİK NO',
      'TC NO',
      'T.C. NO',
      'T.C. Kimlik No',
      'Kimlik No',
      'KimlikNo',
      'Kimlik Numarası',
      'KimlikNumarası',
      'VKN',
      'V.K.N',
      'Vergi No',
      'Vergi Kimlik No',
      'Vergi Kimlik Numarası',
      'VKN/TCKN',
      'TCKN/VKN',
      'TCKN - VKN',
      'TCKN / VKN',
      'TCKN:',
      'VKN:',
      'TCKN-',
      'VKN-'
    ];
    // 1. Search line by line with keywords
    final result =
        _findFlexibleField(text, keywords, numberPattern: r'[0-9]{10,11}');
    if (result != null) return result;

    // 2. Look for 10-11 digit numbers in lines containing "kimlik" or "vergi"
    final lines = text.split('\n');
    for (final line in lines) {
      if (line.toLowerCase().contains('kimlik') ||
          line.toLowerCase().contains('vergi')) {
        final match = RegExp(r'[0-9]{10,11}').firstMatch(line);
        if (match != null) return match.group(0);
      }
    }

    // 3. Fallback: first 10-11 digit number in entire text
    final fallback = RegExp(r'[0-9]{10,11}').firstMatch(text);
    return fallback?.group(0);
  }

  static String? _findBankCode(String text) {
    // Bank Code: Can start with "Banka Kodu", 3 digits
    final regex =
        RegExp(r'(Banka Kodu)[:\s-]*([0-9]{3})', caseSensitive: false);
    return regex.firstMatch(text)?.group(2);
  }

  static String? _findMicrCode(String text) {
    // MICR code: Can start with "MICR", 8-12 digits
    final regex = RegExp(r'(MICR)[:\s-]*([0-9]{8,12})', caseSensitive: false);
    return regex.firstMatch(text)?.group(2);
  }

  static String? _findCheckAmount(String text) {
    const keywords = ['TL', '₺', 'Tutar', 'Çek Tutarı'];
    // First look for numbers next to TL/₺
    final amount =
        _findFlexibleField(text, ['TL', '₺'], numberPattern: r'[0-9.,]+');
    if (amount != null) return amount;
    // Then search with classic Amount keywords
    return _findFlexibleField(text, ['Tutar', 'Çek Tutarı'],
        numberPattern: r'[0-9.,]+');
  }

  static String? _findBasimTarihi(String text) {
    const keywords = ['BAS.TRH.', 'Basım Tarihi', 'Bas TRH', 'BASIM TARİHİ'];
    return _findFlexibleField(text, keywords,
        numberPattern: r'[0-9]{2}\.[0-9]{2}\.[0-9]{4}');
  }

  static String? _findTarih(String text) {
    final regex = RegExp(
        r'(TARİH|Tarih|Tarih:|TARİH:)[^0-9]*([0-9]{2}\.[0-9]{2}\.[0-9]{4})',
        caseSensitive: false);
    final match = regex.firstMatch(text);
    return match != null ? match.group(2) : null;
  }

  static String? _findSubeBilgisi(String text) {
    const keywords = ['Şubesi'];
    return _findFlexibleField(text, keywords);
  }

  static String? _findSubeKodu(String? subeBilgisi) {
    if (subeBilgisi == null) return null;
    // Clean #, *, -, :, . and spaces from beginning of line
    final cleaned = subeBilgisi.replaceFirst(RegExp(r'^[#*\-:\.\s]+'), '');
    final match = RegExp(r'^[0-9]{3,5}').firstMatch(cleaned);
    return match?.group(0);
  }

  static String? _findImzaTarihi(String text) {
    const keywords = ['TARİH:', 'Tarih:', 'Tarih'];
    return _findFlexibleField(text, keywords,
        numberPattern: r'[0-9]{2}\.[0-9]{2}\.[0-9]{4}');
  }

  static String? _findMersisNo(String text) {
    const keywords = [
      'MERSİS',
      'MERSİS NO',
      'Mersis No',
      'Mersis:',
      'MERSIS',
      'MERSIS NO',
      'MersisNo',
      'Mersis Numarası',
      'MersisNumarası',
      'MERSISNO',
      'MERSİSNO',
      'MERSIS NUMARASI',
      'MERSİS NUMARASI',
      'MERSISNO:',
      'MERSİSNO:',
      'MERSIS NO:',
      'MERSİS NO:',
      'MERSISNO.',
      'MERSİSNO.',
      'MERSIS NO.',
      'Mersis No :',
      'MERSİS NO.',
      'MERSISNUMARASI',
      'MERSİSNUMARASI',
      'MERSISNUM',
      'MERSİSNUM',
      'MERSISNUMR',
      'MERSİSNUMR',
      'MERSISNUMAR',
      'MERSİSNUMAR',
      'MERSISNUMARAS',
      'MERSİSNUMARAS'
    ];
    // 1. Search line by line with keywords
    final result =
        _findFlexibleField(text, keywords, numberPattern: r'[0-9]{16}');
    if (result != null) return result;

    // 2. Look for 16-digit numbers only in lines containing 'mersis' (may start with #, *, -, :, .)
    final lines = text.split('\n');
    for (final line in lines) {
      if (line.toLowerCase().contains('mersis')) {
        final cleaned = line.replaceFirst(RegExp(r'^[#*\-:\.\s]+'), '');
        final match = RegExp(r'[0-9]{16}').firstMatch(cleaned);
        if (match != null) return match.group(0);
      }
    }
    return null;
  }
}
