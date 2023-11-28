import 'dart:convert';
import 'dart:ui';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:deadstock/Screens/forgot_password_screen.dart';
import 'package:deadstock/Widgets/bottombar_widget.dart';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:deadstock/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController FnameController = TextEditingController();
  final TextEditingController LnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  int segmentedControlValue = 0;
  var chechOTP = "";
  bool value = false;
  String OTP = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 100),
          height: MediaQuery.of(context).size.height / 2.5,
          color: Color(0xffbc322d),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.3)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Hello, There",
                  style: GoogleFonts.dmSans(
                    color: Color(0xffffffff),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
              Text("Welcome Back",
                  style: GoogleFonts.dmSans(
                    color: Color(0xffffffff),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: 20,
              ),
              CustomSlidingSegmentedControl<int>(
                innerPadding: EdgeInsets.all(4),
                fixedWidth: MediaQuery.of(context).size.width / 2.58,
                initialValue: segmentedControlValue,
                children: {
                  0: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'LogIn',
                      style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: (segmentedControlValue == 0)
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Register',
                      style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: (segmentedControlValue == 1)
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                },
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(50),
                ),
                thumbDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInToLinear,
                onValueChanged: (i) {
                  setState(() {
                    segmentedControlValue = i;
                  });
                },
              ),
            ]),
          ),
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            width: MediaQuery.of(context).size.width,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: (segmentedControlValue == 0)
                ? SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Login to Your Account",
                              style: GoogleFonts.dmSans(
                                color: Color(0xff000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Make sure that you already have an account.",
                              style: GoogleFonts.dmSans(
                                color: const Color(0xff535353),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          TextFieldWidget(
                            controller: phoneController,
                            obscureText: false,
                            inputType: TextInputType.phone,
                            text: "Phone No",
                            hintText: "Enter your phone no",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            controller: passwordController,
                            obscureText: true,
                            inputType: TextInputType.visiblePassword,
                            text: "Password",
                            hintText: "Enter your password",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.done,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ForgotPassword();
                              }));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.dmSans(
                                  color: Color(0xffbc322d),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (phoneController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                loginApi();
                              }
                            },
                            child: ButtonWidget(
                              text: "LogIn",
                              color: Color(0xffbc322d),
                              textColor: Colors.white,
                              width: MediaQuery.of(context).size.width,
                            ),
                          )
                        ]),
                  )
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create Your Account",
                              style: GoogleFonts.dmSans(
                                color: Color(0xff000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Make sure your account keep secure.",
                              style: GoogleFonts.dmSans(
                                color: const Color(0xff535353),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          TextFieldWidget(
                            controller: FnameController,
                            obscureText: false,
                            inputType: TextInputType.name,
                            text: "First Name",
                            hintText: "Enter your first name",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            controller: LnameController,
                            obscureText: false,
                            inputType: TextInputType.name,
                            text: "Last Name",
                            hintText: "Enter your last name",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            controller: phoneController,
                            obscureText: false,
                            inputType: TextInputType.phone,
                            text: "Phone No",
                            hintText: "Enter your phone no",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            controller: emailController,
                            obscureText: false,
                            inputType: TextInputType.emailAddress,
                            text: "Email Address",
                            hintText: "Enter your email",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            controller: passwordController,
                            obscureText: true,
                            inputType: TextInputType.visiblePassword,
                            text: "Password",
                            hintText: "Enter your password",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget(
                            controller: confirmController,
                            obscureText: true,
                            inputType: TextInputType.visiblePassword,
                            text: "Confirm Password",
                            hintText: "Confirm your password",
                            cursorColor: Color(0xffbc322d),
                            inputAction: TextInputAction.done,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Expanded(
                              child: Text(
                                  "I agree with the terms and conditions by creating an account",
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xff535353),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Checkbox(
                              activeColor: Color(0xffbc322d),
                              value: this.value,
                              onChanged: (value) {
                                setState(() {
                                  this.value = value!;
                                });
                              },
                            ),
                          ]),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (value == true) {
                                RegisterApi();
                              }
                            },
                            child: ButtonWidget(
                              text: "Create Account",
                              color: Color(0xffbc322d),
                              textColor: Colors.white,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ]),
                  ))
      ]),
    );
  }

  void OTPScreen() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 25,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Verify Your Account",
                            style: GoogleFonts.dmSans(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            "assets/images/blank-profile-picture-973460_1280.png"),
                        backgroundColor: Colors.grey.shade200,
                        radius: 45,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("${FnameController.text} ${LnameController.text}",
                          style: GoogleFonts.dmSans(
                            color: Color(0xff000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(emailController.text,
                          style: GoogleFonts.dmSans(
                            color: const Color(0xff535353),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Color(0xffFFF5DD),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Color(0xffF0B212),
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                  "We have send you 6 digits verification code to your email. Please kindly check",
                                  style: GoogleFonts.dmSans(
                                    color: Color(0xffF0B212),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 45,
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
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (chechOTP == OTP) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const BottomNavBar()),
                                (route) => false);
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
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.35,
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
                    ]),
                  ));
            }),
          );
        });
  }

  Future<void> loginApi() async {
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
        Uri.parse("https://deadstock.webkype.co/api/user_login"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "phone": phoneController.text,
          "account_type": "u",
          "password": passwordController.text
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        userID(
          data["profile"]["id"].toString(),
        );
      } else {
        dialogBox(data["message"]);
      }
    } else {
      Navigator.of(context).pop();
      final data = json.decode(response.body);
      dialogBox(data["message"]);
    }
  }

  Future<void> RegisterApi() async {
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
        Uri.parse("https://deadstock.webkype.co/api/user_registration"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "firstName": FnameController.text,
          "lastName": LnameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "account_type": "u",
          "password": passwordController.text,
          "password_confirmation": confirmController.text
        });
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString("UserID", data["user_id"].toString());
        setState(() {
          chechOTP = data["otp"].toString();
        });
        Navigator.of(context).pop();
        OTPScreen();
      } else {
        dialogBox(data["message"]);
      }
    } else {
      Navigator.of(context).pop();
      final data = json.decode(response.body);
      dialogBox(data["message"]);
    }
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
          "email": emailController.text,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          chechOTP = data["otp"].toString();
        });
        Navigator.of(context).pop();
      } else {
        dialogBox(data["message"]);
      }
    } else {
      Navigator.of(context).pop();
      final data = json.decode(response.body);
      dialogBox(data["message"]);
    }
  }

  void userID(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("UserID", id);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
        (route) => false);
  }

  dialogBox(String msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: AlertDialog(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text('Error', style: GoogleFonts.outfit()),
              content: Text(msg, style: GoogleFonts.outfit()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK', style: GoogleFonts.outfit()),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          );
        });
  }
}
