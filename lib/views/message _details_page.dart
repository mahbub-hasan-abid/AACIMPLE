import 'dart:io';

import 'package:aacimple/models/database_model.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageDetailsPage extends StatelessWidget {
  final DatabaseModel message;

  MessageDetailsPage({required this.message});

  @override
  Widget build(BuildContext context) {
    // Initialize audio player
    final AudioPlayer audioPlayer = AudioPlayer();
    final assetsAudioPlayer = AssetsAudioPlayer();
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the image

              const SizedBox(height: 16.0),

              SizedBox(
                height: 100,
                width: 100,
                child: Image.file(
                  File(message.messageImage),
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
                message.messageText, // Display the message text
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),

              // Audio play button
              // Center(
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       // Play the audio when the button is clicked
              //       audioPlayer.play(AssetSource(
              //           'assets/audios/adelfi.mp3')); // Use audioPlayer
              //     },
              //     icon: Icon(Icons.play_arrow),
              //     label: Text('Play Audio'),
              //   ),
              // ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Play the audio when the button is clicked
                    audioPlayer.setSource(AssetSource(
                        'assets/audios/adelfi.mp3')); // Use audioPlayer
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text('Play Audio'),
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Play the audio when the button is clicked
                    // audioPlayer.play(AssetSource(
                    //     'assets/sounds/adelfi.mp3')); // Use audioPlayer

                    assetsAudioPlayer.open(
                      Audio(message.messageSound),
                    );
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text('Play Audio'),
                ),
              ),
              Text(message.messageSound),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Play the audio when the button is clicked
                    // audioPlayer.play(AssetSource(
                    //     'assets/sounds/adelfi.mp3')); // Use audioPlayer

                    assetsAudioPlayer.open(
                      Audio('assets/audios/adelfi.mp3'),
                    );
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text('Play Audio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
