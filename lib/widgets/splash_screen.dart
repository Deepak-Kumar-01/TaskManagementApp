import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: SizedBox.expand(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Image.asset("assets/welcome_img.png"),
                  Text(
                    "Get things done.",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Your tasks, your timeline, your control.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
                color: const Color(0xff666af6), shape: BoxShape.circle),
          ),
        )
      ],
    ));
  }
}
