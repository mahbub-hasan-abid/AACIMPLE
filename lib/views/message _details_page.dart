import 'package:aacimple/models/database_model.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MessageDetailsPage extends StatelessWidget {
  final MessageModel message;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image
            Expanded(
              child: Image.asset(
                message.messageImage,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.0),

            // Display message text
            Text(
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
            //           'assets/sounds/adelfi.mp3')); // Use audioPlayer
            //     },
            //     icon: Icon(Icons.play_arrow),
            //     label: Text('Play Audio'),
            //   ),
            // ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Play the audio when the button is clicked
                  // audioPlayer.play(AssetSource(
                  //     'assets/sounds/adelfi.mp3')); // Use audioPlayer

                  assetsAudioPlayer.open(
                    Audio("assets/sounds/adelfi.mp3"),
                  );
                },
                icon: Icon(Icons.play_arrow),
                label: Text('Play Audio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
