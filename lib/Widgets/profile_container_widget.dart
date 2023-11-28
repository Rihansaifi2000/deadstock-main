import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerWidget extends StatefulWidget {
  final String image;
  final String text;
  const ContainerWidget({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  State<ContainerWidget> createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Card(
      color: Colors.white,
      elevation: 0,
      child:
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Image.asset(
            widget.image,
            width: 23,
            color: Color(0xffbc322d),
          ),
          const SizedBox(width: 20),
          Text(
            widget.text,
            style: GoogleFonts.dmSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ]),
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black54,
          size: 23,
        ),
      ]),
    ),
  );
}
