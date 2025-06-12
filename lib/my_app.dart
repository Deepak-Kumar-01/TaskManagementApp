import 'package:flutter/material.dart';
import 'package:taskmanagementapp/components/home/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home() ,
    );
  }
}
