import 'package:flutter/material.dart';
import 'package:Luna/helper/constant.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/model/chatModel.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/state/chats/chatState.dart';
import 'package:Luna/state/searchState.dart';
import 'package:Luna/ui/page/profile/profilePage.dart';
import 'package:Luna/ui/page/profile/widgets/circular_image.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customAppBar.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/newWidget/emptyList.dart';
import 'package:Luna/widgets/newWidget/rippleButton.dart';
import 'package:Luna/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ChatListPage({Key? key, required this.scaffoldKey}) : super(key: key);
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.setIsChatScreenOpen = true;

    // chatState.databaseInit(state.profileUserModel.userId,state.userId);
    chatState.getUserChatList(state.user!.uid);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) context.read<SearchState>().resetFilterList();
  }

  Widget _body() {
    final state = Provider.of<ChatState>(context);
    final searchState = Provider.of<SearchState>(context, listen: false);
    if (state.chatUserList == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyList(
          'Нет переписок ',
          subTitle:
              'Когда кто-нибудь напишет вам, чат появится здесь.',
        ),
      );
    } else {
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: state.chatUserList!.length,
        itemBuilder: (context, index) => _userCard(
          searchState.userlist!.firstWhere(
            (x) => x.userId == state.chatUserList![index].key,
            orElse: () => UserModel(userName: "Unknown"),
          ),
          state.chatUserList![index],
        ),
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
          );
        },
      );
    }
  }

  Widget _userCard(UserModel model, ChatMessage? lastMessage) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          final chatState = Provider.of<ChatState>(context, listen: false);
          final searchState = Provider.of<SearchState>(context, listen: false);
          chatState.setChatUser = model;
          if (searchState.userlist!.any((x) => x.userId == model.userId)) {
            chatState.setChatUser = searchState.userlist!
                .where((x) => x.userId == model.userId)
                .first;
          }
          Navigator.pushNamed(context, '/ChatScreenPage');
        },
        leading: RippleButton(
          onPressed: () {
            Navigator.push(
                context, ProfilePage.getRoute(profileId: model.userId!));
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    model.profilePic ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        title: TitleText(
          model.displayName ?? "NA",
          fontSize: 16,
          fontWeight: FontWeight.w800,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: customText(
          getLastMessage(lastMessage?.message) ?? '@${model.displayName}',
          style:
              TextStyles.onPrimarySubTitleText.copyWith(color: Colors.black54),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: lastMessage == null
            ? const SizedBox.shrink()
            : Text(
                Utility.getChatTime(lastMessage.createdAt).toString(),
                style: TextStyles.onPrimarySubTitleText.copyWith(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }

  FloatingActionButton _newMessageButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/NewMessagePage');
      },
      child: customIcon(
        context,
        icon: AppIcon.newMessage,
        isTwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/DirectMessagesPage');
  }

  String? getLastMessage(String? message) {
    if (message != null && message.isNotEmpty) {
      if (message.length > 100) {
        message = message.substring(0, 80) + '...';
        return message;
      } else {
        return message;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey: widget.scaffoldKey,
        title: customTitleText(
          'Сообщения',
        ),
        icon: AppIcon.settings,
        onActionPressed: onSettingIconPressed,
      ),
      floatingActionButton: _newMessageButton(),
      backgroundColor: TwitterColor.mystic,
      body: _body(),
    );
  }
}
