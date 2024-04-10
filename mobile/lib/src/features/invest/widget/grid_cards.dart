import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/model/for_launch_demo.dart';
import 'package:landvext/src/features/invest/widget/grid_general_card.dart';

class GridCards extends StatelessWidget {
  const GridCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: GridView.builder(
          cacheExtent: 20,
          padding: EdgeInsets.symmetric(horizontal: 5.5.w).copyWith(left: 15.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            mainAxisSpacing: 11.h,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              context.goNamed(AppRoutes.eachInvestment.name);
            },
            child: GridGeneralCard(
              comingSoon: false,
              cost: cost[index],
              discount: '+24% in 8m',
              height: 224.h,
              image: images[index],
              location: location[index],
              title: title[index],
              totalInvestors: '1092',
              width: 214.w,
            ),
          ),
        ),
      );
}
