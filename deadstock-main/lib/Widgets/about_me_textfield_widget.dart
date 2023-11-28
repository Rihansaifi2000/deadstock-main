import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMeTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String hintText;
  final String image;
  final int maxline;
  const AboutMeTextFieldWidget(
      {super.key,
      required this.controller,
      required this.inputType,
      required this.hintText,
      required this.image,
      required this.inputAction,
      required this.maxline});

  @override
  State<AboutMeTextFieldWidget> createState() => _AboutMeTextFieldWidgetState();
}

class _AboutMeTextFieldWidgetState extends State<AboutMeTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Row(
        children: [
          Image.asset(
            widget.image,
            width: 23,
            color: Colors.black54,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(
                cursorColor: Color(0xffbc322d),
                autofocus: false,
                controller: widget.controller,
                keyboardType: widget.inputType,
                textInputAction: widget.inputAction,
                maxLines: widget.maxline,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.dmSans(
                      color: Colors.black26,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                style: GoogleFonts.dmSans(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                onSubmitted: (_) {}),
          ),
        ],
      ),
    );
  }
}
