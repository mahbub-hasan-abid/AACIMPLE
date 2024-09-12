import 'package:aacimple/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //SplashScreenController splashController = Get.put(SplashScreenController());

    return Scaffold(
      body: Center(
          child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.5, end: 1.5),
        duration: Duration(seconds: 3),
        curve: Curves.easeInOutCirc,
        builder: (context, double scale, child) {
          return Transform.scale(
            scale: scale,
            child: const Text(
              'Welcome to MyApp',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          );
        },
        onEnd: () {
          Get.off(HomePage());
        },
      )),
    );
  }
}
