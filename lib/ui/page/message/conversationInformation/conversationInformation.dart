import 'package:flutter/material.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/ui/page/profile/profilePage.dart';
import 'package:Luna/ui/page/profile/widgets/circular_image.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:Luna/state/chats/chatState.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customAppBar.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/url_text/customUrlText.dart';
import 'package:Luna/widgets/newWidget/rippleButton.dart';
import 'package:provider/provider.dart';

class ConversationInformation extends StatelessWidget {
  const ConversationInformation({Key? key}) : super(key: key);

  Widget _header(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: SizedBox(
                height: 80,
                width: 80,
                child: RippleButton(
                  onPressed: () {
                    Navigator.push(
                        context, ProfilePage.getRoute(profileId: user.userId!));
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: CircularImage(path: user.profilePic, height: 80),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UrlText(
                text: user.displayName!,
                style: TextStyles.onPrimaryTitleText.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              user.isVerified!
                  ? customIcon(
                      context,
                      icon: AppIcon.blueTick,
                      isTwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: 18,
                      paddingIcon: 3,
                    )
                  : const SizedBox(width: 0),
            ],
          ),
          customText(
            user.userName,
            style: TextStyles.onPrimarySubTitleText.copyWith(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ChatState>(context).chatUser ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Информация о беседе',
        ),
      ),
      body: ListView(
        children: <Widget>[
          _header(context, user),
          const HeaderWidget('Уведомления'),
          const SettingRowWidget(
            "Заглушить этот чат",
            visibleSwitch: false,
          ),
          Container(
            height: 15,
            color: TwitterColor.mystic,
          ),
          SettingRowWidget(
            "Заблокировать ${user.userName}",
            textColor: TwitterColor.dodgeBlue,
            showDivider: false,
          ),
          SettingRowWidget("Пожаловаться на ${user.userName}",
              textColor: TwitterColor.dodgeBlue, showDivider: false),
          SettingRowWidget("Удалить чат",
              textColor: TwitterColor.ceriseRed, showDivider: false),
        ],
      ),
    );
  }
}
