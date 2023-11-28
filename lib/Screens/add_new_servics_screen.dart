import 'dart:convert';
import 'dart:io';
import 'package:deadstock/Screens/map_screen.dart';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

class AddNewService extends StatefulWidget {
  const AddNewService({super.key});

  @override
  State<AddNewService> createState() => _AddNewServiceState();
}

class _AddNewServiceState extends State<AddNewService> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool value = false;
  Map<String, String> filterValuesMap = {};
  List CategoryList = [];
  List<dynamic> filterList = [];
  var Country;
  var country = ["Us"];
  var State;
  List stateList = [];
  var City;
  List cityList = [];
  var Category;
  List category = [];
  var Category1;
  List category1 = [];
  var Category2;
  List category2 = [];
  var Category3;
  List category3 = [];
  var Category4;
  List category4 = [];
  List<File> selectedImages = [];
  List<XFile> pickedFile = [];
  List returnData = [];
  final picker = ImagePicker();
  void selectImages() async {
    pickedFile = await picker.pickMultiImage(
      imageQuality: 50,
    );
    setState(
      () {
        if (pickedFile.isNotEmpty) {
          for (var i = 0; i < pickedFile.length; i++) {
            selectedImages.add(File(pickedFile[i].path));
          }
        }
      },
    );
  }

  bool isActive = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    StateApi();
    CatagoryApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0x80bc322d),
        automaticallyImplyLeading: false,
        title: Text(
          "Add Service",
          style: GoogleFonts.dmSans(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: (isActive)
            ? Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.5),
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Color(0xffbc322d),
                  strokeWidth: 1.5,
                ),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    "Details",
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "Select Category",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54, width: 1.5)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        value: Category,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.black54,
                        ),
                        hint: Text(
                          "Select",
                          style: GoogleFonts.dmSans(
                            color: Colors.black26,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        elevation: 1,
                        underline: Container(height: 1, color: Colors.black45),
                        onChanged: (String? newValue) {
                          setState(() {
                            Category = newValue!;
                          });
                          Catagory1Api(newValue!);
                        },
                        items: category.map<DropdownMenuItem<String>>((index) {
                          return DropdownMenuItem<String>(
                            value: index["id"].toString(),
                            child: Text(
                              index["category_name"],
                              style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                (category1.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            child: Text(
                              "Select Sub Category 1",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black54, width: 1.5)),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  value: Category1,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  hint: Text(
                                    "Select",
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black26,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  elevation: 1,
                                  underline: Container(
                                      height: 1, color: Colors.black45),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Category1 = newValue!;
                                    });
                                  },
                                  items: category1
                                      .map<DropdownMenuItem<String>>((index) {
                                    return DropdownMenuItem<String>(
                                      value: index["id"].toString(),
                                      child: Text(
                                        index["category_name"],
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
                (category2.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            child: Text(
                              "Select Sub Category 2",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black54, width: 1.5)),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  value: Category2,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  hint: Text(
                                    "Select",
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black26,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  elevation: 1,
                                  underline: Container(
                                      height: 1, color: Colors.black45),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Category2 = newValue!;
                                    });
                                  },
                                  items: category2
                                      .map<DropdownMenuItem<String>>((index) {
                                    return DropdownMenuItem<String>(
                                      value: index["id"].toString(),
                                      child: Text(
                                        index["category_name"],
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                (category3.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            child: Text(
                              "Select Sub Category 3",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black54, width: 1.5)),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  value: Category3,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  hint: Text(
                                    "Select",
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black26,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  elevation: 1,
                                  underline: Container(
                                      height: 1, color: Colors.black45),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Category3 = newValue!;
                                    });
                                  },
                                  items: category3
                                      .map<DropdownMenuItem<String>>((index) {
                                    return DropdownMenuItem<String>(
                                      value: index["id"].toString(),
                                      child: Text(
                                        index["category_name"],
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                (category4.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            child: Text(
                              "Select Sub Category 4",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black54, width: 1.5)),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  value: Category4,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  hint: Text(
                                    "Select",
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black26,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  elevation: 1,
                                  underline: Container(
                                      height: 1, color: Colors.black45),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Category4 = newValue!;
                                    });
                                  },
                                  items: category4
                                      .map<DropdownMenuItem<String>>((index) {
                                    return DropdownMenuItem<String>(
                                      value: index["id"].toString(),
                                      child: Text(
                                        index["category_name"],
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "Country",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        value: Country,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.black54,
                        ),
                        hint: Text(
                          "Select",
                          style: GoogleFonts.dmSans(
                            color: Colors.black26,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        elevation: 1,
                        underline: Container(height: 1, color: Colors.black45),
                        onChanged: (String? newValue) {
                          setState(() {
                            Country = newValue!;
                          });
                        },
                        items: country
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "State",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54, width: 1.5)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        value: State,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.black54,
                        ),
                        hint: Text(
                          "Select",
                          style: GoogleFonts.dmSans(
                            color: Colors.black26,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        elevation: 1,
                        underline: Container(height: 1, color: Colors.black45),
                        onChanged: (String? newValue) {
                          setState(() {
                            State = newValue!;
                          });
                          CityApi(newValue!);
                        },
                        items: stateList.map<DropdownMenuItem<String>>((index) {
                          return DropdownMenuItem<String>(
                            value: index["id"].toString(),
                            child: Text(
                              index["name"],
                              style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                (cityList.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            child: Text(
                              "City",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black54, width: 1.5)),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  )),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  value: City,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  hint: Text(
                                    "Select",
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black26,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  elevation: 1,
                                  underline: Container(
                                      height: 1, color: Colors.black45),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      City = newValue!;
                                    });
                                  },
                                  items: cityList
                                      .map<DropdownMenuItem<String>>((index) {
                                    return DropdownMenuItem<String>(
                                      value: index["id"].toString(),
                                      child: Text(
                                        index["name"],
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Location",
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            returnData = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MapScreen();
                            }));
                            setState(() {
                              locationController.text = returnData[0];
                            });
                          },
                          child: Text("Select Address",
                              style: GoogleFonts.dmSans(
                                color: const Color(0xff4285F4),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    readOnly: true,
                    cursorColor: Color(0xff4285f5),
                    controller: locationController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      border: InputBorder.none,
                      hintText: "Enter",
                      hintStyle: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black26),
                    ),
                    style: GoogleFonts.dmSans(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "Title",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    cursorColor: Color(0xff4285f5),
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      border: InputBorder.none,
                      hintText: "Enter",
                      hintStyle: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black26),
                    ),
                    style: GoogleFonts.dmSans(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    "Photos & Media",
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "Add at least 2 photos for this category, after upload pictures text box with value 1 - is the title picture. You can change the order of pictures by changing the value of text boxes.",
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      selectImages();
                    },
                    child: (selectedImages.isEmpty)
                        ? Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.black26,
                              size: 40,
                            ))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: selectedImages.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff4285f5), width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      image: FileImage(
                                        selectedImages[index],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              );
                            }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "Each picture must not exceed 500 kb Supported formats are .jpg, .gif and .png \n Minimum Image Dimension : 300 px X 300 Px",
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    "Service Details",
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: filterList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 10),
                          child: Text(
                            filterList[index]["filter_name"],
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.black54, width: 1.5)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                )),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                value: filterValuesMap[
                                    filterList[index]["filter_id"].toString()],
                                isExpanded: true,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: Colors.black54,
                                ),
                                hint: Text(
                                  "Select",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black26,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                elevation: 1,
                                underline:
                                    Container(height: 1, color: Colors.black45),
                                onChanged: (value) {
                                  setState(() {
                                    filterValuesMap[filterList[index]
                                            ["filter_id"]
                                        .toString()] = value!;
                                  });
                                },
                                items: filterList[index]["filter_values"]
                                    .map<DropdownMenuItem<String>>(
                                      (index1) => DropdownMenuItem<String>(
                                        value: index1["id"].toString(),
                                        child: Text(
                                          index1["filter_value"],
                                          style: GoogleFonts.dmSans(
                                            textStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "Price",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    cursorColor: Color(0xff4285f5),
                    controller: priceController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      border: InputBorder.none,
                      hintText: "Enter",
                      hintStyle: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black26),
                    ),
                    style: GoogleFonts.dmSans(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(children: [
                  Checkbox(
                    activeColor: Color(0xff4285f5),
                    value: this.value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Negotiable",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  child: Text(
                    "Description",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    cursorColor: Color(0xff4285f5),
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      border: InputBorder.none,
                      hintText: "Enter",
                      hintStyle: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black26),
                    ),
                    style: GoogleFonts.dmSans(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: GestureDetector(
                    onTap: () {
                      CategoryList.add(Category);
                      if (Category1 != null) {
                        CategoryList.add(Category1);
                      }
                      if (Category2 != null) {
                        CategoryList.add(Category2);
                      }
                      if (Category3 != null) {
                        CategoryList.add(Category3);
                      }
                      if (Category4 != null) {
                        CategoryList.add(Category4);
                      }
                      ADDApi();
                    },
                    child: ButtonWidget(
                      text: "Add",
                      color: Color(0xffbc322d),
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ]),
      ),
    );
  }

  Future<void> CatagoryApi() async {
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/main_category"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          category = data["data"];
          isActive = false;
        });
      }
    }
  }

  Future<void> Catagory1Api(String ID) async {
    setState(() {
      category1.clear();
      Category1 = null;
    });
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
        .get(Uri.parse("https://deadstock.webkype.co/api/sub_category/${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        setState(() {
          category1 = data["data"];
        });
        if (category1.isEmpty) {
          FilterApi(ID);
        }
      }
    }
  }

  Future<void> Catagory2Api(String ID) async {
    setState(() {
      category2.clear();
      Category2 = null;
    });
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
        .get(Uri.parse("https://deadstock.webkype.co/api/sub_category/1${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        setState(() {
          category2 = data["data"];
        });
        if (category2.isEmpty) {
          FilterApi(ID);
        }
      }
    }
  }

  Future<void> Catagory3Api(String ID) async {
    setState(() {
      category3.clear();
      Category3 = null;
    });
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
        .get(Uri.parse("https://deadstock.webkype.co/api/sub_category/1${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        setState(() {
          category3 = data["data"];
        });
        if (category3.isEmpty) {
          FilterApi(ID);
        }
      }
    }
  }

  Future<void> Catagory4Api(String ID) async {
    setState(() {
      category4.clear();
      Category4 = null;
    });
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
        .get(Uri.parse("https://deadstock.webkype.co/api/sub_category/1${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        setState(() {
          category4 = data["data"];
        });
        if (category4.isEmpty) {
          FilterApi(ID);
        }
      }
    }
  }

  Future<void> FilterApi(String ID) async {
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
        .get(Uri.parse("https://deadstock.webkype.co/api/servicefilter/${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        setState(() {
          filterList = data["data"];
        });
      }
    }
  }

  Future<void> CityApi(String ID) async {
    setState(() {
      cityList.clear();
      City = null;
    });
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
        .get(Uri.parse("https://deadstock.webkype.co/api/city_list/${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        setState(() {
          cityList = data["data"];
        });
      }
    }
  }

  Future<void> StateApi() async {
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/state_list"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          stateList = data["data"];
        });
      }
    }
  }

  Future<void> ADDApi() async {
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
    var uri = Uri.parse("https://deadstock.webkype.co/api/addService/${UID}");
    var request = https.MultipartRequest('POST', uri);
    Map<String, String> headers = {"Accept": "application/json"};
    request.headers.addAll(headers);
    for (var i = 0; i < pickedFile.length; i++) {
      final file =
          await https.MultipartFile.fromPath('images[]', pickedFile[i].path);
      request.files.add(file);
    }
    request.fields["title"] = titleController.text;
    request.fields["country"] = Country;
    request.fields["state"] = State;
    request.fields["city"] = City;
    request.fields["location"] = locationController.text;
    request.fields["negotiable"] = value.toString();
    request.fields["description"] = descriptionController.text;
    request.fields["price"] = priceController.text;
    request.fields["video_url"] = "";
    request.fields["category"] = (CategoryList.toList())
        .map((e) => e)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    request.fields["filter"] = (filterValuesMap.values.toList())
        .map((e) => e)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    try {
      final streamedResponse = await request.send();
      final response = await https.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "success") {
          setState(() {
            Category = null;
            Category1 = null;
            Category2 = null;
            Category3 = null;
            Category4 = null;
            Country = null;
            State = null;
            City = null;
            locationController.clear();
            titleController.clear();
            selectedImages.clear();
            priceController.clear();
            filterValuesMap.clear();
            filterList.clear();
            value = false;
            descriptionController.clear();
          });
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Product add successfully.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.6),
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: data["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.6),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        var data = json.decode(response.body);
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: data["message"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.6),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {}
  }
}
