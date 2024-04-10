class BankTransaction {
  BankTransaction({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.date,
    required this.time,
  });

  // Factory method to create an instance from a Map
  factory BankTransaction.fromJson(Map<String, dynamic> json) =>
      BankTransaction(
        bank: json['bank'] ?? '',
        accountNumber: json['accountNumber'] ?? '',
        accountName: json['accountName'] ?? '',
        amount: double.parse(json['amount'] ?? '0.0'),
        date: json['date'] ?? '',
        time: json['time'] ?? '',
      );
  final String bank;
  final String accountNumber;
  final String accountName;
  final double amount;
  final String date;
  final String time;

  // Convert the model instance to a Map
  Map<String, dynamic> toJson() => {
        'bank': bank,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'amount': amount.toStringAsFixed(2),
        'date': date,
        'time': time,
      };
}
