import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Luna/helper/enum.dart';
import 'package:Luna/model/feedModel.dart';
import 'package:Luna/state/feedState.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class tweetVideo extends StatelessWidget {
  const tweetVideo({Key? key, required this.model}) : super(key: key);

  final FeedModel model;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      //width: 200,
      duration: const Duration(milliseconds: 1500),
      alignment: Alignment.centerRight,
      child: (model.hasVideo != null)
          ? playtweetVideo(video: model.imagePath!)
          : const SizedBox.shrink(),
    );
  }
}

class playtweetVideo extends StatefulWidget {
  const playtweetVideo({Key? key, this.video}) : super(key: key);

  final String? video;

  @override
  _playtweetVideoState createState() => _playtweetVideoState();
}

class _playtweetVideoState extends State<playtweetVideo> {
  String? video;
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    video = widget.video;
    _initializeVideoPlayerFuture = initVideoPlayer();
  }

  Future<void> initVideoPlayer() async {
    File videoFile = await DefaultCacheManager().getSingleFile(video!);
    _controller = VideoPlayerController.file(videoFile);
    await _controller!.initialize();
    setState(() {
      print(_controller!.value.aspectRatio);
      if (_chewieController == null) {
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          aspectRatio: _controller!.value.aspectRatio,
          autoPlay: false,
          looping: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InteractiveViewer(
          child: Container(
            alignment: Alignment.topRight,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (_chewieController != null &&
                    snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController!,
                    ),
                  );
                } else {
                  return const Center(
                    heightFactor: 5,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
