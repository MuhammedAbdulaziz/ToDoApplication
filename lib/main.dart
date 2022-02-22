import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/layouts/home_layout.dart';
import 'package:todo_application/shared/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
        () {
          runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: HomeScreen(),
    );
  }
}

