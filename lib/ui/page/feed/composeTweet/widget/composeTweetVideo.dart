import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Luna/ui/theme/theme.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ComposeTweetVideo extends StatefulWidget {
  const ComposeTweetVideo(
      {Key? key, this.video, required this.onCrossIconPressed})
      : super(key: key);

  final File? video;
  final VoidCallback onCrossIconPressed;

  @override
  _ComposeTweetVideoState createState() => _ComposeTweetVideoState();
}

  class _ComposeTweetVideoState extends State<ComposeTweetVideo> {

    VoidCallback? onCrossIconPressed;
    File? video;
    VideoPlayerController? _controller;
    ChewieController? _chewieController;
    late Future<void> _initializeVideoPlayerFuture;

    @override
    void dispose() {
      if (_controller!=null) {
        _controller!.dispose();
      }
      if (_chewieController!=null) {
        _chewieController!.dispose();
      }
        //setState(() {});
      super.dispose();
    }


    Future<void> initVideoPlayer() async {

      await _controller!.initialize ();
      setState(() {
        print(_controller!.value.aspectRatio);
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          aspectRatio: _controller!.value.aspectRatio,
          autoPlay: false,
          looping: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white,
                backgroundColor: Colors.transparent),
              ),
            );
          },
        );
      });

     // setState(() {});
    }

    void initState()  {
      super.initState();

        video = widget.video!;
        onCrossIconPressed = widget.onCrossIconPressed;

        _controller = VideoPlayerController.file(video!);
        _initializeVideoPlayerFuture = initVideoPlayer();

    }



    @override
    Widget build(BuildContext context) {
      if (video != null) assert(onCrossIconPressed != null);
      return
          video == null
            ? Container()
            : Stack(
          children: <Widget>[
            InteractiveViewer(
              child:
              Container(
                  color: Colors.transparent,
                   //height: 300,
                  //width: 200,
                  alignment: Alignment.topRight,
                  child:
                  FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if( (_chewieController!=null) && (snapshot.connectionState == ConnectionState.done) && video != null) {
                        // If the VideoPlayerController has finished initialization, use
                        // the data it provides to limit the aspect ratio of the video.
                        return AspectRatio(
                          aspectRatio: 1.0/1.0,
                          // Use the VideoPlayer widget to display the video.
                          child:Chewie(
                            controller: _chewieController!,
                          ),
                          //VideoPlayer(_controller),
                        );
                      } else {
                        // If the VideoPlayerController is still initializing, show a
                        // loading spinner.
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
              ),
            ),
/*            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black54),
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 20,
                  onPressed: onCrossIconPressed,
                  icon: Icon(
                    Icons.close,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                  ),
                ),
              ),
            )*/
          ],
      );
    }
  }
