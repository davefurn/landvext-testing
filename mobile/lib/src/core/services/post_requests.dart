import 'dart:developer';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/savings/views/wallet/model/model.dart';
import 'package:landvest/src/features/savings/views/wallet/model/model_successful.dart';
import 'package:landvest/src/features/savings/views/withdrawal/model/receipt.dart';

class PostRequest {
  static final NetworkService network = NetworkService();

  static Future<void> login(
    BuildContext context, {
    String? email,
    String? password,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.login;

    await network
        .postRequestHandler(path, {'email': email, 'password': password}).then(
      (value) async {
        if (value != null) {
          if (value.statusCode == 200) {
            final prefs = await SharedPreferences.getInstance();
            await LocalStorage.instance.setAccessToken(
              ((value.data as Map<String, dynamic>)['token']
                  as Map<String, dynamic>)['access'],
            );

            await LocalStorage.instance.setRefreshToken(
              ((value.data as Map<String, dynamic>)['token']
                  as Map<String, dynamic>)['refresh'],
            );

            LoginData data = LoginData.fromJson(value.data);
            await LocalStorage.instance.setEmail(
              email.toString(),
            );
            await LocalStorage.instance.saveUserData(data);

            await prefs.setBool(LandConstants.loggedIn, true);

            if (context.mounted) {
              context.goNamed(
                AppRoutes.home.name,
                extra: data,
              );
            }
          } else if (value.statusCode == 502) {
            String message = translate('snackbar:code_502');
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 403) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            ).whenComplete(
              () => context.goNamed(AppRoutes.emailValidation.name),
            );
          } else if (value.statusCode == 500) {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 401) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          }
        } else {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      },
    );
  }

  static Future<void> requestOtpDelete(
    BuildContext context,
  ) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.requestOtpDelete;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    await network
        .postRequestHandler(
      path,
      {},
      options: Options(headers: {'Authorization': 'JWT $tokens'}),
    )
        .then(
      (value) async {
        if (value != null) {
          if (value.statusCode! >= 200 && value.statusCode! < 300) {
            String otp;
            otp = value.data['otp'];
            await LocalStorage.instance.setResetToken(otp);
            if (context.mounted) {
              context.goNamed(
                AppRoutes.requestDeleteAccount.name,
              );
            }
          } else if (value.statusCode == 502) {
            String message = translate('snackbar:code_502');
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 403) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            ).whenComplete(
              () => context.goNamed(AppRoutes.emailValidation.name),
            );
          } else if (value.statusCode == 500) {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 401) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          }
        } else {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      },
    );
  }

  static Future<void> deleteUser(
    BuildContext context, {
    String? otp,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.deleteAccount;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    await network
        .postRequestHandler(
      path,
      {
        'otp': otp,
      },
      options: Options(headers: {'Authorization': 'JWT $tokens'}),
    )
        .then(
      (value) async {
        if (value != null) {
          if (value.statusCode! >= 200 && value.statusCode! < 300) {
            if (context.mounted) {
              context.goNamed(
                AppRoutes.logIn.name,
              );
            }
          } else if (value.statusCode == 502) {
            String message = translate('snackbar:code_502');
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 403) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            ).whenComplete(
              () => context.goNamed(AppRoutes.emailValidation.name),
            );
          } else if (value.statusCode == 500) {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 401) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          }
        } else {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      },
    );
  }

  static Future<void> createUser(
    BuildContext context, {
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
    String? referralCode = '',
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.signUp;
    try {
      await network.postRequestHandler(path, {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phone,
        'referral_code': referralCode,
      }).then(
        (value) async {
          if (value != null) {
            if (value.statusCode == 200 || value.statusCode == 201) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(LandConstants.signedUpFlag, true);

              await LocalStorage.instance.setEmail(
                email.toString(),
              );
              if (context.mounted) {
                context.goNamed(
                  AppRoutes.emailValidation.name,
                );
              }
            } else if (value.statusCode == 400) {
              final data = value.data;

              if (data is Map<String, dynamic>) {
                final emailErrors = data['email'] as List<dynamic>?;
                final phoneErrors = data['phone_number'] as List<dynamic>?;

                String message = '';

                if (emailErrors != null) {
                  message += emailErrors.join('\n');
                  // Check for a specific message indicating email already verified
                  if (emailErrors
                      .contains('a user with this email already exists !')) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool(LandConstants.signedUpFlag, true);
                    await LocalStorage.instance.setEmail(
                      email.toString(),
                    );
                  }
                } else if (phoneErrors != null) {
                  if (message.isNotEmpty) {
                    message += '\n';
                  }
                  message += phoneErrors.join('\n');
                } else {
                  message += 'incorrect refferal code';
                }

                if (message.isNotEmpty && context.mounted) {
                  await ShowFlushBar.showError(
                    error: message,
                    context: context,
                  );
                } else {
                  if (context.mounted) {
                    await ShowFlushBar.showError(
                      context: context,
                    );
                  }
                }
              } else {
                await ShowFlushBar.showError(
                  context: context,
                  error: 'Incorrect referral code',
                );
              }
            } else {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
              );
            }
          }
        },
      );
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<int?> emailSent(
    BuildContext context, {
    bool? reSend = false,
    String? email,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    final path = (reSend ?? false)
        ? AppEndpoints.emailSentSignUp
        : AppEndpoints.emailSent;
    try {
      final response = await network.postRequestHandler(path, {
        'email': email,
      });

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: translate(
                'authentication:sent_email_endpoint',
              ),
            ).whenComplete(
              () async {
                await LocalStorage.instance.setEmail(
                  email.toString(),
                );
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(LandConstants.signedUpFlag, false);
                await LocalStorage.instance.setResetToken(
                  (response.data
                      as Map<String, dynamic>)['password_reset_token'],
                );
                if (reSend!) {
                  return;
                } else {
                  if (context.mounted) {
                    await context.pushNamed(
                      AppRoutes.emailValidation.name,
                    );
                  }
                }
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final emailErrors = data['email'] as List<dynamic>?;
            final detailErrors = data['detail'] as List<dynamic>?;

            String message = '';

            if (emailErrors != null) {
              message += emailErrors.join('\n');
            }

            if (detailErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += detailErrors.join('\n');
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
        return response.statusCode;
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
    return null;
  }

  static Future<int?> emailSentSignUp(
    BuildContext context, {
    String? email,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.emailSentSignUp;
    try {
      final response = await network.postRequestHandler(path, {
        'email': email,
      });

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: 'Email Verified',
            ).whenComplete(
              () {
                context.goNamed(AppRoutes.logIn.name);
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final emailErrors = data['email'] as List<dynamic>?;
            final detailErrors = data['detail'] as List<dynamic>?;

            String message = '';

            if (emailErrors != null) {
              message += emailErrors.join('\n');
            }

            if (detailErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += detailErrors.join('\n');
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
        return response.statusCode;
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
    return null;
  }

  static Future<void> verifyEmail(
    BuildContext context, {
    String? passwordResetToken,
    String? email,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSignup = prefs.getBool(LandConstants.signedUpFlag) ?? false;
    if (kDebugMode) {
      print(isSignup);
    }

    final path = (isSignup == true)
        ? AppEndpoints.verifyEmail
        : AppEndpoints.verifyEmailForgotPassword;

    try {
      final response = isSignup == true
          ? await network.postRequestHandler(path, {
              'email': email,
              'otp': passwordResetToken,
            })
          : await network.postRequestHandler(path, {
              'email': email,
              'password_reset_token': passwordResetToken,
            });

      if (response != null) {
        if (response.statusCode == 200) {
          await LocalStorage.instance.setAccessToken(
            (response.data as Map<String, dynamic>)['access'],
          );

          await LocalStorage.instance.setRefreshToken(
            (response.data as Map<String, dynamic>)['refresh'],
          );

          // await LocalStorage.instance.saveUserData(response.data);

          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
            ).whenComplete(
              () {
                if (isSignup) {
                  context.go(AppRoutes.successfulSignUp.path);
                } else {
                  context.pushNamed(AppRoutes.forgotPassword.name);
                }
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final emailErrors = data['email'] as List<dynamic>?;
            final passwordErrors =
                data['password_reset_token'] as List<dynamic>?;
            String message = '';

            if (emailErrors != null) {
              message += emailErrors.join('\n');
            }

            if (passwordErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += passwordErrors.join('\n');
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        } else if (response.statusCode == 403) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final otpError = data['otp'] as List<dynamic>?;

            String message = '';

            if (otpError != null) {
              message += otpError.join('\n');
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        } else {
          late String message;
          try {
            message = '${(response.data as Map<String, dynamic>)["detail"]}';
          } on Exception catch (_) {
            message = translate('snackbar:code_unknown');
          }
          if (context.mounted) {
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<void> resetPassword(
    BuildContext context, {
    String? password,
    String? confirmPassword,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.resetPassword;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'password': password,
          'confirm_password': confirmPassword,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: (response.data as Map<String, dynamic>)['detail'],
            ).whenComplete(
              () {
                context.go(AppRoutes.logIn.path);
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final passwordErrors = data['password'] as List<dynamic>?;
            final confirmPasswordErrors =
                data['confirm_password'] as List<dynamic>?;
            String message = '';

            if (passwordErrors != null) {
              message += passwordErrors.join('\n');
            }

            if (confirmPasswordErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += confirmPasswordErrors.join('\n');
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<void> createSavings(
    BuildContext context, {
    String? savingsType,
    String? shortDescription,
    String? despositFrequency,
    int? target,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.createSavings;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'savings_type': savingsType,
          'short_description': shortDescription,
          'deposit_frequency': despositFrequency,
          'target': target,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) {
            final Map<String, dynamic> responseData = response.data;
            final id = responseData['id'];
            context.goNamed(
              AppRoutes.deposit.name,
              pathParameters: {'id': id.toString()},
            );
          }
        } else if (response.statusCode == 400 || response.statusCode == 401) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final passwordErrors = data['detail'] as List<dynamic>?;
            final title = data['title'];
            String message = '';

            if (passwordErrors != null) {
              message += passwordErrors.join('\n');
            }
            if (title != null) {
              message += title;
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<int?> createProvidus(
    BuildContext context, {
    int? id,
  }) async {
    String path = 'v1/savings/$id/providus-topup/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {},
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AccountProvidus data = AccountProvidus.fromJson(response.data);
          await LocalStorage.instance.saveProvidusAccount(data);
          if (context.mounted) {
            await showModalBottomSheet(
              context: globalContext,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * .6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 47.979736328125.w,
                        height: 5.3447265625.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: LandColors.dotGrey,
                        ),
                        margin: EdgeInsets.only(top: 7.92.h),
                      ),
                    ),
                    38.73.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 35.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account name:',
                            style: TextStyle(
                              color: const Color(0xFF4E596C),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.28,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            data.accountName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF363A43),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 35.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account number:',
                                style: TextStyle(
                                  color: const Color(0xFF4E596C),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                data.accountNumber,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF363A43),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.36,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                'Bank name:',
                                style: TextStyle(
                                  color: const Color(0xFF4E596C),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                'Providus Bank',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF363A43),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.36,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: data.accountNumber),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              margin: EdgeInsets.only(
                                right: 35.w,
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xFFC9CFD8),
                                  ),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.copy,
                                    size: 20.sp,
                                    color: LandColors.ascentColor,
                                  ),
                                  10.horizontalSpace,
                                  Text(
                                    'Copy',
                                    style: TextStyle(
                                      color: const Color(0xFF363A43),
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else if (response.statusCode == 403) {
          final data = response.data.toString();

          if (data.contains("this savings doesn't belong to you!")) {
            // Directly show the error message
            if (context.mounted) {
              await ShowFlushBar.showError(
                error: "this savings doesn't belong to you!",
                context: context,
              ).whenComplete(() {
                if (context.mounted) {
                  context.pop();
                }
              });
            }
          } else {
            // Handle other 403 errors
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
              ).whenComplete(() async {
                if (context.mounted) {
                  context.pushReplacementNamed(
                    AppRoutes.providus.name,
                    pathParameters: {'id': id.toString()},
                  );
                }
              });
            }
          }
        }
        // Return the status code
        return response.statusCode;
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
        // Return a default status code for cases where response is null
        return 500; // Use an appropriate default status code
      }
    } on Exception catch (error) {
      log('Error: $error');
      // Return a default status code for exception cases
      return 500; // Use an appropriate default status code
    }
  }

  static Future<void> createWalletProvidus(
    BuildContext context,
  ) async {
    String path = 'v1/wallets/providus-topup/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {},
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AccountProvidus data = AccountProvidus.fromJson(response.data);
          await LocalStorage.instance.saveProvidusAccount(data);
          if (context.mounted) {
            await showModalBottomSheet(
              context: globalContext,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * .6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 47.979736328125.w,
                        height: 5.3447265625.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: LandColors.dotGrey,
                        ),
                        margin: EdgeInsets.only(top: 7.92.h),
                      ),
                    ),
                    38.73.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 35.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account name:',
                            style: TextStyle(
                              color: const Color(0xFF4E596C),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.28,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            data.accountName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF363A43),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.36,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 35.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account number:',
                                style: TextStyle(
                                  color: const Color(0xFF4E596C),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                data.accountNumber,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF363A43),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.36,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                'Bank name:',
                                style: TextStyle(
                                  color: const Color(0xFF4E596C),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                'Providus Bank',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF363A43),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.36,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: data.accountNumber),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              margin: EdgeInsets.only(
                                right: 35.w,
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xFFC9CFD8),
                                  ),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.copy,
                                    size: 20.sp,
                                    color: LandColors.ascentColor,
                                  ),
                                  10.horizontalSpace,
                                  Text(
                                    'Copy',
                                    style: TextStyle(
                                      color: const Color(0xFF363A43),
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else if (response.statusCode == 403) {
          final data = response.data.toString();

          if (data.contains("this savings doesn't belong to you!")) {
            // Directly show the error message
            if (context.mounted) {
              await ShowFlushBar.showError(
                error: "this savings doesn't belong to you!",
                context: context,
              ).whenComplete(() {
                if (context.mounted) {
                  context.pop();
                }
              });
            }
          } else {
            // Handle other 403 errors
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
              ).whenComplete(() async {
                if (context.mounted) {
                  context.pushReplacementNamed(
                    AppRoutes.providusWallet.name,
                  );
                }
              });
            }
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<void> validateTrans(
    BuildContext context, {
    String? externalTransactionId,
    bool? isWallet = false,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    String path;
    if (isWallet! == true) {
      path = 'v1/wallets/validate-providus-topup/';
    } else {
      path = 'v1/savings/validate-providus-topup/';
    }

    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'external_transaction_id': externalTransactionId,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null && context.mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AccountProvidusValidate data =
              AccountProvidusValidate.fromJson(response.data);

          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              duration: const Duration(seconds: 3),
              context: context,
              message:
                  'Status: ${data.status}, Account Number: ${data.accountNumber}, Amount: ${data.amount}',
            ).whenComplete(
              () async {
                if (data.status == 'PENDING') {
                } else {
                  context.pushReplacementNamed(
                    AppRoutes.savings.name,
                  );
                }
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            final title = data['external_transaction_id'];
            String message = '';

            if (title != null) {
              message += title;
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<void> withDrawal(
    BuildContext context, {
    String? accountNumber,
    String? amount,
    String? bank,
    BankTransaction? bankTransaction,
  }) async {
    String path = 'v1/wallets/providus-topup/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'account_number': accountNumber,
          'beneficiary_bank': bank,
          'amount': amount,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: 'Withdrawal Successful',
            ).then(
              (value) => context
                ..pop()
                ..pushNamed(
                  AppRoutes.withdrawalReceipt.name,
                  extra: bankTransaction,
                ),
            );
          }
        } else if (response.statusCode == 424) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            final title = data['detail'];
            String message = '';

            if (title != null) {
              message += title;
            }

            if (message.isNotEmpty && context.mounted) {
              await ShowFlushBar.showError(
                error: message,
                context: context,
              );
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: 'Withdrawal not successful',
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<void> depositFromWallet(
    BuildContext context, {
    int? amount,
    String? id,
  }) async {
    String path = 'v1/savings/$id/topup-from-wallet/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'amount': amount,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: 'Deposit Successful',
            ).then(
              (value) => context
                ..pop()
                ..pop(),
            );
          }
        } else if (response.statusCode == 403) {
          final message = response.data;

          if (context.mounted) {
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          }
        } else {
          if (context.mounted) {
            await ShowFlushBar.showError(
              context: context,
            );
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<void> changePassword(
    BuildContext context, {
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.changePassword;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: (response.data as Map<String, dynamic>)['detail'],
            ).whenComplete(
              () {
                context.pop();
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final currentPasswordError =
                data['current_password'] as List<dynamic>?;
            final confirmPasswordErrors =
                data['confirm_password'] as List<dynamic>?;
            final newPasswordError = data['confirm_password'] as List<dynamic>?;
            String message = '';

            if (currentPasswordError != null) {
              message += currentPasswordError.join('\n');
            }

            if (newPasswordError != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += newPasswordError.join('\n');
            }

            if (confirmPasswordErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += confirmPasswordErrors.join('\n');
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }

  static Future<void> sendFeedback(
    BuildContext context, {
    String? title,
    String? message,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.sendFeedback;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'title': title,
          'message': message,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: (response.data as Map<String, dynamic>)['detail'],
            ).whenComplete(
              () {
                context.pop();
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final currentPasswordError =
                data['current_password'] as List<dynamic>?;
            final confirmPasswordErrors =
                data['confirm_password'] as List<dynamic>?;
            final newPasswordError = data['confirm_password'] as List<dynamic>?;
            String message = '';

            if (currentPasswordError != null) {
              message += currentPasswordError.join('\n');
            }

            if (newPasswordError != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += newPasswordError.join('\n');
            }

            if (confirmPasswordErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += confirmPasswordErrors.join('\n');
            }

            if (message.isNotEmpty) {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  error: message,
                  context: context,
                );
              }
            } else {
              if (context.mounted) {
                await ShowFlushBar.showError(
                  context: context,
                );
              }
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }
}
