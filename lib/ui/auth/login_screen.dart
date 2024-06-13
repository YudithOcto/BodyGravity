import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/auth/bloc/login_bloc.dart';
import 'package:bodygravity/ui/auth/bloc/login_event.dart';
import 'package:bodygravity/ui/auth/bloc/login_state.dart';
import 'package:bodygravity/ui/bottom_sheet/otp_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController =
      TextEditingController(text: "");
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary900,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is SendOtpSuccess) {
            BlocProvider.of<LoginBloc>(context).add(const StartTimerEvent());
            showModalBottomSheet(
                context: context,
                enableDrag: true,
                backgroundColor: Colors.white,
                builder: (context) {
                  return OtpBottomSheetWidget(
                      isSelf: true, email: _emailController.text);
                });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Center(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomTextField(
                        hintText: "Masukkan Email",
                        borderColor: Colors.black26,
                        textEditingController: _emailController,
                        errorText: state is SendOtpFailed ? state.error : null,
                        isOutlineBorder: true,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomFilledButton(
                          buttonText: "Kirim OTP",
                          onPressed: () {
                            BlocProvider.of<LoginBloc>(context)
                                .add(SubmitEmailEvent(_emailController.text));
                          },
                          color: AppColors.green600,
                          textStyle: CustomTextStyle.body3
                              .copyWith(color: Colors.white),
                        ))
                  ],
                ),
              ),
              if (state is LoginLoading) ...[
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.red500,
                    ),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
