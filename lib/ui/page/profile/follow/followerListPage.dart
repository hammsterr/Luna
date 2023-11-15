import 'package:Luna/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:Luna/model/user.dart';
import 'package:Luna/ui/page/common/usersListPage.dart';
import 'package:Luna/ui/page/profile/follow/followListState.dart';
import 'package:Luna/widgets/newWidget/customLoader.dart';
import 'package:provider/provider.dart';

class FollowerListPage extends StatelessWidget {
  const FollowerListPage({Key? key, this.userList, this.profile})
      : super(key: key);
  final List<String>? userList;
  final UserModel? profile;

  static MaterialPageRoute getRoute(
      {required List<String> userList, required UserModel profile}) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return ChangeNotifierProvider(
          create: (_) => FollowListState(StateType.follower),
          child: FollowerListPage(userList: userList, profile: profile),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<FollowListState>().isbusy) {
      return SizedBox(
        height: context.height,
        child: const CustomScreenLoader(
          height: double.infinity,
          width: double.infinity,
          backgroundColor: Colors.white,
        ),
      );
    }
    return UsersListPage(
      pageTitle: 'Подписчики',
      userIdsList: userList,
      emptyScreenText: '${profile?.userName} не имеет подписчиков',
      emptyScreenSubTileText:
          'Когда кто нибудь подпишеться на профиль, список появится здесь.',
      isFollowing: (user) {
        return context.watch<FollowListState>().isFollowing(user);
      },
      onFollowPressed: (user) {
        context.read<FollowListState>().followUser(user);
      },
    );
  }
}
