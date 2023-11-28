import 'dart:convert';
import 'dart:ui';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:deadstock/Widgets/textfield_widget.dart';
import 'package:http/http.dart' as https;
import 'package:deadstock/Screens/login_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPassword extends StatefulWidget {
  final String phone;
  const NewPassword({super.key, required this.phone});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController NewPasswordController = TextEditingController();
  final TextEditingController ConPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "New Password",
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
          Text(
              "Set the new password for your account so you can login and access all tha features.",
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
            controller: NewPasswordController,
            obscureText: true,
            inputType: TextInputType.visiblePassword,
            text: "Enter new password",
            hintText: "Enter your new password",
            cursorColor: Color(0xffbc322d),
            inputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldWidget(
            controller: ConPasswordController,
            obscureText: true,
            inputType: TextInputType.visiblePassword,
            text: "Confirm Password",
            hintText: "Re-enter your password",
            cursorColor: Color(0xffbc322d),
            inputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              ChangePassApi();
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

  Future<void> ChangePassApi() async {
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
        Uri.parse("https://deadstock.webkype.co/api/updatePassword"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "phone": widget.phone,
          "password": NewPasswordController.text,
          "password_confirmation": ConPasswordController.text,
          "account_type": "u"
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginRegisterScreen()),
            (route) => false);
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
