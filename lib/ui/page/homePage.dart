import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/model/push_notification_model.dart';
import 'package:Luna/resource/push_notification_service.dart';
import 'package:Luna/state/appState.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/state/chats/chatState.dart';
import 'package:Luna/state/suggestionUserState.dart';
import 'package:Luna/state/feedState.dart';
import 'package:Luna/state/notificationState.dart';
import 'package:Luna/state/searchState.dart';
import 'package:Luna/ui/page/feed/feedPage.dart';
import 'package:Luna/ui/page/feed/feedPostDetail.dart';
import 'package:Luna/ui/page/feed/suggestedUsers.dart';
import 'package:Luna/ui/page/message/chatListPage.dart';
import 'package:Luna/ui/page/profile/profilePage.dart';
import 'package:Luna/widgets/bottomMenuBar/bottomMenuBar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'common/locator.dart';
import 'common/sidebar.dart';
import 'notification/notificationPage.dart';
import 'search/SearchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;
  // ignore: cancel_subscription
  late StreamSubscription<PushNotificationModel> pushNotificationSubscription;
  @override
  void initState() {

    initDynamicLinks();
    initializeDateFormatting('ru');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setPageIndex = 0;
      initTweets();
      initProfile();
      initSearch();
      initNotification();
      initChat();
    });
    WidgetsBinding.instance.addObserver(this);
    setStatus("В сети");
    super.initState();
    checkAndCreateDocument(_auth.currentUser!.uid);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus(String status) async {
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
        "status": status,
      });
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  void checkAndCreateDocument(String uid) async {
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!documentSnapshot.exists) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': _auth.currentUser?.uid,
        'Name': _auth.currentUser?.displayName,
        'status': 'В сети',
      });
      cprint("Проверка выполнена");
    }
  }

  var TimeNow = DateTime.now().toString();
  var FormatedTimeClock = DateFormat.Hm('ru').format(DateTime.now().toLocal());
  var FormatedDate = DateFormat("dd MMMM yyyy", "ru").format(DateTime.now().toLocal());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("В сети");
      checkAndCreateDocument(_auth.currentUser!.uid);
    } else {
      setStatus(FormatedTimeClock + ' - ' + FormatedDate);
      cprint("Вышел из сети: " + FormatedTimeClock + ' ' + FormatedDate);
      print("Вышел из сети: " + FormatedTimeClock + ' ' + FormatedDate);
    }
  }


  @override
  void dispose() {
    pushNotificationSubscription.cancel();
    super.dispose();
  }

  void initTweets() {
    var state = Provider.of<FeedState>(context, listen: false);
    state.databaseInit();
    state.getDataFromDatabase();
  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
  }

  void initNotification() {
    var state = Provider.of<NotificationState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.databaseInit(authState.userId);

    /// configure push notifications
    state.initFirebaseService();

    /// Subscribe the push notifications
    /// Whenever devices receive push notification, `listenPushNotification` callback will trigger.
    pushNotificationSubscription = getIt<PushNotificationService>()
        .pushNotificationResponseStream
        .listen(listenPushNotification);
  }

  /// Listen for every push notifications when app is in background
  /// Check for push notifications when app is launched by tapping on push notifications from system tray.
  /// If notification type is `NotificationType.Message` then chat screen will open
  /// If notification type is `NotificationType.Mention` then user profile will open who tagged/mentioned you in a tweet
  void listenPushNotification(PushNotificationModel model) {
    final authState = Provider.of<AuthState>(context, listen: false);
    var state = Provider.of<NotificationState>(context, listen: false);

    /// Check if user receive chat notification
    /// Redirect to chat screen
    /// `model.data.senderId` is a user id who sends you a message
    /// `model.data.receiverId` is a your user id.
    if (model.type == NotificationType.Message.toString() &&
        model.receiverId == authState.user!.uid) {
      /// Get sender profile detail from firebase
      state.getUserDetail(model.senderId).then((user) {
        final chatState = Provider.of<ChatState>(context, listen: false);
        chatState.setChatUser = user!;
        Navigator.pushNamed(context, '/ChatScreenPage');
      });
    }

    /// Checks for user tag tweet notification
    /// Redirect user to tweet detail if
    /// Tweet contains
    /// If you are mentioned in tweet then it redirect to user profile who mentioned you in a tweet
    /// You can check that tweet on his profile timeline
    /// `model.data.senderId` is user id who tagged you in a tweet
    else if (model.type == NotificationType.Mention.toString() &&
        model.receiverId == authState.user!.uid) {
      var feedState = Provider.of<FeedState>(context, listen: false);
      feedState.getPostDetailFromDatabase(model.tweetId);
      Navigator.push(context, FeedPostDetail.getRoute(model.tweetId));
    }
  }

  void initChat() {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.databaseInit(state.userId, state.userId);

    /// It will update fcm token in database
    /// fcm token is required to send firebase notification
    state.updateFCMToken();

    /// It get fcm server key
    /// Server key is required to configure firebase notification
    /// Without fcm server notification can not be sent
    chatState.getFCMServerKey();
  }

  /// Initialize the firebase dynamic link sdk
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen(
        (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        redirectFromDeepLink(deepLink);
      }
    }, onError: (e) async {
      cprint(e.message, errorIn: "onLinkError");
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      redirectFromDeepLink(deepLink);
    }
  }

  /// Redirect user to specific screen when app is launched by tapping on deep link.
  void redirectFromDeepLink(Uri deepLink) {
    cprint("Found Url from share: ${deepLink.path}");
    var type = deepLink.path.split("/")[1];
    var id = deepLink.path.split("/")[2];
    if (type == "profilePage") {
      Navigator.push(context, ProfilePage.getRoute(profileId: id));
    } else if (type == "tweet") {
      var feedState = Provider.of<FeedState>(context, listen: false);
      feedState.getPostDetailFromDatabase(id);
      Navigator.push(context, FeedPostDetail.getRoute(id));
    }
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        child: _getPage(Provider.of<AppState>(context).pageIndex),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FeedPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
      case 1:
        return SearchPage(scaffoldKey: _scaffoldKey);
      case 2:
        return NotificationPage(scaffoldKey: _scaffoldKey);
      case 3:
        return ChatListPage(scaffoldKey: _scaffoldKey);
      default:
        return FeedPage(scaffoldKey: _scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthState>();
    context.read<SuggestionsState>().initUser(state.userModel);

  /*  if (context
        .select<SuggestionsState, bool>((state) => state.displaySuggestions)) {
      return SuggestedUsers();
    }*/

    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: const BottomMenubar(),
      drawer: const SidebarMenu(),
      body: _body(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<StreamSubscription<PushNotificationModel>>(
            'pushNotificationSubscription', pushNotificationSubscription));
  }
}
