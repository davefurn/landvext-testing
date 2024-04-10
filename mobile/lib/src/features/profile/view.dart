import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/item_list.dart';
import 'package:landvext/src/features/profile/widgets/profile_name_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String phoneNumber = '';
  String referralPoint = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocalStorage.instance.getUserData().then((value) {
        name = '${value.firstName} ${value.lastName}';
        phoneNumber = value.phoneNumber;
        referralPoint = value.referralPoints.toString();
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: CustomAppbar(
        backbutton: false,
        translate: translate('profile:profile_title'),
        appBar: AppBar(),
        widget: Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Icon(
            Icons.notifications_outlined,
            size: 24.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            18.verticalSpace,
            ProfileAndName(
              name: name,
              phoneNumber: phoneNumber,
            ),
            30.verticalSpace,
            InkWell(
              onTap: () => context.pushNamed(AppRoutes.editProfile.name),
              child: ItemsList(
                text: 'Account',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.greyNewColor,
                borderColor: LandColors.textColorHint,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () => context.pushNamed(AppRoutes.history.name),
              child: ItemsList(
                text: 'Transaction History',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.greyNewColor,
                borderColor: LandColors.textColorHint,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () => context.pushNamed(AppRoutes.myProperties.name),
              child: ItemsList(
                text: 'My properties',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.greyNewColor,
                borderColor: LandColors.textColorHint,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () {
                context.goNamed(AppRoutes.saved.name);
              },
              child: ItemsList(
                text: 'Saved',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.greyNewColor,
                borderColor: LandColors.textColorHint,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () {
                context.goNamed(AppRoutes.feedback.name);
              },
              child: ItemsList(
                text: 'Feedback and help',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.greyNewColor,
                borderColor: LandColors.textColorHint,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () {
                context.goNamed(AppRoutes.privacy.name);
              },
              child: ItemsList(
                text: 'Privacy policy',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.greyNewColor,
                borderColor: LandColors.textColorHint,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () => context.pushNamed(AppRoutes.biometrics.name),
              child: ItemsList(
                text: 'Biometrics',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.greyNewColor,
                borderColor: LandColors.textColorHint,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () => context.pushNamed(
                AppRoutes.referral.name,
                pathParameters: {
                  'referralPoint': referralPoint,
                },
              ),
              child: ItemsList(
                text: 'Referrals',
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                ),
                backgroundColor: LandColors.yellowButton,
                borderColor: LandColors.yellowborder,
              ),
            ),
            4.verticalSpace,
            InkWell(
              onTap: () async {
                // await clearTokens();
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.setBool(LandConstants.loggedIn, false);

                if (context.mounted) {
                  context.goNamed(AppRoutes.logIn.name);
                }
              },
              child: ItemsList(
                text: 'Sign Out',
                icon: Icon(
                  Icons.logout,
                  size: 12.sp,
                  color: LandColors.redColorTwo,
                ),
                backgroundColor: LandColors.redActive.withOpacity(.5),
                borderColor: LandColors.redActive,
              ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}
