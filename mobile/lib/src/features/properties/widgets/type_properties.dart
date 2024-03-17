import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/widgets/special_button_2.dart';

class TypeProperties extends StatefulWidget {
  const TypeProperties({
    required this.onSelected,
    super.key,
  });
  final Function(PropertiesType) onSelected;

  @override
  State<TypeProperties> createState() => _TypePropertiesState();
}

class _TypePropertiesState extends State<TypeProperties> {
  PropertiesType value = PropertiesType.unsold;
  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8.w,
        children: [
          PropertiesType.unsold,
          PropertiesType.sold,
        ].map((e) {
          late String text;

          switch (e) {
            case PropertiesType.unsold:
              text = 'Unsold';
              break;
            case PropertiesType.sold:
              text = 'Sold';
              break;
          
          }
          return SpecialButton2(
            onTap: () {
              setState(() => value = e);
              widget.onSelected(e);
            },
            text: text,
            textColor: LandColors.peakBlack,
            backgroundColor:
                value == e ? LandColors.backgroundColour : Colors.transparent,
            borderColor: value == e ? Colors.transparent : Colors.transparent,
          );
        }).toList(),
      );
}
