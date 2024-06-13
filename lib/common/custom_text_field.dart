import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final bool isOutlineBorder;
  final double borderWidth;
  final bool isEnabled;
  final GestureTapCallback? onTap;
  final String? labelText;
  final TextStyle? labelStyle;
  final int? maxLines;
  final TextInputType? keyboardType;
  final EdgeInsets? contentPadding;
  final FocusNode? focusNode;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final String? errorText;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.textEditingController,
    this.obscureText = false,
    this.validator,
    this.isOutlineBorder = true,
    this.borderWidth = 1,
    this.isEnabled = true,
    this.onTap,
    this.labelText,
    this.maxLines,
    this.keyboardType,
    this.labelStyle,
    this.contentPadding = const EdgeInsets.only(left: 16.0),
    this.focusNode,
    this.maxLength,
    this.inputFormatters,
    this.borderColor = AppColors.blueGray300,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
            width: borderWidth, color: borderColor ?? AppColors.blueGray300));
    return TextFormField(
        enabled: isEnabled,
        focusNode: focusNode,
        controller: textEditingController,
        onChanged: onChanged,
        maxLength: maxLength,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onTap: onTap,
        style: CustomTextStyle.body3.copyWith(
          color: AppColors.blueGray900,
        ),
        decoration: InputDecoration(
          counterText: "",
          labelStyle: labelStyle,
          labelText: labelText,
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: CustomTextStyle.body3
              .copyWith(textBaseline: TextBaseline.alphabetic),
          contentPadding: contentPadding,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          focusedErrorBorder: border,
          errorBorder: border.copyWith(
              borderSide: BorderSide(
            width: borderWidth,
            color: AppColors.red500,
          )),
          enabledBorder: border,
          disabledBorder: border.copyWith(
              borderSide: BorderSide(
            width: borderWidth,
            color: AppColors.blueGray200,
          )),
          focusedBorder: border,
          border: border,
          errorText: errorText
        ));
  }
}
