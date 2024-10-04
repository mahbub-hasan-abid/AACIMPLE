import 'dart:async';
import 'dart:io';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThreeMessagePage extends StatefulWidget {
  @override
  _ThreeMessagePageState createState() => _ThreeMessagePageState();
}

class _ThreeMessagePageState extends State<ThreeMessagePage> {
  final DatabaseController controller = Get.put(DatabaseController());
  final SettingsController settingsController = Get.find<SettingsController>();

  int currentIndex = 0;
  Timer? _timer;
  bool isPresentationRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to the previous screen
            Get.back();
          },
        ),
        actions: [
          if (isPresentationRunning)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: stopPresentation,
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use constraints to get the available height and width
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Obx(() {
            if (controller.mainHiveDatabaseMessages.isEmpty) {
              return const Center(
                child: Text(
                  'No messages available',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            int secondIndex = currentIndex + 1;
            int thirdIndex = currentIndex + 2;
            bool hasSecondImage =
                secondIndex < controller.mainHiveDatabaseMessages.length;
            bool hasThirdImage =
                thirdIndex < controller.mainHiveDatabaseMessages.length;

            final message1 = controller.mainHiveDatabaseMessages[currentIndex];
            final message2 = hasSecondImage
                ? controller.mainHiveDatabaseMessages[secondIndex]
                : null;
            final message3 = hasThirdImage
                ? controller.mainHiveDatabaseMessages[thirdIndex]
                : null;

            double imageSize =
                screenWidth / 3 - 16; // Adjust image size dynamically

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // First Image Container
                        if (message1 != null)
                          buildImageContainer(message1, imageSize),

                        // Second Image Container (if exists)
                        if (message2 != null)
                          buildImageContainer(message2, imageSize),

                        // Third Image Container (if exists)
                        if (message3 != null)
                          buildImageContainer(message3, imageSize),
                      ],
                    ),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          iconSize: 40,
                          onPressed: previousMessage,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          iconSize: 40,
                          onPressed: nextMessage,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Start/Stop Presentation Button
                    ElevatedButton(
                      onPressed: togglePresentation,
                      child: Text(isPresentationRunning
                          ? 'Stop Presentation'
                          : 'Start Presentation'),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget buildImageContainer(message, double imageSize) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: Image.file(
                  File(message.messageImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message.messageText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextMessage() {
    setState(() {
      if (currentIndex + 3 < controller.mainHiveDatabaseMessages.length) {
        currentIndex += 3; // Increment by 3 to show next set of images
      }
    });
  }

  void previousMessage() {
    setState(() {
      if (currentIndex - 3 >= 0) {
        currentIndex -= 3; // Decrement by 3 to show previous set of images
      }
    });
  }

  void togglePresentation() {
    if (isPresentationRunning) {
      stopPresentation();
    } else {
      startPresentation();
    }
  }

  void startPresentation() {
    isPresentationRunning = true;
    setState(() {});

    // Start the presentation with the given duration
    _timer = Timer.periodic(
      Duration(
          seconds: settingsController.durationForPresentation.value.toInt()),
      (timer) {
        if (currentIndex + 3 < controller.mainHiveDatabaseMessages.length) {
          setState(() {
            currentIndex += 3; // Move to the next set of images
          });
        } else {
          stopPresentation(); // Stop when we reach the last message
        }
      },
    );
  }

  void stopPresentation() {
    isPresentationRunning = false;
    _timer?.cancel();
    _timer = null;
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
