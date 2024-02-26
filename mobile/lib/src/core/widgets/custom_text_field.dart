import 'package:landvest/src/core/constants/imports.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    required this.hintText,
    this.onFieldSubmitted,
    this.prefixText,
    Key? key,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.readOnly = false,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.maxLength,
    this.minLines,
    this.expands = false,
    this.enabled,
    this.onChanged,
    this.controller,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixPath,
    this.hpD,
    this.onSaved,
    this.width,
    this.validator,
    this.autovalidateMode,
    this.textAlignVertical,
    this.suffixText,
    this.fillColor,
    this.hpDRight,
    this.focusedBorder,
    this.inputFormatters,
    this.contentPadding,
  }) : super(key: key);
  final String? suffixText;
  final TextAlignVertical? textAlignVertical;
  final double? hpD;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final bool? enabled;
  final void Function()? onTap;
  final String? hintText;
  final double? hpDRight;
  final String? prefixPath;
  final Widget? suffixIcon;
  final double? width;
  final AutovalidateMode? autovalidateMode;
  final Color? fillColor;
  final Color? focusedBorder;
  final String? prefixText;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hpD?.w ?? 20.w,
          ).copyWith(
            right: hpDRight ?? hpD?.w,
          ),
          child: TextFormField(
            cursorHeight: 20.h,
            inputFormatters: inputFormatters,
            onFieldSubmitted: onFieldSubmitted,
            textAlignVertical: textAlignVertical,
            controller: controller,
            cursorColor: LandColors.textColorVeryBlack,
            onSaved: onSaved,
            validator: validator,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            readOnly: readOnly,
            autofocus: autofocus,
            obscuringCharacter: obscuringCharacter,
            obscureText: obscureText,
            maxLength: maxLength,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onTap: onTap,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
              color: LandColors.peakBlack,
              letterSpacing: -0.2,
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: LandColors.redErrorColor, // You can customize the color
                fontSize: 12.sp,
                letterSpacing: -0.2,
                fontWeight: FontWeight.normal,
                // You can customize the font size
              ),
              contentPadding: contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: focusedBorder ?? LandColors.mainColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: const BorderSide(
                  color: LandColors.failureColor,
                ),
              ),
              suffixText: suffixText,
              suffixStyle: TextStyle(
                fontSize: 14.sp,
                color: LandColors.textColorBlack,
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefixText: prefixText,
              prefixStyle: TextStyle(
                fontSize: 14.sp,
                color: LandColors.peakBlack,
              ),
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: LandColors.textColorHintGrey,
                    letterSpacing: -0.2,
                  ),
              fillColor: fillColor ?? LandColors.textColorHint,
              filled: true,
            ),
          ),
        ),
      );
}
