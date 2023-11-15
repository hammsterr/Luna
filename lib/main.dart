import 'package:Luna/state/ThemeState.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Luna/state/suggestionUserState.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:Luna/state/searchState.dart';
import 'package:Luna/ui/page/common/locator.dart';
import 'package:Luna/ui/theme/theme.dart';

import 'helper/routes.dart';
import 'state/appState.dart';
import 'state/authState.dart';
import 'state/chats/chatState.dart';
import 'state/feedState.dart';
import 'state/notificationState.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('ru');
  setupDependencies();
  runApp(    ChangeNotifierProvider<ThemeState>(
    create: (_) => ThemeState(),
    builder: (context, _) {
      final themeState = Provider.of<ThemeState>(context);
      themeState.loadDarkMode(); // Загрузка состояния темы
      return MyApp();
    },
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {






    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(create: (_) => ThemeState()),
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
        ChangeNotifierProvider<ChatState>(create: (_) => ChatState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
        ChangeNotifierProvider<NotificationState>(
            create: (_) => NotificationState()),
        ChangeNotifierProvider<SuggestionsState>(
            create: (_) => SuggestionsState()),
      ],
      child: MaterialApp(
        title: 'Luna',
        theme: AppTheme.dayTheme.copyWith(
          textTheme: GoogleFonts.mulishTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
        initialRoute: "SplashPage",

      ),
    );
  }
}
