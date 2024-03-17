enum AppRoutes {
  home(
    name: 'home',
    path: '/home',
    redirect: '/onboarding',
  ),
  savings(
    name: 'savings',
    path: '/savings',
  ),
  goalCreation(
    name: 'goalCreation',
    path: 'goalCreation',
  ),
  sell(
    name: 'sell',
    path: 'sell',
  ),
    properties(
    name: 'properties',
    path: 'properties',
  ),
  deleteAccount(
    name: 'deleteAccount',
    path: 'deleteAccount',
  ),
    requestDeleteAccount(
    name: 'requestDeleteAccount',
    path: 'requestDeleteAccount',
  ),
    myProperties(
    name: 'myProperties',
    path: 'myProperties',
  ),
  withdrawalSavings(
    name: 'withdrawalSavings',
    path: 'withdrawalSavings/:amount/:surcharge',
  ),
  withdrawalReceipt(
    name: 'withdrawalReceipt',
    path: 'withdrawalReceipt',
  ),
  saved(
    name: 'saved',
    path: 'saved',
  ),
   privacy(
    name: 'privacy',
    path: 'privacy',
  ),
   feedback(
    name: 'feedback',
    path: 'feedback',
  ),



  history(
    name: 'history',
    path: 'history',
  ),
  historyMore(
    name: 'historyMore',
    path: 'historyMore',
  ),
  providus(
    name: 'providus',
    path: 'providus/:id',
  ),
  providusWallet(
    name: 'providusWallet',
    path: 'providusWallet',
  ),
  providusSuccessful(
    name: 'providusSuccessful',
    path: 'providusSuccessful/:wallet',
  ),
  otpEmailProfile(
    name: 'otpEmailProfile',
    path: 'otpEmailProfile',
  ),
  changeEmailProfile(
    name: 'changeEmailProfile',
    path: 'changeEmailProfile',
  ),
  changePhoneNumber(
    name: 'changePhoneNumber',
    path: 'changePhoneNumber',
  ),
  biometrics(
    name: 'biometrics',
    path: 'biometrics',
  ),
  pinTransact(
    name: 'pinTransact',
    path: 'pinTransact',
  ),
  referral(
    name: 'referral',
    path: 'referral/:referralPoint',
  ),
  inputAmountDeposit(
    name: 'inputAmountDeposit',
    path: 'inputAmountDeposit/:id',
  ),
  cardDeposit(
    name: 'cardDeposit',
    path: 'cardDeposit',
  ),
  withDrawal(
    name: 'withDrawal',
    path: 'withDrawal',
  ),
  deposit(
    name: 'deposit',
    path: 'deposit/:id',
  ),
  goalHub(
    name: 'goalHub',
    path: 'goalHub',
  ),
  walletDeposit(
    name: 'walletDeposit',
    path: 'walletDeposit',
  ),
  invest(
    name: 'invest',
    path: '/invest',
  ),
  buyInvestment(
    name: 'buyInvestment',
    path: 'buyInvestment',
  ),
  eachInvestment(
    name: 'eachInvestment',
    path: 'eachInvestment',
  ),
  profile(
    name: 'profile',
    path: '/profile',
  ),
  editProfile(
    name: 'editProfile',
    path: 'editProfile',
    navigation: '/profile/editProfile',
  ),
  changePassword(
    name: 'changePassword',
    path: 'changePassword',
    navigation: '/profile/changePassword',
  ),
  signUp(
    name: 'signUp',
    path: '/signUp',
  ),
  signupPersonalDetails(
    name: 'signupPersonalDetails',
    path: '/signupPersonalDetails',
  ),
  emailValidation(
    name: 'emailValidation',
    path: '/emailValidation',
  ),
  resetPassword(
    name: 'resetPassword',
    path: '/resetPassword',
  ),
  quickLoginSet(
    name: 'quickLoginSet',
    path: '/quickLoginSet',
  ),
  quickLogin(
    name: 'quickLogin',
    path: '/quickLogin',
  ),

  wallet(
    name: 'wallet',
    path: '/wallet',
  ),

  successfulSignUp(
    name: 'successfulSignUp',
    path: '/successfulSignUp',
  ),
  forgotPassword(
    name: 'forgotPassword',
    path: '/forgotPassword',
  ),
  logIn(
    name: 'logIn',
    path: '/logIn',
  ),
  onBoarding(
    name: 'onboarding',
    path: '/onboarding',
  ),
  settings(
    name: 'setting',
    path: '/settings',
  );

  const AppRoutes({
    required this.name,
    required this.path,
    this.redirect,
    this.navigation,
  });

  final String name;

  final String path;

  final String? redirect;
  final String? navigation;

  @override
  String toString() => name;
}
