class BankDetails {
  String type;
  String accountHolderName;
  String accountNumber;
  String ifscCode;
  String bankName;
  String branch;

  BankDetails({
    this.type = 'BANK',
    this.accountHolderName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.bankName = '',
    this.branch = '',
  });

  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      accountHolderName: map['accountHolderName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      bankName: map['bankName'] ?? '',
      branch: map['branch'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'branch': branch,
    };
  }
}
