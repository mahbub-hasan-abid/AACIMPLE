import 'dart:async';
import 'dart:io';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:aacimple/models/database_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TwelveMessagePage extends StatefulWidget {
  @override
  _TwelveMessagePageState createState() => _TwelveMessagePageState();
}

class _TwelveMessagePageState extends State<TwelveMessagePage> {
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

        // Ensure we don't exceed the list length for 12 images
        List<DatabaseModel?> messages = List.generate(12, (index) {
          int messageIndex = currentIndex + index;
          return messageIndex < controller.mainHiveDatabaseMessages.length
              ? controller.mainHiveDatabaseMessages[messageIndex]
              : null;
        });

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int row = 0; row < 2; row++) // Two rows
                    Row(
                      children: [
                        for (int col = 0; col < 6; col++) // Six images per row
                          if (messages[row * 6 + col] !=
                              null) // Check if message exists
                            Expanded(
                              child: _buildImageContainer(
                                  messages[row * 6 + col]!),
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
      if (currentIndex + 12 < controller.mainHiveDatabaseMessages.length) {
        currentIndex += 12; // Increment by 12 to show next twelve images
      }
    });
  }

  void previousMessage() {
    setState(() {
      if (currentIndex - 12 >= 0) {
        currentIndex -= 12; // Decrement by 12 to show previous twelve images
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
        if (currentIndex + 12 < controller.mainHiveDatabaseMessages.length) {
          setState(() {
            currentIndex += 12; // Move to the next set of twelve images
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
