import 'dart:convert';
import 'package:deadstock/Screens/search_screen.dart';
import 'package:http/http.dart' as https;
import 'package:deadstock/Screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isActive = false;
  List CatagoryList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    CatagoryApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          title: Text("Category",
              style: GoogleFonts.dmSans(
                color: Color(0xffffffff),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
          backgroundColor: Color(0x80bc322d),
          automaticallyImplyLeading: false,
          elevation: 0,
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Navigator.push(context, MaterialPageRoute(builder: (context) {
          //           return const SearchScreen();
          //         }));
          //       },
          //       icon: Image.asset(
          //         "assets/icons/search.png",
          //         width: 23,
          //         color: const Color(0xffffffff),
          //       )),
          // ]
      ),
      body: (isActive)
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xffbc322d),
                strokeWidth: 1.5,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: CatagoryList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductScreen(
                            text: CatagoryList[index]["category_name"],
                            Id: CatagoryList[index]["id"].toString(),
                          );
                        }));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  radius: 57,
                                  child: Image.network(
                                      "https://deadstock.webkype.co/public/public/category/icon/${CatagoryList[index]["icon"]}"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(CatagoryList[index]["category_name"],
                                    style: GoogleFonts.dmSans(
                                      color: const Color(0xff535353),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Future CatagoryApi() async {
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/main_category"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          CatagoryList = data["data"];
          isActive = false;
        });
      }
    }
  }
}
