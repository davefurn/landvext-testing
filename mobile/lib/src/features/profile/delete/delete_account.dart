import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/request_otp_delete.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  LoadingState state = LoadingState.normal;

  @override
  void initState() {
    super.initState();
    setState(() {
      state = LoadingState.normal;
    });
  }

  Future<void> deleteUser() async {
    setState(() {
      state = LoadingState.loading;
    });

    await PostRequestRequestOtpDelete.requestOtpDelete(
      context,
    );
    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Account',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(
            20.r,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account? This action cannot be undone and all information and money associated with your account will be lost.',
                style: TextStyle(
                  color: LandColors.textColorBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 5,
              ),
              50.verticalSpace,
              LoadingButton(
                state: state,
                color: LandColors.redActive,
                width: double.maxFinite,
                text: 'I understand, Delete account',
                onTap: () {
                  deleteUser();
                },
              ),
            ],
          ),
        ),
      );
}
