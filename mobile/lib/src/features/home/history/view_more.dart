import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';

import 'package:landvext/src/features/home/model/model.dart';
import 'package:landvext/src/features/home/widget/amount_text.dart';
import 'package:landvext/src/features/home/widget/transaction_id.dart';

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
            Amount(
              widget: widget,
              text: 'Amount:',
              text2: NumberFormat.currency(
                symbol: '₦',
                decimalDigits: 2,
              ).format(widget.transactionModel.amount),
            ),
            12.verticalSpace,
            Amount(
              widget: widget,
              text: 'Date:',
              text2: formattedDate,
            ),
            12.verticalSpace,
            Amount(
              widget: widget,
              text: 'Time:',
              text2: formattedTime,
            ),
            12.verticalSpace,
            TransactionID(
              text: widget.transactionModel.externalTransactionId
                  .toString()
                  .padLeft(25)
                  .substring(17),
            ),
            12.verticalSpace,
            Amount(
              widget: widget,
              text: 'Description:',
              text2: widget.transactionModel.transactionType == 'CREDIT'
                  ? 'Credit to ${widget.transactionModel.destination}'
                  : 'Debit to ${widget.transactionModel.destination}',
            ),
            12.verticalSpace,
            Amount(
              widget: widget,
              text: 'Destination:',
              text2: widget.transactionModel.destination,
            ),
            12.verticalSpace,
            Amount(
              widget: widget,
              text: 'Status:',
              text2: widget.transactionModel.transactionType == 'CREDIT'
                  ? 'Credit'
                  : 'Debit',
              color: widget.transactionModel.transactionType == 'CREDIT'
                  ? LandColors.green
                  : LandColors.redActive,
            ),
            12.verticalSpace,
            Amount(
              widget: widget,
              text: 'Bank:',
              text2: widget.transactionModel.source,
            ),
            12.verticalSpace,
            Amount(
              widget: widget,
              text: 'Balance on transaction:',
              text2: widget.transactionModel.balanceOnTransaction.toString(),
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
