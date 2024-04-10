import 'package:landvext/src/core/constants/imports.dart';

class CustomTextInputProfile extends StatelessWidget {
  const CustomTextInputProfile({
    required this.hintText,
    required this.text,
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
  }) : super(key: key);
  final String? suffixText;
  final TextAlignVertical? textAlignVertical;
  final double? hpD;
  final IconData? prefixIcon;
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
  final String text;
  final String? prefixPath;
  final Widget? suffixIcon;
  final double? width;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: LandColors.textColorVeryBlack,
            ),
          ),
          12.verticalSpace,
          SizedBox(
            width: width,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hpD?.w ?? 20.w,
              ),
              child: TextFormField(
                textAlignVertical: textAlignVertical,
                controller: controller,
                cursorColor: Colors.black,
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
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  height: 1,
                  color: LandColors.textColorBlack,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: LandColors.mainColor,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: LandColors.failureColor,
                    ),
                  ),
                  suffixText: suffixText,
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  fillColor: LandColors.fillColor,
                  filled: true,
                ),
              ),
            ),
          ),
        ],
      );
}
