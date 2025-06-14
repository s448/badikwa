import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_bloc.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_event.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_state.dart';
import 'package:prufcoach/core/utils/app_messages.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/screens/auth/new_password_page.dart';
import 'package:prufcoach/views/widgets/buttons.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state is OtpVerificationSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: BlocProvider.of<ResetPasswordBloc>(context),
                    child: NewPasswordPage(email: state.email),
                  ),
            ),
          );
        } else if (state is OtpVerificationError) {
          log("OTP Verification Error: ${state.message}");
          appMessageShower(
            context,
            "Error",
            state.message ?? "An error occurred while verifying OTP.",
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "OTP Verification",
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter the OTP sent to your email",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Pinput(
                  length: 6,
                  autofocus: true,
                  controller: _otpCtrl,
                  onCompleted: (pin) {
                    context.read<ResetPasswordBloc>().add(
                      VerifyOtpEvent(widget.email, pin),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  child: const Text(
                    "Verify OTP",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    if (_otpCtrl.text.length == 6) {
                      context.read<ResetPasswordBloc>().add(
                        VerifyOtpEvent(widget.email, _otpCtrl.text),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid OTP"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
