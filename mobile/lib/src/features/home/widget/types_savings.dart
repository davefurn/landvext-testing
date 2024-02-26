import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/widgets/special_button_2.dart';

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
        children: [
          HistoryTransaction.all,
          HistoryTransaction.saving,
          HistoryTransaction.properties,
        ].map((e) {
          late String text;

          switch (e) {
            case HistoryTransaction.all:
              text = 'All';
              break;
            case HistoryTransaction.saving:
              text = 'Savings';
              break;
            case HistoryTransaction.properties:
              text = 'Properties';
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
