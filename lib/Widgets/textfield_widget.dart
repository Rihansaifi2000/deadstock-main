import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatefulWidget {
  final Color cursorColor;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool obscureText;
  final String text;
  final String hintText;
  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.inputType,
    required this.text,
    required this.hintText,
    required this.cursorColor,
    required this.inputAction,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.text,
            style: GoogleFonts.dmSans(
              color: Color(0xff000000),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: TextField(
            cursorColor: widget.cursorColor,
            obscureText: widget.obscureText,
            controller: widget.controller,
            keyboardType: widget.inputType,
            textInputAction: widget.inputAction,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade400),
            ),
            style: GoogleFonts.dmSans(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
