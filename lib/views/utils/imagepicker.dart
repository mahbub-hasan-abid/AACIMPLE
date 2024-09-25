import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickImage(
    BuildContext context, Function(String?) onImageSelected) async {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _urlController = TextEditingController();

  // Helper function to show URL input dialog
  Future<void> _showUrlInputDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Image URL'),
          content: TextField(
            controller: _urlController,
            decoration: const InputDecoration(hintText: 'Enter image URL'),
            keyboardType: TextInputType.url,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                onImageSelected(_urlController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Helper function to pick image from source (camera/gallery)
  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      onImageSelected(pickedImage.path);
    }
  }

  // Show options dialog
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('From Camera'),
            onTap: () {
              _pickImageFromSource(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('From Gallery'),
            onTap: () {
              _pickImageFromSource(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('From Internet'),
            onTap: () {
              Navigator.pop(context);
              _showUrlInputDialog();
            },
          ),
        ],
      );
    },
  );
}
