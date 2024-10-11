import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:audioplayers/audioplayers.dart';
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
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final imageSize = screenWidth * 0.15; // 40% of screen width
    final buttonSize = screenWidth * 0.05; // 10% of screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
                      color: settingsController.backgroundColor.value,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        if (settingsController.listenToSound.value) {
                          if (isPlaying) {
                            await audioPlayer.stop();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await audioPlayer
                                .play(DeviceFileSource(message.messageSound));
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        }
                      },
                      child: Column(
                        children: [
                          if (settingsController.showPictures.value)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: imageSize,
                                height: imageSize,
                                child: Image.file(
                                  File(message.messageImage),
                                ),
                              ),
                            ),
                          if (settingsController.showText.value)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                message.messageText,
                                style: TextStyle(
                                  color: settingsController.fontColor.value,
                                  fontSize: settingsController.fontSize.value,
                                  fontFamily:
                                      settingsController.fontFamily.value,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        iconSize: buttonSize,
                        onPressed: previousMessage,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        iconSize: buttonSize,
                        onPressed: nextMessage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Start/Stop Presentation Button styled with theme
                  ElevatedButton(
                    onPressed: togglePresentation,
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(screenWidth * 0.3, 50), // Responsive width
                      backgroundColor:
                          Theme.of(context).primaryColor, // Theme color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      isPresentationRunning
                          ? 'Stop Presentation'
                          : 'Start Presentation',
                      style: TextStyle(
                          fontSize: screenWidth * 0.03, color: Colors.white),
                    ),
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

    _timer = Timer.periodic(
      Duration(
          seconds: settingsController.durationForPresentation.value.toInt()),
      (timer) {
        if (settingsController.randomize.value) {
          final random = Random();
          setState(() {
            currentIndex =
                random.nextInt(controller.mainHiveDatabaseMessages.length);
          });
        } else {
          if (currentIndex < controller.mainHiveDatabaseMessages.length - 1) {
            setState(() {
              currentIndex++;
            });
          } else {
            stopPresentation();
          }
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
}
