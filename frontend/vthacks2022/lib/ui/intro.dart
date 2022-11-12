import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vthacks2022/ui/login.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  late VideoPlayerController _controller;
  //initialize video player controller
  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.network(
        "https://youtube.com/shorts/E4DxPdJVvLs?feature=share")
      ..initialize().then((_) {
        setState(() {});
      });
    setState(() {});
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _videoPlayerController.setVolume(0);
    //   _videoPlayerController.play();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("vid player tutorial!"),
      ), //AppBar
      body: content(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      }), //floatingActionButton
    ); //scaffold

    // need to connect this to another
  }

  Widget content() {
    return Center(
      child: Container(
        width: 350,
        height: 350,
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : Container(),
      ),
    );
  }
}
