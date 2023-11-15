import 'package:flutter/material.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/ui/page/settings/widgets/headerWidget.dart';
import 'package:Luna/ui/page/settings/widgets/settingsAppbar.dart';
import 'package:Luna/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Account',
        subtitle: user.userName,
      ),
      body: ListView(
        children: <Widget>[
          const HeaderWidget('Вход и защита'),
          SettingRowWidget(
            "Ник",
            subtitle: user.userName,
          ),
          const Divider(height: 0),
          SettingRowWidget(
            "Телефон",
            subtitle: user.contact,
          ),
          SettingRowWidget(
            "Email",
            subtitle: user.email,
            navigateTo: 'VerifyEmailPage',
          ),
          const SettingRowWidget("Пароль"),
          const SettingRowWidget("Защита"),
          const HeaderWidget(
            'Данные и разрешения',
            secondHeader: true,
          ),
          const SettingRowWidget("Место"),
          const SettingRowWidget("Ваши данные"),
          const SettingRowWidget("Приложения"),
          SettingRowWidget(
            "Выход",
            textColor: TwitterColor.ceriseRed,
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              final state = Provider.of<AuthState>(context);
              state.logoutCallback();
            },
          ),
        ],
      ),
    );
  }
}
