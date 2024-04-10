import 'package:landvext/src/core/constants/imports.dart';

class NoGoalWidget extends StatelessWidget {
  const NoGoalWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(LandAssets.target),
          27.verticalSpace,
          Text(
            'You don’t have a goal yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: LandColors.inAppHint,
            ),
          ),
          27.verticalSpace,
          CustomButton(
            hasIcon: true,
            text: 'Create',
            onpressed: () {
              context.pushNamed(AppRoutes.goalCreation.name);
            },
            thickLine: 1,
            radius: 50.r,
            width: 131.w,
            height: 32.h,
            borderColor: LandColors.inAppHint,
            color: LandColors.backgroundColour,
            textcolor: LandColors.textColorVeryBlack,
            icon: Icon(
              Icons.add,
              size: 20.sp,
              color: LandColors.textColorVeryBlack,
            ),
          ),
        ],
      );
}
