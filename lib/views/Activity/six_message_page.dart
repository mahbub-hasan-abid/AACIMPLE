import 'dart:async';
import 'dart:io';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SixMessagePage extends StatefulWidget {
  @override
  _SixMessagePageState createState() => _SixMessagePageState();
}

class _SixMessagePageState extends State<SixMessagePage> {
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
        int fifthIndex = currentIndex + 4;
        int sixthIndex = currentIndex + 5;

        bool hasSecondImage =
            secondIndex < controller.mainHiveDatabaseMessages.length;
        bool hasThirdImage =
            thirdIndex < controller.mainHiveDatabaseMessages.length;
        bool hasFourthImage =
            fourthIndex < controller.mainHiveDatabaseMessages.length;
        bool hasFifthImage =
            fifthIndex < controller.mainHiveDatabaseMessages.length;
        bool hasSixthImage =
            sixthIndex < controller.mainHiveDatabaseMessages.length;

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
        final message5 = hasFifthImage
            ? controller.mainHiveDatabaseMessages[fifthIndex]
            : null;
        final message6 = hasSixthImage
            ? controller.mainHiveDatabaseMessages[sixthIndex]
            : null;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Row: 3 Images
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
                                  width: 100,
                                  height: 100,
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
                                    width: 100,
                                    height: 100,
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

                      // Third Image Container (if exists)
                      if (message3 != null)
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
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      File(message3.messageImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message3!.messageText),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Second Row: 3 Images
                  Row(
                    children: [
                      // Fourth Image Container (if exists)
                      if (message4 != null)
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
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      File(message4!.messageImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message4!.messageText),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Fifth Image Container (if exists)
                      if (message5 != null)
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
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      File(message5!.messageImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message5!.messageText),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Sixth Image Container (if exists)
                      if (message6 != null)
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
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      File(message6!.messageImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(message6!.messageText),
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
      if (currentIndex + 6 < controller.mainHiveDatabaseMessages.length) {
        currentIndex += 6; // Show the next set of 6 messages
      }
    });
  }

  void previousMessage() {
    setState(() {
      if (currentIndex - 6 >= 0) {
        currentIndex -= 6; // Show the previous set of 6 messages
      }
    });
  }

  void togglePresentation() {
    setState(() {
      if (isPresentationRunning) {
        stopPresentation();
      } else {
        startPresentation();
      }
    });
  }

  void startPresentation() {
    isPresentationRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      nextMessage();
    });
  }

  void stopPresentation() {
    isPresentationRunning = false;
    _timer?.cancel();
  }
}
