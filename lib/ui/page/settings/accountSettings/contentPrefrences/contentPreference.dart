import 'package:flutter/material.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/page/settings/widgets/settingsAppbar.dart';
import 'package:Luna/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class ContentPrefrencePage extends StatelessWidget {
  const ContentPrefrencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Настройки контента',
        subtitle: user.userName,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const <Widget>[
          HeaderWidget('Поиск'),
          SettingRowWidget(
            "Тренды",
            navigateTo: 'TrendsPage',
          ),
          Divider(height: 0),
          SettingRowWidget(
            "Поиск настроек",
            navigateTo: null,
          ),
          HeaderWidget(
            'Языки',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Рекомендации",
            vPadding: 15,
            subtitle:
                "Выберите язык контента",
          ),
          HeaderWidget(
            'Безопасность',
            secondHeader: true,
          ),
          SettingRowWidget("Заблокированные"),
          SettingRowWidget("Заглушенные"),
        ],
      ),
    );
  }
}
