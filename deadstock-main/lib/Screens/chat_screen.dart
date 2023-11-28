import 'package:deadstock/Screens/agora_chet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as https;

class ChatScreen extends StatefulWidget {
  final String ID;
  const ChatScreen({Key? key, required this.ID}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isActive = false;
  List ChatList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    ChatListApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Responses",
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
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ChatList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AgoraChat(
                                  chatID: ChatList[index]["chat_channel"],
                                receiver_id: ChatList[index]["user_id"],
                                  name: ChatList[index]["name"], ad_id: widget.ID,);
                            }));
                            print(ChatList[index]["chat_channel"]);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              radius: 25,
                              backgroundImage: NetworkImage((ChatList[index]
                                          ["image"] ==
                                      null)
                                  ? "https://cdn.vectorstock.com/i/preview-1x/66/14/default-avatar-photo-placeholder-profile-picture-vector-21806614.jpg"
                                  : "https://deadstock.webkype.co/public/user/${ChatList[index]["image"]}"),
                            ),
                            title: Text(
                              ChatList[index]["name"],
                              style: GoogleFonts.dmSans(
                                color: const Color(0xff000000),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              "How are you.",
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.black54,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
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
              ));
  }

  Future ChatListApi() async {
    var response = await https.get(Uri.parse(
        "https://deadstock.webkype.co/api/show_response/${widget.ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          ChatList = data["data"];
          isActive = false;
        });
      }
    }
  }
}
