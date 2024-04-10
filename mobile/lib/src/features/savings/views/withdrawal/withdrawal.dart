import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/functions/money_formatter.dart';
import 'package:landvext/src/core/riverpod/providers.dart';
import 'package:landvext/src/core/services/postRequests/requests/withdrawal.dart';
import 'package:landvext/src/core/widgets/app_error.dart';
import 'package:landvext/src/features/savings/views/withdrawal/model/model.dart';
import 'package:landvext/src/features/savings/views/withdrawal/model/receipt.dart';

class WithDrawal extends ConsumerStatefulWidget {
  const WithDrawal({super.key});

  @override
  ConsumerState<WithDrawal> createState() => _WithDrawalState();
}

class _WithDrawalState extends ConsumerState<WithDrawal> {
  bool isLoading = false;
  String? selectedValue;
  String? accountName;
  String? validAccountNumber;
  late TextEditingController searchBanks;
  late TextEditingController amount;
  late TextEditingController account;
  bool submitted = false;
  LoadingState state = LoadingState.normal;
  String displayText = '';
  final _formKey = GlobalKey<FormState>();
  String? bankName;
  List<Bank>? value;

  @override
  void initState() {
    super.initState();
    searchBanks = TextEditingController();
    amount = TextEditingController();
    account = TextEditingController();
  }

  @override
  void dispose() {
    account.dispose();
    searchBanks.dispose();
    amount.dispose();
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
      amount: double.parse(amount.text.replaceAll(',', '')),
      date: now.toLocal().toString(),
      time: '${now.hour}:${now.minute}',
    );

    await LocalStorage.instance.saveBankTransaction(bankTransaction);

    await PostRequestWithDrawalWallet.withDrawalWallet(
      context,
      accountNumber: account.text,
      amount: double.parse(amount.text.replaceAll(',', '')),
      bank: selectedValue,
    );
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

  String? _validateAccount(String? value) {
    if (value == null ||
        value.isEmpty ||
        validAccountNumber == 'incorrect' ||
        value.length != 10) {
      return 'No account was found for this number';
    } else if (validAccountNumber == 'unavailable') {
      return 'Withdrawal is currently unavailable.\nWe apologize for any inconvenience.';
    }
    return null;
  }

  Future<void> _onAccountChanged(String value) async {
    if (value.length == 10) {
      _showLoadingDialog(context);
      await _fetchAccountInfo();
      context.pop();
    } else {
      setState(() {
        accountName = '';
      });
    }
  }

  Future<void> _fetchAccountInfo() async {
    final NetworkService network = NetworkService();
    await network.postRequestHandler(
      'v1/users/get-account-info-providus-nip/',
      {
        'account_number': account.text,
        'beneficiary_bank': selectedValue,
      },
    ).then(
      (value) {
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
  }

  InputDecoration _buildInputDecoration() => InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
      );

  void _onDropdownChanged(String? newValue) {
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
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() => value!
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
      .toList();

  String? _validateDropdown(String? value) {
    if (value == null) {
      return 'Select your preferred payment frequency, such as weekly, monthly, or daily.';
    }
    return null;
  }

  void _onDropdownSaved(String? value) {
    selectedValue = value.toString();
  }

  DropdownStyleData _buildDropdownStyleData() => DropdownStyleData(
        decoration: BoxDecoration(
          color: LandColors.backgroundColour,
          border: Border.all(color: LandColors.mainColor),
          borderRadius: BorderRadius.circular(4.r),
        ),
      );

  DropdownSearchData<String> _buildDropdownSearchData() => DropdownSearchData(
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
        searchMatchFn: _searchMatchFunction,
      );

  void _clearSearchValue(bool isOpen) {
    if (!isOpen) {
      searchBanks.clear();
    }
  }

  bool _searchMatchFunction(item, searchValue) => value!
      .where(
        (bitem) =>
            bitem.bankCode.contains(item.value!) &&
            bitem.bankName.contains(
              searchValue.toUpperCase(),
            ),
      )
      .isNotEmpty;

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
        child: SingleChildScrollView(
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
                              decoration: _buildInputDecoration(),
                              isExpanded: true,
                              value: selectedValue,
                              onChanged: _onDropdownChanged,
                              items: _buildDropdownItems(),
                              validator: _validateDropdown,
                              onSaved: _onDropdownSaved,
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
                              dropdownStyleData: _buildDropdownStyleData(),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              dropdownSearchData: _buildDropdownSearchData(),
                              onMenuStateChange: _clearSearchValue,
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
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
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
                maxLength: 10,
                validator: _validateAccount,
                onChanged: _onAccountChanged,
                onEditingComplete: _fetchAccountInfo,
              ),
              25.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
              ),
              12.verticalSpace,
              CustomTextInput(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the amount';
                  }

                  return null;
                },
                controller: amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                suffixText: 'NGN',
                hintText: 'Enter amount',
                inputFormatters: [
                  MoneyTextFormatter(),
                ],
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
      ),
    );
  }
}
