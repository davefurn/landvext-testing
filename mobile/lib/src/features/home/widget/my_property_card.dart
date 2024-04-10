import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/model/for_launch_demo.dart';
import 'package:landvext/src/features/home/widget/ads_widget.dart';

class MyPropertyCard extends StatelessWidget {
  const MyPropertyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
        ),
        child: SizedBox(
          height: 224.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => GeneralCard(
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
