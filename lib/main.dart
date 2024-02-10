import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home_layout(),
      debugShowCheckedModeBanner: false,
    );
  }
  // This widget is the root of your application.

}