import 'dart:convert';
import 'package:deadstock/Screens/edit_services_screen.dart';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostedServices extends StatefulWidget {
  const PostedServices({super.key});

  @override
  State<PostedServices> createState() => _PostedServicesState();
}

class _PostedServicesState extends State<PostedServices> {
  bool isActive = false;
  List MyServiceList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    MyServiceListApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Posted Services",
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
        body: (isActive)
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xffbc322d),
                  strokeWidth: 1.5,
                ),
              )
            : (MyServiceList.isNotEmpty)
                ? ListView.builder(
                    itemCount: MyServiceList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin:
                              EdgeInsets.only(bottom: 15, left: 10, right: 10),
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
                                            "https://deadstock.webkype.co/public/ad/${MyServiceList[index]["logo"]}"),
                                        fit: BoxFit.fitWidth)),
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${MyServiceList[index]["title"]}",
                                          style: GoogleFonts.dmSans(
                                            color: Color(0xff000000),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text("₹ ${MyServiceList[index]["price"]}",
                                          style: GoogleFonts.dmSans(
                                            color: const Color(0xff535353),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(
                                          "${MyServiceList[index]["description"]}",
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
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EditService(
                                        ID: MyServiceList[index]["id"]
                                            .toString(),
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
                                              "assets/icons/edit.png",
                                              color: Colors.white,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Edit",
                                              style: GoogleFonts.dmSans(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ])),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    DeleteApi(
                                        MyServiceList[index]["id"].toString());
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
                                            Color(0xcdbc322d),
                                            Color(0x80bc322d),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/trash.png",
                                              color: Colors.white,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Delete",
                                              style: GoogleFonts.dmSans(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ])),
                                ),
                              )
                            ])
                          ]),
                        ),
                      );
                    })
                : Center(
                    child: Text("Your Don't post any service yet!!",
                        style: GoogleFonts.dmSans(
                          color: const Color(0xff535353),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ))));
  }

  Future MyServiceListApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    print(UID);
    var response = await https.get(
        Uri.parse("https://deadstock.webkype.co/api/user_product_list/${UID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          MyServiceList = data["data"];
          isActive = false;
        });
      }
    }
  }

  Future DeleteApi(String ID) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ));
        });
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/delete_service/${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        MyServiceListApi();
      }
    }
  }
}
