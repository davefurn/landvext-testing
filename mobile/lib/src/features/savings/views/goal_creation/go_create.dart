import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/functions/money_formatter.dart';
import 'package:landvext/src/core/services/postRequests/requests/create_savings.dart';

class GoalCreate extends StatefulWidget {
  const GoalCreate({Key? key}) : super(key: key);

  @override
  State<GoalCreate> createState() => _GoalCreateState();
}

class _GoalCreateState extends State<GoalCreate> {
  int selectedValue = 1;

  late TextEditingController amount;
  late TextEditingController description;

  bool submitted = false;
  LoadingState state = LoadingState.normal;
  String? selectedValueDrop;

  final _formKey = GlobalKey<FormState>();

  double result = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      state = LoadingState.normal;
    });

    amount = TextEditingController();
    description = TextEditingController();
  }

  Future<void> createSavings() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequestCreateSavings.createSavings(
      context,
      target: int.tryParse(amount.text.replaceAll(',', '')),
      savingsType: selectedValue == 1 ? 'LAND' : 'RENT',
      shortDescription: description.text.trim(),
      despositFrequency: selectedValueDrop!.toUpperCase(),
    );
    setState(() {
      state = LoadingState.normal;
    });
  }

  void calculateResult() {
    String getRawValue(String formattedValue) =>
        formattedValue.replaceAll(',', '');

    double amounts = double.tryParse(getRawValue(amount.text)) ?? 0.0;

    setState(() {
      if (amounts > 0) {
        switch (selectedValueDrop) {
          case 'Weekly':
            result = amounts / 52; // Assuming 52 weeks in a year
            break;
          case 'Daily':
            result = amounts / 365; // Assuming 365 days in a year
            break;
          case 'Bi-Weekly':
            result = amounts / 26; // Assuming 26 fortnights in a year
            break;
          case 'Monthly':
            result = amounts / 12; // Assuming 12 months in a year
            break;
        }
      } else {
        result = 0.0;
      }
    });
  }

  StringBuffer formatValue(String rawValue) {
    StringBuffer formattedValue = StringBuffer();
    int length = rawValue.length;

    for (int i = 0; i < length; i++) {
      formattedValue.write(rawValue[i]);

      if ((length - i - 1) % 3 == 0 && i != length - 1) {
        formattedValue.write(',');
      }
    }
    return formattedValue;
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'Create a goal',
          appBar: AppBar(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                18.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Type of savings',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: LandColors.textColorVeryBlack,
                    ),
                  ),
                ),
                8.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: RadioListTile(
                    activeColor: LandColors.tileBlue,
                    selectedTileColor: LandColors.tileActiveShade,
                    selected: selectedValue == 1 || false,
                    dense: true,
                    value: 1,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    title: Text(
                      'Land',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: LandColors.tileTextColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: selectedValue == 1
                            ? LandColors.tileBlue
                            : LandColors.tileGrey,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                12.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: RadioListTile(
                    activeColor: LandColors.tileBlue,
                    selectedTileColor: LandColors.tileActiveShade,
                    selected: selectedValue == 2 || false,
                    dense: true,
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    title: Text(
                      'Rent',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: LandColors.tileTextColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: selectedValue == 2
                            ? LandColors.tileBlue
                            : LandColors.tileGrey,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Short description',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: LandColors.textColorVeryBlack,
                    ),
                  ),
                ),
                8.verticalSpace,
                CustomTextInput(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the description';
                    }

                    return null;
                  },
                  controller: description,
                  hintText: selectedValue == 1
                      ? 'Short description on land saved for'
                      : 'Short description on rent saved for',
                ),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    selectedValue == 1 ? 'Land Amount' : 'Rent Amount',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: LandColors.textColorVeryBlack,
                    ),
                  ),
                ),
                8.verticalSpace,
                CustomTextInput(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your target';
                    }

                    return null;
                  },
                  controller: amount,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  suffixText: 'NGN',
                  hintText: 'Enter amount',
                  onChanged: (value) {
                    setState(calculateResult);
                  },
                  inputFormatters: [
                    MoneyTextFormatter(),
                  ],
                ),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Text(
                    'Deposit Frequency',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: LandColors.textColorVeryBlack,
                    ),
                  ),
                ),
                8.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: SizedBox(
                    height: 48.h,
                    child: DropdownButtonFormField2<String>(
                      value: selectedValueDrop,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: Color(0xffEAECF4),
                          ),
                        ),
                      ),
                      hint: Text(
                        'Deposit Frequency',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffAEB0B9),
                        ),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Daily',
                          child: Text(
                            'Daily',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Weekly',
                          child: Text(
                            'Weekly',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Bi-Weekly',
                          child: Text(
                            'Bi-Weekly',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Monthly',
                          child: Text(
                            'Monthly',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return 'Select your preferred payment frequency, such as weekly, monthly, or daily.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedValueDrop = value.toString();
                          calculateResult();
                        });

                        //Do something when selected item is changed.
                      },
                      onSaved: (value) {
                        selectedValueDrop = value.toString();
                        calculateResult();
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
                          border: Border.all(
                            color: const Color(0xffAEB0B9),
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    '₦${result.toStringAsFixed(2).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')} ${selectedValueDrop ?? ''}'
                        .toLowerCase(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: LandColors.textColorVeryBlack,
                    ),
                  ),
                ),
                20.verticalSpace,
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
                        createSavings();
                      }
                    },
                    text: 'Create',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
