import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:deadstock/Screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  final String Lat;
  final String Long;
  const SearchScreen({super.key, required this.Lat, required this.Long});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isActive = false;
  List ProductList = [];
  int searchCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Color(0x80bc322d),
          automaticallyImplyLeading: false,
          elevation: 0,
          leadingWidth: 35,
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xffffffff),
              ),
            ),
          ),
          title: Container(
            height: 45,
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TextField(
                autofocus: false,
                cursorColor: Colors.black,
                controller: searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isActive = true;
                          ProductList.clear();
                          searchCount = 1;
                        });
                        SearchApi("", "");
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: "Search for product",
                    hintStyle: GoogleFonts.dmSans(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
                style: GoogleFonts.dmSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                onSubmitted: (_) {
                  setState(() {
                    isActive = true;
                    ProductList.clear();
                    searchCount = 1;
                  });
                  SearchApi("", "");
                }),
          ),
        ),
        body: (isActive)
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xffbc322d),
                  strokeWidth: 1.5,
                ),
              )
            : (ProductList.isNotEmpty)
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: ProductList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailScreen(
                                  Id: ProductList[index]["id"].toString(),
                                );
                              }));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
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
                                                "https://deadstock.webkype.co/public/ad/${ProductList[index]["logo"]}"),
                                            fit: BoxFit.fitWidth)),
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${ProductList[index]["title"]}",
                                              style: GoogleFonts.dmSans(
                                                color: Color(0xff000000),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(
                                              "₹ ${ProductList[index]["price"]}",
                                              style: GoogleFonts.dmSans(
                                                color: const Color(0xff535353),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(
                                              "${ProductList[index]["description"]}",
                                              maxLines: 3,
                                              style: GoogleFonts.dmSans(
                                                color: const Color(0xff535353),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ]),
                                  ),
                                ]),
                              ]),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Text("Nothing to show",
                        style: GoogleFonts.dmSans(
                          color: (searchCount == 0)
                              ? Colors.grey.shade100
                              : Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ));
  }

  Future<void> SearchApi(String lat, long) async {
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/search_product_list"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "keyword": searchController.text,
          "latitude": widget.Lat,
          "longitude": widget.Long
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          ProductList = data["servises"];
          isActive = false;
        });
      }
    }
  }
}
