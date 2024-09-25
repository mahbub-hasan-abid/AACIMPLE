import 'dart:io';

import 'package:aacimple/models/database_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MessageDetailsPage extends StatefulWidget {
  final DatabaseModel message;

  const MessageDetailsPage({required this.message});

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              SizedBox(
                height: 100,
                width: 100,
                child: Image.file(
                  File(widget.message.messageImage),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),

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
                widget.message.messageText,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),

              const Text('---'),
              Text(widget.message.messageSound),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer
                          .play(DeviceFileSource(widget.message.messageSound));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(isPlaying ? 'Stop Audio' : 'Play Audio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
