import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';

class SuccessfulSignUp extends StatefulWidget {
  const SuccessfulSignUp({super.key});

  @override
  State<SuccessfulSignUp> createState() => _SuccessfulSignUpState();
}

class _SuccessfulSignUpState extends State<SuccessfulSignUp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      // LoginData data = await LocalStorage.instance.getUserData();
      if (context.mounted) {
        context.goNamed(
          AppRoutes.logIn.name,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 50.w,
                right: 50.w,
              ),
              child: SvgPicture.asset(LandAssets.successSign),
            ),
            33.1.verticalSpace,
            Text(
              translate('authentication:signup_successful'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 22.82666778564453.sp,
                    color: LandColors.green,
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            13.7.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                translate('authentication:signup_successful_little_text'),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15.9786.sp,
                      color: LandColors.textColorHintGrey,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
