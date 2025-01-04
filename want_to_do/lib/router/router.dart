import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:want_to_do/feature/todo/ui/home.dart';

import '../feature/app_base/ui/app_base.dart';
import '../feature/login/ui/login.dart';


final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, child) {
          return AppBaseWidget(
              body: child,
              canBack: state.fullPath != '/home' && state.fullPath != '/login',
              isGuestPage: state.fullPath == '/login'
          );
        },
        branches: [
          StatefulShellBranch(
              navigatorKey: _sectionNavigatorKey,
              routes: [
                GoRoute(
                    path: '/',
                    redirect: (BuildContext context, GoRouterState state) {
                      if (FirebaseAuth.instance.currentUser == null) {
                        return '/login';
                      } else {
                        return '/home';
                      }
                    }
                ),
                GoRoute(
                    path: '/home',
                    builder: (BuildContext context, GoRouterState state) {
                      return TodoListPage();
                    },
                    routes: [
                    ]
                ),
                GoRoute(
                  path: '/login',
                  builder: (BuildContext context, GoRouterState state) {
                    return const LoginPage();
                  },
                )
              ]
          )
        ]
    ),
  ],
);