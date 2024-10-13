import 'package:aacimple/common/responsive.dart';
import 'package:aacimple/constant.dart';
import 'package:aacimple/models/home_screen_button_model.dart';
import 'package:aacimple/views/acrivity_page.dart';
import 'package:aacimple/views/create_new_message_page.dart';
import 'package:aacimple/views/database_page.dart';
import 'package:aacimple/views/registration_page.dart';
import 'package:aacimple/views/settings_pages.dart';
import 'package:aacimple/views/utils/home_button_cointainer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _showExitDialog(BuildContext context) async {
      final double screenWidth = MediaQuery.of(context).size.width;
      final double screenHeight = MediaQuery.of(context).size.height;

      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Exit Application',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: screenWidth * 0.03, // Responsive font size
              ),
            ),
            content: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.05), // Responsive vertical padding
              child: Text(
                'Are you sure you want to exit?',
                style: TextStyle(
                    fontSize: screenWidth * 0.02), // Responsive font size
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: screenWidth * 0.02, // Responsive font size
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  SystemNavigator.pop(); // Exit the app
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: screenWidth * 0.02, // Responsive font size
                  ),
                ),
              ),
            ],
            // Add padding around the content of the dialog
            contentPadding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.04,
            ),
          );
        },
      );
    }

    // Define layout based on screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int columns = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);
    double containerWidth = screenWidth / columns - 20;
    double containerHeight = containerWidth * 0.6;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First Row
                  Flexible(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => GeneralSettingsPage());
                          },
                          child: HomeButtonContainer(
                            homeButtonModel: HomeButtonModel(
                              icon: const Icon(Icons.settings),
                              label: "Settings",
                            ),
                            containerWidth: containerWidth,
                            containerHeight: containerHeight,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => RegistratationPage());
                          },
                          child: HomeButtonContainer(
                            homeButtonModel: HomeButtonModel(
                              icon: const Icon(Icons.app_registration),
                              label: "Registration",
                            ),
                            containerWidth: containerWidth,
                            containerHeight: containerHeight,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => MessageInputPage());
                          },
                          child: HomeButtonContainer(
                            homeButtonModel: HomeButtonModel(
                              icon: const Icon(Icons.message_rounded),
                              label: "Create Message",
                            ),
                            containerWidth: containerWidth,
                            containerHeight: containerHeight,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => DatabaseManagementPage());
                          },
                          child: HomeButtonContainer(
                            homeButtonModel: HomeButtonModel(
                              icon: const Icon(Icons.data_saver_off_outlined),
                              label: "Database",
                            ),
                            containerWidth: containerWidth,
                            containerHeight: containerHeight,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ActivityPage());
                          },
                          child: HomeButtonContainer(
                            homeButtonModel: HomeButtonModel(
                              icon: const Icon(Icons.attractions_rounded),
                              label: "Activities",
                            ),
                            containerWidth: containerWidth,
                            containerHeight: containerHeight,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showExitDialog(
                                context); // Show exit dialog correctly
                          },
                          child: HomeButtonContainer(
                            homeButtonModel: HomeButtonModel(
                              icon: const Icon(Icons.exit_to_app),
                              label: "Exit",
                            ),
                            containerWidth: containerWidth,
                            containerHeight: containerHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
