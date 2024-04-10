import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/model/model.dart';
import 'package:landvext/src/features/home/widget/transactions_card.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    required this.value,
    super.key,
  });

  final List<TransactionModel>? value;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: 200.h,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value!.length,
            itemBuilder: (context, index) {
              String originalDateString = value![index].dateCreated;

              // Parse the original string to DateTime
              DateTime originalDate = DateTime.parse(originalDateString);

              // Format the DateTime to the desired format
              String formattedDate =
                  DateFormat('E MMM d, y').format(originalDate);

              // Format the DateTime to the desired time format
              String formattedTime = DateFormat('hh:mm a').format(originalDate);

              return InkWell(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.historyMore.name,
                    extra: value![index],
                  );
                },
                child: Transcations(
                  value: value,
                  formattedDate: formattedDate,
                  formattedTime: formattedTime,
                  index: index,
                ),
              );
            },
          ),
        ),
      );
}
