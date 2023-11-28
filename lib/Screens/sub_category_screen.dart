import 'package:deadstock/Screens/product_screen.dart';
import 'package:deadstock/Widgets/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubCategory extends StatefulWidget {
  final String text;
  const SubCategory({super.key, required this.text});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Stack(clipBehavior: Clip.none, children: [
        Container(
          color: Color(0x80bc322d),
          padding: const EdgeInsets.only(top: 30, bottom: 39),
          child: Row(children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color(0xffffffff),
              ),
            ),
            Text(widget.text,
                style: GoogleFonts.dmSans(
                  color: Color(0xffffffff),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ]),
        ),
        Positioned(
          bottom: -27.5,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.1,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: TextField(
                    autofocus: false,
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 25,
                        ),
                        border: InputBorder.none,
                        hintText: "Search for services",
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
                      // if (searchController.text.isNotEmpty) {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(
                      //           builder: (context) {
                      //             return SearchScreen(
                      //               text: searchController.text,
                      //             );
                      //           })).whenComplete(
                      //           () => searchController.clear());
                      // }
                    }),
              ),
            ),
          ),
        ),
      ]),
      SizedBox(
        height: 25,
      ),
      Container(
        height: MediaQuery.of(context).size.height / 1.19,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GridView.builder(
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return ProductScreen(text: data[index].text, Image: data[index].imageUrl,);
                // }));
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
                            radius: 30,
                            child: Image.asset(
                              data[index].imageUrl,
                              width: 30,
                            )),
                        Text(data[index].text,
                            style: GoogleFonts.dmSans(
                              color: const Color(0xff535353),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            )),
                      ]),
                ),
              ),
            );
          },
        ),
      ),
    ]));
  }
}
