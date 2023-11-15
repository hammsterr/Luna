import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/ui/page/common/splash.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customFlatButton.dart';
import 'package:Luna/widgets/newWidget/title_text.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class UpdateApp extends StatefulWidget {
  const UpdateApp({Key? key}) : super(key: key);



  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
      builder: (_) => UpdateApp(),
    );
  }

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("В сети");
    initializeDateFormatting("ru");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus (String status) async{
    await _firestore.collection("users").doc(_auth.currentUser?.uid).update({
    "status": status,
        });
  }

  var dateFormat = DateFormat.Hm("ru").addPattern('  dd MMMM yyyy').toString();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
          setStatus("В сети");
    }
    else{
      setStatus(dateFormat);
      cprint("Вышел из сети: " + dateFormat);
      print("Вышел из сети: " + dateFormat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/icon-480.png"),
            const TitleText(
              "Доступно обновление!",
              fontSize: 25,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const TitleText(
              "Эта версия устарела. Установите новую версию",
              fontSize: 14,
              color: AppColor.darkGrey,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 35),
              child: CustomFlatButton(
                label: "Обновить сейчас",
                onPressed: () => Utility.launchURL(
                    "https://hamystore.web.app/"),
                borderRadius: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
