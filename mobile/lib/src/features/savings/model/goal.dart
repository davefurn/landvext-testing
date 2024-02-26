class Goal {
  Goal({
    required this.id,
    required this.dateCreated,
    required this.dateModified,
    required this.savingsType,
    required this.depositFrequency,
    required this.target,
    required this.withdrawalDate,
    required this.currentBalance,
    this.shortDescription,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['id'],
        dateCreated: json['date_created'],
        dateModified: json['date_modified'],
        savingsType: json['savings_type'],
        shortDescription: json['short_description'],
        depositFrequency: json['deposit_frequency'],
        target: json['target'],
        withdrawalDate: json['withdrawal_date'],
        currentBalance: json['current_balance'],
      );
  final int id;
  final String dateCreated;
  final String dateModified;
  final String savingsType;
  final String? shortDescription;
  final String depositFrequency;
  final double target;
  final String withdrawalDate;
  double currentBalance;
}
