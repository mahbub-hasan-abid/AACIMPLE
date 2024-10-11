import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:aacimple/models/database_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ActivityMessagePresentationPage extends StatefulWidget {
  final int totalImage;
  final int rowNumber;
  final int columnNumber;

  const ActivityMessagePresentationPage({
    Key? key,
    required this.totalImage,
    required this.rowNumber,
    required this.columnNumber,
  }) : super(key: key);

  @override
  _ActivityMessagePresentationPageState createState() =>
      _ActivityMessagePresentationPageState();
}

class _ActivityMessagePresentationPageState
    extends State<ActivityMessagePresentationPage> {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
          isPresentationRunning
              ? IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: stopPresentation,
                )
              : IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: startPresentation,
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

        List<DatabaseModel?> messages =
            List.generate(widget.totalImage, (index) {
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
                  SizedBox(
                    height: screenHeight * .6,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.columnNumber,
                        mainAxisSpacing:
                            screenHeight * 0.005, // 1% of screen height
                        crossAxisSpacing:
                            screenWidth * 0.005, // 1% of screen width
                        childAspectRatio: (screenWidth / widget.columnNumber) /
                            (screenHeight * 0.6 / widget.rowNumber),
                      ),
                      itemCount: widget.rowNumber * widget.columnNumber,
                      itemBuilder: (context, index) {
                        DatabaseModel? message = messages[index];
                        if (message != null) {
                          return Center(
                            child: GestureDetector(
                              onTap: () async {
                                if (settingsController.listenToSound.value) {
                                  if (isPlaying) {
                                    await audioPlayer.stop();
                                    setState(() {
                                      isPlaying = false;
                                    });
                                  } else {
                                    await audioPlayer.play(
                                        DeviceFileSource(message.messageSound));
                                    setState(() {
                                      isPlaying = true;
                                    });
                                  }
                                }
                              },
                              child: _buildImageContainer(
                                message,
                                screenWidth,
                                screenHeight,
                              ),
                            ),
                          );
                        } else {
                          return Container(); // Empty space for null items
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: previousMessage,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(screenWidth * 0.3, 50), // Responsive width
                          backgroundColor:
                              Theme.of(context).primaryColor, // Theme color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: togglePresentation,
                        child: Text(
                          isPresentationRunning
                              ? 'Stop Presentation'
                              : 'Start Presentation',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: nextMessage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImageContainer(
      DatabaseModel message, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.all(screenHeight * 0.01), // 1% margin
      decoration: BoxDecoration(
        color: settingsController.backgroundColor.value,
        borderRadius:
            BorderRadius.circular(screenHeight * 0.02), // 2% corner radius
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (settingsController.showPictures.value)
              SizedBox(
                height: widget.rowNumber == 2
                    ? screenHeight * 0.15
                    : screenHeight * 0.4,
                child: Image.file(
                  File(message.messageImage),
                  fit: BoxFit.scaleDown,
                ),
              ),
            if (settingsController.showText.value)
              Padding(
                padding: EdgeInsets.all(screenHeight * 0.01),
                child: Text(
                  message.messageText,
                  style: TextStyle(
                    color: settingsController.fontColor.value,
                    fontSize: settingsController.fontSize.value,
                    fontFamily: settingsController.fontFamily.value,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void nextMessage() {
    setState(() {
      if (currentIndex + widget.totalImage <
          controller.mainHiveDatabaseMessages.length) {
        currentIndex += widget.totalImage;
      }
    });
  }

  void previousMessage() {
    setState(() {
      if (currentIndex - widget.totalImage >= 0) {
        currentIndex -= widget.totalImage;
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
          if (currentIndex + widget.totalImage <
              controller.mainHiveDatabaseMessages.length) {
            setState(() {
              currentIndex += widget.totalImage;
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
