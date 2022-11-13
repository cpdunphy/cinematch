import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/media_service.dart';
import 'media/media_item.dart';
// import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:swipe/swipe.dart';

class Swipping extends StatefulWidget {
  String title = "CINEMATCH";

  @override
  State<Swipping> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Swipping> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // return Consumer<MediaService>(
    //   builder: (context, value, child) {
    //     return ListView.builder(
    //         itemCount: value.mediaList.length,
    //         itemBuilder: ((context, index) {
    //           return MediaItem(value.mediaList[index]);
    //         }));
    //   },
    // );
    return Consumer<MediaService>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.mediaList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                elevation: 10,
                margin: EdgeInsets.all(10),
                child: Dismissible(
                    background: Container(
                      color: Colors.green,
                    ),
                    key: ValueKey<String>(value.mediaList[index].id),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        value.mediaList.removeAt(index);
                      });
                    },
                    child: ListTile(
                      title: Text(
                        'Item ${value.mediaList[index]}',
                      ),
                    )));
          },
        );
      },
    );

    // return Scaffold(
    //   body: Swipe(
    //       child: Center(
    //     child: Container(
    //       height: 300,
    //       width: 200,
    //       child: Stack(
    //         children: [
    //           //tinder
    //           Container(
    //             color: Colors.deepPurple,
    //           ),
    //         ],
    //       ),
    //     ),
    //   )),
    // );
  }
}
