library routes;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:eyespace/pages/auth_page.dart';
import 'package:eyespace/pages/loading_page.dart';
import 'package:eyespace/pages/register_page.dart';
import 'package:eyespace/pages/home_page.dart';
import 'models/app_state.dart';
import 'package:eyespace/pages/update_page.dart';
import 'package:eyespace/pages/chat_page.dart';

Map<String, WidgetBuilder> getRoutes(context, store) {
  return {
    '/': (BuildContext context) => new StoreBuilder<AppState>(
          builder: (context, store) {
            return HomePage('Eyespace');
          },
        ),
    '/chat': (BuildContext context) => new StoreBuilder<AppState>(
          builder: (context, store) {
            return ChatPage('Chat');
          },
        ),
    '/update': (BuildContext context) => new StoreBuilder<AppState>(
          builder: (context, store) {
            return UpdatePage('Update Details');
          },
        ),
    '/register': (BuildContext context) => new StoreBuilder<AppState>(
          builder: (context, store) {
            return RegisterPage('Registration');
          },
        ),
    '/login': (BuildContext context) => new StoreBuilder<AppState>(
          builder: (context, store) {
            return AuthPage();
          },
        ),
    '/loading': (BuildContext context) => new StoreBuilder<AppState>(
          builder: (context, store) {
            return LoadingPage();
          },
        ),
  };
}
