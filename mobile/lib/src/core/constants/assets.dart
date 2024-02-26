class LandConstants {
  static const String hasOnBoarded = 'hasOnBoarded';
  static const String quickLoginSet = 'quick_login_set';
  static const String loggedIn = 'loggedIn';
    static const String signedOut = 'signedOut';
        static const String signedUpFlag = 'signedUpFlag';
  static const String pinSet = 'pin_set';
  static final RegExp emailRegEx =
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static final RegExp checkLettersregEx = RegExp('^(?=.*?[A-Z])(?=.*?[a-z])');
  static final RegExp phoneExp = RegExp(r'^\+?0[0-9]{10}$');
  static final RegExp nameExp = RegExp('[a-zA-Z]');
}
