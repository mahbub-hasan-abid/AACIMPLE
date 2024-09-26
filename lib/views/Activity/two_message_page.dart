import 'dart:async';
import 'dart:io';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TwoMessagePage extends StatefulWidget {
  @override
  _TwoMessagePageState createState() => _TwoMessagePageState();
}

class _TwoMessagePageState extends State<TwoMessagePage> {
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
        bool hasSecondImage =
            secondIndex < controller.mainHiveDatabaseMessages.length;

        final message1 = controller.mainHiveDatabaseMessages[currentIndex];
        final message2 = hasSecondImage
            ? controller.mainHiveDatabaseMessages[secondIndex]
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
                      // First Image Container
                      Expanded(
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
                                  width: 150,
                                  height: 150,
                                  child: Image.file(
                                    File(message1.messageImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(message1.messageText),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Second Image Container (if exists)
                      if (message2 != null)
                        Expanded(
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
                                    width: 150,
                                    height: 150,
                                    child: Image.file(
                                      File(message2.messageImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message2!.messageText),
                                ),
                              ],
                            ),
                          ),
                        ),
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
          ),
        );
      }),
    );
  }

  void nextMessage() {
    setState(() {
      if (currentIndex + 2 < controller.mainHiveDatabaseMessages.length) {
        currentIndex += 2; // Increment by 2 to show next pair
      }
    });
  }

  void previousMessage() {
    setState(() {
      if (currentIndex - 2 >= 0) {
        currentIndex -= 2; // Decrement by 2 to show previous pair
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
        if (currentIndex + 2 < controller.mainHiveDatabaseMessages.length) {
          setState(() {
            currentIndex += 2; // Move to the next pair of images
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
