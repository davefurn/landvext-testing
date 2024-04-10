import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/savings/model/goal.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({
    required this.value,
    super.key,
  });

  final List<Goal>? value;

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 100.h,
        ),
        itemCount: value!.length,
        itemBuilder: (context, index) {
          double totalAmount = value![index].target; // Total amount
          double currentAmount = double.parse(
            value![index].currentBalance.toString(),
          ); // Current amount
          double progress = currentAmount / totalAmount;
          String fullString = value![index].withdrawalDate;
          String datePart = fullString.substring(0, 10);
          String progressss = progress.toStringAsFixed(2);

          return InkWell(
            onTap: () {
              context.pushNamed(
                AppRoutes.goalHub.name,
                extra: value![index],
              );
            },
            child: Container(
              width: 336.w,
              margin: EdgeInsets.symmetric(horizontal: 0.w).copyWith(
                top: 20.h,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color(0xFFE2E6EB),
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value![index].savingsType,
                    style: TextStyle(
                      color: LandColors.peakBlack,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.verticalSpace,
                  LinearPercentIndicator(
                    width: 250.w,
                    trailing: Text(
                      double.parse(progressss) > 1.00 ? '100%' : '$progressss%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    barRadius: Radius.circular(20.r),
                    animation: true,
                    lineHeight: 8.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                    percent: double.parse(progressss) > 1.0
                        ? 1.0
                        : double.parse(progressss),
                    backgroundColor: LandColors.whiteGrey,
                    progressColor: progress == 1.0
                        ? LandColors.green
                        : LandColors.ascentColor,
                  ),
                  6.verticalSpace,
                  if (value![index].shortDescription != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About:',
                          style: TextStyle(
                            color: const Color(0xFF363A43),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          value![index].shortDescription!,
                          style: TextStyle(
                            color: const Color(0xFF363A43),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  6.verticalSpace,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deposit Frequency:',
                        style: TextStyle(
                          color: const Color(0xFF363A43),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        value![index].depositFrequency,
                        style: TextStyle(
                          color: const Color(0xFF363A43),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due:',
                        style: TextStyle(
                          color: const Color(0xFF363A43),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        datePart,
                        style: TextStyle(
                          color: const Color(0xFF363A43),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
}
