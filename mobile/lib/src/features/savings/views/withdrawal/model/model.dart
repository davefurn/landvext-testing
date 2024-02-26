class Bank {
  Bank({required this.bankCode, required this.bankName});
  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankCode: json['bankCode'],
        bankName: json['bankName'],
      );
  final String bankCode;
  final String bankName;
}
