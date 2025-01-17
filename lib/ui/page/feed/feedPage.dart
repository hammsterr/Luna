import 'package:flutter/material.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/model/feedModel.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/state/feedState.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/newWidget/customLoader.dart';
import 'package:Luna/widgets/newWidget/emptyList.dart';
import 'package:Luna/widgets/tweet/tweet.dart';
import 'package:Luna/widgets/tweet/widgets/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
/*
  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
      },
      child: customIcon(
        context,
        icon: AppIcon.fabTweet,
        isTwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: _floatingActionButton(context),
      backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              /// refresh home page feed
              var feedState = Provider.of<FeedState>(context, listen: false);
              feedState.getDataFromDatabase();
              return Future.value(true);
            },
            child: _FeedPageBody(
              refreshIndicatorKey: refreshIndicatorKey,
              scaffoldKey: scaffoldKey,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedPageBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const _FeedPageBody(
      {Key? key, required this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Consumer<FeedState>(
        builder: (context, state, child) {
          final List<FeedModel>? list = state.getTweetList(authState.userModel);
          return CustomScrollView(
            slivers: <Widget>[
              child!,
              state.isBusy && list == null
                  ? SliverToBoxAdapter(
                child: SizedBox(
                  height: context.height - 135,
                  child: CustomScreenLoader(
                    height: double.infinity,
                    width: double.infinity,
                    backgroundColor: Colors.white,
                  ),
                ),
              )
                  : !state.isBusy && list == null
                  ? const SliverToBoxAdapter(
                child: EmptyList(
                  'Нет публикаций',
                  subTitle:
                  'Когда что-нибудь появится, вы увидете посты здесь. А лучше - напишите что нибудь сами)',
                ),
              )
                  : SliverList(
                delegate: SliverChildListDelegate(
                  list!.map(
                        (model) {
                      return Container(
                        color: Colors.white,
                        child: Tweet(
                          model: model,
                          trailing: TweetBottomSheet().tweetOptionIcon(
                              context,
                              model: model,
                              type: TweetType.Tweet,
                              scaffoldKey: scaffoldKey),
                          scaffoldKey: scaffoldKey,
                        ),
                      );
                    },
                  ).toList(),
                ),
              )
            ],
          );
        },
        child: SliverAppBar(
          floating: true,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              );
            },
          ),
          title: Image.asset('assets/images/icon-480.png', height: 40),
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme
              .of(context)
              .primaryColor),
          backgroundColor: Theme
              .of(context)
              .appBarTheme
              .backgroundColor,
          bottom: PreferredSize(
            child: Container(
              color: Colors.grey.shade200,
              height: 1.0,
            ),
            preferredSize: const Size.fromHeight(0.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/CreateFeedPage/tweet'); //Create Post Button
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: TwitterColor.dodgeBlue,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Создать',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

}
