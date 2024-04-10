import 'package:landvext/src/core/constants/imports.dart';

class ChangePhoneNumberProfile extends StatefulWidget {
  const ChangePhoneNumberProfile({Key? key}) : super(key: key);

  @override
  State<ChangePhoneNumberProfile> createState() =>
      _ChangePhoneNumberProfileState();
}

class _ChangePhoneNumberProfileState extends State<ChangePhoneNumberProfile> {
  late TextEditingController phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Phone Number',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            50.verticalSpace,
            CustomTextInput(
              controller: phoneNumber,
              hintText: 'Enter new phone number',
              keyboardType: TextInputType.number,
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                radius: 4.r,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: LandColors.mainColor,
                textcolor: LandColors.backgroundColour,
                width: double.maxFinite,
                height: 42.h,
                text: 'Change Email',
                onpressed: () {
                  context.pushNamed(AppRoutes.otpEmailProfile.name);
                },
                thickLine: 1,
              ),
            ),
          ],
        ),
      );
}
