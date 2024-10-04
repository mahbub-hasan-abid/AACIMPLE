import 'package:aacimple/models/home_screen_button_model.dart';
import 'package:flutter/material.dart';

class HomeButtonContainer extends StatelessWidget {
  final HomeButtonModel homeButtonModel;
  final double containerWidth; // New parameter for width
  final double containerHeight; // New parameter for height

  HomeButtonContainer({
    super.key,
    required this.homeButtonModel,
    required this.containerWidth,
    required this.containerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth, // Use the received width
      height: containerHeight, // Use the received height
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF010080),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              homeButtonModel.icon.icon,
              size: containerWidth * 0.3, // Icon size based on the width
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                homeButtonModel.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      containerWidth * 0.10, // Text size based on the width
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
