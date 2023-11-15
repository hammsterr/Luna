import 'package:flutter/material.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/page/settings/widgets/settingsAppbar.dart';
import 'package:Luna/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class DirectMessagesPage extends StatelessWidget {
  const DirectMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Личные сообщения',
        subtitle: user.userName,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const <Widget>[
          HeaderWidget(
            'Личные сообщения',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Сохранять запросы переписок",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            vPadding: 20,
            subtitle:
                'You will be able to receive Direct Message requests from anyone on Luna, even if you don\'t follow them.',
          ),
          SettingRowWidget(
            "Показывать индикацию о прочтении",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            subtitle:
                'When someone sends you a message, people in the conversation will know you\'ve seen it. If you turn off this setting, you won\'t be able to see read receipt from others.',
          ),
        ],
      ),
    );
  }
}
