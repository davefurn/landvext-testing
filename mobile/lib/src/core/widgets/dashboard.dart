import 'package:landvest/src/core/constants/imports.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    required this.subBoards,
    required this.promo,
    required this.investment,
    required this.amount,
    required this.color,
    required this.discountColor,
    required this.textColor,
    required this.discountTextColor,
    super.key,
    this.subTextTitle,
    this.subTextDescription,
    this.subTextTitleMain,
    this.subTextDescriptionMain,
  });
  final bool subBoards;

  final String promo;
  final String investment;
  final String amount;
  final String? subTextTitleMain;
  final String? subTextDescriptionMain;
  final String? subTextTitle;
  final String? subTextDescription;
  final Color color;
  final Color textColor;
  final Color discountColor;
  final Color discountTextColor;

  @override
  Widget build(BuildContext context) => Container(
        width: subBoards ? null : 380.w,
        padding:
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h).copyWith(
          top: 15.h,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: discountColor,
                borderRadius: BorderRadius.circular(360.r),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 5.h,
                horizontal: 14.w,
              ),
              child: FittedBox(
                child: Text(
                  promo,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: discountTextColor,
                      ),
                ),
              ),
            ),
            14.verticalSpace,
            Text(
              investment,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                  ),
            ),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: '',
                    color: textColor,
                  ),
            ),
            14.verticalSpace,
            if (subBoards)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubDashboard(
                    subTextTitle: subTextTitleMain!,
                    subTextDescription: subTextDescriptionMain!,
                  ),
                  SubDashboard(
                    subTextTitle: subTextTitle!,
                    subTextDescription: subTextDescription!,
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      );
}
