import 'package:aacimple/models/home_screen_button_model.dart';
import 'package:aacimple/views/utils/home_button_cointainer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          color: Colors.white,
          child: Center(
            child: GridView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1, // Ensures uniform sizing
              ),
              children: [
                HomeButtonContainer(
                  homeButtonModel: HomeButtonModel(
                    icon: const Icon(Icons.settings),
                    label: "Settings",
                  ),
                ),
                HomeButtonContainer(
                  homeButtonModel: HomeButtonModel(
                    icon: const Icon(Icons.settings),
                    label: "Settings",
                  ),
                ),
                HomeButtonContainer(
                  homeButtonModel: HomeButtonModel(
                    icon: const Icon(Icons.settings),
                    label: "Settings",
                  ),
                ),
                HomeButtonContainer(
                  homeButtonModel: HomeButtonModel(
                    icon: const Icon(Icons.settings),
                    label: "Settings",
                  ),
                ),
                HomeButtonContainer(
                  homeButtonModel: HomeButtonModel(
                    icon: const Icon(Icons.settings),
                    label: "Settings",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
