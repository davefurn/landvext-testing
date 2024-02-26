import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/home/model/user_model.dart';
import 'package:landvest/src/features/savings/views/wallet/model/model.dart';

class LocalStorage {
  LocalStorage._init();
  static final LocalStorage instance = LocalStorage._init();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final String firstTime = 'firstTime';
  final String email = 'email';
  final String password = 'password';
  final String phone = 'phone';
  final String accessToken = 'accessToken';
  final String refreshToken = 'refreshToken';
  final String firstName = 'firstName';
  final String lastName = 'lastName';
  final String resetToken = 'resetToken';
  final String signUpProcess = 'signUpProcess';
  final String accountName = 'accountName';
  final String accountNumber = 'accountNumber';
  final String initiationTranRef = 'initiationTranRef';
  final String referralCode = 'referralCode';
  final String currentBalance = '0';
  final String referralPoints = 'referralPoints';
  Future<void> setSignUpProcess() async =>
      _secureStorage.write(key: signUpProcess, value: 'true');

  Future<bool> getSignUpProcess() async {
    var isNotSignUpProcess =
        await _secureStorage.read(key: signUpProcess) == null;
    if (isNotSignUpProcess) {
      await setSignUpProcess();
      return false;
    }
    return true;
  }

  Future<void> setFirstTime() async =>
      _secureStorage.write(key: firstTime, value: 'true');

  Future<bool> getFirstTime() async {
    var isNotFirstTime = await _secureStorage.read(key: firstTime) == null;
    if (isNotFirstTime) {
      await setFirstTime();
      return false;
    }
    return true;
  }

  Future<void> setCurrentBalance(String value) async =>
      _secureStorage.write(key: currentBalance, value: value);

  Future<String?> getCurrentBalance() async =>
      _secureStorage.read(key: currentBalance);
  Future<void> setEmail(String value) async =>
      _secureStorage.write(key: email, value: value);
  Future<void> setReferralCode(String value) async =>
      _secureStorage.write(key: referralCode, value: value);
  Future<void> setAccountName(String value) async =>
      _secureStorage.write(key: accountName, value: value);
  Future<void> setAccountNumber(String value) async =>
      _secureStorage.write(key: accountNumber, value: value);
  Future<void> setInitiationTranRef(String value) async =>
      _secureStorage.write(key: initiationTranRef, value: value);

  Future<String?> getAccountName() async =>
      _secureStorage.read(key: accountName);
  Future<String?> getReferralCode() async =>
      _secureStorage.read(key: referralCode);
  Future<String?> getAccountNumber() async =>
      _secureStorage.read(key: accountNumber);
  Future<String?> getInitiationTranRef() async =>
      _secureStorage.read(key: initiationTranRef);
  Future<void> setFirstName(String value) async =>
      _secureStorage.write(key: firstName, value: value);

  Future<void> setLastName(String value) async =>
      _secureStorage.write(key: lastName, value: value);
  Future<void> setReferralPoint(String value) async =>
      _secureStorage.write(key: referralPoints, value: value);
  Future<String?> getReferralPoint() async =>
      _secureStorage.read(key: referralPoints);

  Future<String?> getFirstName() async => _secureStorage.read(key: firstName);

  Future<String?> getLastName() async => _secureStorage.read(key: lastName);

  Future<void> setPassword(String value) async =>
      _secureStorage.write(key: password, value: value);

  Future<void> setPhoneNumber(String value) async =>
      _secureStorage.write(key: phone, value: value);

  Future<String?> getPhone() async => _secureStorage.read(key: phone);

  Future<String?> getPassword() async => _secureStorage.read(key: password);

  Future<String?> getEmail() async => _secureStorage.read(key: email);

  Future<void> setAccessToken(String value) async =>
      _secureStorage.write(key: accessToken, value: value);

  Future<String?> getAccessToken() async =>
      _secureStorage.read(key: accessToken);

  Future<void> setRefreshToken(String value) async =>
      _secureStorage.write(key: refreshToken, value: value);

  Future<String?> getRefreshToken() async =>
      _secureStorage.read(key: refreshToken);

  Future<void> setResetToken(String value) async =>
      _secureStorage.write(key: resetToken, value: value);

  Future<String?> getResetToken() async => _secureStorage.read(key: resetToken);

  Future<void> saveUserData(LoginData data) async {
    await setAccessToken(data.token.accessToken);
    await setRefreshToken(data.token.refreshToken);
    await setFirstName(data.firstName);
    await setLastName(data.lastName);
    await setEmail(data.email);
    await setPhoneNumber(data.phoneNumber);
    await setReferralCode(data.referralCode);
    await setCurrentBalance(data.currentBalance.toString());
    await setReferralPoint(data.referralPoints.toString());
  }

  Future<void> saveProvidusAccount(AccountProvidus data) async {
    await setAccountName(data.accountName);
    await setAccountNumber(data.accountNumber);
    await setInitiationTranRef(data.initiationTranRef);
  }

  Future<AccountProvidus> getProvidusAccount() async {
    var accountName_ = await getAccountName() ?? '';
    var accountNumber_ = await getAccountNumber() ?? '';
    var initiationTranRef_ = await getInitiationTranRef() ?? '';

    return AccountProvidus(
      accountName: accountName_,
      accountNumber: accountNumber_,
      initiationTranRef: initiationTranRef_,
    );
  }

  Future<LoginData> getUserData() async {
    var lastName_ = await getLastName() ?? '';
    var firstName_ = await getFirstName() ?? '';
    var email_ = await getEmail() ?? '';
    var phoneNumber_ = await getPhone() ?? '';
    var referralCode_ = await getReferralCode() ?? '';
    var currentBalance_ = await getCurrentBalance() ?? '';
    var token_ = Token(
      refreshToken: await getRefreshToken() ?? '',
      accessToken: await getAccessToken() ?? '',
    );
    var referralPoints_ = await getReferralPoint() ?? '';

    return LoginData(
      referralPoints: double.parse(referralPoints_),
      referralCode: referralCode_,
      email: email_,
      firstName: firstName_,
      token: token_,
      lastName: lastName_,
      phoneNumber: phoneNumber_,
      currentBalance: double.parse(currentBalance_),
    );
  }

  Future<void> saveUserModel(UserModels data) async {
    await setFirstName(data.firstName);
    await setLastName(data.lastName);
    await setEmail(data.email);
    await setPhoneNumber(data.phoneNumber);
    await setReferralCode(data.referralCode);
    await setCurrentBalance(data.currentBalance.toString());
    await setReferralPoint(data.referralPoints.toString());
  }

  Future<UserModels> getUserModel() async {
    var lastName_ = await getLastName() ?? '';
    var firstName_ = await getFirstName() ?? '';
    var email_ = await getEmail() ?? '';
    var phoneNumber_ = await getPhone() ?? '';
    var referralCode_ = await getReferralCode() ?? '';
    var currentBalance_ = await getCurrentBalance() ?? '';
    var referralPoints_ = await getReferralPoint() ?? '';

    return UserModels(
      referralPoints: double.parse(referralPoints_),
      referralCode: referralCode_,
      email: email_,
      firstName: firstName_,
      lastName: lastName_,
      phoneNumber: phoneNumber_,
      currentBalance: double.parse(currentBalance_),
    );
  }
}
