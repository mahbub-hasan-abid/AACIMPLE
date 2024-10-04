import 'package:aacimple/constant.dart';
import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:aacimple/models/database_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class MessageInputPage extends StatefulWidget {
  @override
  _MessageInputPageState createState() => _MessageInputPageState();
}

class _MessageInputPageState extends State<MessageInputPage> {
  final SettingsController settingsController =
      Get.put<SettingsController>(SettingsController());
  final DatabaseController _databaseController = Get.put(DatabaseController());

  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController();
  final TextEditingController _fontColorController = TextEditingController();
  final TextEditingController _backgroundColorController =
      TextEditingController();
  final TextEditingController urlControllerImage = TextEditingController();
  final TextEditingController urlControllerAudio = TextEditingController();

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
  bool _isRecording = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _openRecorder();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _audioPlayer.dispose();
    super.dispose();
  }

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Message'),
        backgroundColor: const Color(0xFF010080),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      ' Message Text',
                      Icons.message, // Changed icon for consistency
                      _messageTextController),
                  _buildTextField(
                      ' Font Size',
                      Icons.format_size, // Updated icon for font size
                      _fontSizeController,
                      isNumber: true),
                  _buildColorPicker(
                    'Color of Font Text on Message Boxes',
                    Icons.format_color_text,
                    settingsController.fontColor,
                  ),
                  _buildColorPicker(
                    'Color Background of Message Boxes',
                    Icons.format_paint,
                    settingsController.backgroundColor,
                  ),

                  const SizedBox(height: 20),
                  _buildDropdownForLanguage(),

                  const SizedBox(height: 20),
                  _buildImagePicker(),
                  const SizedBox(height: 20),
                  _buildAudioPicker(),
                  const SizedBox(height: 20),
                  //  _buildFromWhereDropdown(),
                  const SizedBox(height: 20),
                  _buildToggleSwitch(
                      Icons.image, 'Show Picture', _isPictureVisible, (val) {
                    setState(() {
                      _isPictureVisible = val;
                    });
                  }),
                  _buildToggleSwitch(
                      Icons.text_fields, 'Show Text', _isTextVisible, (val) {
                    setState(() {
                      _isTextVisible = val;
                    });
                  }),
                  _buildToggleSwitch(
                      Icons.volume_up, 'Enable Sound', _isSoundEnabled, (val) {
                    setState(() {
                      _isSoundEnabled = val;
                    });
                  }),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text(
                        'Save Message',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF010080),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isNumber = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, // Bold for better readability
            color: Colors.black87,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF010080)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker(String title, IconData icon, Rx<Color> observable) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all()),
            child: ListTile(
              //contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading:
                  Icon(icon, color: const Color(0xFF010080)), // Use theme color
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // Bold for better readability
                  color: Colors.black87,
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: observable.value,
                  border: Border.all(color: Colors.black),
                ), // Use theme color
                width: 40,
                height: 40,
              ),
              onTap: () async {
                Color? selectedColor =
                    await _selectColor(Get.context!, observable.value);
                if (selectedColor != null) {
                  // Only change the color of the trailing container
                  observable.value =
                      selectedColor; // Update the observable directly
                }
              },
            ),
          ),
        ));
  }

  Future<Color?> _selectColor(BuildContext context, Color initialColor) async {
    Color selectedColor = initialColor;

    return await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Select Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  hexInputBar: true,
                  colorPickerWidth: Get.width * 0.3,
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    selectedColor = color; // Update selected color
                  },
                  enableAlpha: true,
                  displayThumbColor: true,
                  pickerAreaHeightPercent: 0.6,
                ),
                const SizedBox(height: 20),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(selectedColor),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  

  Widget _buildDropdownForLanguage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(), // Added border color for better visibility
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 15.0), // Added padding for better spacing
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Space between label and dropdown
        children: [
          Icon(Icons.language_sharp, color: Color(0xFF010080)),
          SizedBox(
            width: 20,
          ),
          const Text(
            'Select language:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Bold for better readability
              color: Colors.black87,
            ),
          ),
          Expanded(
            // Allows the DropdownButton to take the remaining space
            child: DropdownButton<Language?>(
              value: _selectedLanguage,
              items: Language.values.map((Language language) {
                return DropdownMenuItem<Language>(
                  value: language,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: Text(
                      language.toString().split('.').last,
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.black87),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Language? value) {
                setState(() {
                  _selectedLanguage = value; // Nullable value assignment
                });
              },
              hint: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Text(
                  'Select Language:',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(), // Hides the default underline
              iconEnabledColor: const Color(0xFF010080),
              iconSize: 30.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Image:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12), // Added spacing between text and buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildImageButton('Gallery', () async {
              final XFile? pickedImage =
                  await _imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedImage != null) {
                setState(() {
                  isImageFromInternet = false;
                  urlControllerImage.clear();
                  _selectedImage = pickedImage.path;
                });
              }
            }),
            _buildImageButton('Camera', () async {
              final XFile? pickedImage =
                  await _imagePicker.pickImage(source: ImageSource.camera);
              if (pickedImage != null) {
                setState(() {
                  isImageFromInternet = false;
                  urlControllerImage.clear();
                  _selectedImage = pickedImage.path;
                });
              }
            }),
            _buildImageButton('Internet', () async {
              _showUrlInputDialog('image');
            }),
          ],
        ),
        const SizedBox(height: 12), // Added spacing
        if (_selectedImage != null && urlControllerImage.text.isEmpty)
          Container(
            margin:
                const EdgeInsets.only(top: 12.0), // Margin for better spacing
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                File(_selectedImage!),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (urlControllerImage.text.isNotEmpty && _selectedImage == null)
          Container(
            margin:
                const EdgeInsets.only(top: 12.0), // Margin for better spacing
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                urlControllerImage.text,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 12), // Increased padding
            backgroundColor: const Color(0xFF010080), // Consistent button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showUrlInputDialog(String audioOrImage) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              'Enter ${audioOrImage == 'audio' ? 'Audio' : 'Image'} URL',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width:
                  double.maxFinite, // Make the dialog content take full width
              child: TextField(
                controller: audioOrImage == 'audio'
                    ? urlControllerAudio // Use appropriate controller
                    : urlControllerImage,
                decoration: InputDecoration(
                  hintText:
                      'Enter ${audioOrImage == 'audio' ? 'Audio' : 'Image'} URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                ),
                keyboardType: TextInputType.url,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  textStyle: const TextStyle(fontSize: 16), // Text size
                ),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                 
                  setState(() {
                    audioOrImage == 'audio'
                        ? {isAudioFromInternet = true, _selectedSound = null}
                        : {isImageFromInternet = true, _selectedImage = null};
                  });
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  textStyle: const TextStyle(fontSize: 16),
                ),
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
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        await _recorder!.openRecorder();
      } else {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    } catch (e) {
      print("Error opening recorder: $e");
    }
  }

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

  Widget _buildAudioPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Audio:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildImageButton(
                _isRecording ? 'Stop Recording' : 'Record a Sound',
                _recordSound),
            _buildImageButton('Device', () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.audio);
              if (result != null) {
                setState(() {
                  urlControllerAudio.clear();
                  isAudioFromInternet = false;
                  _selectedSound = result.files.single.path;
                });
              }
            }),
            _buildImageButton('Internet', () async {
              _showUrlInputDialog('audio');
            }),
          ],
        ),
        const SizedBox(height: 10),
        if (_selectedSound != null || urlControllerAudio.text.isNotEmpty)
          ElevatedButton(
            onPressed: () => isAudioFromInternet
                ? _toggleAudioFromUrl(urlControllerAudio.text)
                : _toggleAudio(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPlaying ? Icons.stop : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    isPlaying
                        ? 'Stop Playing'
                        : 'Play Selected Sound', // Toggle label
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: isPlaying
                  ? Colors.red // Change button color to red when playing
                  : const Color(0xFF010080), // Default color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          )
      ],
    );
  }

  Future<void> _toggleAudioFromUrl(String url) async {
    if (isPlaying) {
      await _audioPlayer.stop(); // Stop the audio
    } else {
      await _audioPlayer.play(UrlSource(url)); // Play the audio
    }
    setState(() {
      isPlaying = !isPlaying; // Toggle the isPlaying state
    });
  }

  Future<void> _toggleAudio() async {
    if (_selectedSound != null) {
      if (isPlaying) {
        await _audioPlayer.stop(); // Stop the audio
      } else {
        await _audioPlayer
            .play(DeviceFileSource(_selectedSound!)); // Play the audio
      }
      setState(() {
        isPlaying = !isPlaying; // Toggle the isPlaying state
      });
    } else {
      print('No audio file selected');
    }
  }

  Future<void> _playAudioFromUrl(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> _playAudio() async {
    if (_selectedSound != null) {
      await _audioPlayer.play(DeviceFileSource(_selectedSound!));
    } else {
      print('No audio file selected');
    }
  }

  Widget _buildFromWhereDropdown() {
    return DropdownButton<FromWhere>(
      value: _fromWhere,
      items: FromWhere.values.map((FromWhere fromWhere) {
        return DropdownMenuItem<FromWhere>(
          value: fromWhere,
          child: Text(fromWhere.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _fromWhere = value;
        });
      },
      hint: const Text('Select From Where'),
      isExpanded: true,
    );
  }

  Widget _buildToggleSwitch(
      IconData icon, String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0), // Padding between switches
      child: Container(
        padding: const EdgeInsets.symmetric(
            //vertical: 12.0,
            horizontal: 16.0), // Inner padding for the container
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(), // Border with primary color
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF010080)),
            SizedBox(
              width: 30,
            ), // Icon for better UI
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // Bold for better readability
                  color: Colors.black87,
                ),
              ),
            ),
            Transform.scale(
              scale: 1.2, // Slightly increase the size of the switch
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFF010080), // Switch active color
                inactiveTrackColor:
                    Colors.grey.withOpacity(0.5), // Inactive track color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_messageTextController.text.isNotEmpty) {
      DatabaseModel newMessage = DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            _databaseController.mainHiveDatabase.value.length.toInt() +
                _databaseController.oldHiveDatabase.value.length.toInt()),
        messageText: _messageTextController.text,
        messageImage: isImageFromInternet
            ? await _databaseController
                .downloadAndStoreImageInHive(urlControllerImage.text)
            : await _databaseController.saveImageToHive(_selectedImage!),
        messageSound: isAudioFromInternet
            ? await _databaseController
                .downloadAndStoreImageInHive(urlControllerAudio.text)
            : await _databaseController.saveImageToHive(_selectedSound!),
        language: _selectedLanguage!,
        isPictureVisible: _isPictureVisible,
        isTextVisible: _isTextVisible,
        isSoundEnabled: _isSoundEnabled,
        fontSize: int.parse(_fontSizeController.text),
        fontColor: _fontColorController.text,
        backgroundColor: _backgroundColorController.text,
        fromWhere: _fromWhere!,
      );
      _databaseController.addMessageToMain(newMessage);
      _clearFields();
      Get.snackbar('Success', 'Message saved successfully');
    } else {
      Get.snackbar('Error', 'Please enter a message');
    }
  }

  void _clearFields() {
    _messageTextController.clear();
    _fontSizeController.clear();
    _fontColorController.clear();
    _backgroundColorController.clear();
    urlControllerImage.clear();
    urlControllerAudio.clear();
    setState(() {
      _selectedImage = null;
      _selectedSound = null;
      isImageFromInternet = false;
      isAudioFromInternet = false;
    });
  }
}
