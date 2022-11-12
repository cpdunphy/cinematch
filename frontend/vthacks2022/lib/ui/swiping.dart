import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/media_service.dart';
import 'media/media_item.dart';

class Swipping extends StatefulWidget {
  String title = "CINEMATCH";

  @override
  State<Swipping> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Swipping> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaService>(
      builder: (context, value, child) {
        return ListView.builder(
            itemCount: value.mediaList.length,
            itemBuilder: ((context, index) {
              return MediaItem(value.mediaList[index]);
            }));
      },
    );
  }
}
