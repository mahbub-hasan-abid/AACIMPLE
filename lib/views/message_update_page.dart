import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/models/database_model.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:file_picker/file_picker.dart'; // For audio file picking
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart'; // For working with files

class UpdateMessage extends StatefulWidget {
  final DatabaseModel message;
  final int index;

  UpdateMessage({
    super.key,
    required this.message,
    required this.index,
  });
  @override
  _UpdateMessageState createState() => _UpdateMessageState();
}

class _UpdateMessageState extends State<UpdateMessage> {
  final DatabaseController _databaseController = Get.put(DatabaseController());

  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController();
  final TextEditingController _fontColorController = TextEditingController();
  final TextEditingController _backgroundColorController =
      TextEditingController();
  TextEditingController urlControllerImage = TextEditingController();

  TextEditingController urlControllerAudio = TextEditingController();
  String? _selectedImage;
  String? _selectedSound;
  Language? _selectedLanguage = Language.English;
  bool _isPictureVisible = true;
  bool _isTextVisible = true;
  bool _isSoundEnabled = true;
  FromWhere? _fromWhere = FromWhere.user;
  bool isImageFromInternet = false;
  bool isAudioFromInternet = false;
  FlutterSoundRecorder? _recorder;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isImageUpdated = false;
  bool isSoundUpdated = false;

  bool _isRecording = false;
  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _messageTextController.text = widget.message.messageText;
    _fontSizeController.text = widget.message.fontSize.toString();
    _fontColorController.text = widget.message.fontColor;
    _backgroundColorController.text = widget.message.backgroundColor;
    _selectedLanguage = widget.message.language;
    _selectedImage = widget.message.messageImage;
    _selectedSound = widget.message.messageSound;
    _isPictureVisible = widget.message.isPictureVisible;
    _isTextVisible = widget.message.isTextVisible;
    _isSoundEnabled = widget.message.isSoundEnabled;
    _fromWhere = widget.message.fromWhere;

    _openRecorder();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update the Message'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _messageTextController,
                decoration: const InputDecoration(labelText: 'Message Text'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _fontSizeController,
                decoration: const InputDecoration(labelText: 'Font Size'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _fontColorController,
                decoration: const InputDecoration(labelText: 'Font Color'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _backgroundColorController,
                decoration:
                    const InputDecoration(labelText: 'Background Color'),
              ),
              const SizedBox(height: 20),
              _buildDropdownForLanguage(),
              _buildImagePicker(),
              _buildAudioPicker(),
              _buildFromWhereDropdown(),
              const SizedBox(height: 20),
              _buildToggleSwitch('Show Picture', _isPictureVisible, (val) {
                setState(() {
                  _isPictureVisible = val;
                });
              }),
              _buildToggleSwitch('Show Text', _isTextVisible, (val) {
                setState(() {
                  _isTextVisible = val;
                });
              }),
              _buildToggleSwitch('Enable Sound', _isSoundEnabled, (val) {
                setState(() {
                  _isSoundEnabled = val;
                });
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownForLanguage() {
    return DropdownButton<Language>(
      value: _selectedLanguage,
      items: Language.values.map((Language language) {
        return DropdownMenuItem<Language>(
          value: language,
          child: Text(language.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value;
        });
      },
      hint: const Text('Select Language'),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Image: '),
            ElevatedButton(
              onPressed: () async {
                final XFile? pickedImage = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedImage != null) {
                  setState(() {
                    isImageUpdated = true;
                    isImageFromInternet = false;
                    urlControllerImage.clear();
                    _selectedImage = pickedImage.path;
                  });
                }
              },
              child: const Text('Gallery'),
            ),
            ElevatedButton(
              onPressed: () async {
                final XFile? pickedImage = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedImage != null) {
                  setState(() {
                    isImageUpdated = true;
                    isImageFromInternet = false;
                    urlControllerImage.clear();
                    _selectedImage = pickedImage.path;
                  });
                }
              },
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () async {
                _showUrlInputDialog('image');
              },
              child: const Text('Internet '),
            ),
          ],
        ),
        const SizedBox(height: 10), // Optional spacing
        if (_selectedImage != null && urlControllerImage.text.isEmpty)
          Image.file(
            File(_selectedImage!),
            width: 100, // Set the width for the image
            height: 100, // Set the height for the image
            fit: BoxFit.cover,
          ),
        if (urlControllerImage.text.isNotEmpty && _selectedImage == null)
          Image.network(
            urlControllerImage.text,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          )
      ],
    );
  }

