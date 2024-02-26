import 'package:landvest/src/core/constants/imports.dart';

class InputAmountDeposit extends StatefulWidget {
  const InputAmountDeposit({required this.id, Key? key}) : super(key: key);
  final String id;

  @override
  State<InputAmountDeposit> createState() => _InputAmountDepositState();
}

class _InputAmountDepositState extends State<InputAmountDeposit> {
  late TextEditingController amount;
  LoadingState state = LoadingState.normal;
  bool submitted = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amount = TextEditingController();
  }

  Future<void> depositFromWallet() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequest.depositFromWallet(
      context,
      amount: int.parse(amount.text),
      id: widget.id,
    );

    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Deposit',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              32.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Enter amount',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
              ),
              8.verticalSpace,
              CustomTextInput(
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Amount can't be empty";
                  }
                  return null;
                },
                controller: amount,
                hintText: 'Enter the amount',
                keyboardType: TextInputType.number,
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: LoadingButton(
                  width: double.maxFinite,
                  color: LandColors.mainColor,
                  state: state,
                  onTap: () {
                    setState(() => submitted = true);
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      depositFromWallet();
                    }
                  },
                  text: 'Deposit',
                ),
              ),
            ],
          ),
        ),
      );
}
