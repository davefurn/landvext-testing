class UserModels {
  UserModels({
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.referralPoints,
    required this.referralCode,
    this.otp,
    this.username,
    this.loginPin,
    this.transactionPin,
    this.currentBalance,
  });

  factory UserModels.fromMap(Map<String, dynamic> map) => UserModels(
        email: map['email'] ?? '',
        phoneNumber: map['phone_number'] ?? '',
        firstName: map['first_name'] ?? '',
        lastName: map['last_name'] ?? '',
        username: map['username'] ?? '',
        otp: map['otp'] ?? 0,
        referralCode: map['referral_code'] ?? '',
        loginPin: map['login_pin'] ?? '',
        transactionPin: map['transaction_pin'] ?? '',
        referralPoints: map['referral_points'] ?? 0.0,
        currentBalance: map['current_balance'] ?? 0.0,
      );
  String email;
  String phoneNumber;
  String firstName;
  String lastName;
  String? username;
  int? otp;
  String referralCode;
  String? loginPin;
  String? transactionPin;
  double referralPoints;
  double? currentBalance;
}
