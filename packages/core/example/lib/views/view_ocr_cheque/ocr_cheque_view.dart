import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ocr_cheque_view_model.dart';
import 'module/ocr_cheque_event.dart';
import 'module/ocr_cheque_state.dart';
import 'model/ocr_cheque_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// 🚀 **Smart OCR Çek Görünümü** - Gelişmiş OCR ve filepicker entegrasyonu
class OcrChequeView
    extends MasterView<OcrChequeViewModel, OcrChequeEvent, OcrChequeState> {
  OcrChequeView(
      {super.key,
      super.appBar,
      super.arguments,
      super.currentView,
      super.snackBarFunction});

  @override
  void initialContent(OcrChequeViewModel viewModel, BuildContext context) {
    // Başlangıçta kullanıcıya filepicker tanıtımı göster
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showIntroDialog(context);
    // });
  }

  @override
  Widget viewContent(BuildContext context, OcrChequeViewModel viewModel,
      OcrChequeState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏦 Çek OCR Okuma'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.info_outline),
          //   tooltip: 'Yardım',
          // ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: _buildBody(context, viewModel, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OcrChequeViewModel viewModel,
      OcrChequeState state) {
    if (state is OcrChequeLoadingState) {
      return _buildLoadingWidget();
    } else if (state is OcrChequeErrorState) {
      return _buildErrorWidget(context, viewModel, state.message);
    } else if (state is OcrChequeLoadedState) {
      return _buildChequeData(context, viewModel, state.chequeData);
    }
    // Initial state
    return _buildInitialWidget(context, viewModel);
  }

  Widget _buildInitialWidget(
      BuildContext context, OcrChequeViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner,
            size: 120,
            color: Colors.blue.shade600,
          ),
          const SizedBox(height: 24),
          const Text(
            'Çek OCR Okuma Sistemi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Çek görselinizi seçin ve otomatik olarak çek bilgilerini çıkartalım',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.image_search, size: 28),
            label: const Text(
              'Geleneksel Çek Okuma',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(230),
              foregroundColor: Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 4,
            ),
            onPressed: () => viewModel.add(OcrChequePickImageEvent()),
          ),
          const SizedBox(height: 24),
          _buildFeatureCards(),
          const SizedBox(height: 16),
          _buildTipCard(),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Çek okunuyor...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lütfen bekleyin, görsel işleniyor',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(
      BuildContext context, OcrChequeViewModel viewModel, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'Hata Oluştu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () => viewModel.add(OcrChequePickImageEvent()),
          ),
        ],
      ),
    );
  }

  Widget _buildChequeData(
      BuildContext context, OcrChequeViewModel viewModel, OcrChequeModel data) {
    final state = viewModel.state;
    String? rawText;
    Map<String, dynamic>? allFields;
    String? imageRef;
    if (state is OcrChequeLoadedState) {
      rawText = state.rawText;
      allFields = state.allFields;
      imageRef = state.imageRef;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageRef != null && imageRef.isNotEmpty) ...[
            Center(
              child: kIsWeb
                  ? Image.memory(
                      Uri.parse(imageRef).data!.contentAsBytes(),
                      width: 320,
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      File(imageRef),
                      width: 320,
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(height: 16),
          ],
          if (rawText != null && rawText.isNotEmpty) ...[
            Card(
              color: Colors.yellow.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tüm OCR Metni:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SelectableText(rawText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (allFields != null && allFields.isNotEmpty) ...[
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tüm Tespit Edilen Alanlar:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...allFields.entries
                        .where((e) => e.key != 'rawText')
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text('${e.key}: ${e.value ?? "-"}'),
                            )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Çek Bilgileri Kartı
          Builder(
            builder: (context) {
              final subeKodu = data.branchCode?.isNotEmpty == true
                  ? data.branchCode
                  : (allFields?['subeKodu'] as String?);
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Çek Bilgileri',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildEnhancedField(
                          'IBAN', data.iban, Icons.account_balance,
                          copyable: true),
                      _buildEnhancedField(
                          'Çek No', data.cekNo, Icons.confirmation_number,
                          copyable: true),
                      _buildEnhancedField(
                          'Banka Kodu', data.bankCode, Icons.business,
                          copyable: true),
                      _buildEnhancedField(
                          'Şube Kodu', subeKodu, Icons.location_on,
                          copyable: true),
                      _buildEnhancedField('Hesap No', data.accountNumber,
                          Icons.account_balance_wallet,
                          copyable: true),
                      _buildEnhancedField(
                          'TCKN/VKN', data.tcknVkn, Icons.person,
                          copyable: true),
                      _buildEnhancedField(
                          'MICR Kodu', data.micrCode, Icons.qr_code,
                          copyable: true),
                      _buildEnhancedField(
                          'Çek Tutarı', data.checkAmount, Icons.attach_money,
                          copyable: true),
                      _buildEnhancedField(
                          'Mersis No', data.mersisNo, Icons.numbers,
                          copyable: true),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yeni Görsel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => viewModel.add(OcrChequePickImageEvent()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.copy_all),
                  label: const Text('Hepsini Kopyala'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _copyAllData(context, data),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedField(String label, String? value, IconData icon,
      {bool copyable = false}) {
    final hasValue = value != null && value.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasValue ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasValue ? Colors.green.shade200 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: hasValue ? Colors.green.shade600 : Colors.grey.shade500,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  hasValue ? value : 'Bulunamadı',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                    color: hasValue ? Colors.black87 : Colors.grey.shade500,
                    fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          if (hasValue && copyable)
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.copy,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
                onPressed: () => _copyToClipboard(context, label, value),
                tooltip: 'Kopyala',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber.shade600,
                ),
                const SizedBox(width: 8),
                const Text(
                  'İpucu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'En iyi sonuç için çekin tamamının görsel içinde olduğundan ve net olduğundan emin olun.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    // Kullanıcıya feedback ver
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label kopyalandı: $value'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  void _copyAllData(BuildContext context, OcrChequeModel data) {
    final buffer = StringBuffer();
    buffer.writeln('=== ÇEK BİLGİLERİ ===');
    if (data.iban != null) buffer.writeln('IBAN: ${data.iban}');
    if (data.cekNo != null) buffer.writeln('Çek No: ${data.cekNo}');
    if (data.bankCode != null) buffer.writeln('Banka Kodu: ${data.bankCode}');
    if (data.branchCode != null)
      buffer.writeln('Şube Kodu: ${data.branchCode}');
    if (data.accountNumber != null)
      buffer.writeln('Hesap No: ${data.accountNumber}');
    if (data.tcknVkn != null) buffer.writeln('TCKN/VKN: ${data.tcknVkn}');
    if (data.micrCode != null) buffer.writeln('MICR Kodu: ${data.micrCode}');
    if (data.checkAmount != null)
      buffer.writeln('Çek Tutarı: ${data.checkAmount}');
    if (data.mersisNo != null) buffer.writeln('Mersis No: ${data.mersisNo}');
    buffer.writeln('==================');

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tüm çek bilgileri kopyalandı'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  /// 🎯 **Özellik Kartları**
  Widget _buildFeatureCards() {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureCard(
            icon: Icons.auto_awesome,
            title: 'Akıllı Analiz',
            description: 'Form alanlarını otomatik tespit eder',
            color: Colors.purple.shade100,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFeatureCard(
            icon: Icons.speed,
            title: 'Hızlı İşlem',
            description: 'Paralel işleme ile daha hızlı',
            color: Colors.green.shade100,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFeatureCard(
            icon: Icons.high_quality,
            title: 'Yüksek Doğruluk',
            description: 'Context7 optimizasyonu',
            color: Colors.orange.shade100,
          ),
        ),
      ],
    );
  }

  /// 🏷️ **Özellik Kartı Widget**
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(128)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
