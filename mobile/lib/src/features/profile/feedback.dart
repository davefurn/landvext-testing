import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';

class FeedBacks extends StatelessWidget {
  const FeedBacks({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'Feedback & Help',
          appBar: AppBar(),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            top: 30.w,
          ),
          children: [
            const CustomTextInput(
              hintText: 'What is it about? ',
            ),
            16.sbH,
            CustomTextInput(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              hintText: 'Enter content here? ',
              maxLines: 5,
              maxLength: 120,
            ),
            16.sbH,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                thickLine: 1,
                color: LandColors.mainColor,
                onpressed: () {},
                text: 'Send Feedback',
                hpD: 0,
                textcolor: LandColors.backgroundColour,
                icon: SvgPicture.asset('assets/svgs/send.svg'),
              ),
            ),
          ],
        ),
      );
}
