// import 'package:aacimple/models/message_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:hive/hive.dart';
// import 'package:audioplayers/audioplayers.dart';

// // Enum to specify the source of the image/audio


// class MessageController extends GetxController {
//   final ImagePicker imagePicker = ImagePicker();
//   final AudioPlayer audioPlayer = AudioPlayer();

//   // Variables for storing selected data
//   var phrase = ''.obs;
//   var selectedLanguage = 'English'.obs;
//   var imagePath = ''.obs;
//   var audioPath = ''.obs;
//   var fontSize = 12.0.obs;
//   var fontColor = Colors.white.obs;
//   var backgroundColor = const Color(0xFF00008B).obs;
//   var isPictureVisible = true.obs;
//   var isTextVisible = true.obs;
//   var isSoundEnabled = true.obs;

//   // Open camera for image selection
//   Future<void> selectFromCamera() async {
//     final XFile? image =
//         await imagePicker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       imagePath.value = image.path;
//     }
//   }

//   // Open gallery for image selection
//   Future<void> selectFromGallery() async {
//     final XFile? image =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       imagePath.value = image.path;
//     }
//   }

//   // Enter image link manually
//   void selectFromInternet(String url) {
//     imagePath.value = url;
//   }

//   // Open file picker for audio selection
//   Future<void> selectAudioFile() async {
//     FilePickerResult? result =
//         await FilePicker.platform.pickFiles(type: FileType.audio);
//     if (result != null) {
//       audioPath.value = result.files.single.path!;
//     }
//   }

//   // Save message to Hive database
//   Future<void> saveMessage(FromWhere fromWheres) async {
//     final box = await Hive.openBox<MessageModel>('messages');
//     final newMessage = MessageModel(
//       keyfieldCode: DateTime.now().millisecondsSinceEpoch.toString(),
//       language: selectedLanguage.value,
//       phrase: phrase.value,
//       fromWhere: fromWheres, // Store the enum directly
//       imagePath: imagePath.value,
//       soundPath: audioPath.value,
//       isPictureVisible: isPictureVisible.value,
//       isTextVisible: isTextVisible.value,
//       isSoundEnabled: isSoundEnabled.value,
//       fontSize: fontSize.value,
//       fontColor: fontColor.value,
//       backgroundColor: backgroundColor.value,
//     );
//     await box.add(newMessage);
//     Get.snackbar('Success', 'Message saved successfully!');
//   }
// }
