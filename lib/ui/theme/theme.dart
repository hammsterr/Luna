import 'package:flutter/material.dart';
part 'app_icons.dart';
part 'color/light_color.dart';
part 'text_styles.dart';
part 'extention.dart';
part 'color/dark_color.dart';


class AppTheme {
  static final ThemeData dayTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: TwitterColor.white,
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    cardColor: Colors.white,
    unselectedWidgetColor: Colors.grey,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColor.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: TwitterColor.white,
      iconTheme: IconThemeData(
        color: TwitterColor.dodgeBlue,
      ),
      elevation: 0,
      // ignore: deprecated_member_use
    ),
    bottomAppBarTheme: ThemeData.light().bottomAppBarTheme.copyWith(
          color: Colors.white,
          elevation: 0,
        ),
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyles.titleStyle.copyWith(color: TwitterColor.dodgeBlue),
      unselectedLabelColor: AppColor.darkGrey,
      unselectedLabelStyle:
          TextStyles.titleStyle.copyWith(color: AppColor.darkGrey),
      labelColor: TwitterColor.dodgeBlue,
      labelPadding: const EdgeInsets.symmetric(vertical: 12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: TwitterColor.dodgeBlue,
    ),
    colorScheme: const ColorScheme(
      background: Colors.white,
      onPrimary: Colors.white,
      onBackground: Colors.black,
      onError: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      primary: Colors.blue,
      primaryContainer: Colors.blue,
      secondary: AppColor.secondary,
      secondaryContainer: AppColor.darkGrey,
      surface: Colors.white,
      brightness: Brightness.light,
    ),
  );


  static final ThemeData nightTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: TwitterColor.black,
    brightness: Brightness.dark,
    primaryColor: darkColor.primary,
    cardColor: Colors.black,
    unselectedWidgetColor: Colors.grey,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: TwitterColor.black,
      iconTheme: IconThemeData(
        color: TwitterColor.dodgeBlue,
      ),
      elevation: 0,
    ),
    bottomAppBarTheme: ThemeData.dark().bottomAppBarTheme.copyWith(
      color: Colors.black,
      elevation: 0,
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyles.titleStyle.copyWith(color: TwitterColor.dodgeBlue),
      unselectedLabelColor: AppColor.lightGrey,
      unselectedLabelStyle:
      TextStyles.titleStyle.copyWith(color: AppColor.lightGrey),
      labelColor: TwitterColor.dodgeBlue,
      labelPadding: const EdgeInsets.symmetric(vertical: 12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: TwitterColor.dodgeBlue,
    ),
    colorScheme: const ColorScheme(
      background: Colors.black,
      onPrimary: Colors.black,
      onBackground: Colors.white,
      onError: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      error: Colors.red,
      primary: Colors.blue,
      primaryContainer: Colors.blue,
      secondary: AppColor.secondary,
      secondaryContainer: AppColor.darkGrey,
      surface: Colors.black,
      brightness: Brightness.dark,
    ),
  );

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(
        blurRadius: 10,
        offset: const Offset(5, 5),
        color: AppTheme.dayTheme.colorScheme.secondary,
        spreadRadius: 1)
  ];
  static BoxDecoration softDecoration =
      const BoxDecoration(boxShadow: <BoxShadow>[
    BoxShadow(
        blurRadius: 8,
        offset: Offset(5, 5),
        color: Color(0xffe2e5ed),
        spreadRadius: 5),
    BoxShadow(
        blurRadius: 8,
        offset: Offset(-5, -5),
        color: Color(0xffffffff),
        spreadRadius: 5)
  ], color: Color(0xfff1f3f6));
}

String get description {
  return '';
}
