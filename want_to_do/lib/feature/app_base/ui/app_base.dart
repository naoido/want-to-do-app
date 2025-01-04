import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'end_drawer.dart';

class AppBaseWidget extends StatefulWidget {
  final Widget body;
  final bool canBack;
  final bool isGuestPage;

  const AppBaseWidget({super.key, required this.body, required this.canBack, required this.isGuestPage});

  @override
  State<StatefulWidget> createState() => _AppBaseWidget();
}

class _AppBaseWidget extends State<AppBaseWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.canBack ? IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back)
        ) : Container(),
        actions: [
          if (!widget.isGuestPage) IconButton(
              onPressed: () => {
                _scaffoldKey.currentState?.openEndDrawer()
              },
              icon: const Icon(
                Icons.menu,
                size: 30,
              )
          )
          else Container()
        ],
        backgroundColor: Colors.grey,
        shadowColor: const Color.fromARGB(255, 189, 189, 189),
        elevation: 6,
      ),
      backgroundColor: Colors.green,
      key: _scaffoldKey,
      endDrawer: EndDrawerWidget(scaffoldKey: _scaffoldKey),
      body: widget.body,
    );
  }
}