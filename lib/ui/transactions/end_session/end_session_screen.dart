import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/countdown_timer.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/transactions/end_session/bloc/end_session_bloc.dart';
import 'package:bodygravity/ui/transactions/end_session/bloc/end_session_event.dart';
import 'package:bodygravity/ui/transactions/end_session/bloc/end_session_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class EndSessionScreen extends StatefulWidget {
  final String workoutId;
  final VoidCallback onRefresh;

  const EndSessionScreen({
    super.key,
    required this.workoutId,
    required this.onRefresh,
  });

  @override
  State<EndSessionScreen> createState() => _EndSessionScreenState();
}

class _EndSessionScreenState extends State<EndSessionScreen> {
  final OtpFieldController _controller = OtpFieldController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EndSessionBloc>(context).add(InitialEndSessionEvent(widget.workoutId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EndSessionBloc, EndSessionState>(
        listener: (context, state) {
      if (state is SubmitDataFailedState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      } else if (state is SubmitDataSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onRefresh();
        });
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Masukkan OTP", style: CustomTextStyle.headline3),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Kami telah mengirimkan otp ke email Klien Anda.',
                    style: CustomTextStyle.body3.copyWith(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Silahkan untuk meminta OTP pada klien",
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
                      BlocProvider.of<EndSessionBloc>(context).add(SubmitDataEvent(
                          widget.workoutId, pin));
                    },
                  ),
                ),
                Visibility(
                  visible: state is OtpShowResendTextState,
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
                                BlocProvider.of<EndSessionBloc>(context)
                                    .add(RestartTimerEvent(widget.workoutId));
                              }),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: state is OtpShowTimerState,
                  child: CountdownTimer(
                    seconds: 60,
                    onTimerEnd: () => BlocProvider.of<EndSessionBloc>(context)
                        .add(const TimerEndedEvent()),
                    restart: state is OtpShowTimerState,
                  ),
                ),
                // const SizedBox(height: 24.0),
                // CustomFilledButton(
                //   buttonText: "Lanjutkan",
                //   suffixIcon: state is LoginLoading
                //       ? const CircularProgressIndicator()
                //       : null,
                //   onPressed: () {
                //     BlocProvider.of<EndSessionBloc>(context)
                //         .add(SubmitDataEvent(widget.workoutId, widget.userId, widget.concern, _controller.toString()));
                //   },
                //   color: AppColors.green600,
                // )
              ],
            ),
          ),
          if (state is EndSessionLoading)... {
            const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.yellow500),
                  strokeWidth: 3.0,
                ),
              )
          }
        ],
      );
    });
  }
}
