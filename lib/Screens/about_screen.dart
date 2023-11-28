import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as https;
import 'package:deadstock/Widgets/about_me_textfield_widget.dart';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final TextEditingController FnameController = TextEditingController();
  final TextEditingController LnameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController LocationController = TextEditingController();
  final TextEditingController CnameController = TextEditingController();
  final TextEditingController CMailController = TextEditingController();
  final TextEditingController CPhoneController = TextEditingController();
  final TextEditingController CAddressController = TextEditingController();
  final TextEditingController CWebsiteController = TextEditingController();
  var CompanyCategory;
  List Companycategory = [];
  bool isActive = false;
  @override
  void initState() {
    super.initState();
    CatagoryApi();
    setState(() {
      isActive = true;
    });
    profileApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0x80bc322d),
        leadingWidth: 35,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
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
        title: Text(
          "About Me",
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text("Personal Details",
                      style: GoogleFonts.dmSans(
                        color: Color(0xff000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                AboutMeTextFieldWidget(
                  controller: FnameController,
                  inputType: TextInputType.text,
                  image: 'assets/icons/user12.png',
                  hintText: 'First Name',
                  inputAction: TextInputAction.next,
                  maxline: 1,
                ),
                AboutMeTextFieldWidget(
                  controller: LnameController,
                  inputType: TextInputType.text,
                  image: 'assets/icons/user12.png',
                  hintText: 'Last Name',
                  inputAction: TextInputAction.next,
                  maxline: 1,
                ),
                AboutMeTextFieldWidget(
                  controller: EmailController,
                  inputType: TextInputType.emailAddress,
                  image: 'assets/icons/email1.png',
                  hintText: 'Email Address',
                  inputAction: TextInputAction.next,
                  maxline: 1,
                ),
                AboutMeTextFieldWidget(
                  controller: PhoneController,
                  inputType: TextInputType.phone,
                  image: 'assets/icons/telephone.png',
                  hintText: 'Phone Number',
                  inputAction: TextInputAction.next,
                  maxline: 1,
                ),
                AboutMeTextFieldWidget(
                  controller: LocationController,
                  inputType: TextInputType.streetAddress,
                  image: 'assets/icons/location.png',
                  hintText: 'Address',
                  inputAction: TextInputAction.next,
                  maxline: 1,
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                //   child: Text("Cooperate Information",
                //       style: GoogleFonts.dmSans(
                //         color: Color(0xff000000),
                //         fontSize: 18,
                //         fontWeight: FontWeight.w600,
                //       )),
                // ),
                // Container(
                //   margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                //   alignment: Alignment.center,
                //   width: MediaQuery.of(context).size.width,
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   color: Colors.white,
                //   child: Row(
                //     children: [
                //       Image.asset(
                //         "assets/icons/category.png",
                //         width: 23,
                //         color: Colors.black54,
                //       ),
                //       SizedBox(
                //         width: 20,
                //       ),
                //       Expanded(
                //         child: InputDecorator(
                //           decoration: const InputDecoration(
                //               border: InputBorder.none,
                //               contentPadding: EdgeInsets.symmetric(
                //                 horizontal: 10,
                //               )),
                //           child: DropdownButtonHideUnderline(
                //             child: DropdownButton<String>(
                //               style: GoogleFonts.dmSans(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w500,
                //                 color: Colors.black54,
                //               ),
                //               dropdownColor: Colors.white,
                //               borderRadius: BorderRadius.circular(10),
                //               value: CompanyCategory,
                //               isExpanded: true,
                //               icon: Icon(
                //                 Icons.keyboard_arrow_down,
                //                 size: 30,
                //                 color: Colors.black54,
                //               ),
                //               hint: Text(
                //                 "Company Category",
                //                 style: GoogleFonts.dmSans(
                //                   color: Colors.black26,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //               ),
                //               elevation: 1,
                //               underline:
                //                   Container(height: 1, color: Colors.black45),
                //               onChanged: (String? newValue) {
                //                 setState(() {
                //                   CompanyCategory = newValue!;
                //                 });
                //               },
                //               items:
                //                   Companycategory.map<DropdownMenuItem<String>>(
                //                       (index) {
                //                 return DropdownMenuItem<String>(
                //                   value: index["id"].toString(),
                //                   child: Text(
                //                     index["category_name"],
                //                     style: GoogleFonts.dmSans(
                //                       textStyle: TextStyle(
                //                         color: Colors.black54,
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.w500,
                //                       ),
                //                     ),
                //                   ),
                //                 );
                //               }).toList(),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // AboutMeTextFieldWidget(
                //   controller: CnameController,
                //   inputType: TextInputType.text,
                //   image: 'assets/icons/user12.png',
                //   hintText: 'Company Name',
                //   inputAction: TextInputAction.next,
                //   maxline: 1,
                // ),
                // AboutMeTextFieldWidget(
                //   controller: CMailController,
                //   inputType: TextInputType.emailAddress,
                //   image: 'assets/icons/email1.png',
                //   hintText: 'Company Email Address',
                //   inputAction: TextInputAction.next,
                //   maxline: 1,
                // ),
                // AboutMeTextFieldWidget(
                //   controller: CPhoneController,
                //   inputType: TextInputType.phone,
                //   image: 'assets/icons/telephone.png',
                //   hintText: 'Company Phone Number',
                //   inputAction: TextInputAction.next,
                //   maxline: 1,
                // ),
                // AboutMeTextFieldWidget(
                //   controller: CAddressController,
                //   inputType: TextInputType.text,
                //   image: 'assets/icons/location.png',
                //   hintText: 'Company Address',
                //   inputAction: TextInputAction.next,
                //   maxline: 1,
                // ),
                // AboutMeTextFieldWidget(
                //   controller: CWebsiteController,
                //   inputType: TextInputType.url,
                //   image: 'assets/icons/web-programming.png',
                //   hintText: 'Company Website',
                //   inputAction: TextInputAction.next,
                //   maxline: 1,
                // ),
                GestureDetector(
                  onTap: () {
                    UpdateApi();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 20),
                    child: ButtonWidget(
                      text: "Update",
                      color: Color(0xffbc322d),
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                )
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
          Companycategory = data["data"];
        });
      }
    }
  }

  Future<void> profileApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/user_profile/${UID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          FnameController.text = data["profile"]["firstName"];
          LnameController.text = data["profile"]["lastName"];
          EmailController.text = data["profile"]["email"];
          PhoneController.text = data["profile"]["phone"];
          LocationController.text = data["profile"]["location"] ?? "";
          CnameController.text = data["profile"]["companyName"] ?? "";
          CMailController.text = data["profile"]["companyEmail"] ?? "";
          CPhoneController.text = data["profile"]["companyPhone"] ?? "";
          CAddressController.text = data["profile"]["companyAddress"] ?? "";
          CompanyCategory = data["profile"]["company_category"].toString();
          CWebsiteController.text = data["profile"]["companyWebsite"] ?? "";
          isActive = false;
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var uri =
        Uri.parse("https://deadstock.webkype.co/api/profile_update/${UID}");
    var request = https.MultipartRequest('POST', uri);
    Map<String, String> headers = {"Accept": "application/json"};
    request.headers.addAll(headers);
    request.fields["firstname"] = FnameController.text;
    request.fields["lastName"] = LnameController.text;
    request.fields["email"] = EmailController.text;
    request.fields["phone"] = PhoneController.text;
    request.fields["location"] = LocationController.text;
    // request.fields["company_category"] = CompanyCategory;
    // request.fields["companyName"] = CnameController.text;
    // request.fields["companyEmail"] = CMailController.text;
    // request.fields["companyPhone"] = CPhoneController.text;
    // request.fields["companyAddress"] = CAddressController.text;
    // request.fields["companyWebsite"] = CWebsiteController.text;
    try {
      final streamedResponse = await request.send();
      final response = await https.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "success") {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
        }
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {}
  }

  dialogBox(String msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: AlertDialog(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text('Error', style: GoogleFonts.outfit()),
              content: Text(msg, style: GoogleFonts.outfit()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK', style: GoogleFonts.outfit()),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
