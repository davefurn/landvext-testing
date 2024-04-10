import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/providers.dart';
import 'package:landvext/src/core/services/postRequests/requests/withdrawal_savings.dart';
import 'package:landvext/src/core/widgets/app_error.dart';
import 'package:landvext/src/features/savings/views/withdrawal/model/model.dart';
import 'package:landvext/src/features/savings/views/withdrawal/model/receipt.dart';

class WithDrawalSavings extends ConsumerStatefulWidget {
  const WithDrawalSavings({
    required this.surCharge,
    required this.id,
    required this.amount,
    super.key,
  });
  final String amount;
  final String surCharge;
  final String id;

  @override
  ConsumerState<WithDrawalSavings> createState() => _WithDrawalSavingsState();
}

class _WithDrawalSavingsState extends ConsumerState<WithDrawalSavings> {
  bool isLoading = false;
  String? selectedValue;
  String? accountName;
  String? validAccountNumber;
  String? bankName;
  late TextEditingController searchBanks;
  late TextEditingController account;
  bool submitted = false;
  LoadingState state = LoadingState.normal;
  String displayText = '';
  final _formKey = GlobalKey<FormState>();
  List<Bank>? value;

  @override
  void initState() {
    super.initState();
    searchBanks = TextEditingController();
    account = TextEditingController();
  }

  @override
  void dispose() {
    account.dispose();
    searchBanks.dispose();

    super.dispose();
  }

