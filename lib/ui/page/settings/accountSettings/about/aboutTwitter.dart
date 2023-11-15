import 'package:flutter/material.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customAppBar.dart';
import 'package:Luna/widgets/customWidgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'О Луне',
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const HeaderWidget(
            'Помощь',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Помощь",
            vPadding: 0,
            showDivider: false,
            onPressed: () {
              Utility.launchURL(
                  "https://github.com/hammsterr/Luna/issues");
            },
          ),
          const HeaderWidget('Оферта'),
          const SettingRowWidget(
            "Правила пользования",
            showDivider: true,
          ),
          const SettingRowWidget(
            "Политика конфиденциальности",
            showDivider: true,
          ),
          const SettingRowWidget(
            "Использование куки",
            showDivider: true,
          ),
          SettingRowWidget(
            "Лицензии",
            showDivider: true,
            onPressed: () async {
              showLicensePage(
                context: context,
                applicationName: 'Luna',
                applicationVersion: '1.0.8',
                useRootNavigator: true,
              );
            },
          ),
          const HeaderWidget('Разработчик Луны'),
          SettingRowWidget("Сайт Хомяка", showDivider: true, onPressed: () {
            Utility.launchURL("https://hamyack.pages.dev");
          }),
          SettingRowWidget("Гитхаб Хомяка", showDivider: true, onPressed: () {
            Utility.launchURL("https://github.com/hammsterr");
          }),
          SettingRowWidget("Твиттер TheAlphamerc (Создатель шаблона)", showDivider: true, onPressed: () {
            Utility.launchURL("https://twitter.com/TheAlphaMerc");
          }),
        ],
      ),
    );
  }
}
