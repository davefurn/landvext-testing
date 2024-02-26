class AccountProvidusValidate {
  AccountProvidusValidate({
    required this.accountNumber,
    required this.status,
    required this.amount,
  });

  // Named constructor that takes a Map as a parameter
  AccountProvidusValidate.fromJson(Map<String, dynamic> data)
      : accountNumber = data['account_number'],
        amount = data['amount'],
        status = data['status'];

  final String status;
  final double amount;
  final String accountNumber;
}