  Future<void> _showUrlInputDialog(String audioORimage) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: audioORimage == 'audio'
                ? const Text('Enter Image URL')
                : const Text('Enter Audio URL'),
            content: TextField(
              controller: audioORimage == 'audio'
                  ? urlControllerAudio
                  : urlControllerImage,
              decoration: InputDecoration(
                  hintText: audioORimage == 'audio'
                      ? 'Enter image URL'
                      : 'Enter Audio URL'),
              keyboardType: TextInputType.url,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  audioORimage == 'audio'
                      ? isSoundUpdated = true
                      : isImageUpdated = true;

                  setState(() {});
                  audioORimage == 'audio'
                      ? {
                          isAudioFromInternet = true,
                          _selectedSound = null,
                        }
                      : {isImageFromInternet = true, _selectedImage = null};
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

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
            isSoundUpdated = true;
            isAudioFromInternet = false;
            urlControllerAudio.clear();
            _isRecording = true;
            _selectedSound = tempPath;
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

        print("Recording stopped, saved at: $_selectedSound");
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
        isSoundUpdated = true;
        urlControllerAudio.clear();
        isAudioFromInternet = false;
        _selectedSound = result.files.single.path;
      });
    }
  }

  // Play the selected audio
  Future<void> _playAudio() async {
    if (_selectedSound != null) {
      await _audioPlayer.play(DeviceFileSource(_selectedSound!));
    } else {
      print('No audio file selected');
    }
  }

  // Play audio from the internet
  Future<void> _playAudioFromUrl(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Widget _buildAudioPicker() {
    return SizedBox(
      width: Get.width,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _recordSound,
            child: Text(_isRecording ? 'Stop Recording' : 'Record a Sound'),
          ),

          // Button to pick a sound from local storage
          ElevatedButton(
            onPressed: _pickSoundFromLocal,
            child: const Text('Pick Sound from Local Storage'),
          ),
          ElevatedButton(
            onPressed: () => _showUrlInputDialog('audio'),
            child: const Text('Internet'),
          ),

          // Button to play audio from URL

          // Button to play the selected or recorded audio
          ElevatedButton(
            onPressed: () => isAudioFromInternet
                ? _playAudioFromUrl(urlControllerAudio.text)
                : _playAudio(),
            child: const Text('Play Selected Sound'),
          ),
        ],
      ),
    );
  }

  Widget _buildFromWhereDropdown() {
    return DropdownButton<FromWhere>(
      value: _fromWhere,
      items: FromWhere.values.map((FromWhere source) {
        return DropdownMenuItem<FromWhere>(
          value: source,
          child: Text(source.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _fromWhere = value;
        });
      },
      hint: const Text('Select Source'),
    );
  }

  Widget _buildToggleSwitch(
      String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  void _submitForm() async {
    // Check if all fields are filled
    if (_messageTextController.text.isNotEmpty &&
        (_selectedSound != null || urlControllerAudio.text.isNotEmpty) &&
        (_selectedImage != null || urlControllerImage.text.isNotEmpty)) {
      bool isConnected = await _checkInternetConnection();
      print(isConnected);

      // If audio or image is from the internet, check connection
      if ((isAudioFromInternet || isImageFromInternet) && !isConnected) {
        Get.snackbar('Error', 'Please connect to the internet',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      _showLoadingDialog(context);

      try {
        // Create the message
        DatabaseModel newMessage = DatabaseModel(
          keyfieldCode: widget.message.keyfieldCode,
          messageText: _messageTextController.text,
          messageImage: isImageUpdated
              ? isImageFromInternet
                  ? await _databaseController
                      .downloadAndStoreImageInHive(urlControllerImage.text)
                  : await _databaseController.saveImageToHive(_selectedImage!)
              : widget.message.messageImage,
          messageSound: isImageUpdated
              ? isAudioFromInternet
                  ? await _databaseController
                      .downloadAndStoreImageInHive(urlControllerAudio.text)
                  : await _databaseController.saveImageToHive(_selectedSound!)
              : widget.message.messageSound,
          language: _selectedLanguage!,
          isPictureVisible: _isPictureVisible,
          isTextVisible: _isTextVisible,
          isSoundEnabled: _isSoundEnabled,
          fontSize: int.parse(_fontSizeController.text),
          fontColor: _fontColorController.text,
          backgroundColor: _backgroundColorController.text,
          fromWhere: _fromWhere!,
        );

        // Add message to database
        _databaseController.updateMessageInMain(widget.index, newMessage);
        // widget.updateDatabasePage;
        // Clear form fields
        _messageTextController.clear();
        _fontSizeController.clear();
        _fontColorController.clear();
        _backgroundColorController.clear();
        _selectedImage = null;
        isImageFromInternet = false;
        urlControllerAudio.clear;
        urlControllerImage.clear;

        setState(() {});

        Get.back();
        Get.back();
        Get.snackbar('Success', 'Message Updated successfully',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        // Handle any error during the process
        Get.snackbar('Error', 'An error occurred: $e',
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        // Dismiss the loading dialog
        Navigator.pop(context);
      }
    } else {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

// Check internet connection
  Future<bool> _checkInternetConnection() async {
    try {
      // Get the current connectivity status (mobile, wifi, none)
      var connectivityResult = await Connectivity().checkConnectivity();

      // Log the result for debugging purposes (optional)
      print("Connectivity Result: $connectivityResult");

      // Check if the device is connected via mobile data or Wi-Fi
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        return true; // Connected to the internet
      } else {
        return false; // No internet connection
      }
    } catch (e) {
      // Handle potential errors (e.g., platform-specific issues)
      print("Error checking connectivity: $e");
      return false; // Return false if any error occurs
    }
  }

// Show loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text("Processing..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
