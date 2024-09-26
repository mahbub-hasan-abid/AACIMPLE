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

  // Function to delete the message and save to OldMessages Database
  void _deleteMessage() {
    Get.defaultDialog(
      title: 'Delete Message',
      content: const Text("You will delete this message. Are you sure?"),
      confirm: ElevatedButton(
        onPressed: () {
          _databaseController.deleteMessageFromMain(widget.index);

          Get.back();
          Get.back(); // Close dialog
          Get.snackbar(
              'Success', 'Message deleted and saved in OldMessages Database.');
        },
        child: const Text("YES"),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("NO"),
      ),
    );
  }

  void _editMessage(DatabaseModel msg) {
    Get.defaultDialog(
      title: 'Update Message',
      content: const Text("Do you want to update this message?"),
      confirm: ElevatedButton(
        onPressed: () {
          Get.off(() => UpdateMessage(
                message: msg,
                index: widget.index,
              ));
          // Logic to update message in the Main Database
          // _databaseController.updateMessageInMain(widget.message);
          //Get.back(); // Close dialog
          // Get.snackbar('Success', 'Message updated successfully.');
        },
        child: const Text("YES"),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("NO"),
      ),
    );
  }

  void _restoreMessage() {
    Get.defaultDialog(
      title: 'Restore Message',
      content: const Text(
          "Do you want to restore this message to the Main Database?"),
      confirm: ElevatedButton(
        onPressed: () {
          // DatabaseModel restoredMessage = widget.message.copyWith(
          //   keyfieldCode: DatabaseModel.generateKeyfieldCode(
          //       _databaseController.mainHiveDatabase.value.length),
          // );
          _databaseController.restoreMessageToMain(widget.index);
          Get.back();
          Get.back(); // Close dialog
          // Close dialog
          Get.snackbar('Success', 'Message restored to the Main Database.');
        },
        child: const Text("YES"),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("NO"),
      ),
    );
  }

  // Function to save a new message to Main Database
  void _saveNewMessage() {
    Get.defaultDialog(
      title: 'Create New Message',
      content: const Text(
          "Do you want to create a new message to the Main Database?"),
      confirm: ElevatedButton(
        onPressed: () {
          Get.off(() => MessageInputPage());
        },
        child: const Text("YES"),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("NO"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  // Left half: Image display
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(File(widget.message.messageImage),
                          fit: BoxFit.scaleDown),
                    ),
                  ),

                  // Right half: Message text and audio control
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display message text
                          const Text(
                            'Message Text:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            widget.message.keyfieldCode,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            widget.message.messageText,
                            style: const TextStyle(fontSize: 16.0),
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
                            icon:
                                Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                            label:
                                Text(isPlaying ? 'Stop Audio' : 'Play Audio'),
                          ),
                          widget.fromMainOrOld == 'main'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _editMessage(widget.message),
                                      child: const Text('Edit/Update'),
                                    ),
                                    ElevatedButton(
                                      onPressed: _saveNewMessage,
                                      child: const Text('Create New'),
                                    ),
                                    ElevatedButton(
                                      onPressed: _deleteMessage,
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                )
                              : ElevatedButton(
                                  onPressed: _restoreMessage,
                                  child: const Text('Restore'),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom: Action buttons in a row
          ],
        ),
      ),
    );
  }
}
