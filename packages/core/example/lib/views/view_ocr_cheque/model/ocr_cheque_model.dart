class OcrChequeModel {
  final String? iban;
  final String? cekNo;
  final String? branchCode;
  final String? accountNumber;
  final String? tcknVkn;
  final String? bankCode;
  final String? micrCode;
  final String? checkAmount;
  final String? mersisNo;

  OcrChequeModel({
    this.iban,
    this.cekNo,
    this.branchCode,
    this.accountNumber,
    this.tcknVkn,
    this.bankCode,
    this.micrCode,
    this.checkAmount,
    this.mersisNo,
  });

  factory OcrChequeModel.fromMap(Map<String, String?> map) {
    return OcrChequeModel(
      iban: map['iban'],
      cekNo: map['cekNo'],
      branchCode: map['branchCode'],
      accountNumber: map['accountNumber'],
      tcknVkn: map['tcknVkn'],
      bankCode: map['bankCode'],
      micrCode: map['micrCode'],
      checkAmount: map['checkAmount'],
      mersisNo: map['mersisNo'],
    );
  }
}
