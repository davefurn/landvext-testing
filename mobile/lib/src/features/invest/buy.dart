import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/invest/widget/buy_card.dart';

class BuyInvestment extends StatelessWidget {
  const BuyInvestment({Key? key}) : super(key: key);

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
            19.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ).copyWith(bottom: 25.h),
                    child: BuyCard(
                      image: LandAssets.defaultImage,
                      title: 'Capital City Estate',
                      location: 'Cluster Omega, Jakarta',
                      perUnit: '1 unit',
                      unitPrice: '₦2,500,000',
                      onpressed: () {
                        context.goNamed(AppRoutes.deposit.name);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
