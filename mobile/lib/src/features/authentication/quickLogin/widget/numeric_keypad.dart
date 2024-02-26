import 'package:landvest/src/core/constants/imports.dart';

/// A widget that builds a numeric keypad which
/// mimics the Os numeric keypad on Android and IOS devices
/// or other touch-enabled devices.
class NumericKeyPad extends StatelessWidget {
  /// Creates a widget that builds the numeric keypad.
  const NumericKeyPad({
    required this.onInputNumber,
    required this.onClearLastInput,
    required this.onClearAll,
    required this.onTap,
    super.key,
    this.signOut = true,
  });

  final ValueSetter<int> onInputNumber;
  final VoidCallback onClearLastInput;
  final VoidCallback onClearAll;
  final VoidCallback onTap;
  final bool? signOut;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (int i = 1; i < 4; i++)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int j = 1; j < 4; j++)
                    Expanded(
                      child: Numeral(
                        number: (i - 1) * 3 + j,
                        onKeyPress: () => onInputNumber((i - 1) * 3 + j),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add some spacing between the "0" button and "Sign Out"
                if (signOut!)
                  Expanded(
                    child: Align(
                      child: InkWell(
                        onTap: onTap,
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 15.978666305541992.sp,
                            fontWeight: FontWeight.w600,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Align(
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          '        ',
                          style: TextStyle(
                            fontSize: 15.978666305541992.sp,
                            fontWeight: FontWeight.w600,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Numeral(
                    number: 0,
                    onKeyPress: () => onInputNumber(0),
                  ),
                ),
                Expanded(
                  child: ClearButton(
                    onClearLastInput: onClearLastInput,
                    onClearAll: onClearAll,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

/// Represents a button on the numeric keypad that contains a number.
class Numeral extends StatelessWidget {
  /// Creates a button on the numeric keypad that contains a number.
  const Numeral({
    required this.number,
    required this.onKeyPress,
    super.key,
  });

  final int number;
  final VoidCallback onKeyPress;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(10),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: LandColors.transparent,
            backgroundColor: LandColors.transparent,
            side: BorderSide.none,
          ),
          onPressed: onKeyPress,
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: LandColors.textColorVeryBlack,
            ),
          ),
        ),
      );
}

class ClearButton extends StatelessWidget {
  const ClearButton({
    required this.onClearLastInput,
    required this.onClearAll,
    super.key,
  });

  final VoidCallback onClearLastInput;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: onClearAll,
        child: IconButton(
          onPressed: onClearLastInput,
          icon: const Icon(
            Icons.backspace_outlined,
            color: LandColors.textColorVeryBlack,
          ),
        ),
      );
}
