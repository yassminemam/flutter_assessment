import 'package:flutter/material.dart';
import 'package:flutter_assessment/feature/presentation/page/register/register_page.dart';
import 'package:go_router/go_router.dart';
import 'feature/presentation/page/login/login_page.dart';

const String registerRoute = 'register';
List<RouteBase> allRouts = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const LoginPage();
    },
    routes: <RouteBase>[
      GoRoute(
        path: registerRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
    ],
  ),
];
