import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class AgoraChat extends StatefulWidget {
  final String receiver_id;
  final String ad_id;
  final String chatID;
  final String name;
  const AgoraChat(
      {super.key,
      required this.chatID,
      required this.name,
      required this.ad_id,
      required this.receiver_id});

  @override
  State<AgoraChat> createState() => _AgoraChatState();
}

class _AgoraChatState extends State<AgoraChat> {
  final TextEditingController msgController = TextEditingController();
  bool _isLogin = false;
  bool _isInChannel = false;
  bool isActive = false;
  List MSGList = [];
  var userID;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  @override
  void initState() {
    super.initState();
    _createClient();
    setState(() {
      isActive = true;
    });
    GetMsgApi();
  }

  @override
  void dispose() {
    _client?.release();
    super.dispose();
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
            widget.name,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w500,
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
            : Stack(
                children: <Widget>[
                  (MSGList.isNotEmpty)
                      ? SingleChildScrollView(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: MSGList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      (MSGList[index]["message"] != null)
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Align(
                                                alignment: (MSGList[index]
                                                            ["sender_id"] ==
                                                        userID
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: MSGList[index][
                                                                  "sender_id"] ==
                                                              userID
                                                          ? 100
                                                          : 0,
                                                      right: MSGList[index][
                                                                  "sender_id"] !=
                                                              userID
                                                          ? 100
                                                          : 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: (MSGList[index]
                                                                ["sender_id"] ==
                                                            userID
                                                        ? Colors.grey.shade200
                                                        : Color(0xffbc322d)
                                                            .withOpacity(0.1)),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                                  child: Text(
                                                    MSGList[index]["message"],
                                                    style: GoogleFonts.dmSans(
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ))
                                          : Container(),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height: 60,
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: Text("No Messages",
                              style: GoogleFonts.dmSans(
                                color: const Color(0xff535353),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ))),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Stack(clipBehavior: Clip.none, children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(left: 10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                  controller: msgController,
                                  textInputAction: TextInputAction.send,
                                  decoration: InputDecoration(
                                      hintText: "Write message...",
                                      hintStyle: GoogleFonts.dmSans(
                                          color: Colors.black54),
                                      border: InputBorder.none),
                                  onSubmitted: (_) {
                                    _sendChannelMessage();
                                  }),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                _sendChannelMessage();
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xffbc322d),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ));
  }

  Future<void> _createClient() async {
    _client =
        await AgoraRtmClient.createInstance('bb59bcb117324c818f06a3a2f7da5cb7');
    _toggleLogin();
    print(await AgoraRtmClient.getSdkVersion());
    await _client?.setParameters('{"rtm.log_filter": 15}');
    await _client?.setLogFile('');
    await _client?.setLogFilter(RtmLogFilter.info);
    await _client?.setLogFileSize(10240);
    _client?.onError = (error) {
      print("Client error: $error");
    };
    _client?.onConnectionStateChanged2 =
        (RtmConnectionState state, RtmConnectionChangeReason reason) {
      print('Connection state changed: $state, reason: $reason');
      if (state == RtmConnectionState.aborted) {
        _client?.logout();
        print('Logout');
        setState(() {
          _isLogin = false;
        });
      }
    };
    _client?.onMessageReceived = (RtmMessage message, String peerId) {
      print("Peer msg: $peerId, msg: ${message.messageType} ${message.text}");
    };
    _client?.onTokenExpired = () {
      print("Token expired");
    };
    _client?.onTokenPrivilegeWillExpire = () {
      print("Token privilege will expire");
    };
    _client?.onPeersOnlineStatusChanged =
        (Map<String, RtmPeerOnlineState> peersStatus) {
      print("Peers online status changed ${peersStatus.toString()}");
    };

    var callManager = _client?.getRtmCallManager();
    callManager?.onError = (error) {
      print('Call manager error: $error');
    };
    callManager?.onLocalInvitationReceivedByPeer =
        (LocalInvitation localInvitation) {
      print(
          'Local invitation received by peer: ${localInvitation.calleeId}, content: ${localInvitation.content}');
    };
    callManager?.onRemoteInvitationReceived =
        (RemoteInvitation remoteInvitation) {
      print(
          'Remote invitation received by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {});
    };
    callManager?.onRemoteInvitationAccepted =
        (RemoteInvitation remoteInvitation) {
      print(
          'Remote invitation accepted by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {});
    };
    callManager?.onRemoteInvitationRefused =
        (RemoteInvitation remoteInvitation) {
      print(
          'Remote invitation refused by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {});
    };
    callManager?.onRemoteInvitationCanceled =
        (RemoteInvitation remoteInvitation) {
      print(
          'Remote invitation canceled: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {});
    };
    callManager?.onRemoteInvitationFailure =
        (RemoteInvitation remoteInvitation, int errorCode) {
      print(
          'Remote invitation failure: ${remoteInvitation.callerId}, errorCode: $errorCode');
      setState(() {});
    };
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onError = (error) {
        print("Channel error: $error");
      };
      channel.onMemberCountUpdated = (int memberCount) {
        print("Member count updated: $memberCount");
      };
      channel.onAttributesUpdated = (List<RtmChannelAttribute> attributes) {
        print("Channel attributes updated: ${attributes.toString()}");
      };
      channel.onMessageReceived =
          (RtmMessage message, RtmChannelMember member) {
        setState(() {
          GetMsgApi();
        });
        print("${member.userId}, msg: ${message.text}");
      };
      channel.onMemberJoined = (RtmChannelMember member) {
        print('Member joined: ${member.userId}, channel: ${member.channelId}');
      };
      channel.onMemberLeft = (RtmChannelMember member) {
        print('Member left: ${member.userId}, channel: ${member.channelId}');
      };
    }
    return channel;
  }

  Future<void> _toggleLogin() async {
    if (_isLogin) {
      try {
        await _client?.logout();
        print('Logout success');
        setState(() {
          _isLogin = false;
          _isInChannel = false;
        });
      } catch (errorCode) {
        print('Logout error: $errorCode');
      }
    } else {
      String userId = widget.name;
      if (userId.isEmpty) {
        print('Please input your user id to login');
        return;
      }

      try {
        await _client?.login(null, userId);
        print('Login success: $userId');
        _toggleJoinChannel();
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        print('Login error: $errorCode');
      }
    }
  }

  Future<void> _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _channel?.leave();
        print('Leave channel success');
        await _channel?.release();
        setState(() {
          _isInChannel = false;
        });
      } catch (errorCode) {
        print('Leave channel error: $errorCode');
      }
    } else {
      String channelId = widget.chatID;
      if (channelId.isEmpty) {
        print('Please input channel id to join');
        return;
      }

      try {
        _channel = await _createChannel(channelId);
        await _channel?.join();
        print('Join channel success');

        setState(() {
          _isInChannel = true;
        });
      } catch (errorCode) {
        print('Join channel error: $errorCode');
      }
    }
  }

  Future<void> _sendChannelMessage() async {
    String text = msgController.text;
    if (text.isEmpty) {
      print('Please input text to send');
      return;
    }

    try {
      RtmMessage? message =
          _client?.createRawMessage(Uint8List.fromList([]), text);
      if (message != null) {
        print(message.text);
        await magApi();
        await _channel?.sendMessage2(message);
        print('Send channel message success');
      }
    } catch (errorCode) {
      print('Send channel message error: $errorCode');
    }
  }

  Future<void> GetMsgApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userID = preferences.getString("UserID");
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/chat_list/${userID}"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "ad_id": widget.ad_id,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          MSGList = data["chats"];
          isActive = false;
        });
      }
    }
  }

  Future<void> magApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var uri = Uri.parse("https://deadstock.webkype.co/api/save_chat");
    var request = https.MultipartRequest('POST', uri);
    Map<String, String> headers = {"Accept": "application/json"};
    request.headers.addAll(headers);
    request.fields['sender_id'] = UID!;
    request.fields['receiver_id'] = widget.receiver_id;
    request.fields["ad_id"] = widget.ad_id;
    request.fields["message"] = msgController.text;
    try {
      final streamedResponse = await request.send();
      final response = await https.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "success") {
          msgController.clear();
          await GetMsgApi();
        }
      }
    } catch (e) {}
  }
}
