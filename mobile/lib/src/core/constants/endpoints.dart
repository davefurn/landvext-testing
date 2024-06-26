class AppEndpoints {
  static const baseUrl = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'https://app.landvext.co/api/',
  );
  static const getAllBanks = String.fromEnvironment(
    'API_BANKS',
    defaultValue: 'http://154.113.16.142:8882/',
  );
  static const String login = 'v1/users/login/';
  static const String signUp = 'v1/users/signup-otp/';
  static const String emailSent = 'v1/users/send-reset-token/';
  static const String verifyEmail = 'v1/users/verify-otp/';
  static const String verifyEmailForgotPassword =
      'v1/users/verify-reset-token/';
  static const String resetPassword = 'v1/users/reset-password/';
  static const String emailSentSignUp = 'v1/users/send-otp/';
  static const String createSavings = 'v1/savings/';
  static const String deleteAccount = 'v1/users/delete/';
  static const String requestOtpDelete = 'v1/users/request-account-deletion/';
  static const String changePassword = 'v1/users/change-password/';
  static const String sendFeedback = 'v1/users/feedbacks/';
  static const String otpWallet =
      'v1/wallets/verify-withdrawal-to-providus-nip/';
  static const String otpSavings =
      'v1/savings/verify-withdrawal-to-providus-nip/';
}
