import 'package:flutter/material.dart';
import '../common/customtextstyle.dart';

class CustomTextFieldTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Widget textFieldWidget;
  const CustomTextFieldTitle(
      {super.key,
      required this.title,
      required this.textFieldWidget,
      this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(title, style: style ?? CustomTextStyle.headline5),
        const SizedBox(
          height: 8.0,
        ),
        textFieldWidget,
      ],
    );
  }
}
