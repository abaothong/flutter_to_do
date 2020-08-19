import 'package:flutter/material.dart';
import 'package:todo/constant/router_constant.dart';
import 'package:todo/page/todo/todo_listing/todo_listing_page.dart';
import 'package:todo/router/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Router().generateRoute,
      title: "Todo",
      theme: ThemeData(
          primaryColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
          )),
      initialRoute: todoListingRouter,
//      home: TodoListingPage(),
    );
  }
}

