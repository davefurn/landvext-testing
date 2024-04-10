import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/special_button_2.dart';

class TypeHistory extends StatefulWidget {
  const TypeHistory({
    required this.onSelected,
    super.key,
  });
  final Function(HistoryTransaction) onSelected;

  @override
  State<TypeHistory> createState() => _TypeHistoryState();
}

class _TypeHistoryState extends State<TypeHistory> {
  HistoryTransaction value = HistoryTransaction.all;
  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8.w,
        children: <HistoryTransaction>[
          HistoryTransaction.all,
          HistoryTransaction.saving,
          HistoryTransaction.properties,
        ].map((e) {
          late String text;

          // Mapping each enum value to its corresponding text
          final textMap = {
            HistoryTransaction.all: 'All',
            HistoryTransaction.saving: 'Savings',
            HistoryTransaction.properties: 'Properties',
          };

          text = textMap[e]!;

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
