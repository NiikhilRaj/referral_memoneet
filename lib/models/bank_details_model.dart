class BankDetails {
  String accountHolderName;
  String accountNumber;
  String ifscCode;
  String bankName;
  String branch;

  BankDetails({
    this.accountHolderName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.bankName = '',
    this.branch = '',
  });

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