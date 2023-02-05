import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'BlocOserver.dart';
import 'layout/home_layout.dart';

main(){
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
