import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/properties/model/model.dart';
import 'package:landvext/src/features/properties/widgets/properties_card.dart';
import 'package:landvext/src/features/properties/widgets/properties_sold.dart';
import 'package:landvext/src/features/properties/widgets/type_properties.dart';

class Properties extends ConsumerStatefulWidget {
  const Properties({super.key});

  @override
  ConsumerState<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends ConsumerState<Properties> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Properties',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              14.verticalSpace,
              Container(
                width: 200.w,
                margin: EdgeInsets.only(
                  left: 36.5.w,
                  right: 44.5.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 4.h,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F6F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Center(
                  child: TypeProperties(
                    onSelected: (value) {
                      setState(() {
                        currentIndex = value.index;
                      });
                    },
                  ),
                ),
              ),
              32.verticalSpace,
              if (currentIndex == 0)
                SizedBox(
                  height: 600.h,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      List<String> images = [
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                      ];
                      List<String> sellingPrice = [
                        '₦2,000,000',
                        '₦2,000,000',
                        '₦1,500,000',
                        '₦7,800,000',
                        '₦2,900,000',
                        '₦12,000,000',
                      ];

                      List<String> title = [
                        'Brook view cottage',
                        'Hilltop Residence',
                        'Land Banking Estate',
                        'Attitude Space Phase 2',
                        'Brook view cottage',
                        'Attitude Space Phase 1',
                      ];
                      List<String> location = [
                        'Ibusa, Delta',
                        'Leisure Park Asaba',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                      ];

                      List<bool> pending = [
                        true,
                        false,
                        true,
                        false,
                        false,
                        true,
                      ];

                      List<bool> comingSoon = [
                        false,
                        false,
                        false,
                        false,
                        false,
                        true,
                      ];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: GeneralCardSold(
                          comingSoon: comingSoon[index],
                          cost: sellingPrice[index],
                          discount: '+24% in 8m',
                          height: 224.h,
                          image: images[index],
                          location: location[index],
                          title: title[index],
                          totalInvestors: '1092',
                          width: 214.w,
                          pending: pending[index],
                        ),
                      );
                    },
                  ),
                )
              else if (currentIndex == 1)
                SizedBox(
                  height: 600.h,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      List<String> images = [
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                        LandAssets.defaultImage,
                      ];

                      List<String> cost = [
                        '₦1,000,000',
                        '₦1,800,000',
                        '₦1,000,000',
                        '₦7,000,000',
                        '₦2,500,000',
                        '₦10,000,000',
                      ];
                      List<String> sellingPrice = [
                        '₦2,000,000',
                        '₦2,000,000',
                        '₦1,500,000',
                        '₦7,800,000',
                        '₦2,900,000',
                        '₦12,000,000',
                      ];

                      List<String> title = [
                        'Brook view cottage',
                        'Hilltop Residence',
                        'Land Banking Estate',
                        'Attitude Space Phase 2',
                        'Brook view cottage',
                        'Attitude Space Phase 1',
                      ];
                      List<String> location = [
                        'Ibusa, Delta',
                        'Leisure Park Asaba',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                      ];
                      List<String> description = [
                        'Capital City Estate is a luxurious haven nestled in the heart of the bustling metropolis. This exclusive property offers an unparalleled urban living experience, combining contemporary design with the comfort of a suburban oasis. With its sleek architecture, stunning skyline views, and a myriad of amenities, Capital City Estate promises a lifestyle of sophistication and convenience. Explore the vibrant city life while coming home to the tranquility of this modern urban retreat. Your dream of city living awaits at Capital City Estate',
                        'Capital City Estate is a luxurious haven nestled in the heart of the bustling metropolis. This exclusive property offers an unparalleled urban living experience, combining contemporary design with the comfort of a suburban oasis. With its sleek architecture, stunning skyline views, and a myriad of amenities, Capital City Estate promises a lifestyle of sophistication and convenience. Explore the vibrant city life while coming home to the tranquility of this modern urban retreat. Your dream of city living awaits at Capital City Estate',
                        'Capital City Estate is a luxurious haven nestled in the heart of the bustling metropolis. This exclusive property offers an unparalleled urban living experience, combining contemporary design with the comfort of a suburban oasis. With its sleek architecture, stunning skyline views, and a myriad of amenities, Capital City Estate promises a lifestyle of sophistication and convenience. Explore the vibrant city life while coming home to the tranquility of this modern urban retreat. Your dream of city living awaits at Capital City Estate',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                      ];
                      final PropertiesModel propertiesModel = PropertiesModel(
                        id: index,
                        cost: cost[index],
                        description: description[index],
                        image: images[index],
                        location: location[index],
                        sellingPrice: sellingPrice[index],
                        title: title[index],
                      );
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: InkWell(
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.sell.name,
                              extra: propertiesModel,
                            );
                          },
                          child: GeneralCard2(
                            comingSoon: false,
                            sellingPrice: sellingPrice[index],
                            cost: cost[index],
                            discount: '+24% in 8m',
                            height: 230.h,
                            image: images[index],
                            location: location[index],
                            title: title[index],
                            totalInvestors: '1092',
                            width: 214.w,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
}
