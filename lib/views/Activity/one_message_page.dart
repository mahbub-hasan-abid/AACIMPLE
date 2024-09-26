import 'dart:async';
import 'dart:io';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OneMessagePage extends StatefulWidget {
  @override
  _OneMessagePageState createState() => _OneMessagePageState();
}

class _OneMessagePageState extends State<OneMessagePage> {
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

        final message = controller.mainHiveDatabaseMessages[currentIndex];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Message Image
                  Container(
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
                              //fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(message.messageText),
                        )
                      ],
                    ),
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
      if (currentIndex < controller.mainHiveDatabaseMessages.length - 1) {
        currentIndex++;
      }
    });
  }

  void previousMessage() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
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
        if (currentIndex < controller.mainHiveDatabaseMessages.length - 1) {
          setState(() {
            currentIndex++;
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
