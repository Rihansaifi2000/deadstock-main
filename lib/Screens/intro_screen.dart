import 'package:deadstock/Screens/login_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
        finishButtonText: 'Continue',
        finishButtonStyle: FinishButtonStyle(
            backgroundColor: Color(0xffbc322d),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70))),
        onFinish: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginRegisterScreen();
          }));
        },
        trailingFunction: () {},
        totalPage: 2,
        headerBackgroundColor: Colors.white,
        pageBackgroundColor: Colors.white,
        background: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Image.asset(
              'assets/images/user-friendly.png',
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Image.asset(
              'assets/images/user-friendly.png',
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
        speed: 1.5,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                  ),
                  Text.rich(
                    TextSpan(
                        text: "Find Your ",
                        style: GoogleFonts.dmSans(
                          color: Color(0xff000000),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                              text: "\nDream Shops ",
                              style: GoogleFonts.dmSans(
                                color: Color(0xffbc322d),
                                decoration: TextDecoration.underline,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              )),
                          TextSpan(
                              text: "\nHere!",
                              style: GoogleFonts.dmSans(
                                color: Color(0xff000000),
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              )),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Explore all the most exciting job roles based on your interest and study major.',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color(0xff535353)),
                  ),
                ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                  ),
                  Text.rich(
                    TextSpan(
                        text: "Find Your ",
                        style: GoogleFonts.dmSans(
                          color: Color(0xff000000),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                              text: "\nDream Shops ",
                              style: GoogleFonts.dmSans(
                                color: Color(0xffbc322d),
                                decoration: TextDecoration.underline,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              )),
                          TextSpan(
                              text: "\nHere!",
                              style: GoogleFonts.dmSans(
                                color: Color(0xff000000),
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              )),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Explore all the most exciting job roles based on your interest and study major.',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color(0xff535353)),
                  ),
                ]),
          ),
        ]);
  }
}
