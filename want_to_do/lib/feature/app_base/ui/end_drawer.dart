import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/normal_dialog.dart';
import '../../login/domains/google_auth.dart';

class EndDrawerWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const EndDrawerWidget({super.key, required this.scaffoldKey});

  @override
  State<StatefulWidget> createState() => _EndDrawerWidget();
}

class _EndDrawerWidget extends State<EndDrawerWidget> {
  late final List<_Link> _links;

  _EndDrawerWidget() {
    _links = [
      const _Link(title: "プロフィール", path: "/home/user", icon: Icon(Icons.person)),
      const _Link(title: "設定", path: "setting", icon: Icon(Icons.settings)),
      _Link(
          title: "ログアウト",
          path: "logout",
          icon: const Icon(Icons.logout),
          onTaped: () {
            var state = widget.scaffoldKey.currentState;
            showNormalDialog(context, "ログアウト", "本当によろしいですか？", () async {
              state?.closeEndDrawer();
              Navigator.pop(context);
              await Authentication.signOut(context: context);
              context.go("/login");
            });
          }
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _closeButton(),
              const SizedBox(height: 10),
              _userInfo(),
            ],
          ),
          SizedBox(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _linkList(),
                    const SizedBox(height: 40),
                    _linkWidget(
                      const _Link(title: "利用規約", path: "terms", icon: Icon(Icons.open_in_new)),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _closeButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
          onPressed: () => {
            widget.scaffoldKey.currentState?.closeEndDrawer()
          },
          icon: const Icon(
            Icons.close,
            size: 35,
          )
      ),
    );
  }

  Widget _userInfo() {
    if (FirebaseAuth.instance.currentUser == null) {
      context.go("/login");
      return Container();
    }

    User user = FirebaseAuth.instance.currentUser!;
    return InkWell(
      onTap: () {
        widget.scaffoldKey.currentState?.closeEndDrawer();
        context.go("/home/user");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(90, 152, 152, 152),
                  spreadRadius: 10,
                  blurRadius: 20,
                  offset: Offset(1, 1)
              )
            ]
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                    user.displayName ?? "",
                    style: const TextStyle(
                        fontSize: 20
                    ),
                    overflow: TextOverflow.ellipsis
                ),
              ),
              const SizedBox(width: 20),
              user.photoURL != null ?
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  user.photoURL!,
                  width: 50,
                  height: 50,
                ),
              ) : const Icon(
                Icons.account_circle,
                size: 70,
              ),
              const SizedBox(width: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _links.length,
        itemBuilder: (context, index) {
          return _linkWidget(_links[index]);
        }
    );
  }

  Widget _linkWidget(_Link link) {
    return TextButton(
        onPressed: link.onTaped ?? () {
          widget.scaffoldKey.currentState?.closeEndDrawer();
          context.go(link.path);
        },
        style: TextButton.styleFrom(
          alignment: Alignment.centerRight,
          minimumSize: const Size(double.infinity, 10),
          textStyle: const TextStyle(
              fontSize: 20
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(link.title),
              const SizedBox(width: 10),
              if (link.icon != null) link.icon!,
            ],
          ),
        )
    );
  }
}

class _Link {
  final String title;
  final String path;
  final Widget? icon;
  final VoidCallback? onTaped;

  const _Link({
    required this.title,
    required this.path,
    this.icon,
    this.onTaped,
  });
}