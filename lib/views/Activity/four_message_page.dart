import 'dart:async';
import 'dart:io';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FourMessagePage extends StatefulWidget {
  @override
  _FourMessagePageState createState() => _FourMessagePageState();
}

class _FourMessagePageState extends State<FourMessagePage> {
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
      body: Obx(() {
        if (controller.mainHiveDatabaseMessages.isEmpty) {
          return const Center(
            child: Text(
              'No messages available',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Ensure we don't exceed the list length
        int secondIndex = currentIndex + 1;
        int thirdIndex = currentIndex + 2;
        int fourthIndex = currentIndex + 3;

        bool hasSecondImage =
            secondIndex < controller.mainHiveDatabaseMessages.length;
        bool hasThirdImage =
            thirdIndex < controller.mainHiveDatabaseMessages.length;
        bool hasFourthImage =
            fourthIndex < controller.mainHiveDatabaseMessages.length;

        final message1 = controller.mainHiveDatabaseMessages[currentIndex];
        final message2 = hasSecondImage
            ? controller.mainHiveDatabaseMessages[secondIndex]
            : null;
        final message3 = hasThirdImage
            ? controller.mainHiveDatabaseMessages[thirdIndex]
            : null;
        final message4 = hasFourthImage
            ? controller.mainHiveDatabaseMessages[fourthIndex]
            : null;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildImageContainer(message1),
                      ),
                      if (message2 != null)
                        Expanded(
                          child: _buildImageContainer(message2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      if (message3 != null)
                        Expanded(
                          child: _buildImageContainer(message3),
                        ),
                      if (message4 != null)
                        Expanded(
                          child: _buildImageContainer(message4),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

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
          ),
        );
      }),
    );
  }

  Widget _buildImageContainer(message) {
    return Container(
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
              width: 150,
              height: 150,
              child: Image.file(
                File(message.messageImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message.messageText),
          ),
        ],
      ),
    );
  }

  void nextMessage() {
    setState(() {
      if (currentIndex + 4 < controller.mainHiveDatabaseMessages.length) {
        currentIndex += 4; // Increment by 4 to show next four images
      }
    });
  }

  void previousMessage() {
    setState(() {
      if (currentIndex - 4 >= 0) {
        currentIndex -= 4; // Decrement by 4 to show previous four images
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
        if (currentIndex + 4 < controller.mainHiveDatabaseMessages.length) {
          setState(() {
            currentIndex += 4; // Move to the next set of four images
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
