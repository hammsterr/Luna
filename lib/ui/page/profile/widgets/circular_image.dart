import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Luna/helper/constant.dart';

class CircularImage extends StatelessWidget {
  const CircularImage(
      {Key? key, this.path, this.height = 50, this.isBorder = false})
      : super(key: key);
  final String? path;
  final double height;
  final bool isBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: Colors.grey.shade100, width: isBorder ? 2 : 0),
      ),
      child: CircleAvatar(
        maxRadius: height / 2,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage:
            customAdvanceNetworkImage(path ?? Constants.dummyProfilePic),
      ),
    );
  }
}

CachedNetworkImageProvider customAdvanceNetworkImage(String? path) {
  if (path ==
      'https://i2.photo.2gis.com/images/profile/30258560098803276_96cf_640x.jpg') {
    path = Constants.dummyProfilePic;
  } else {
    path ??= Constants.dummyProfilePic;
  }
  return CachedNetworkImageProvider(
    path,
    cacheKey: path,
  );
}
