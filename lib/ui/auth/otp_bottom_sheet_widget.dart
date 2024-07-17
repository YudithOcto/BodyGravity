import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/countdown_timer.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/auth/bloc/login_bloc.dart';
import 'package:bodygravity/ui/auth/bloc/login_event.dart';
import 'package:bodygravity/ui/auth/bloc/login_state.dart';
import 'package:bodygravity/ui/dashboard/dashboard_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpBottomSheetWidget extends StatelessWidget {
  final bool isSelf;
  final String email;
  final OtpFieldController _controller = OtpFieldController();
  OtpBottomSheetWidget({super.key, required this.isSelf, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (Route<dynamic> route) => false);
      } else if (state is LoginFailure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }
    }, builder: (context, state) {
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
                text: 'Kami telah mengirimkan otp ke email ${isSelf ? "" : "Klien Anda"}',
                style: CustomTextStyle.body3.copyWith(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: '$email ',
                      style: CustomTextStyle.body3.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.red500)),
                  TextSpan(
                      text: isSelf
                          ? "Silahkan untuk mengecek email diatas."
                          : "Silahkan untuk meminta OTP pada klien",
                      style:
                          CustomTextStyle.body3.copyWith(color: Colors.black))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 48.0, bottom: 32.0),
              child: OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 40,
                style: CustomTextStyle.body3,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                controller: _controller,
                onCompleted: (pin) {
                  BlocProvider.of<LoginBloc>(context)
                      .add(SubmitOtpEvent(email, pin));
                },
              ),
            ),
            Visibility(
              visible: state is ShowResendTextState,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Tidak menerima OTP?',
                  style: CustomTextStyle.body3.copyWith(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Kirim Ulang',
                        style: CustomTextStyle.body3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary900),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            BlocProvider.of<LoginBloc>(context)
                                .add(RestartTimerEvent(email));
                          }),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: state is ShowTimerState,
              child: CountdownTimer(
                seconds: 10,
                onTimerEnd: () => BlocProvider.of<LoginBloc>(context)
                    .add(const TimerEndedEvent()),
                restart: state is ShowTimerState,
              ),
            ),
            const SizedBox(height: 24.0),
            CustomFilledButton(
              buttonText: "Lanjutkan",
              suffixIcon: state is LoginLoading
                  ? const CircularProgressIndicator()
                  : null,
              onPressed: () {
                BlocProvider.of<LoginBloc>(context)
                    .add(SubmitOtpEvent(email, _controller.toString()));
              },
              color: AppColors.green600,
            )
          ],
        ),
      );
    });
  }
}