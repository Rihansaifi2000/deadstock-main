import 'dart:convert';
import 'dart:io';
import 'package:deadstock/Screens/map_screen.dart';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


class EditService extends StatefulWidget {
  final String ID;
  const EditService({super.key, required this.ID});

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool value = false;
  Map<String, String> filterValuesMap = {};
  List returnData = [];
  List<dynamic> filterList = [];
  var State;
  List stateList = [];
  var City;
  List cityList = [];
  List<File> selectedImages = [];
  List<XFile> pickedFile = [];
  List Photos = [];
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
    StateApi();
    setState(() {
      isActive = true;
    });
    GetApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xcd000000),
            ),
          ),
        ),
        title: Text(
          "Edit Service",
          style: GoogleFonts.dmSans(
            fontSize: 20,
            color: Colors.black,
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
          child: const CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ),
        )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            color: Colors.grey.shade100,
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
              "State",
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
                  icon: const Icon(
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
                      CityApi(State);
                    });
                  },
                  items: stateList.map<DropdownMenuItem<String>>((index) {
                    return DropdownMenuItem<String>(
                      value: index["id"].toString(),
                      child: Text(
                        index["name"],
                        style: GoogleFonts.dmSans(
                          textStyle: const TextStyle(
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      icon: const Icon(
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
                              textStyle: const TextStyle(
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
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: TextField(
              cursorColor: const Color(0xffbc322d),
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
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade100,
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
              child: (Photos.isNotEmpty)
                  ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Photos.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
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
                            color: const Color(0xffbc322d), width: 1),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://deadstock.webkype.co/public/ad/${Photos[index]["image"]}"),
                            fit: BoxFit.cover),
                      ),
                    );
                  })
                  : (selectedImages.isEmpty)
                  ? Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black54, width: 1.5),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(10)),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black26,
                    size: 40,
                  ))
                  : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedImages.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
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
                            color: const Color(0xffbc322d),
                            width: 1),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
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
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade100,
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Service Details",
              style: GoogleFonts.dmSans(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // ListView.builder(
          //   itemCount: filterList.length,
          //   physics: const NeverScrollableScrollPhysics(),
          //   shrinkWrap: true,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(
          //               top: 20, left: 10, right: 10, bottom: 10),
          //           child: Text(
          //             filterList[index]["filter_name"],
          //             style: GoogleFonts.dmSans(
          //               fontSize: 16,
          //               color: Colors.black,
          //               fontWeight: FontWeight.w400,
          //             ),
          //           ),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.symmetric(horizontal: 10),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               border: Border.all(
          //                   color: Colors.black54, width: 1.5)),
          //           child: InputDecorator(
          //             decoration: const InputDecoration(
          //                 border: InputBorder.none,
          //                 contentPadding: EdgeInsets.symmetric(
          //                   horizontal: 10,
          //                 )),
          //             child: DropdownButtonHideUnderline(
          //               child: DropdownButton<String>(
          //                 style: GoogleFonts.dmSans(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w500,
          //                   color: Colors.black54,
          //                 ),
          //                 dropdownColor: Colors.white,
          //                 borderRadius: BorderRadius.circular(10),
          //                 value: filterValuesMap[
          //                     filterList[index]["filter_id"].toString()],
          //                 isExpanded: true,
          //                 icon: const Icon(
          //                   Icons.keyboard_arrow_down,
          //                   size: 30,
          //                   color: Colors.black54,
          //                 ),
          //                 hint: Text(
          //                   "Select",
          //                   style: GoogleFonts.dmSans(
          //                     color: Colors.black26,
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //                 elevation: 1,
          //                 underline:
          //                     Container(height: 1, color: Colors.black45),
          //                 onChanged: (value) {
          //                   setState(() {
          //                     filterValuesMap[filterList[index]
          //                             ["filter_id"]
          //                         .toString()] = value!;
          //                   });
          //                 },
          //                 items: filterList[index]["filter_values"]
          //                     .map<DropdownMenuItem<String>>(
          //                       (index1) => DropdownMenuItem<String>(
          //                         value: index1["id"].toString(),
          //                         child: Text(
          //                           index1["filter_value"],
          //                           style: GoogleFonts.dmSans(
          //                             textStyle: const TextStyle(
          //                               color: Colors.black54,
          //                               fontSize: 16,
          //                               fontWeight: FontWeight.w500,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     )
          //                     .toList(),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          // ),
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
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: TextField(
              cursorColor: const Color(0xffbc322d),
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
              activeColor: const Color(0xffbc322d),
              value: this.value,
              onChanged: (value) {
                setState(() {
                  this.value = value!;
                });
              },
            ),
            const SizedBox(
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
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: TextField(
              cursorColor: const Color(0xffbc322d),
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
                UpdateApi();
              },
              child: ButtonWidget(
                text: "Update",
                color: const Color(0xffbc322d),
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> GetApi() async {
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/editService/${widget.ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        await CityApi(data["data"]["state"].toString());
        setState(() {
          filterList = data["filters"];
          State = data["data"]["state"].toString();
          City = data["data"]["city"].toString();
          locationController.text = data["data"]["location"];
          titleController.text = data["data"]["title"];
          priceController.text = data["data"]["price"].toString();
          value = (data["data"]["negotiable"] == "true") ? true : false;
          descriptionController.text = data["data"]["description"];
          Photos = data["photo"];
          // for (var i = 0; i < data["filtervalues"].length; i++) {
          //   filterValuesMap[filterList[i]["filter_id"].toString()] =
          //       data["filtervalues"][i]["filter_value_id"].toString();
          // }
          isActive = false;
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
    var response =
    await https.get(Uri.parse("https://deadstock.webkype.co/api/city_list/${ID}"));
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
    var response =
    await https.get(Uri.parse("https://deadstock.webkype.co/api/state_list"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          stateList = data["data"];
        });
      }
    }
  }

  Future<void> UpdateApi() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
                color: Color(0xffbc322d),
                strokeWidth: 1.5,
              ));
        });
    var uri = Uri.parse("https://deadstock.webkype.co/api/updateService/${widget.ID}");
    var request = https.MultipartRequest('POST', uri);
    Map<String, String> headers = {"Accept": "application/json"};
    request.headers.addAll(headers);
    for (var i = 0; i < pickedFile.length; i++) {
      final file =
      await https.MultipartFile.fromPath('images[]', pickedFile[i].path);
      request.files.add(file);
    }
    request.fields["title"] = titleController.text;
    request.fields["country"] = "India";
    request.fields["state"] = State;
    request.fields["city"] = City;
    request.fields["location"] = locationController.text;
    request.fields["negotiable"] = value.toString();
    request.fields["description"] = descriptionController.text;
    request.fields["price"] = priceController.text;
    request.fields["plan"] = "";
    request.fields["video_url"] = "";
    // request.fields["filter"] = (filterValuesMap.values.toList())
    //     .map((e) => e)
    //     .toString()
    //     .replaceAll('(', '')
    //     .replaceAll(')', '');
    try {
      final streamedResponse = await request.send();
      final response = await https.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "success") {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
        }
      } else {
        var data = json.decode(response.body);
        Navigator.of(context).pop();
        dialogBox(data["status"], data["message"]);
      }
    } catch (e) {}
  }

  dialogBox(String title, msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          var ImageFilter;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: AlertDialog(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(title, style: GoogleFonts.outfit()),
              content: Text(msg, style: GoogleFonts.outfit()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK', style: GoogleFonts.outfit()),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          );
        });
  }
}