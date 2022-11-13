import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/media_service.dart';
import '../media/media_item.dart';
// import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:swipe/swipe.dart';
import 'package:flutter/src/widgets/framework.dart';

class Swipping extends StatefulWidget {
  String title = "CINEMATCH";

  @override
  State<Swipping> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Swipping> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<MediaService>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.mediaList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 10,
              margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     fit: BoxFit.cover,
                  //     image: NetworkImage(
                  //       value.mediaList[index].posterUrl,
                  //     ),
                  //   ),
                  // ),
                  // height: height * 0.9,
                  // width: width * 0.8,
                  child: Dismissible(
                background: Container(
                  color: Colors.green,
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                ),
                key: ValueKey<String>(value.mediaList[index].id),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    value.mediaList.removeAt(index);
                  });
                },
                // child: Text(
                //   '${value.mediaList[index].title}',
                // ),
                child: Image.network(value.mediaList[index].posterUrl),
              )),
            );
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
