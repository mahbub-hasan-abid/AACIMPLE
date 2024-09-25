import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/models/database_model.dart';
import 'package:aacimple/views/utils/imagepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:file_picker/file_picker.dart'; // For audio file picking
import 'dart:io'; // For working with files

class MessageInputPage extends StatefulWidget {
  @override
  _MessageInputPageState createState() => _MessageInputPageState();
}

class _MessageInputPageState extends State<MessageInputPage> {
  final DatabaseController _databaseController = Get.put(DatabaseController());

  // Controllers for text fields
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController();
  final TextEditingController _fontColorController = TextEditingController();
  final TextEditingController _backgroundColorController =
      TextEditingController();
  TextEditingController _urlController = TextEditingController();
  // Variables for storing selected image, sound, and language
  String? _selectedImage;
  String _selectedSound = '';
  Language? _selectedLanguage = Language.English;
  bool _isPictureVisible = true;
  bool _isTextVisible = true;
  bool _isSoundEnabled = true;
  FromWhere? _fromWhere = FromWhere.user;
  bool isImageFromInternet = false;

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Message'),
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
                    isImageFromInternet = false;
                    _urlController.clear();
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
                    isImageFromInternet = false;
                    _urlController.clear();
                    _selectedImage = pickedImage.path;
                  });
                }
              },
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () async {
                _showUrlInputDialog();
              },
              child: const Text('Internet '),
            ),
          ],
        ),
        const SizedBox(height: 10), // Optional spacing
        if (_selectedImage != null && _urlController.text.isEmpty)
          Image.file(
            File(_selectedImage!),
            width: 100, // Set the width for the image
            height: 100, // Set the height for the image
            fit: BoxFit.cover,
          ),
        if (_urlController.text.isNotEmpty && _selectedImage == null)
          Image.network(
            _urlController.text,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          )
      ],
    );
  }

  Future<void> _showUrlInputDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Enter Image URL'),
            content: TextField(
              controller: _urlController,
              decoration: const InputDecoration(hintText: 'Enter image URL'),
              keyboardType: TextInputType.url,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  isImageFromInternet = true;
                  _selectedImage = null;
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

  Widget _buildAudioPicker() {
    return Row(
      children: [
        const Text('Audio: '),
        // ElevatedButton(
        //   onPressed: () async {
        //     FilePickerResult? result = await FilePicker.platform.pickFiles(
        //       type: FileType.audio,
        //       allowMultiple: false,
        //     );
        //     if (result != null && result.files.isNotEmpty) {
        //       setState(() {
        //         _selectedSound = result.files.single.path;
        //         print('Selected audio: $_selectedSound');
        //       });
        //     } else {
        //       Get.snackbar('Error', 'No audio file selected',
        //           snackPosition: SnackPosition.BOTTOM);
        //     }
        //   },
        //   child: const Text('Choose Audio'),
        // ),
      ],
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
    if (_messageTextController.text.isNotEmpty &&
            (_selectedImage != null || _urlController.text.isNotEmpty)
        // _selectedSound != null
        ) {
      DatabaseModel newMessage = DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            _databaseController.mainHiveDatabase.value.length),
        messageText: _messageTextController.text,
        messageImage: isImageFromInternet
            ? await _databaseController
                .downloadAndStoreImageInHive(_urlController.text)
            : await _databaseController.saveImageToHive(_selectedImage!),
        messageSound: _selectedSound,
        language: _selectedLanguage!,
        isPictureVisible: _isPictureVisible,
        isTextVisible: _isTextVisible,
        isSoundEnabled: _isSoundEnabled,
        fontSize: int.parse(_fontSizeController.text),
        fontColor: _fontColorController.text,
        backgroundColor: _backgroundColorController.text,
        fromWhere: _fromWhere!,
      );

      Get.snackbar('if', 'if', snackPosition: SnackPosition.BOTTOM);
      // Call addMessageToMain function
      _databaseController.addMessageToMain(newMessage);
      // _databaseController.mainHiveDatabase.add(newMessage);

      // Clear the form
      _messageTextController.clear();
      _fontSizeController.clear();
      _fontColorController.clear();
      _backgroundColorController.clear();
      _selectedImage = null;
      isImageFromInternet = false;
      setState(() {});
      // _selectedSound = null;

      Get.snackbar('Success', 'Message added successfully',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
