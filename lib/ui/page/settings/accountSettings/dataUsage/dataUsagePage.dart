import 'package:flutter/material.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customAppBar.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/newWidget/title_text.dart';

class DataUsagePage extends StatelessWidget {
  const DataUsagePage({Key? key}) : super(key: key);

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
            child: TitleText('Настройки сети'),
          ),
          const Divider(height: 0),
          _row("Мобильный трафик и WI-FI"),
          const Divider(height: 0),
          _row("Только WI-FI"),
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
          'Использование сети',
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const HeaderWidget('Экономия трафика'),
          const SettingRowWidget(
            "Экономия трафика",
            showCheckBox: true,
            vPadding: 15,
            showDivider: false,
            subtitle:
                'Когда этот режим включен, фото и видео будут загружаться в невысоком качестве для экономии трафика.',
            visibleSwitch: null,
          ),
          const Divider(height: 0),
          const HeaderWidget('Фото'),
          SettingRowWidget(
            "Высокое качество фото",
            subtitle:
                'Данные режимы в разработке...',
            vPadding: 15,
            onPressed: () {
              openDarkModeSettings(context);
            },
            showDivider: false,
            visibleSwitch: null,
            showCheckBox: null,
          ),
          const HeaderWidget(
            'Видео',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Высокое качество фото",
            subtitle:
                'Данные режимы в разработке...',
            vPadding: 15,
            onPressed: () {
              openDarkModeSettings(context);
            },
            visibleSwitch: null,
            showCheckBox: null,
          ),
          SettingRowWidget(
            "Автовоспроизведение видео",
            subtitle:
                'В разработке...',
            vPadding: 15,
            onPressed: () {
              openDarkModeSettings(context);
            },
            showCheckBox: null,
            visibleSwitch: null,
          ),
          const HeaderWidget(
            'Синхронизация данных',
            secondHeader: true,
          ),
          const SettingRowWidget(
            "Синхронизация данных",
            showCheckBox: true,
            visibleSwitch: null,
          ),
          const SettingRowWidget(
            "Интервал синхронизации",
            subtitle: 'Ежедневно',
            showCheckBox: null,
            visibleSwitch: null,
          ),
          const SettingRowWidget(
            null,
            subtitle:
                'В разработке (возможность синхронизации в фоне).',
            vPadding: 10,
            showCheckBox: null,
            visibleSwitch: null,
          ),
        ],
      ),
    );
  }
}
