import 'dart:convert';
import 'package:deadstock/Screens/agora_chet.dart';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QueriesScreen extends StatefulWidget {
  const QueriesScreen({super.key});

  @override
  State<QueriesScreen> createState() => _QueriesScreenState();
}

class _QueriesScreenState extends State<QueriesScreen> {
  bool isActive = false;
  List QueriesList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    QueriesListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Services Queries",
              style: GoogleFonts.dmSans(
                color: Color(0xffffffff),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
          backgroundColor: Color(0x80bc322d),
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
                color: Color(0xffffffff),
              ),
            ),
          ),
        ),
        body: (isActive)
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xffbc322d),
                  strokeWidth: 1.5,
                ),
              )
            : (QueriesList.isNotEmpty)
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(top: 15),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: QueriesList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 15,
                                left: 10,
                                right: 10,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(children: [
                                Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    height: 100,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://deadstock.webkype.co/public/ad/${QueriesList[index]["logo"]}"),
                                            fit: BoxFit.fitWidth)),
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(QueriesList[index]["title"],
                                              style: GoogleFonts.dmSans(
                                                color: Color(0xff000000),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(
                                              "₹ ${QueriesList[index]["price"]}",
                                              style: GoogleFonts.dmSans(
                                                color: const Color(0xff535353),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(
                                              "${QueriesList[index]["description"]}",
                                              maxLines: 3,
                                              style: GoogleFonts.dmSans(
                                                color: const Color(0xff535353),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ]),
                                  ),
                                ]),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AgoraChat(
                                        chatID: QueriesList[index]
                                            ["chat_channel"],
                                        receiver_id: QueriesList[index]
                                            ["user_id"].toString(),
                                        name: QueriesList[index]["title"],
                                        ad_id: QueriesList[index]["ad_id"].toString(),
                                      );
                                    }));
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0x80bc322d),
                                            Color(0xcdbc322d),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/email.png",
                                              color: Colors.white,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Start Chat",
                                              style: GoogleFonts.spaceGrotesk(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ])),
                                ),
                              ]),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Text("No queries yet!!",
                        style: GoogleFonts.dmSans(
                          color: const Color(0xff535353),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ))));
  }

  Future QueriesListAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https.get(
        Uri.parse("https://deadstock.webkype.co/api/service_queries/${UID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          QueriesList = data["enquiries"];
          isActive = false;
        });
      }
    }
  }
}
