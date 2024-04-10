class Token {
  Token({
    required this.refreshToken,
    required this.accessToken,
  });
  String refreshToken;
  String accessToken;

  static Token fromJson(Map<String, dynamic> data) => Token(
        refreshToken: data['refresh'],
        accessToken: data['access'],
      );
}

class LoginData {
  LoginData({
    required this.referralCode,
    required this.token,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.currentBalance,
    required this.referralPoints,
  });
  Token token;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String referralCode;
  double currentBalance;
  double referralPoints;

  static LoginData fromJson(Map<String, dynamic> data) => LoginData(
        lastName: data['last_name'],
        phoneNumber: data['phone_number'],
        token: Token.fromJson(data['token']),
        email: data['email'],
        firstName: data['first_name'],
        referralCode: data['referral_code'],
        currentBalance: data['current_balance'],
        referralPoints: data['referral_points'] ?? 0.0,
      );
}
