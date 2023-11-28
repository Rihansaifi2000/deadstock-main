import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double width;
  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.color,
      required this.textColor,
      required this.width})
      : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) => Container(
        width: widget.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.5),
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(50))),
        child: Text(
          widget.text,
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
              color: widget.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}
