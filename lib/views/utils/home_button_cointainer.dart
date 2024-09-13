import 'package:aacimple/models/home_screen_button_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeButtonContainer extends StatelessWidget {
  final HomeButtonModel homeButtonModel;

  HomeButtonContainer({
    super.key,
    required this.homeButtonModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .2,
      height: Get.height * .2,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF010080),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              homeButtonModel.icon.icon,
              size: Get.width * 0.05,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                homeButtonModel.label,
                style: TextStyle(
                  fontSize: Get.width * 0.02,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
