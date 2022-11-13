import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:vthacks2022/core/services/media_service.dart';
import 'package:vthacks2022/ui/manage_user.dart';
import 'package:vthacks2022/ui/session_view.dart';
import 'package:vthacks2022/ui/swiping.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 1;

  final pages = [
    Text("Sessions"),
    const SessionView(),
    Swipping(),
    ManageUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CINEMATCH"),
        actions: getActions(_pageIndex),
      ),
      bottomNavigationBar: buildNavBar(context),
      body: pages[_pageIndex],
    );
  }

  getActions(int body) {
    switch (body) {
      case 2:
        return [
          // Action button that fetches the first 10 movies from the API
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider =
                  Provider.of<MediaService>(context, listen: false);
              if (provider.mediaList.isEmpty) {
                provider.getMedia();
              } else {
                provider.getNextMedia();
              }
            },
          ),
        ];
    }
  }

  Widget buildNavBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageIndex = 0;
              });
            },
            icon: _pageIndex == 0
                ? const Icon(
                    CupertinoIcons.house_fill,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    CupertinoIcons.house,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageIndex = 1;
              });
            },
            icon: _pageIndex == 1
                ? const Icon(
                    Icons.work_rounded,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.work_outline_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageIndex = 2;
              });
            },
            icon: _pageIndex == 2
                ? const Icon(
                    CupertinoIcons.rectangle_grid_2x2,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    CupertinoIcons.rectangle_grid_2x2,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageIndex = 3;
              });
            },
            icon: _pageIndex == 3
                ? const Icon(
                    CupertinoIcons.person_circle_fill,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    CupertinoIcons.person_circle,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
        ],
      ),
    );
  }
}
