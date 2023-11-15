import 'package:flutter/material.dart';
import 'package:Luna/helper/customRoute.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/helper/utility.dart';
import 'package:Luna/model/feedModel.dart';
import 'package:Luna/state/authState.dart';
import 'package:Luna/state/feedState.dart';
import 'package:Luna/ui/page/common/usersListPage.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:Luna/widgets/customWidgets.dart';
import 'package:Luna/widgets/tweet/widgets/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class TweetIconsRow extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Color iconEnableColor;
  final double? size;
  final bool isTweetDetail;
  final TweetType? type;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TweetIconsRow(
      {Key? key,
      required this.model,
      required this.iconColor,
      required this.iconEnableColor,
      this.size,
      this.isTweetDetail = false,
      this.type,
      required this.scaffoldKey})
      : super(key: key);

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    var authState = Provider.of<AuthState>(context, listen: false);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(bottom: 0, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          _iconWidget(
            context,
            text: isTweetDetail ? '' : model.commentCount.toString(),
            icon: AppIcon.reply,
            iconColor: iconColor,
            size: size ?? 20,
            onPressed: () {
              var state = Provider.of<FeedState>(context, listen: false);
              state.setTweetToReply = model;
              Navigator.of(context).pushNamed('/ComposeTweetPage');
            },
          ),
          _iconWidget(context,
              text: isTweetDetail ? '' : model.retweetCount.toString(),
              icon: AppIcon.retweet,
              iconColor: iconColor,
              size: size ?? 20, onPressed: () {
            TweetBottomSheet().openRetweetBottomSheet(context,
                type: type, model: model, scaffoldKey: scaffoldKey);
          }),
          _iconWidget(
            context,
            text: isTweetDetail ? '' : model.likeCount.toString(),
            icon: model.likeList!.any((userId) => userId == authState.userId)
                ? AppIcon.heartFill
                : AppIcon.heartEmpty,
            onPressed: () {
              addLikeToTweet(context);
            },
            iconColor:
                model.likeList!.any((userId) => userId == authState.userId)
                    ? iconEnableColor
                    : iconColor,
            size: size ?? 20,
          ),
          _iconWidget(context, text: '', icon: null, sysIcon: Icons.share,
              onPressed: () {
            shareTweet(context);
          }, iconColor: iconColor, size: size ?? 20),
        ],
      ),
    );
  }

  Widget _iconWidget(BuildContext context,
      {required String text,
      IconData? icon,
      Function? onPressed,
      IconData? sysIcon,
      required Color iconColor,
      double size = 20}) {
    if (sysIcon == null) assert(icon != null);
    if (icon == null) assert(sysIcon != null);

    return Expanded(
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (onPressed != null) onPressed();
            },
            icon: sysIcon != null
                ? Icon(sysIcon, color: iconColor, size: size)
                : customIcon(
                    context,
                    size: size,
                    icon: icon!,
                    isTwitterIcon: true,
                    iconColor: iconColor,
                  ),
          ),
          customText(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: iconColor,
              fontSize: size - 5,
            ),
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _timeWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const SizedBox(width: 5),
            customText(Utility.getPostTime2(model.createdAt),
                style: TextStyles.textStyle14),
            const SizedBox(width: 10),
            customText('Luna для Android',
                style: TextStyle(color: Theme.of(context).primaryColor))
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _likeCommentWidget(BuildContext context) {
    bool isLikeAvailable = model.likeCount != null ? model.likeCount! > 0 : false;
    bool isRetweetAvailable = model.retweetCount! > 0;
    bool isLikeRetweetAvailable = isRetweetAvailable || isLikeAvailable;

    // Получение формы слова "лайки" в зависимости от количества
    String likeText = model.likeCount != null ? getLikeText(model.likeCount!) : 'Лайков';


    return Column(
      children: <Widget>[
        const Divider(
          endIndent: 10,
          height: 0,
        ),
        AnimatedContainer(
          padding: EdgeInsets.symmetric(vertical: isLikeRetweetAvailable ? 12 : 0),
          duration: const Duration(milliseconds: 500),
          child: !isLikeRetweetAvailable
              ? const SizedBox.shrink()
              : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              !isRetweetAvailable
                  ? const SizedBox.shrink()
                  : customText(model.retweetCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              !isRetweetAvailable ? const SizedBox.shrink() : const SizedBox(width: 5),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: customText('Репосты', style: TextStyles.subtitleStyle),
                crossFadeState: !isRetweetAvailable ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 800),
              ),
              !isRetweetAvailable ? const SizedBox.shrink() : const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  onLikeTextPressed(context);
                },
                child: AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Row(
                    children: <Widget>[
                      customSwitcherWidget(
                        duraton: const Duration(milliseconds: 300),
                        child: customText(model.likeCount.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            key: ValueKey(model.likeCount)),
                      ),
                      const SizedBox(width: 5),
                      customText(likeText, style: TextStyles.subtitleStyle) // Используем форму слова "лайки"
                    ],
                  ),
                  crossFadeState: !isLikeAvailable ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              )
            ],
          ),
        ),
        !isLikeRetweetAvailable
            ? const SizedBox.shrink()
            : const Divider(
          endIndent: 10,
          height: 0,
        ),
      ],
    );
  }

  String getLikeText(int likeCount) {
    if (likeCount == 0) {
      return 'Лайков';
    } else if (likeCount == 1) {
      return 'Лайк';
    } else if (likeCount >= 2 && likeCount <= 4) {
      return 'Лайка';
    } else {
      return 'Лайков';
    }
  }

  Widget customSwitcherWidget(
      {required child, Duration duraton = const Duration(milliseconds: 500)}) {
    return AnimatedSwitcher(
      duration: duraton,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: child,
    );
  }

  void addLikeToTweet(BuildContext context) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToTweet(model, authState.userId);
  }

  void onLikeTextPressed(BuildContext context) {
    Navigator.of(context).push(
      CustomRoute<bool>(
        builder: (BuildContext context) => UsersListPage(
          pageTitle: "Лайки",
          userIdsList: model.likeList!.map((userId) => userId).toList(),
          emptyScreenText: "Этот пост никто не лайкал(",
          emptyScreenSubTileText:
              "Когда кто-нибудь поставит лайк, он будет в этом списке",
        ),
      ),
    );
  }

  void shareTweet(BuildContext context) async {
    TweetBottomSheet().openShareTweetBottomSheet(context, model, type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isTweetDetail ? _timeWidget(context) : const SizedBox(),
        isTweetDetail ? _likeCommentWidget(context) : const SizedBox(),
        _likeCommentsIcons(context, model)
      ],
    );
  }
}
