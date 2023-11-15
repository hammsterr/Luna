import 'package:flutter/material.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/model/feedModel.dart';
import 'package:Luna/state/bookmarkState.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customAppBar.dart';
import 'package:Luna/widgets/newWidget/emptyList.dart';
import 'package:Luna/widgets/tweet/tweet.dart';
import 'package:provider/provider.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
      builder: (_) {
        return Provider(
          create: (_) => BookmarkState(),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => BookmarkState(),
            builder: (_, child) => const BookmarkPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      appBar: CustomAppBar(
        title: Text("Закладки", style: TextStyles.titleStyle),
        isBackButton: true,
      ),
      body: const BookmarkPageBody(),
    );
  }
}

class BookmarkPageBody extends StatelessWidget {
  const BookmarkPageBody({Key? key}) : super(key: key);

  Widget _tweet(BuildContext context, FeedModel model) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Tweet(
            model: model,
            type: TweetType.Tweet,
            scaffoldKey: GlobalKey<ScaffoldState>(),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<BookmarkState>(context, listen: false).removeBookmark(model.key as String);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<BookmarkState>(context);
    var list = state.tweetList;
    if (state.isbusy) {
      return const SizedBox(
        height: 3,
        child: LinearProgressIndicator(),
      );
    } else if (list == null || list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyList(
          'Закладок нет',
          subTitle: 'Когда вы добавите пост в закладки, \'он появится здесь.',
        ),
      );
    }
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) => _tweet(context, list[index]),
      itemCount: list.length,
    );
  }
}
