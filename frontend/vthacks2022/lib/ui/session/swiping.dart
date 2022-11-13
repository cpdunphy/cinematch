import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/session_participant_service.dart';
import 'package:vthacks2022/ui/session/session_view.dart';

import '../../core/services/media_service.dart';
import '../media/media_item.dart';
// import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:swipe/swipe.dart';
import 'package:flutter/src/widgets/framework.dart';

class Swipping extends StatefulWidget {
  // String title = "CINEMATCH";

  Swipping({super.key, required this.swipeState});

  SwipeState swipeState;

  @override
  State<Swipping> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Swipping> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    SessionParticipantService participantService =
        Provider.of<SessionParticipantService>(context);
    MediaService mediaService = Provider.of<MediaService>(context);

    print("There are (${mediaService.mediaList.length}) items remaining.");

    // if (mediaService.mediaList.isEmpty) {
    //   participantService.setSwipeState(SwipeState.waiting);
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Session Code ${participantService.participatingSessionCode}',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              participantService.setSwipeState(SwipeState.gallery);
            },
            alignment: Alignment.centerLeft,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: mediaService.mediaList.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 10,
            margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: Dismissible(
              background: Container(
                color: Colors.green,
              ),
              secondaryBackground: Container(
                color: Colors.red,
              ),
              key: ValueKey<String>(mediaService.mediaList[index].id),
              onDismissed: (DismissDirection direction) async {
                switch (direction) {
                  case DismissDirection.endToStart:
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('Disliked'),
                    //   ),
                    // );
                    await participantService
                        .swipeLeft(mediaService.mediaList[index]);
                    break;
                  case DismissDirection.startToEnd:
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('Liked'),
                    //   ),
                    // );
                    await participantService
                        .swipeRight(mediaService.mediaList[index]);
                    break;
                  default:
                    break;
                }

                setState(() {
                  mediaService.mediaList.removeAt(index);
                });
              },
              child: Image.network(mediaService.mediaList[index].posterUrl),
            ),
          );
        },
      ),
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
