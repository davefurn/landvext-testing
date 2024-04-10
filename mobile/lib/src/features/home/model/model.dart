class TransactionModel {
  TransactionModel({
    required this.id,
    required this.dateCreated,
    required this.dateModified,
    required this.internalTransactionId,
    required this.transactionType,
    required this.status,
    required this.balanceOnTransaction,
    required this.amount,
    required this.source,
    required this.destination,
    this.externalTransactionId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'],
        dateCreated: json['date_created'],
        dateModified: json['date_modified'],
        internalTransactionId: json['internal_transaction_id'],
        externalTransactionId: json['external_transaction_id'],
        transactionType: json['transaction_type'],
        status: json['status'],
        balanceOnTransaction: json['balance_on_transaction'],
        amount: json['amount'],
        source: json['source'],
        destination: json['destination'],
      );
  final int id;
  final String dateCreated;
  final String dateModified;
  final String internalTransactionId;
  final String? externalTransactionId;
  final String transactionType;
  final String status;
  final double balanceOnTransaction;
  final double amount;
  final String source;
  final String destination;
}
