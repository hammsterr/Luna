import 'dart:io';

import 'package:Luna/widgets/tweet/widgets/tweetVideo.dart';
import 'package:flutter/material.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/model/feedModel.dart';
import 'package:Luna/state/feedState.dart';
import 'package:Luna/widgets/cache_image.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Luna/widgets/newWidget/customLoader.dart';
import 'package:photo_view/photo_view.dart';

class TweetImage extends StatelessWidget {
  const TweetImage({
    Key? key,
    required this.model,
    this.type,
    this.isRetweetImage = false,
  }) : super(key: key);

  final FeedModel model;
  final TweetType? type;
  final bool isRetweetImage;

  @override
  Widget build(BuildContext context) {
    if (model.imagePath != null) assert(type != null);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model.imagePath == null
          ? const SizedBox.shrink()
          : Padding(
        padding: const EdgeInsets.only(top: 8),
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(isRetweetImage ? 0 : 20),
          ),
          onTap: () {
            if (type == TweetType.ParentTweet) {
              return;
            }
            var state = Provider.of<FeedState>(context, listen: false);
            state.getPostDetailFromDatabase(model.key);
            state.setTweetToReply = model;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewPage(
                  imagePath: model.imagePath!,
                ),
              ),
            );
          },
          child: Hero(
            tag: model.imagePath!,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(isRetweetImage ? 0 : 20),
              ),
              child: Stack(
              children: [
                if (isVideoFile(model.imagePath!))
                Container(                                                      //VIDEO
                  width: context.width *
                      (type == TweetType.Detail ? .95 : .8) -
                      8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: /*AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: */

                          playtweetVideo(video: model.imagePath!),

                    ),
                 // ),
                //),
                if (!isVideoFile(model.imagePath!))
              InteractiveViewer(                                                //IMAGE
                  child: Container(
                      width: context.width *
                          (type == TweetType.Detail ? .95 : .8) -
                          8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Stack(
                              children: [


                                  CacheImage(
                                      path: model.imagePath!,
                                      fit: BoxFit.cover
                                  ),
                              ],
            ),
          ),
        ),
        scaleEnabled: true, // Enable pinch-to-zoom
        minScale: 0.5, // Minimum zoom scale
        maxScale: 2.0, // Maximum zoom scale
      ),
             ] ),
    ),
    ),
    ),
    ),
    );
  }
}

class ImageViewPage extends StatefulWidget {
  final String imagePath;

  const ImageViewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    // Simulate image loading delay
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: widget.imagePath,
                child: _isLoading
                    ? CustomScreenLoader(
                  height: double.infinity,
                  width: double.infinity,
                  backgroundColor: Colors.white,
                )
                    : PhotoView(
                  imageProvider: NetworkImage(widget.imagePath),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  initialScale: PhotoViewComputedScale.contained,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isVideoFile(String path) {
  if (path.toLowerCase().contains('.mp4')) {
    return true;
  }
  else {
    return false;
  }
}
