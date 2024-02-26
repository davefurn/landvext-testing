import 'package:intl/intl.dart';
import 'package:landvest/src/core/constants/imports.dart';

import 'package:landvest/src/features/home/model/model.dart';

class HistoryMore extends StatefulWidget {
  const HistoryMore({required this.transactionModel, super.key});
  final TransactionModel transactionModel;

  @override
  State<HistoryMore> createState() => _HistoryMoreState();
}

class _HistoryMoreState extends State<HistoryMore> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    String originalDateString = widget.transactionModel.dateCreated;

    // Parse the original string to DateTime
    DateTime originalDate = DateTime.parse(originalDateString);

    // Format the DateTime to the desired format
    String formattedDate = DateFormat('E MMM d, y').format(originalDate);

    // Format the DateTime to the desired time format
    String formattedTime = DateFormat('hh:mm a').format(originalDate);
    return Scaffold(
      appBar: CustomAppbar(
        translate: 'Transaction History',
        appBar: AppBar(),
        widget: const SizedBox.shrink(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.verticalSpace,
            Row(
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
                Text(
                  NumberFormat.currency(
                    symbol: '₦',
                    decimalDigits: 2,
                  ).format(widget.transactionModel.amount),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
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
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
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
                  formattedTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Transaction ID:',
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
                    widget.transactionModel.externalTransactionId
                        .toString()
                        .padLeft(25)
                        .substring(17),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.28,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Description:',
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
                  widget.transactionModel.transactionType == 'CREDIT'
                      ? 'Credit to ${widget.transactionModel.destination}'
                      : 'Debit to ${widget.transactionModel.destination}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Destination:',
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
                  widget.transactionModel.destination,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Status:',
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
                  widget.transactionModel.transactionType == 'CREDIT'
                      ? 'Credit'
                      : 'Debit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.transactionModel.transactionType == 'CREDIT'
                        ? LandColors.green
                        : LandColors.redActive,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
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
                  widget.transactionModel.source,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Balance on transaction:',
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
                  widget.transactionModel.balanceOnTransaction.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
