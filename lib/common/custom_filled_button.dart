import 'package:flutter/material.dart';

import 'appcolors.dart';
import 'customtextstyle.dart';

class CustomFilledButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? color;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final bool isEnabled;
  final bool intrinsicWidthEnabled;
  final double radius;
  final double? height;

  const CustomFilledButton(
      {super.key,
        required this.buttonText,
        required this.onPressed,
        this.color,
        this.prefixIcon,
        this.suffixIcon,
        this.textStyle,
        this.isEnabled = true,
        this.intrinsicWidthEnabled = false,
        this.height,
        this.radius = 8.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
            backgroundColor: isEnabled ? color : AppColors.primary900),
        child: Row(
          mainAxisSize:
          intrinsicWidthEnabled ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(right: 10),
              child: prefixIcon!,
            )
                : const SizedBox(),
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: textStyle ??
                  CustomTextStyle.headline5.copyWith(
                    color: AppColors.white900,
                  ),
            ),
            suffixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(left: 10),
              child: suffixIcon!,
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
