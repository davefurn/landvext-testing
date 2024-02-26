class AccountProvidus {
  AccountProvidus({
    required this.accountNumber,
    required this.accountName,
    required this.initiationTranRef,
  });

  // Named constructor that takes a Map as a parameter
  AccountProvidus.fromJson(Map<String, dynamic> data)
      : accountNumber = data['account_number'],
        accountName = data['account_name'],
        initiationTranRef = data['initiationTranRef'];

  final String accountNumber;
  final String accountName;
  final String initiationTranRef;
}
