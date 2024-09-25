import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class SoundSelector extends StatefulWidget {
  @override
  _SoundSelectorState createState() => _SoundSelectorState();
}

class _SoundSelectorState extends State<SoundSelector> {
  FlutterSoundRecorder? _recorder;
  AudioPlayer _audioPlayer = AudioPlayer();
  String? _filePath;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _openRecorder();
  }

  // Initialize the recorder with permissions
  Future<void> _openRecorder() async {
    try {
      // Request microphone permission
      var status = await Permission.microphone.request();

      if (status.isGranted) {
        await _recorder!.openRecorder();
      } else {
        print(
            "Microphone permission not granted. Please allow access in settings.");
        throw RecordingPermissionException('Microphone permission not granted');
      }
    } catch (e) {
      print("Error opening recorder: $e");
      throw e; // Rethrow the error if necessary
    }
  }

  // Record audio and save it locally
  Future<void> _recordSound() async {
    try {
      if (!_isRecording) {
        // Request microphone permission
        var status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          throw RecordingPermissionException(
              'Microphone permission not granted');
        }

        // Check if the recorder is properly initialized
        if (_recorder!.isStopped) {
          // Prepare temporary directory for the recording file
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = '${tempDir.path}/recorded_audio.aac';

          // Start recording and save the file
          await _recorder!.startRecorder(
            toFile: tempPath,
            codec: Codec.aacMP4, // Correct codec for AAC format
          );

          setState(() {
            _isRecording = true;
            _filePath = tempPath;
          });

          print("Recording started, saving to: $tempPath");
        } else {
          print("Recorder not initialized properly.");
        }
      } else {
        // Stop recording
        await _recorder!.stopRecorder();
        setState(() {
          _isRecording = false;
        });

        print("Recording stopped, saved at: $_filePath");
      }
    } catch (e) {
      print("Error during recording: $e");
    }
  }

  // Pick audio from local storage
  Future<void> _pickSoundFromLocal() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  // Play the selected audio
  Future<void> _playAudio() async {
    if (_filePath != null) {
      await _audioPlayer.play(DeviceFileSource(_filePath!));
    } else {
      print('No audio file selected');
    }
  }

  // Play audio from the internet
  Future<void> _playAudioFromUrl(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select and Play Audio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Button to record a new sound
            ElevatedButton(
              onPressed: _recordSound,
              child: Text(_isRecording ? 'Stop Recording' : 'Record a Sound'),
            ),

            // Button to pick a sound from local storage
            ElevatedButton(
              onPressed: _pickSoundFromLocal,
              child: const Text('Pick Sound from Local Storage'),
            ),

            // Input for entering URL to play sound from the internet
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Enter sound URL',
                border: OutlineInputBorder(),
              ),
            ),

            // Button to play audio from URL
            ElevatedButton(
              onPressed: () => _playAudioFromUrl(urlController.text),
              child: const Text('Play Audio from URL'),
            ),

            // Button to play the selected or recorded audio
            ElevatedButton(
              onPressed: _playAudio,
              child: const Text('Play Selected Sound'),
            ),
          ],
        ),
      ),
    );
  }
}
