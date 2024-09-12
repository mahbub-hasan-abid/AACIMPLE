import 'package:aacimple/constant.dart';
import 'package:aacimple/models/home_screen_button_model.dart';
import 'package:flutter/material.dart';

class HomeButtonContainer extends StatelessWidget {
  final HomeButtonModel homeButtonModel; // Receiving HomeButtonModel data

  const HomeButtonContainer({super.key, required this.homeButtonModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          // width: width.value * 0.1,
          // height: width.value * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue[900],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                homeButtonModel.icon.icon,
                size: homeButtonModel.icon.size,
                color: Colors.white54,
              ),
              const SizedBox(height: 8),
              Text(
                homeButtonModel.label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
    );
  }
}
