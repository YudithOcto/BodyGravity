import 'package:flutter/material.dart';

import 'appcolors.dart';

class CommonDivider extends StatelessWidget {
  const CommonDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: const Divider(
        thickness: 10.0,
        color: AppColors.blueGray100,
      ),
    );
  }
}
