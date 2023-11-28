import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isActive = false;
  List NotificationList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    NotificationListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Notification",
            style: GoogleFonts.dmSans(
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: Color(0x80bc322d),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: (isActive)
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xffbc322d),
                strokeWidth: 1.5,
              ),
            )
          : (NotificationList.isNotEmpty)
          ? SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: NotificationList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      "assets/icons/ribbon.png",
                      width: 25,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(
                    NotificationList[index]["notification"],
                    style: GoogleFonts.dmSans(
                      color: const Color(0xff000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd MMM y - h:mm a').format(
                        DateTime.parse(
                            NotificationList[index]["created_at"])),
                    style: GoogleFonts.dmSans(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.black45,
                  indent: 15,
                  endIndent: 15,
                );
              },
            ),
          ],
        ),
      )
          : Center(
          child: Text("No notification yet!",
              style: GoogleFonts.dmSans(
                color: const Color(0xff535353),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ))));
  }

  Future NotificationListAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/notification/${UID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          NotificationList = data["notification"];
          isActive = false;
        });
      }
    }
  }
}
