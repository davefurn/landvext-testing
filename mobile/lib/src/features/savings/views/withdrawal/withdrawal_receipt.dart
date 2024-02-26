import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/savings/views/withdrawal/model/receipt.dart';

class WithDrawalReceipt extends StatelessWidget {
  const WithDrawalReceipt({required this.bankTransaction, super.key});
  final BankTransaction bankTransaction;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: '',
          appBar: AppBar(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56.h,
              width: double.maxFinite,
              color: LandColors.ascentColor,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRANSACTION RECEIPT',
                    style: TextStyle(
                      color: LandColors.backgroundColour,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.32,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Image.asset(
                      'assets/images/icon/light_mode.jpg',
                      width: 36.w,
                      height: 36.h,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bank:',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    bankTransaction.bank,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            17.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Account Number:',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    bankTransaction.accountNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            17.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Account Name:',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    bankTransaction.accountName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            17.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Amount:',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FittedBox(
                    child: Text(
                      '₦${bankTransaction.amount.toStringAsPrecision(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: LandColors.textColorVeryBlack,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.28,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            17.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Date:',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    bankTransaction.date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            17.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Time:',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    bankTransaction.time,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,
          ],
        ),
      );
}
