import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpBottomSheetWidget extends StatelessWidget {
  final bool isSelf;
  const OtpBottomSheetWidget({super.key, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Masukkan OTP", style: CustomTextStyle.headline3),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Kami mengirimkan otp ke ',
              style: CustomTextStyle.body3.copyWith(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'EMAIL ',
                    style: CustomTextStyle.body3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary900)),
                TextSpan(
                    text:
                        "${isSelf ? "" : " klien"} anda. Silahkan untuk meminta pada klien",
                    style: CustomTextStyle.body3.copyWith(color: Colors.black))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48.0, bottom: 32.0),
            child: OTPTextField(
              length: 4,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 40,
              style: CustomTextStyle.body3,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                print("Completed: $pin");
              },
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Tidak menerima OTP?',
              style: CustomTextStyle.body3.copyWith(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: ' Kirim Ulang',
                    style: CustomTextStyle.body3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary900)),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          CustomFilledButton(
            buttonText: "Lanjutkan",
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DashboardScreen()));
            },
            color: AppColors.green600,
          )
        ],
      ),
    );
  }
}
