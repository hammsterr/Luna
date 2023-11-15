import 'package:flutter/material.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customAppBar.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/newWidget/title_text.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({Key? key}) : super(key: key);

  void openBottomSheet(
    BuildContext context,
    double height,
    Widget child,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: TwitterColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: child,
        );
      },
    );
  }

  void openDarkModeSettings(BuildContext context) {
    openBottomSheet(
      context,
      250,
      Column(
        children: <Widget>[
          const SizedBox(height: 5),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: TwitterColor.paleSky50,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: TitleText('Настройки сети (не реализовано)'),
          ),
          const Divider(height: 0),
          _row("Мобильный трафик и WiFi"),
          const Divider(height: 0),
          _row("Только WiFi"),
          const Divider(height: 0),
          _row("Никогда"),
        ],
      ),
    );
  }

  void openDarkModeAppearanceSettings(BuildContext context) {
    openBottomSheet(
      context,
      190,
      Column(
        children: <Widget>[
          const SizedBox(height: 5),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: TwitterColor.paleSky50,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TitleText('Режим темной темы'),
          ),
          const Divider(height: 0),
          _row("Тусклый"),
          const Divider(height: 0),
          _row("Темный"),
        ],
      ),
    );
  }

  Widget _row(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: RadioListTile(
        value: false,
        groupValue: true,
        onChanged: (val) {},
        title: Text(text),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Доступность',
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const HeaderWidget('Screen Reader'),
          const SettingRowWidget(
            "Pronounce # as \"hashtag\"",
            showCheckBox: true,
          ),
          const Divider(height: 0),
          const HeaderWidget('Vision'),
          SettingRowWidget(
            "Compose image descriptions",
            subtitle:
                'Adds the ability to describe images for the visually impaired.',
            vPadding: 15,
            showCheckBox: false,
            onPressed: () {
              openDarkModeSettings(context);
            },
            showDivider: false,
          ),
          const HeaderWidget(
            'Motion',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Reduce Motion",
            subtitle:
                'Limit the amount of in-app animations, including live engagement counts.',
            vPadding: 15,
            showCheckBox: false,
            onPressed: () {
              openDarkModeSettings(context);
            },
          ),
          SettingRowWidget(
            "Video autoplay",
            subtitle: 'Wi-Fi only ',
            onPressed: () {
              openDarkModeSettings(context);
            },
          ),
        ],
      ),
    );
  }
}
