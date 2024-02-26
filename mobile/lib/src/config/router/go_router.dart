import 'package:flutter/cupertino.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/authentication/signUp/model/sign_up.dart';
import 'package:landvest/src/features/home/history/view.dart';
import 'package:landvest/src/features/home/history/view_more.dart';
import 'package:landvest/src/features/home/model/model.dart';
import 'package:landvest/src/features/profile/biometrics.dart';
import 'package:landvest/src/features/profile/change_email.dart';
import 'package:landvest/src/features/profile/delete/delete_account.dart';
import 'package:landvest/src/features/profile/delete/delete_otp.dart';
import 'package:landvest/src/features/profile/feedback.dart';
import 'package:landvest/src/features/profile/my_properties.dart';
import 'package:landvest/src/features/profile/otp_email.dart';
import 'package:landvest/src/features/profile/privacy.dart';
import 'package:landvest/src/features/profile/saved.dart';
import 'package:landvest/src/features/savings/model/goal.dart';
import 'package:landvest/src/features/savings/views/deposit/card_deposit.dart';
import 'package:landvest/src/features/savings/views/deposit/deposit.dart';
import 'package:landvest/src/features/savings/views/deposit/input_amount.dart';
import 'package:landvest/src/features/savings/views/deposit/successful.dart';
import 'package:landvest/src/features/savings/views/goal_creation/go_create.dart';
import 'package:landvest/src/features/savings/views/goal_creation/goal_hub.dart';
import 'package:landvest/src/features/savings/views/wallet/model/model.dart';
import 'package:landvest/src/features/savings/views/wallet/providus.dart';
import 'package:landvest/src/features/savings/views/wallet/providus_wallet.dart';
import 'package:landvest/src/features/savings/views/wallet/wallet.dart';
import 'package:landvest/src/features/savings/views/wallet/wallet_deposit.dart';
import 'package:landvest/src/features/savings/views/withdrawal/model/receipt.dart';
import 'package:landvest/src/features/savings/views/withdrawal/pin_place.dart';
import 'package:landvest/src/features/savings/views/withdrawal/withdrawal.dart';
import 'package:landvest/src/features/savings/views/withdrawal/withdrawal_receipt.dart';
import 'package:landvest/src/features/savings/views/withdrawal/withdrawal_savings.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorSavingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorInvestKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellC');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellD');
final _shellNavigatorWalletKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellE');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.logIn.path,
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();

      final hasOnBoarded = prefs.getBool(LandConstants.hasOnBoarded) ?? false;

      // var protectedRoutes = [
      //   AppRoutes.home.name,
      //   AppRoutes.invest.name,
      //   AppRoutes.profile.name,
      //   AppRoutes.savings.name,
      // ];
      // print('onbaording flag : $hasOnBoarded');
      // print('current location: ${state.matchedLocation}');
      // print('access token : $accessToken');

      if (hasOnBoarded != true) {
        return AppRoutes.onBoarding.path;
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ScaffoldWithNavBar(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.home.name,
                path: AppRoutes.home.path,
                pageBuilder: (context, state) {
                  LoginData loginDatas = state.extra! as LoginData;
                  return MaterialPage(
                    child: Home(
                      loginData: loginDatas,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    name: AppRoutes.referral.name,
                    path: AppRoutes.referral.path,
                    pageBuilder: (context, state) => NoTransitionPage(
                      child: Referral(
                        referralPoints: state.pathParameters['referralPoint']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.history.name,
                    path: AppRoutes.history.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: History(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.historyMore.name,
                    path: AppRoutes.historyMore.path,
                    pageBuilder: (context, state) {
                      TransactionModel transactionModel =
                          state.extra! as TransactionModel;
                      return CupertinoPage(
                        child: HistoryMore(transactionModel: transactionModel),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSavingsKey,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.savings.name,
                path: AppRoutes.savings.path,
                pageBuilder: (context, state) => const MaterialPage(
                  child: Savings(),
                ),
                routes: [
                  GoRoute(
                    name: AppRoutes.goalCreation.name,
                    path: AppRoutes.goalCreation.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: GoalCreate(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.goalHub.name,
                    path: AppRoutes.goalHub.path,
                    pageBuilder: (context, state) {
                      Goal goal = state.extra! as Goal;
                      return CupertinoPage(
                        child: GoalHub(
                          goal: goal,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.withDrawal.name,
                    path: AppRoutes.withDrawal.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: WithDrawal(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.withdrawalSavings.name,
                    path: AppRoutes.withdrawalSavings.path,
                    pageBuilder: (context, state) => CupertinoPage(
                      child: WithDrawalSavings(
                        surCharge: state.pathParameters['surcharge']!,
                        amount: state.pathParameters['amount']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.withdrawalReceipt.name,
                    path: AppRoutes.withdrawalReceipt.path,
                    pageBuilder: (context, state) {
                      BankTransaction bankTransaction =
                          state.extra! as BankTransaction;
                      return CupertinoPage(
                        child: WithDrawalReceipt(
                          bankTransaction: bankTransaction,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.deposit.name,
                    path: AppRoutes.deposit.path,
                    pageBuilder: (context, state) => CupertinoPage(
                      child: Deposit(
                        id: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.pinTransact.name,
                    path: AppRoutes.pinTransact.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: PinTransact(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.cardDeposit.name,
                    path: AppRoutes.cardDeposit.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: CardDeposit(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.inputAmountDeposit.name,
                    path: AppRoutes.inputAmountDeposit.path,
                    pageBuilder: (context, state) => CupertinoPage(
                      child: InputAmountDeposit(
                        id: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.providus.name,
                    path: AppRoutes.providus.path,
                    pageBuilder: (context, state) => CupertinoPage(
                      child: Providus(
                        id: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.providusWallet.name,
                    path: AppRoutes.providusWallet.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: ProvidusWallet(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.providusSuccessful.name,
                    path: AppRoutes.providusSuccessful.path,
                    pageBuilder: (context, state) {
                      AccountProvidus accountProvidus =
                          state.extra! as AccountProvidus;
                      return CupertinoPage(
                        child: ProvidusSuccessful(
                          accountProvidus: accountProvidus,
                          wallet: state.pathParameters['wallet'],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorInvestKey,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.invest.name,
                path: AppRoutes.invest.path,
                pageBuilder: (context, state) => const MaterialPage(
                  child: Invest(),
                ),
                routes: [
                  GoRoute(
                    name: AppRoutes.buyInvestment.name,
                    path: AppRoutes.buyInvestment.path,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: BuyInvestment(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.eachInvestment.name,
                    path: AppRoutes.eachInvestment.path,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: EachInvestment(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.profile.name,
                path: AppRoutes.profile.path,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Profile(),
                ),
                routes: [
                  GoRoute(
                    name: AppRoutes.editProfile.name,
                    path: AppRoutes.editProfile.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: EditProfile(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.deleteAccount.name,
                    path: AppRoutes.deleteAccount.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: DeleteAccount(),
                    ),
                  ),
                   GoRoute(
                    name: AppRoutes.requestDeleteAccount.name,
                    path: AppRoutes.requestDeleteAccount.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: DeleteOtp(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.biometrics.name,
                    path: AppRoutes.biometrics.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: Biometrics(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.changePassword.name,
                    path: AppRoutes.changePassword.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: ChangePassword(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.changePhoneNumber.name,
                    path: AppRoutes.changePhoneNumber.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: ChangePassword(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.otpEmailProfile.name,
                    path: AppRoutes.otpEmailProfile.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: OtpEmailProfile(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.changeEmailProfile.name,
                    path: AppRoutes.changeEmailProfile.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: ChangeEmailProfile(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.privacy.name,
                    path: AppRoutes.privacy.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: Privacy(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.feedback.name,
                    path: AppRoutes.feedback.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: FeedBacks(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.saved.name,
                    path: AppRoutes.saved.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: Saved(),
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.myProperties.name,
                    path: AppRoutes.myProperties.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: MyProperties(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorWalletKey,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.wallet.name,
                path: AppRoutes.wallet.path,
                pageBuilder: (context, state) => const MaterialPage(
                  child: Wallet(),
                ),
                routes: [
                  GoRoute(
                    name: AppRoutes.walletDeposit.name,
                    path: AppRoutes.walletDeposit.path,
                    pageBuilder: (context, state) => const CupertinoPage(
                      child: WalletDeposit(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.onBoarding.name,
        path: AppRoutes.onBoarding.path,
        pageBuilder: (context, state) => const CupertinoPage(
          child: OnBoarding(),
        ),
      ),
      GoRoute(
        name: AppRoutes.signUp.name,
        path: AppRoutes.signUp.path,
        pageBuilder: (context, state) {
          UserModel userModel = state.extra! as UserModel;
          return CupertinoPage(
            child: SignUp(
              userModel: userModel,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.signupPersonalDetails.name,
        path: AppRoutes.signupPersonalDetails.path,
        pageBuilder: (context, state) => const CupertinoPage(
          child: PersonalDetails(),
        ),
      ),
      GoRoute(
        name: AppRoutes.logIn.name,
        path: AppRoutes.logIn.path,
        pageBuilder: (context, state) => const CupertinoPage(
          child: Login(),
        ),
      ),
      GoRoute(
        name: AppRoutes.forgotPassword.name,
        path: AppRoutes.forgotPassword.path,
        pageBuilder: (context, state) => const CupertinoPage(
          child: ForgotPassword(),
        ),
      ),
      GoRoute(
        name: AppRoutes.emailValidation.name,
        path: AppRoutes.emailValidation.path,
        pageBuilder: (context, state) => const CupertinoPage(
          child: EmailValidation(),
        ),
      ),
      GoRoute(
        name: AppRoutes.successfulSignUp.name,
        path: AppRoutes.successfulSignUp.path,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SuccessfulSignUp(),
        ),
      ),
      GoRoute(
        name: AppRoutes.resetPassword.name,
        path: AppRoutes.resetPassword.path,
        pageBuilder: (context, state) => const CupertinoPage(
          child: SentEmail(),
        ),
      ),
    ],
  );
}
