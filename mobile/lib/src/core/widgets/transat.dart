import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';

class Transact extends StatelessWidget {
  const Transact({
    required this.credit,
    required this.amount,
    required this.date,
    required this.details,
    required this.balance,
    super.key,
  });
  final bool credit;
  final String amount;
  final String date;
  final String details;
  final String balance;

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        height: 105.2623.h,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: LandColors.whiteGrey, width: 0.5),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 24.h,
        ),
        child: Row(
          children: [
            Container(
              width: 57.2623.w,
              height: 57.2623.h,
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 15.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(360.r)),
                border: Border.all(
                  color: LandColors.whiteGrey,
                ),
              ),
              child: SvgPicture.asset(
                credit ? LandAssets.goodSvg : LandAssets.badSvg,
                fit: BoxFit.scaleDown,
              ),
            ),
            12.horizontalSpace,
            SizedBox(
              height: 57.2623.h,
              width: 310.7377.w,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          credit ? '+ ₦$amount' : '- ₦$amount',
                          style: TextStyle(
                            fontFamily: '',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          details,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                        Container(
                          height: 16.5.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                            color: LandColors.greyNewColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              credit ? 'Bal: ₦$balance' : 'Bal:₦$balance',
                              style: TextStyle(
                                fontFamily: '',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: LandColors.specialGrey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
