import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/services/postRequests/validate_trans.dart';
import 'package:landvest/src/features/savings/views/wallet/model/model.dart';

class ProvidusSuccessful extends StatefulWidget {
  const ProvidusSuccessful({
    required this.accountProvidus,
    super.key,
    this.wallet = 'false',
  });
  final AccountProvidus accountProvidus;
  final String? wallet;

  @override
  State<ProvidusSuccessful> createState() => _ProvidusSuccessfulState();
}

class _ProvidusSuccessfulState extends State<ProvidusSuccessful> {
  late AccountProvidus accountProvidus;
  LoadingState state = LoadingState.normal;
  @override
  void initState() {
    super.initState();
    setState(() {
      state = LoadingState.normal;
    });
  }

  Future<void> validateTrans() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequest.validateTrans(
      context,
      externalTransactionId: widget.accountProvidus.initiationTranRef,
      isWallet: bool.parse(widget.wallet.toString()),
    );
    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Account Generated',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Name:${widget.accountProvidus.accountName}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              10.sbH,
              Text(
                'Account Number: ${widget.accountProvidus.accountNumber}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              10.sbH,
              Text(
                'id: ${widget.accountProvidus.initiationTranRef}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              10.sbH,
              LoadingButton(
                width: 310.w,
                color: LandColors.mainColor,
                state: state,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  validateTrans();
                },
                text: 'Validate Transaction',
              ),
            ],
          ),
        ),
      );
}
