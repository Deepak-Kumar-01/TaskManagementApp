import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(child: Text("WhatBytes",style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white // Use white for dark mode
          : Color(0xff191919), // Use black for light mode

      fontSize: 32,
      fontWeight: FontWeight.bold,
      // letterSpacing: MediaQuery.of(context).size.width * 0.04
      ),
      )),
    );
  }
}