  Future<void> withDraw() async {
    setState(() {
      state = LoadingState.loading;
    });
    DateTime now = DateTime.now();
    BankTransaction bankTransaction = BankTransaction(
      accountName: accountName.toString(),
      bank: bankName ?? '',
      accountNumber: account.text,
      amount:
          double.parse(widget.amount.replaceAll(',', '').replaceAll('₦', '')),
      date: now.toLocal().toString(),
      time: '${now.hour}:${now.minute}',
    );

    await LocalStorage.instance.saveBankTransaction(bankTransaction);
    if (widget.surCharge == 'true') {
      await PostRequestWithDrawalSavings.withDrawalSavings(
        context,
        accountNumber: account.text,
        bank: selectedValue,
        id: widget.id,
      );
    } else {
      await PostRequestWithDrawalSavings.withDrawalSavings(
        context,
        accountNumber: account.text,
        bank: selectedValue,
        id: widget.id,
      );
    }

    setState(() {
      state = LoadingState.normal;
    });
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var getAllBanks = ref.watch(getAllBanksProvider);
    return Scaffold(
      appBar: CustomAppbar(
        widget: const SizedBox.shrink(),
        translate: 'Withdraw',
        appBar: AppBar(),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            18.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Select bank',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: LandColors.textColorVeryBlack,
                ),
              ),
            ),
            8.verticalSpace,
            getAllBanks.when(
              data: (data) {
                if (data?.statusCode == 200 && data != null) {
                  value = (data.data['banks'] as List)
                      .map((e) => Bank.fromJson(e))
                      .toList();

                  return value!.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: DropdownButtonFormField2<String>(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: const BorderSide(
                                  color: Color(0xffEAECF4),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xffEAECF4),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: LandColors.mainColor,
                                  width: 2,
                                ),
                              ),
                              // Add more decoration..
                            ),
                            isExpanded: true,
                            value: selectedValue,
                            onChanged: (newValue) {
                              // setState(() {
                              //   selectedValue = newValue;
                              // });
                              setState(() {
                                selectedValue = newValue;
                                bankName = value!
                                    .firstWhere(
                                      (item) => item.bankCode == newValue,
                                      orElse: () => Bank(
                                        bankCode: '',
                                        bankName: '',
                                      ), // Provide a default BankItem here
                                    )
                                    .bankName;
                              });
                            },
                            items: value!
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item.bankCode,
                                    child: Text(
                                      item.bankName,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Select your preferred payment frequency, such as weekly, monthly, or daily.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              selectedValue = value.toString();
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.only(right: 8),
                            ),
                            iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 24.sp,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: LandColors.backgroundColour,
                                border: Border.all(color: LandColors.mainColor),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: searchBanks,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: CustomTextInput(
                                  hintText: 'Search Banks',
                                  controller: searchBanks,
                                ),
                              ),
                              searchMatchFn: (item, searchValue) => value!
                                  .where(
                                    (bitem) =>
                                        bitem.bankCode.contains(item.value!) &&
                                        bitem.bankName.contains(
                                          searchValue.toUpperCase(),
                                        ),
                                  )
                                  .isNotEmpty,
                            ),
                            //This to clear the search value when you close the menu
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                searchBanks.clear();
                              }
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              Text(
                                'No Transactions done yet',
                                style: TextStyle(
                                  color: LandColors.inAppHint,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              50.verticalSpace,
                            ],
                          ),
                        );
                } else if (data?.statusCode == 500 && data!.statusCode! < 600) {
                  return Center(
                    child: AppErrorWidget(
                      errorData: data.data,
                      errorCode: data.statusCode,
                      retry: CustomButton(
                        thickLine: 1,
                        text: 'Retry',
                        onpressed: () => ref.refresh(
                          getAllBanksProvider,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: AppErrorWidget(
                      errorData: data?.data,
                      errorCode: data?.statusCode,
                      retry: CustomButton(
                        thickLine: 1,
                        text: 'Retry',
                        onpressed: () => ref.refresh(
                          getAllBanksProvider,
                        ),
                      ),
                    ),
                  );
                }
              },
              loading: () => Center(
                child: SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              ),
              error: (error, trace) => const Center(
                child: AppErrorWidget(),
              ),
            ),
            25.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Account Number',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: LandColors.textColorVeryBlack,
                ),
              ),
            ),
            12.verticalSpace,
            CustomTextInput(
              controller: account,
              suffixText: accountName ?? '',
              hintText: '',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    validAccountNumber == 'incorrect' ||
                    value.length != 10) {
                  return 'No account was found for this number';
                } else if (validAccountNumber == 'unavailable') {
                  return 'Withdrawal is currently unavailable.\nWe apologize for any inconvenience.';
                }
                return null;
              },
              maxLength: 10,
              onChanged: (value) async {
                if (value.length == 10) {
                  final NetworkService network = NetworkService();
                  _showLoadingDialog(context);
                  await network.postRequestHandler(
                      'v1/users/get-account-info-providus-nip/', {
                    'account_number': account.text,
                    'beneficiary_bank': selectedValue,
                  }).then(
                    (value) async {
                      if (value != null) {
                        if (value.statusCode == 200) {
                          setState(() {
                            accountName = value.data['accountName'];
                            validAccountNumber = '';
                          });
                        } else if (value.statusCode == 503) {
                          setState(() {
                            validAccountNumber = 'unavailable';
                          });
                        } else {
                          setState(() {
                            validAccountNumber = 'incorrect';
                          });
                        }
                      }
                    },
                  );
                  if (context.mounted) {
                    context.pop();
                  }
                } else {
                  setState(() {
                    accountName = '';
                  });
                }
              },
              onEditingComplete: () async {
                final NetworkService network = NetworkService();

                await network.postRequestHandler(
                    'v1/users/get-account-info-providus-nip/', {
                  'account_number': account.text,
                  'beneficiary_bank': selectedValue,
                }).then(
                  (value) async {
                    if (value != null) {
                      if (value.statusCode == 200) {
                        setState(() {
                          accountName = value.data['accountName'];
                          validAccountNumber = '';
                        });
                      } else {
                        setState(() {
                          validAccountNumber = 'incorrect';
                        });
                      }
                    }
                  },
                );
              },
            ),
            25.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
              ),
              child: LoadingButton(
                color: LandColors.mainColor,
                state: state,
                onTap: () {
                  setState(() => submitted = true);
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    withDraw();
                  }
                },
                text: 'WithDraw',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
