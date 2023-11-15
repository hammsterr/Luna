import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/model/chatModel.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/state/chats/chatState.dart';
import 'package:Luna/ui/page/profile/widgets/circular_image.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/url_text/customUrlText.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../model/link_media_info.dart';
import '../../../widgets/url_text/custom_link_media_info.dart';

import 'package:dartz/dartz.dart' as dartz;

class ChatScreenPage extends StatefulWidget {
  const ChatScreenPage({
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final messageController = TextEditingController();
  String? senderId;
  late String userImage;
  late ChatState state;
  late ScrollController _controller;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  File? imageFile;

  Future getImage() async {

    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null){
        imageFile = File(xFile.path);
      }

    });

  }

  Future uploadImage() async {

    String fileName = Uuid().v1();

    var ref = FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!);

    String imageUrl = await uploadTask.ref.getDownloadURL();

    cprint(imageUrl);

  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }



  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _controller = ScrollController();
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.setIsChatScreenOpen = true;
    senderId = state.userId;
    chatState.databaseInit(chatState.chatUser!.userId!, state.userId);
    chatState.getChatDetailAsync();
    super.initState();
  }

  Widget _chatScreenBody() {
    final state = Provider.of<ChatState>(context);
    if (state.messageList == null || state.messageList!.isEmpty) {
      return const Center(
        child: Text(
          'Нет сообщений',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemCount: state.messageList!.length,
      itemBuilder: (context, index) => chatMessage(state.messageList![index]),
    );
  }

  Widget chatMessage(ChatMessage message) {
    if (senderId == null) {
      return Container();
    }
    if (message.senderId == senderId) {
      return _message(message, true);
    } else {
      return _message(message, false);
    }
  }




  CustomLinkMediaInfo linkMediaInfo = CustomLinkMediaInfo();

  Widget _message(ChatMessage chat, bool myMessage) {
    return Column(
      crossAxisAlignment: myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            myMessage
                ? const SizedBox()
                : CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: customAdvanceNetworkImage(userImage),
            ),
            Expanded(
              child: Container(
                alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (context.width / 4),
                  top: 20,
                  left: myMessage ? (context.width / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage ? TwitterColor.dodgeBlue : TwitterColor.mystic,
                      ),
                      child: FutureBuilder(
                        future: linkMediaInfo.fetchLinkMediaInfo(chat.message!),
                        builder: (context, AsyncSnapshot<dartz.Either<String, LinkMediaInfo>> snapshot) {
                          if (snapshot.hasData) {

                            String? getUrl() {
                              if (chat.message == null) {
                                return null;
                              }
                              RegExp reg = RegExp(
                                  r"(https?|http)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
                              Iterable<Match> _matches = reg.allMatches(chat.message!);
                              if (_matches.isNotEmpty) {
                                return _matches.first.group(0);
                              }
                              return null;
                            }

                            var response = snapshot.data;
                            return response!.fold(
                                  (l) => UrlText(
                                text: chat.message!.removeSpaces,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: myMessage ? TwitterColor.white : Colors.black,
                                ),
                                urlStyle: TextStyle(
                                  fontSize: 16,
                                  color: myMessage ? TwitterColor.white : TwitterColor.dodgeBlue,
                                  decoration: TextDecoration.underline,

                                ),

                              ),

                                  (model) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (model.thumbnailUrl != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                      child: Container(
                                        height: 140,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(model.thumbnailUrl!),
                                            fit: BoxFit.cover,


                                          ),

                                        ),

                                      ),
                                    ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: model.thumbnailUrl != null
                                          ? Theme.of(context).colorScheme.onPrimary
                                          : const Color(0xFFF0F1F2),
                                    ),
                                    padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8, top: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (model.title != null)
                                          Text(
                                            model.title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.titleStyle.copyWith(fontSize: 14),
                                          ),
                                        if (model.providerUrl != null)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  Uri.tryParse(model.providerUrl!)!.authority,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyles.subtitleStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ).ripple(
                                          () {
                                            String url = getUrl() ?? '';
                                        Utility.launchURL(url!);
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Text(
            Utility.getChatTime(chat.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }





  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomRight:
      myMessage ? const Radius.circular(0) : const Radius.circular(20),
      bottomLeft:
      myMessage ? const Radius.circular(20) : const Radius.circular(0),
    );
  }

  Widget _bottomEntryField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Divider(
            thickness: 0,
            height: 1,
          ),
          TextField(
            onSubmitted: (val) async {
              submitMessage();
            },
            controller: messageController,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
/*              prefixIcon: IconButton(
                onPressed: () => getImage(), icon: Icon(AppIcon.image),
              ),*/


              alignLabelWithHint: true,
              hintText: 'Введите сообщение...',
              suffixIcon: IconButton(
                  icon: const Icon(Icons.send), onPressed: submitMessage),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    state.setIsChatScreenOpen = false;
    state.onChatScreenClosed();
    return true;
  }

  void submitMessage() {
    var authState = Provider.of<AuthState>(context, listen: false);
    ChatMessage message;
    message = ChatMessage(
        message: messageController.text.removeSpaces,
        createdAt: DateTime.now().toUtc().toString(),
        senderId: authState.userModel!.userId!,
        receiverId: state.chatUser!.userId!,
        seen: false,
        timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        senderName: authState.user!.displayName!);
    if (messageController.text.removeSpaces.isEmpty) {
      return;
    }
    state.onMessageSubmitted(
      message, /*myUser: myUser, secondUser: secondUser*/
    );
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      messageController.clear();
    });
    try {
      if (state.messageList != null &&
          state.messageList!.length > 1 &&
          _controller.offset > 0) {
        _controller.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    } catch (e) {
      print("[Error] $e");
    }
  }
  Widget build(BuildContext context) {
    state = Provider.of<ChatState>(context, listen: false);
    userImage = state.chatUser!.profilePic!;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UrlText(
                text: state.chatUser!.displayName!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(state.chatUser!.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>?;
                    String status = data?['status'] ?? 'Когда-то...✨';
                    return Text(
                      status,
                      style: const TextStyle(
                        color: AppColor.darkGrey,
                        fontSize: 15,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.blue),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info, color: AppColor.primary),
              onPressed: () {
                Navigator.pushNamed(context, '/ConversationInformation');
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: _chatScreenBody(),
                ),
              ),
              _bottomEntryField()
            ],
          ),
        ),
      ),
    );
  }
}