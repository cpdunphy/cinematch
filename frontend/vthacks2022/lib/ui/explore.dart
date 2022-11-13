import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/media_service.dart';
import 'media/media_item.dart';
import 'package:swipe/swipe.dart';
import 'package:flutter/src/widgets/framework.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    const title = 'Explore Titles';
    return Consumer<MediaService>(builder: (context, value, child) {
      value.getMedia();
      return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: value.mediaList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Card(
              child: Image.network(
                value.mediaList[index].posterUrl,
                fit: BoxFit.fitHeight,
              ),
            ),
            onTap: () {
              // AlertDialog(
              //   title: const Text(value.mediaList[index].title),
              //   content: const Text(value.mediaList[index].description),
              //   actions: <Widget>[
              //     TextButton(
              //       onPressed: () => Navigator.pop(context, 'OK'),
              //       child: const Text('OK'),
              //     ),
              //   ],
              // );
            },
          );
        },
      );
    });
    // IconButton(onPressed: onPressed, icon: icon)

    // child: Row(

    // ),
  }
}

                // Container(
                //   height: 140,
                //   width: 100,
                //   decoration: BoxDecoration(
                //       image: DecorationImage(
                //     image: NetworkImage(value.mediaList[index].posterUrl),
                //   )),
                //   // image: Image.network(value.mediaList[index].posterUrl,
                //   //     height: 150),
                //   child: Text('${value.mediaList[index].title}',
                //       textAlign: TextAlign.center),
                // ),