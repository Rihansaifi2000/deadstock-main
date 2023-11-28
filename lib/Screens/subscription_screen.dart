import 'package:deadstock/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  String subscription = "free";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Subscription",
            style: GoogleFonts.dmSans(
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: Color(0x80bc322d),
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 35,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color(0xffffffff),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text(
            "Select the subscription and pay the fees. Once fees is approved, You subscription will be active.",
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: const Color(0xff000000),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: RadioListTile(
              activeColor: Color(0xffbc322d),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Basic",
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Validity: 1 Month\nFeatured Services: 1\nVideo URL: Not Available\nCategories Access: All",
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color(0xffbc322d).withOpacity(0.4),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50))),
                            child: Text(
                              "Services: 50",
                              style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "\$ 0.0",
                            style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ])
                  ]),
              value: "free",
              groupValue: subscription,
              onChanged: (value) {
                setState(() {
                  subscription = value.toString();
                });
              },
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.only(bottom: 20),
          //   margin: const EdgeInsets.only(top: 20),
          //   decoration: BoxDecoration(
          //       color: Colors.white, borderRadius: BorderRadius.circular(10)),
          //   child: RadioListTile(
          //     activeColor: Color(0xffbc322d),
          //     title: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Boost",
          //             style: GoogleFonts.dmSans(
          //               fontSize: 18,
          //               color: const Color(0xff000000),
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Text(
          //             "Validity: 15 days\nBid/Auction Features: 5\nFeatured Services: 5\nVideo URL: Available\nCategories Access: 10\nRemaining Services: 10/10",
          //             style: GoogleFonts.dmSans(
          //               fontSize: 14,
          //               color: const Color(0xff000000),
          //               fontWeight: FontWeight.w400,
          //             ),
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Container(
          //                   width: MediaQuery.of(context).size.width / 3,
          //                   alignment: Alignment.center,
          //                   padding: const EdgeInsets.all(10),
          //                   decoration: BoxDecoration(
          //                       color: Color(0xffbc322d).withOpacity(0.4),
          //                       borderRadius: const BorderRadius.all(
          //                           Radius.circular(50))),
          //                   child: Text(
          //                     "Services: 10",
          //                     style: GoogleFonts.dmSans(
          //                       textStyle: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 16,
          //                         fontWeight: FontWeight.w400,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Text(
          //                   "₹ 1,800.0",
          //                   style: GoogleFonts.dmSans(
          //                     textStyle: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: 18,
          //                       fontWeight: FontWeight.w500,
          //                     ),
          //                   ),
          //                 )
          //               ])
          //         ]),
          //     value: "Boost",
          //     groupValue: subscription,
          //     onChanged: (value) {
          //       setState(() {
          //         subscription = value.toString();
          //       });
          //     },
          //   ),
          // ),
          // Container(
          //   padding: const EdgeInsets.only(bottom: 20),
          //   margin: const EdgeInsets.only(top: 20),
          //   decoration: BoxDecoration(
          //       color: Colors.white, borderRadius: BorderRadius.circular(10)),
          //   child: RadioListTile(
          //     activeColor: Color(0xffbc322d),
          //     title: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Premium",
          //             style: GoogleFonts.dmSans(
          //               fontSize: 18,
          //               color: const Color(0xff000000),
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Text(
          //             "Validity: 30 days\nBid/Auction Features: Unlimited\nFeatured Services: 10\nVideo URL: Available\nCategories Access: 20\nRemaining Services: 20/20",
          //             style: GoogleFonts.dmSans(
          //               fontSize: 14,
          //               color: const Color(0xff000000),
          //               fontWeight: FontWeight.w400,
          //             ),
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Container(
          //                   width: MediaQuery.of(context).size.width / 3,
          //                   alignment: Alignment.center,
          //                   padding: const EdgeInsets.all(10),
          //                   decoration: BoxDecoration(
          //                       color: Color(0xffbc322d).withOpacity(0.4),
          //                       borderRadius: const BorderRadius.all(
          //                           Radius.circular(50))),
          //                   child: Text(
          //                     "Services: 5",
          //                     style: GoogleFonts.dmSans(
          //                       textStyle: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 16,
          //                         fontWeight: FontWeight.w400,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Text(
          //                   "₹ 17,000.0",
          //                   style: GoogleFonts.dmSans(
          //                     textStyle: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: 18,
          //                       fontWeight: FontWeight.w500,
          //                     ),
          //                   ),
          //                 )
          //               ])
          //         ]),
          //     value: "Premium",
          //     groupValue: subscription,
          //     onChanged: (value) {
          //       setState(() {
          //         subscription = value.toString();
          //       });
          //     },
          //   ),
          // ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {},
            child: ButtonWidget(
              text: "Pay/Save",
              color: Color(0xffbc322d),
              textColor: Colors.white,
              width: MediaQuery.of(context).size.width - 100,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
