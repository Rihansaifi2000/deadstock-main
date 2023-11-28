import 'dart:convert';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:deadstock/Screens/new_password_screen.dart';
import 'package:http/http.dart' as https;
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatefulWidget {
  final String otp;
  final String phone;
  const OTPScreen({super.key, required this.otp, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String CheckOTP = "";
  String OTP = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      CheckOTP = widget.otp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Verification",
          style: GoogleFonts.dmSans(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 35,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Text("Enter the verification code we just sent to ${widget.phone}.",
              textAlign: TextAlign.start,
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(
            height: 30,
          ),
          OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 55,
            style: GoogleFonts.dmSans(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            otpFieldStyle: OtpFieldStyle(
              borderColor: Colors.grey.shade100,
              disabledBorderColor: Colors.grey.shade100,
              focusBorderColor: Color(0xffbc322d),
            ),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) {
              setState(() {
                OTP = pin.toString();
              });
            },
          ),
          const SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () {
              if (CheckOTP == OTP) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NewPassword(
                    phone: widget.phone,
                  );
                }));
              } else {
                Fluttertoast.showToast(
                    msg: "The OTP entered is incorrect.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: ButtonWidget(
              text: "Verify",
              color: Color(0xffbc322d),
              textColor: Colors.white,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Didn’t receive the code?",
                style: GoogleFonts.dmSans(
                  color: const Color(0xff535353),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
            ArgonTimerButton(
              initialTimer: 60, // Optional
              height: 50,
              width: MediaQuery.of(context).size.width * 0.35,
              minWidth: MediaQuery.of(context).size.width * 0.35,
              color: Color(0xffbc322d),
              borderRadius: 5.0,
              child: Text(
                "Resend OTP",
                style: GoogleFonts.dmSans(
                    color: Color(0xffbc322d),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              loader: (timeLeft) {
                return Text(
                  "Wait $timeLeft Sec",
                  style: GoogleFonts.dmSans(
                      color: Color(0xffbc322d),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                );
              },
              onTap: (startTimer, btnState) {
                if (btnState == ButtonState.Idle) {
                  startTimer(60);
                }
                ResendOTPApi();
              },
            ),
          ]),
          const SizedBox(
            height: 15,
          ),
        ]),
      ),
    );
  }

  Future<void> ResendOTPApi() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ));
        });
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/resend_otp"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "phone": widget.phone,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          CheckOTP = data["otp"].toString();
        });
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }
}
