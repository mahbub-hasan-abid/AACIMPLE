import 'dart:io';
import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/models/database_model.dart';
import 'package:aacimple/views/create_new_message_page.dart';
import 'package:aacimple/views/message_update_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for state management

class MessageDetailsPage extends StatefulWidget {
  final DatabaseModel message;
  int index;
  String fromMainOrOld;

  MessageDetailsPage(
      {required this.message,
      required this.index,
      required this.fromMainOrOld});

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  final DatabaseController _databaseController = Get.put(DatabaseController());
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
    super.dispose();
  }

  void _deleteMessage() {
    showCustomDialog(
      context: context,
      title: 'Delete Message',
      contentText: "You will delete this message. Are you sure?",
      onConfirm: () {
        _databaseController.deleteMessageFromMain(widget.index);
        Get.back(); // Close the dialog
        Get.back(); // Go back to the previous screen
        Get.snackbar(
            'Success', 'Message deleted and saved in OldMessages Database.');
      },
      onCancel: () => Get.back(),
      confirmText: "YES",
      cancelText: "NO",
    );
  }

  void _editMessage(DatabaseModel msg) {
    showCustomDialog(
      context: context,
      title: 'Update Message',
      contentText: "Do you want to update this message?",
      onConfirm: () {
        Get.off(() => UpdateMessage(
              message: msg,
              index: widget.index,
            ));
      },
      onCancel: () => Get.back(),
      confirmText: "YES",
      cancelText: "NO",
    );
  }

  void _restoreMessage() {
    showCustomDialog(
      context: context,
      title: 'Restore Message',
      contentText: "Do you want to restore this message to the Main Database?",
      onConfirm: () {
        _databaseController.restoreMessageToMain(widget.index);
        Get.back(); // Close the dialog
        Get.back(); // Go back to the previous screen
        Get.snackbar('Success', 'Message restored to the Main Database.');
      },
      onCancel: () => Get.back(),
      confirmText: "YES",
      cancelText: "NO",
    );
  }

  void _saveNewMessage() {
    showCustomDialog(
      context: context,
      title: 'Create New Message',
      contentText: "Do you want to create a new message to the Main Database?",
      onConfirm: () {
        Get.off(() => MessageInputPage());
      },
      onCancel: () => Get.back(),
      confirmText: "YES",
      cancelText: "NO",
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes
    final double imageSize = screenWidth * 0.5; // 40% of screen width
    final double textSize = screenWidth * 0.02; // 4% of screen width
    final double buttonFontSize = screenWidth * 0.02; // 4% of screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // Left half: Image display
              Center(
                child: Expanded(
                  child: SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: Image.file(File(widget.message.messageImage),
                        fit: BoxFit.scaleDown),
                  ),
                ),
              ),

              // Right half: Message text and audio control
              Center(
                child: Expanded(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display message text
                            Text(
                              'Message Text : ${widget.message.messageText} ',
                              style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Code : ${widget.message.keyfieldCode} ',
                              style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16.0),

                            // Audio playback controls
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (isPlaying) {
                                  await audioPlayer.stop();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                } else {
                                  await audioPlayer.play(DeviceFileSource(
                                      widget.message.messageSound));
                                  setState(() {
                                    isPlaying = true;
                                  });
                                }
                              },
                              icon: Icon(
                                isPlaying ? Icons.stop : Icons.play_arrow,
                                size: buttonFontSize,
                              ),
                              label: Text(
                                isPlaying ? 'Stop Audio' : 'Play Audio',
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // White text color
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(200, 50)), // Uniform size
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 16.0)),
                                elevation:
                                    MaterialStateProperty.all<double>(5.0),
                              ),
                            ),
                            widget.fromMainOrOld == 'main'
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _editMessage(widget.message),
                                          child: Text(
                                            'Edit/Update',
                                            style: TextStyle(
                                                fontSize: buttonFontSize),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.orange),
                                            foregroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .white), // White text color
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(200,
                                                        50)), // Uniform size
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0)),
                                            elevation: MaterialStateProperty
                                                .all<double>(5.0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: _saveNewMessage,
                                          child: Text(
                                            'Create New',
                                            style: TextStyle(
                                                fontSize: buttonFontSize),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green),
                                            foregroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .white), // White text color
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(200,
                                                        50)), // Uniform size
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0)),
                                            elevation: MaterialStateProperty
                                                .all<double>(5.0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: _deleteMessage,
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: buttonFontSize),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                            foregroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .white), // White text color
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(200,
                                                        50)), // Uniform size
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsets>(
                                                EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0)),
                                            elevation: MaterialStateProperty
                                                .all<double>(5.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: _restoreMessage,
                                      child: Text(
                                        'Restore',
                                        style:
                                            TextStyle(fontSize: buttonFontSize),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors
                                                    .white), // White text color
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(200, 50)), // Uniform size
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 16.0)),
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                5.0),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      )),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String contentText,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
  required String confirmText,
  required String cancelText,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final double dialogPadding =
      screenWidth * 0.03; // Padding as 6% of screen width
  final double buttonFontSize =
      screenWidth * 0.035; // Font size relative to screen width

  Get.defaultDialog(
    title: title,
    titleStyle:
        TextStyle(fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
    content: Padding(
      padding: EdgeInsets.all(dialogPadding),
      child: Text(
        contentText,
        style: TextStyle(fontSize: buttonFontSize),
        textAlign: TextAlign.center,
      ),
    ),
    confirm: ElevatedButton(
      onPressed: onConfirm,
      child: Text(
        confirmText,
        style: TextStyle(fontSize: buttonFontSize, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Button background color
        minimumSize: Size(150, 50), // Minimum size for uniform buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    ),
    cancel: ElevatedButton(
      onPressed: onCancel,
      child: Text(
        cancelText,
        style: TextStyle(fontSize: buttonFontSize, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Button background color
        minimumSize: Size(150, 50), // Minimum size for uniform buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    ),
  );
}
