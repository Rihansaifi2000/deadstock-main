import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:deadstock/Screens/about_screen.dart';
import 'package:deadstock/Screens/login_register_screen.dart';
import 'package:deadstock/Screens/posted_services_screen.dart';
import 'package:deadstock/Screens/service_queries.dart';
import 'package:deadstock/Screens/services_response_screen.dart';
import 'package:deadstock/Screens/subscription_screen.dart';
import 'package:deadstock/Screens/wish_list_screen.dart';
import 'package:deadstock/Widgets/full_screen_view.dart';
import 'package:deadstock/Widgets/profile_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var Profile = "";
  var FName = "";
  var LName = "";
  var mail = "";
  var phone = "";
  File? imageFile;
  @override
  void initState() {
    super.initState();
    profileApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile",
            style: GoogleFonts.dmSans(
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: Color(0x80bc322d),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey.shade100],
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25))),
                          context: context,
                          builder: (BuildContext bc) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 0.3, sigmaY: 0.3),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return FullScreenImage(
                                                    img: Profile);
                                              }));
                                            },
                                            child: Row(children: [
                                              Image.asset(
                                                "assets/icons/image.png",
                                                width: 25,
                                                color: Colors.black54,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "View Photo",
                                                style: GoogleFonts.dmSans(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ]),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              await _getFromCamera();
                                              if (imageFile != null) {
                                                UpdateApi();
                                              }
                                            },
                                            child: Row(children: [
                                              Image.asset(
                                                "assets/icons/photo-camera-interface-symbol-for-button.png",
                                                width: 25,
                                                color: Colors.black54,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "Take Photo",
                                                style: GoogleFonts.dmSans(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ]),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              await _getFromGallery();
                                              if (imageFile != null) {
                                                UpdateApi();
                                              }
                                            },
                                            child: Row(children: [
                                              Image.asset(
                                                "assets/icons/gallery.png",
                                                width: 25,
                                                color: Colors.black54,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "Select from gallery",
                                                style: GoogleFonts.dmSans(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ]),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ]),
                                  ));
                            });
                          });
                    },
                    child: Stack(clipBehavior: Clip.none, children: [
                      (imageFile == null)
                          ? CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 51,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(Profile),
                                backgroundColor: Colors.grey.shade200,
                                radius: 50,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 50,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 50,
                                backgroundImage: FileImage(
                                  imageFile!,
                                ),
                              ),
                            ),
                      Positioned(
                          bottom: 10,
                          right: -5,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xffbc322d).withOpacity(0.8),
                            child: Image.asset(
                              "assets/icons/photo-camera-interface-symbol-for-button.png",
                              color: Colors.white,
                              width: 16,
                            ),
                          ))
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${FName} ${LName}",
                      style: GoogleFonts.dmSans(
                        color: Color(0xff000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(mail,
                      style: GoogleFonts.dmSans(
                        color: const Color(0xff535353),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
                ]),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AboutMeScreen();
              }));
            },
            child: ContainerWidget(
              image: 'assets/icons/user12.png',
              text: 'About Me',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Wishlist();
              }));
            },
            child: ContainerWidget(
              image: 'assets/icons/heart1.png',
              text: 'Wishlist',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PostedServices();
              }));
            },
            child: ContainerWidget(
              image: 'assets/icons/sharing.png',
              text: 'Posted Services',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const QueriesScreen();
              }));
            },
            child: ContainerWidget(
              image: 'assets/icons/faq.png',
              text: 'Service Queries',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MyServicesResponses();
              }));
            },
            child: ContainerWidget(
              image: 'assets/icons/wall-clock.png',
              text: 'Services Response',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Subscription();
              }));
            },
            child: ContainerWidget(
              image: 'assets/icons/subscription.png',
              text: 'Subscription',
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: Colors.grey.shade100,
            child: Text("Other",
                style: GoogleFonts.dmSans(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {},
            child: ContainerWidget(
              image: 'assets/icons/settings.png',
              text: 'Account Settings',
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: ContainerWidget(
              image: 'assets/icons/info.png',
              text: 'About Us',
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: ContainerWidget(
              image: 'assets/icons/information.png',
              text: 'FAQ',
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: ContainerWidget(
              image: 'assets/icons/privacy-policy.png',
              text: 'Privacy & Policy',
            ),
          ),
          GestureDetector(
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => LoginRegisterScreen()),
                  (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Card(
                color: Colors.white,
                elevation: 0,
                child: Row(children: [
                  Image.asset(
                    'assets/icons/logout.png',
                    width: 23,
                    color: const Color(0xffEF574B),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Log out",
                    style: GoogleFonts.dmSans(
                      color: const Color(0xffEF574B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ]),
      ),
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File? img = File(pickedFile.path);
      setState(() {
        imageFile = img;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File? img = File(pickedFile.path);
      setState(() {
        imageFile = img;
      });
    }
  }

  Future profileApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/user_profile/${UID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          Profile =
              "https://deadstock.webkype.co/public/user/${data["profile"]["image"]}";
          FName = data["profile"]["firstName"] ?? "";
          LName = data["profile"]["lastName"] ?? "";
          mail = data["profile"]["email"] ?? "";
          phone = data["profile"]["phone"] ?? "";
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
    if (imageFile != null) {
      request.files
          .add(await https.MultipartFile.fromPath('image', imageFile!.path));
    }
    request.fields["firstname"] = FName;
    request.fields["lastName"] = LName;
    request.fields["email"] = mail;
    request.fields["phone"] = phone;
    try {
      final streamedResponse = await request.send();
      final response = await https.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "success") {
          Navigator.of(context).pop();
        }
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {}
  }
}
