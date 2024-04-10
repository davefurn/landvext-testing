import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/savings/views/withdrawal/model/receipt.dart';
import 'package:landvext/src/features/savings/widgets/logo_design.dart';
import 'package:landvext/src/features/savings/widgets/receipt_text.dart';

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
            const LogoDesign(),
            20.verticalSpace,
             ReceiptWidget(
              text1: 'Bank Name:',
              text2: bankTransaction.bank,
            ),
            17.verticalSpace,
            ReceiptWidget(
              text1: 'Account Number:',
              text2: bankTransaction.accountNumber,
            ),
            17.verticalSpace,
            ReceiptWidget(
              text1: 'Account Name:',
              text2: bankTransaction.accountName,
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
            ReceiptWidget(
              text1: 'Date:',
              text2: bankTransaction.date.padRight(15),
            ),
            17.verticalSpace,
            ReceiptWidget(
              text1: 'Time:',
              text2: bankTransaction.time,
            ),
            48.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  CustomButton(
                    text: 'Download',
                    onpressed: () {},
                    thickLine: 1,
                    radius: 4.r,
                    width: 162.5.w,
                    height: 48.h,
                    hpD: 0.w,
                    fontWeight: FontWeight.w500,
                    borderColor: LandColors.textColorVeryBlack,
                    color: LandColors.backgroundColour,
                    textcolor: LandColors.textColorVeryBlack,
                  ),
                  10.horizontalSpace,
                  CustomButton(
                    text: 'Share',
                    onpressed: () {},
                    thickLine: 1,
                    radius: 4.r,
                    width: 162.5.w,
                    height: 48.h,
                    hpD: 0.w,
                    fontWeight: FontWeight.w500,
                    borderColor: LandColors.mainColor,
                    color: LandColors.mainColor,
                    textcolor: LandColors.backgroundColour,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
