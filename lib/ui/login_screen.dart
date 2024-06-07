import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/bottom_sheet/otp_bottom_sheet_widget.dart';
import 'package:bodygravity/ui/dashboard_screen.dart';
import 'package:bodygravity/ui/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary900,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Selamat datang di Body Gravity",
                style: CustomTextStyle.headline1
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Expanded(
            //       child: Center(
            //         child: ,
            //       ),
            //     ),
            //     // const SizedBox(width: 8.0),
            //     // const Icon(
            //     //   Icons.fitness_center_rounded,
            //     //   color: AppColors.primary900,
            //     //   size: 32.0,
            //     // )
            //   ],
            // ),
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomTextField(
                hintText: "Masukkan Email",
                borderColor: Colors.black26,
                isOutlineBorder: true,
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomFilledButton(
                  buttonText: "Kirim OTP",
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return const OtpBottomSheetWidget(isSelf: true);
                        });
                  },
                  color: AppColors.green600,
                  textStyle:
                      CustomTextStyle.body3.copyWith(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
