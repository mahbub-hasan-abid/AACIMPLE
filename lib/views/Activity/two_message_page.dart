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
    // Get the size of the screen
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final boxHeight = (screenHeight / 2);
    final boxWidth = (screenWidth / 3);
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Dynamically calculate image size based on available width

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Message display row
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_left),
                            iconSize: 40,
                            onPressed: previousMessage,
                          ),
                          // First Image Container
                          Expanded(
                            child: Container(
                              width: boxWidth,
                              height: boxHeight,
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
                                  SizedBox(
                                    width: boxWidth,
                                    height: boxHeight * .85, // Keep it square
                                    child: Image.file(
                                      File(message1.messageImage),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  Text(message1.messageText),
                                ],
                              ),
                            ),
                          ),

                          // Second Image Container (if exists)
                          if (message2 != null)
                            Expanded(
                              child: Container(
                                height: boxHeight,
                                width: boxWidth,
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
                                    SizedBox(
                                      width: boxWidth,
                                      height: boxHeight * .85, // Keep it square
                                      child: Image.file(
                                        File(message2.messageImage),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    Text(message2.messageText),
                                  ],
                                ),
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.arrow_right),
                            iconSize: 40,
                            onPressed: nextMessage,
                          ),
                        ],
                      ),

                      // Navigation Buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: togglePresentation,
                      //       child: Text(isPresentationRunning
                      //           ? 'Stop Presentation'
                      //           : 'Start Presentation'),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20),

                      // Start/Stop Presentation Button
                    ],
                  ),
                ),
              );
            },
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
