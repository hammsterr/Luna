import 'package:Luna/ui/page/profile/profilePage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/model/feedModel.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/state/feedState.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/share_widget.dart';
import 'package:Luna/widgets/tweet/tweet.dart';
import 'package:provider/provider.dart';

import '../../../state/profile_state.dart';

class TweetBottomSheet {





  Widget tweetOptionIcon(BuildContext context,
      {required FeedModel model,
      required TweetType type,
      required GlobalKey<ScaffoldState> scaffoldKey}) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: customIcon(context,
          icon: AppIcon.arrowDown,
          isTwitterIcon: true,
          iconColor: AppColor.lightGrey),
    ).ripple(
      () {
        _openBottomSheet(context,
            type: type, model: model, scaffoldKey: scaffoldKey);
      },
      borderRadius: BorderRadius.circular(20),
    );
  }

  void _openBottomSheet(BuildContext context,
      {required TweetType type,
      required FeedModel model,
      required GlobalKey<ScaffoldState> scaffoldKey}) async {
    var authState = Provider.of<AuthState>(context, listen: false);
    bool isMyTweet = authState.userId == model.userId;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: context.height *
                (type == TweetType.Tweet
                    ? (isMyTweet ? .25 : .44)
                    : (isMyTweet ? .38 : .52)),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: type == TweetType.Tweet
                ? _tweetOptions(context,
                    scaffoldKey: scaffoldKey,
                    isMyTweet: isMyTweet,
                    model: model,
                    type: type)
                : _tweetDetailOptions(context,
                    scaffoldKey: scaffoldKey,
                    isMyTweet: isMyTweet,
                    model: model,
                    type: type));
      },
    );
  }

  Widget _tweetDetailOptions(BuildContext context,
      {required bool isMyTweet,
      required FeedModel model,
      required TweetType type,
      required GlobalKey<ScaffoldState> scaffoldKey}) {
    var authState = Provider.of<AuthState>(context);
    return Column(
      children: <Widget>[
        Container(
          width: context.width * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(context, AppIcon.link,
            text: 'Скопировать ссылку на пост', isEnable: true, onPressed: () async {
          Navigator.pop(context);
          var uri = await Utility.createLinkToShare(
            context,
            "tweet/${model.key}",
            socialMetaTagParameters: SocialMetaTagParameters(
                description: model.description ??
                    "${model.user!.displayName} опубликовал пост в Луне.",
                title: "Пост в луне",
                imageUrl: Uri.parse(
                    "https://play-lh.googleusercontent.com/e66XMuvW5hZ7HnFf8R_lcA3TFgkxm0SuyaMsBs3KENijNHZlogUAjxeu9COqsejV5w=s180-rw")),
          );

          Utility.copyToClipBoard(
              context: context,
              text: uri.toString(),
              message: "Ссылка скопирована");
        }),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Удаление публикации',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Удалить"),
                      content: const Text('Вы точно хотите удалить этот пост?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Оставить'),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              TwitterColor.dodgeBlue,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              TwitterColor.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteTweet(
                              context,
                              type,
                              model.key!,
                              parentkey: model.parentkey,
                            );
                          },
                          child: const Text('Подтвердить'),
                        ),
                      ],
                    ),
                  );
                },
                isEnable: true,
              )
            : Container(),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Закрепить в профиле',
              )
            : _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Отписаться ${model.user!.userName}',

        ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.mute,
                text: 'Заглушить ${model.user!.userName}',
              ),
      _widgetBottomSheetRow(
          context,
          AppIcon.viewHidden,
          text: 'Кнопочка...',
        ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.block,
                text: 'Заблокировать ${model.user!.userName}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.report,
                text: 'Пожаловаться',
              ),
      ],
    );
  }

  Widget _tweetOptions(BuildContext context,
      {required bool isMyTweet,
      required FeedModel model,
      required TweetType type,
      required GlobalKey<ScaffoldState> scaffoldKey}) {
    return Column(
      children: <Widget>[
        Container(
          width: context.width * .1,
          height: 10,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(context, AppIcon.link,
            text: 'Скопировать ссылку', isEnable: true, onPressed: () async {
          var uri = await Utility.createLinkToShare(
            context,
            "tweet/${model.key}",
            socialMetaTagParameters: SocialMetaTagParameters(
                description: model.description ??
                    "${model.user!.displayName} опубликовал(а) пост в Луне.",
                title: "Пост в Луне",
                imageUrl: Uri.parse(
                    "https://play-lh.googleusercontent.com/e66XMuvW5hZ7HnFf8R_lcA3TFgkxm0SuyaMsBs3KENijNHZlogUAjxeu9COqsejV5w=s180-rw")),
          );

          Navigator.pop(context);
          Utility.copyToClipBoard(
              context: context,
              text: uri.toString(),
              message: "Ссылка на пост скопирована");
        }),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Удалить',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Удалить пост"),
                      content: const Text('Вы точно хотите удалить этот пост?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Оставить'),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              TwitterColor.dodgeBlue,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              TwitterColor.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteTweet(
                              context,
                              type,
                              model.key!,
                              parentkey: model.parentkey,
                            );
                          },
                          child: const Text('Подтвердить'),
                        ),
                      ],
                    ),
                  );
                },
                isEnable: true,
              )
            : Container(),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.thumbpinFill,
                text: 'Закрепить в профиле',
                onPressed: () {

                }
              )
            : _widgetBottomSheetRow(
                context,
                AppIcon.sadFace,
                text: 'Это не интересно',
                onPressed: () {

                }
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Отписаться ${model.user!.userName}',
                onPressed: () {

                }
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.mute,
                text: 'Заглушить ${model.user!.userName}',
                onPressed: () {

                }
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.block,
                text: 'Заблокировать ${model.user!.userName}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.report,
                text: 'Жалоба',
              ),
      ],
    );
  }

  Widget _widgetBottomSheetRow(BuildContext context, IconData icon,
      {required String text, Function? onPressed, bool isEnable = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            customIcon(
              context,
              icon: icon,
              isTwitterIcon: true,
              size: 25,
              paddingIcon: 8,
              iconColor:
                  onPressed != null ? AppColor.darkGrey : AppColor.lightGrey,
            ),
            const SizedBox(
              width: 15,
            ),
            customText(
              text,
              context: context,
              style: TextStyle(
                color: isEnable ? AppColor.secondary : AppColor.lightGrey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ).ripple(() {
        if (onPressed != null) {
          onPressed();
        } else {
          Navigator.pop(context);
        }
      }),
    );
  }

  void _deleteTweet(BuildContext context, TweetType type, String tweetId,
      {String? parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deleteTweet(tweetId, type, parentkey: parentkey);
    // CLose bottom sheet
    Navigator.of(context).pop();
    if (type == TweetType.Detail) {
      // Close Tweet detail page
      Navigator.of(context).pop();
      // Remove last tweet from tweet detail stack page
      state.removeLastTweetDetail(tweetId);
    }
  }

  void openRetweetBottomSheet(BuildContext context,
      {TweetType? type,
      required FeedModel model,
      required GlobalKey<ScaffoldState> scaffoldKey}) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: 130,
            width: context.width,
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _retweet(context, model, type));
      },
    );
  }

  Widget _retweet(BuildContext context, FeedModel model, TweetType? type) {
    return Column(
      children: <Widget>[
        Container(
          width: context.width * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.retweet,
          isEnable: true,
          text: 'Репост',
          onPressed: () async {
            var state = Provider.of<FeedState>(context, listen: false);
            var authState = Provider.of<AuthState>(context, listen: false);
            var myUser = authState.userModel;
            myUser = UserModel(
                displayName: myUser!.displayName ?? myUser.email!.split('@')[0],
                profilePic: myUser.profilePic,
                userId: myUser.userId,
                isVerified: authState.userModel!.isVerified,
                userName: authState.userModel!.userName);
            // Prepare current Tweet model to reply
            FeedModel post = FeedModel(
                childRetwetkey: model.getTweetKeyToRetweet,
                createdAt: DateTime.now().toUtc().toString(),
                user: myUser,
                userId: myUser.userId!);
            state.createTweet(post);

            Navigator.pop(context);
            var sharedPost = await state.fetchTweet(post.childRetwetkey!);
            if (sharedPost != null) {
              sharedPost.retweetCount ??= 0;
              sharedPost.retweetCount = sharedPost.retweetCount! + 1;
              state.updateTweet(sharedPost);
            }
          },
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.edit,
          text: 'Репостнуть с комментарием',
          isEnable: true,
          onPressed: () {
            var state = Provider.of<FeedState>(context, listen: false);
            // Prepare current Tweet model to reply
            state.setTweetToReply = model;
            Navigator.pop(context);

            /// `/ComposeTweetPage/retweet` route is used to identify that tweet is going to be retweet.
            /// To simple reply on any `Tweet` use `ComposeTweetPage` route.
            Navigator.of(context).pushNamed('/ComposeTweetPage/retweet');
          },
        )
      ],
    );
  }

  void openShareTweetBottomSheet(
      BuildContext context, FeedModel model, TweetType? type) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: 180,
            width: context.width,
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _shareTweet(context, model, type));
      },
    );
  }

  Widget _shareTweet(BuildContext context, FeedModel model, TweetType? type) {
    var socialMetaTagParameters = SocialMetaTagParameters(
        description: model.description ?? "",
        title: "${model.user!.displayName} запостил(-а) в Луне.",
        imageUrl: Uri.parse(model.user?.profilePic ??
            "https://play-lh.googleusercontent.com/e66XMuvW5hZ7HnFf8R_lcA3TFgkxm0SuyaMsBs3KENijNHZlogUAjxeu9COqsejV5w=s180-rw"));
    return Column(
      children: <Widget>[
        Container(
          width: context.width * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _widgetBottomSheetRow(
          context,
          AppIcon.bookmark,
          isEnable: true,
          text: 'В закладки',
          onPressed: () async {
            var state = Provider.of<FeedState>(context, listen: false);
            await state.addBookmark(model.key!);
            Navigator.pop(context);
            ScaffoldMessenger.maybeOf(context)!.showSnackBar(
              const SnackBar(content: Text("Закладка сохранена")),
            );
          },
        ),
        const SizedBox(height: 8),
        _widgetBottomSheetRow(
          context,
          AppIcon.link,
          isEnable: true,
          text: 'Поделиться ссылкой',
          onPressed: () async {
            Navigator.pop(context);
            var url = Utility.createLinkToShare(
              context,
              "tweet/${model.key}",
              socialMetaTagParameters: socialMetaTagParameters,
            );
            var uri = await url;
            Utility.share(uri.toString(), subject: "Tweet");
          },
        ),
        const SizedBox(height: 8),
        _widgetBottomSheetRow(
          context,
          AppIcon.image,
          text: 'Поделиться красиво ✨',
          isEnable: true,
          onPressed: () {
            socialMetaTagParameters = SocialMetaTagParameters(
                description: model.description ?? "",
                title: "${model.user!.displayName} запостил(-а) в Луне",
                imageUrl: Uri.parse(model.user?.profilePic ??
                    "https://play-lh.googleusercontent.com/e66XMuvW5hZ7HnFf8R_lcA3TFgkxm0SuyaMsBs3KENijNHZlogUAjxeu9COqsejV5w=s180-rw"));
            Navigator.pop(context);
            Navigator.push(
              context,
              ShareWidget.getRoute(
                  child: type != null
                      ? Tweet(
                          model: model,
                          type: type,
                          scaffoldKey: GlobalKey<ScaffoldState>(),
                        )
                      : Tweet(
                          model: model,
                          scaffoldKey: GlobalKey<ScaffoldState>()),
                  id: "tweet/${model.key}",
                  socialMetaTagParameters: socialMetaTagParameters),
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
