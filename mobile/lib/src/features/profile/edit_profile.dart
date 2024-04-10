import 'dart:developer';

import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/item_list.dart';
import 'package:landvext/src/features/profile/widgets/edit_card.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String email = '';
  String phoneNumber = '';
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var userData = await LocalStorage.instance.getUserData();
      email = userData.email;
      phoneNumber = userData.phoneNumber;
      setState(() {});
    } on Exception catch (error) {
      log('Error retrieving user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: CustomAppbar(
        widget: const SizedBox.shrink(),
        translate: translate('profile:update_profile'),
        appBar: AppBar(),
      ),
      body: ListView(
        children: [
          19.verticalSpace,
          EditCard(
            mainText: 'Email',
            subText: email,
            editable: false,
          ),
          7.verticalSpace,
          EditCard(
            editable: false,
            mainText: 'Phone number',
            subText: phoneNumber,
          ),
          7.verticalSpace,
          InkWell(
            onTap: () => context.pushNamed(AppRoutes.changePassword.name),
            child: const EditCard(
              editable: true,
              mainText: 'Password',
              subText: '*********',
            ),
          ),
          7.verticalSpace,
          InkWell(
            onTap: () {
              context.pushNamed(AppRoutes.deleteAccount.name);
            },
            child: ItemsList(
              text: 'Delete Account',
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 12.sp,
              ),
              backgroundColor: LandColors.greyNewColor,
              borderColor: LandColors.textColorHint,
            ),
          ),
        ],
      ),
    );
  }
}
