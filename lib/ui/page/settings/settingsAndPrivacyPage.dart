import 'package:flutter/material.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customAppBar.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

import 'widgets/settingsRowWidget.dart';

class SettingsAndPrivacyPage extends StatelessWidget {
  const SettingsAndPrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Настройки и приватность',
        ),
      ),
      body: ListView(
        children: <Widget>[
          HeaderWidget(user.userName),
          const SettingRowWidget(
            "Аккаунт",
            navigateTo: 'AccountSettingsPage',
          ),
          const Divider(height: 0),
          const SettingRowWidget("Приватность и безопасность",
              navigateTo: 'PrivacyAndSaftyPage'),
          const SettingRowWidget("Уведомления",
              navigateTo: 'NotificationPage'),
          const SettingRowWidget("Content prefrences",
              navigateTo: 'ContentPrefrencePage'),
          const HeaderWidget(
            'General',
            secondHeader: true,
          ),
          const SettingRowWidget("Display and Sound",
              navigateTo: 'DisplayAndSoundPage'),
          const SettingRowWidget("Data usage", navigateTo: 'DataUsagePage'),
          const SettingRowWidget("Accessibility",
              navigateTo: 'AccessibilityPage'),
          const SettingRowWidget("Proxy", navigateTo: "ProxyPage"),
          const SettingRowWidget(
            "Проверить обновления",
            navigateTo: "SplashPage"),
          const SettingRowWidget(
            "О Луне",
            navigateTo: "AboutPage",
          ),
          const SettingRowWidget(
            null,
            showDivider: false,
            vPadding: 10,
            subtitle:
                'Это настройки Луны. \nМногие функции находятся в разработке. \nСледите за обновлениями в проекте на гитхабе',
          )
        ],
      ),
    );
  }
}
