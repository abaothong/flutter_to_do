import 'package:flutter/material.dart';
import 'package:todo/constant/router_constant.dart';
import 'package:todo/page/todo/todo_detail/todo_detail_page.dart';
import 'package:todo/page/todo/todo_listing/todo_listing_page.dart';

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case todoListingRouter:
        return MaterialPageRoute(
          builder: (_) => TodoListingPage(),
          settings: settings,
        );
        break;
      case todoDetailRouter:
        return MaterialPageRoute(
          builder: (_) => TodoDetailPage(settings.arguments),
          settings: settings,

        );
        break;
      default:
        return MaterialPageRoute(
          builder: (_) => TodoListingPage(),
          settings: settings,
        );
    }
  }
}
