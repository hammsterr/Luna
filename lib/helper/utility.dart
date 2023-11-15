// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../widgets/newWidget/customLoader.dart';

final kAnalytics = FirebaseAnalytics.instance;
final DatabaseReference kDatabase = FirebaseDatabase.instance.ref();
final kScreenLoader = CustomLoader();
void cprint(dynamic data,
    {String? errorIn, String? event, String label = 'Log'}) {
  /// Print logs only in development mode
  if (kDebugMode) {
    if (errorIn != null) {
      print(
          '****************************** error ******************************');
      developer.log('[Error]',
          time: DateTime.now(), error: data, name: errorIn);
      print(
          '****************************** error ******************************');
    } else if (data != null) {
      developer.log(data, time: DateTime.now(), name: label);
    }
    if (event != null) {
      Utility.logEvent(event, parameter: {});
    }
  }
}




class Utility {
  static String getPostTime2(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    initializeDateFormatting('ru', null); // Инициализация русской локали
    var dateFormat = DateFormat.Hm("ru").addPattern('  dd MMMM yyyy');
    var dat = dateFormat.format(dt);
    return dat;
  }

  static String getDob(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat = DateFormat.yMMMd().format(dt);
    return dat;
  }

  static String getJoiningDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    initializeDateFormatting("ru", null);


    var dt = DateTime.parse(date).toLocal();
    var dat = DateFormat("dd MMMM yyyy", "ru").format(dt);
    return 'Присоединился $dat';
  }

  static String getChatTime(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    String msg = '';
    var dt = DateTime.parse(date).toLocal();

    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
    }

    var dur = DateTime.now().toLocal().difference(dt);
    if (dur.inDays > 365) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 30) {
      msg = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 0) {
      msg = '${dur.inDays} дн.';
      return dur.inDays == 1 ? 'день назад' : DateFormat.MMMd().format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours} ч.';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes} мин.';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds} сек.';
    } else {
      msg = 'сейчас';
    }
    return msg;
  }

  static String getPollTime(String date) {
    int hr, mm;
    String msg = 'Опрос завершён';
    var endDate = DateTime.parse(date);
    if (DateTime.now().isAfter(endDate)) {
      return msg;
    }
    msg = 'Опрос завершён за';
    var dur = endDate.difference(DateTime.now());
    hr = dur.inHours - dur.inDays * 24;
    mm = dur.inMinutes - (dur.inHours * 60);
    if (dur.inDays > 0) {
      msg = ' ' + dur.inDays.toString() + (dur.inDays > 1 ? ' дн. ' : ' день');
    }
    if (hr > 0) {
      msg += ' ' + hr.toString() + ' ч.';
    }
    if (mm > 0) {
      msg += ' ' + mm.toString() + ' мин.';
    }
    return (dur.inDays).toString() +
        ' дн. ' +
        ' ' +
        hr.toString() +
        ' ч. ' +
        mm.toString() +
        ' мин.';
  }

  static String? getSocialLinks(String? url) {
    if (url != null && url.isNotEmpty) {
      url = url.contains("https://www") || url.contains("http://www")
          ? url
          : url.contains("www") &&
                  (!url.contains('https') && !url.contains('http'))
              ? 'https://' + url
              : 'https://www.' + url;
    } else {
      return null;
    }
    cprint('Открытие ссылки : $url');
    return url;
  }

  static launchURL(String url) async {
    if (url == "") {
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      cprint('Невозможно открыть $url');
    }
  }

  static void logEvent(String event, {Map<String, dynamic>? parameter}) {
    kReleaseMode
        ? kAnalytics.logEvent(name: event, parameters: parameter)
        : print("[EVENT]: $event");
  }

  static void debugLog(String log, {dynamic param = ""}) {
    final String time = DateFormat("mm:ss:mmm").format(DateTime.now());
    print("[$time][Log]: $log, $param");
  }

  static void share(String message, {String? subject}) {
    Share.share(message, subject: subject);
  }

  static List<String> getHashTags(String text) {
    RegExp reg = RegExp(
        r"([#])\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> _matches = reg.allMatches(text);
    List<String> resultMatches = <String>[];
    for (Match match in _matches) {
      if (match.group(0)!.isNotEmpty) {
        var tag = match.group(0);
        resultMatches.add(tag!);
      }
    }
    return resultMatches;
  }

  static String getUserName({
    required String id,
    required String name,
  }) {
    String userName = '';
    if (name.length > 15) {
      name = name.substring(0, 6);
    }
    name = name.split(' ')[0];
    id = id.substring(0, 4).toLowerCase();
    userName = '@$name$id';
    return userName;
  }

  static bool validateCredentials(
      BuildContext context, String? email, String? password) {
    if (email == null || email.isEmpty) {
      customSnackBar(context, 'Введите email');
      return false;
    } else if (password == null || password.isEmpty) {
      customSnackBar(context, 'Введите пароль');
      return false;
    } else if (password.length < 8) {
      customSnackBar(context, 'Пароль должен быть длиннее 8 символов');
      return false;
    }

    var status = validateEmail(email);
    if (!status) {
      customSnackBar(context, 'Введите правильный email');
      return false;
    }
    return true;
  }

  static customSnackBar(BuildContext context, String msg,
      {double height = 30, Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool validateEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    var status = regExp.hasMatch(email);
    return status;
  }

  static Future<Uri> createLinkToShare(BuildContext context, String id,
      {required SocialMetaTagParameters socialMetaTagParameters}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://lunarv.page.link',
      link: Uri.parse('https://lunarv.page.link/$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.hamy.lunarv_dev',
        minimumVersion: 0,
      ),
      socialMetaTagParameters: socialMetaTagParameters,
    );
    Uri url;
    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    url = shortLink.shortUrl;
    return url;
  }

  static createLinkAndShare(BuildContext context, String id,
      {required SocialMetaTagParameters socialMetaTagParameters}) async {
    var url = await createLinkToShare(context, id,
        socialMetaTagParameters: socialMetaTagParameters);

    share(url.toString(), subject: "Tweet");
  }

  static shareFile(List<String> path, {String text = ""}) {
    try {
      final files = path.map((path) => XFile(path)).toList();
      Share.shareXFiles(files, text: text);
    } catch (error) {
      print(error);
    }
  }

  static void copyToClipBoard({
    required BuildContext context,
    required String text,
    required String message,
  }) {
    var data = ClipboardData(text: text);
    Clipboard.setData(data);
    customSnackBar(context, message);
  }

  static Locale getLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }
}
