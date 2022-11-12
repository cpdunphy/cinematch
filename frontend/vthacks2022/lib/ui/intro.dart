import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
    void initState() {
      // TODO: implement initState
      _controller=IntroController.network("./assets/Intro_Anim.mp4")
      super.initState();
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
  }
}
