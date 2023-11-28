import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:deadstock/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_rating/star_rating.dart';

class WriteReview extends StatefulWidget {
  final String ID;
  final String Type;
  const WriteReview({super.key, required this.ID, required this.Type});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final int starLength = 5;
  double _rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Write a review",
            style: GoogleFonts.dmSans(
              color: Color(0xff000000),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        leadingWidth: 35,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
              color: Color(0xff000000),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 20,
            ),
            Text("Rating",
                style: GoogleFonts.dmSans(
                  color: Color(0xff000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(
              height: 10,
            ),
            StarRating(
              color: Color(0xfffaa83c),
              mainAxisAlignment: MainAxisAlignment.start,
              length: starLength,
              rating: _rating,
              between: 5,
              starSize: 30,
              onRaitingTap: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFieldWidget(
              controller: titleController,
              obscureText: false,
              inputType: TextInputType.text,
              text: "Review Title",
              hintText: "Give your review a title",
              cursorColor: Color(0xffbc322d),
              inputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Description",
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
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                cursorColor: Color(0xffbc322d),
                controller: commentController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: InputBorder.none,
                  hintText: "Write your comment here",
                  hintStyle: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade400),
                ),
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: GestureDetector(
                onTap: () {
                  if (widget.Type == "User") {
                    UserReviewApi();
                  } else {
                    ProductReviewApi();
                  }
                },
                child: ButtonWidget(
                  text: "Submit",
                  color: Color(0xffbc322d),
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ])),
    );
  }

  Future<void> UserReviewApi() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ));
        });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/user_review/${UID}"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "rating": "${_rating}",
          "review_title": titleController.text,
          "message": commentController.text,
          "user_id": widget.ID,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> ProductReviewApi() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ));
        });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/product_review/${UID}"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "rating": "${_rating}",
          "review_title": titleController.text,
          "message": commentController.text,
          "ad_id": widget.ID,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      }
    }
  }
}
