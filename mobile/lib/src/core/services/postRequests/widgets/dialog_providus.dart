import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/savings/views/wallet/model/model.dart';

class BottomSheetProvidus extends StatelessWidget {
  const BottomSheetProvidus({
    required this.data,
    super.key,
  });

  final AccountProvidus data;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * .6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 47.979736328125.w,
                height: 5.3447265625.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: LandColors.dotGrey,
                ),
                margin: EdgeInsets.only(top: 7.92.h),
              ),
            ),
            38.73.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 35.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account name:',
                    style: TextStyle(
                      color: const Color(0xFF4E596C),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.28,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    data.accountName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF363A43),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.36,
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 35.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account number:',
                        style: TextStyle(
                          color: const Color(0xFF4E596C),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.28,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        data.accountNumber,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF363A43),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.36,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'Bank name:',
                        style: TextStyle(
                          color: const Color(0xFF4E596C),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.28,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'Providus Bank',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF363A43),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.36,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: data.accountNumber),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      margin: EdgeInsets.only(
                        right: 35.w,
                      ),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color(0xFFC9CFD8),
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy,
                            size: 20.sp,
                            color: LandColors.ascentColor,
                          ),
                          10.horizontalSpace,
                          Text(
                            'Copy',
                            style: TextStyle(
                              color: const Color(0xFF363A43),
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
