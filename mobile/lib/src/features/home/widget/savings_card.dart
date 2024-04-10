import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/model/model.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({
    required this.value,
    super.key,
  });

  final List<TransactionModel>? value;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          height: 600.h,
          child: ListView.builder(
            itemCount: value!.length,
            itemBuilder: (context, index) {
              String originalDateString = value![index].dateCreated;

              // Parse the original string to DateTime
              DateTime originalDate = DateTime.parse(
                originalDateString,
              );

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
                child: Container(
                  height: 72.h,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: LandColors.textColorHint,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 5.h,
                            ),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundColor:
                                  value![index].transactionType == 'CREDIT'
                                      ? LandColors.greenLightShade
                                      : LandColors.redLightShade,
                              child: SvgPicture.asset(
                                value![index].transactionType == 'CREDIT'
                                    ? LandAssets.leftArrow
                                    : LandAssets.rightArrow,
                              ),
                            ),
                          ),
                          8.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                NumberFormat.currency(
                                  symbol: '₦',
                                  decimalDigits: 2,
                                ).format(
                                  value![index].amount,
                                ),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      value![index].transactionType == 'CREDIT'
                                          ? LandColors.green
                                          : LandColors.redActive,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                value![index].transactionType == 'CREDIT'
                                    ? 'Credit to ${value![index].destination}'
                                    : 'Debit to ${value![index].destination}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: LandColors.textColorGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: LandColors.textColorGrey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: LandColors.textColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
