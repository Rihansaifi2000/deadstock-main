import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as https;
import 'package:deadstock/Screens/otp_screen.dart';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:deadstock/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Forgot Password",
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
          Text("Enter the Phone number associated with your account.",
              textAlign: TextAlign.start,
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(
            height: 30,
          ),
          TextFieldWidget(
            controller: phoneController,
            obscureText: false,
            inputType: TextInputType.phone,
            text: "Phone Number",
            hintText: "Enter your phone number",
            cursorColor: Color(0xffbc322d),
            inputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () {
              forgotApi();
            },
            child: ButtonWidget(
              text: "Send",
              color: Color(0xffbc322d),
              textColor: Colors.white,
              width: MediaQuery.of(context).size.width,
            ),
          )
        ]),
      ),
    );
  }

  Future<void> forgotApi() async {
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
        Uri.parse("https://deadstock.webkype.co/api/fpassword"),
        headers: {"Accept": "application/json"},
        body: {"phone": phoneController.text, "account_type": "u"});
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OTPScreen(
            otp: data["otp"].toString(),
            phone: phoneController.text,
          );
        }));
      } else {
        dialogBox(data["message"]);
      }
    } else {
      Navigator.of(context).pop();
      final data = json.decode(response.body);
      dialogBox(data["message"]);
    }
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
