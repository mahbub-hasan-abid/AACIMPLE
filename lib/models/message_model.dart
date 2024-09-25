// import 'package:flutter/material.dart';

// // Enum to specify the source of the image/sound
// enum FromWhere { assets, user }

// class MessageModel {
//   // Unique identifier for each message (automatically generated)
//   final String keyfieldCode;

//   // Language of the message
//   final String language;

//   // The text label for the message
//   final String phrase;

//   // Enum field to indicate if data is from assets or user
//   final FromWhere fromWhere; // Changed from String to FromWhere enum

//   // The image associated with the message (file path or URL)
//   final String? imagePath;

//   // The sound associated with the message (file path or URL)
//   final String? soundPath;

//   // Display controls
//   bool isPictureVisible;
//   bool isTextVisible;
//   bool isSoundEnabled;

//   // Font customization
//   double fontSize;
//   Color fontColor;

//   // Background color
//   Color backgroundColor;

//   // Constructor
//   MessageModel({
//     required this.keyfieldCode,
//     required this.language,
//     required this.phrase,
//     required this.fromWhere, // Changed to enum
//     this.imagePath,
//     this.soundPath,
//     this.isPictureVisible = true, // Default ON
//     this.isTextVisible = true, // Default ON
//     this.isSoundEnabled = true, // Default ON
//     this.fontSize = 12.0, // Default font size 12
//     this.fontColor = Colors.white, // Default font color white
//     this.backgroundColor =
//         const Color(0xFF00008B), // Default dark blue background
//   });

//   // Convert to JSON (for saving to database)
//   Map<String, dynamic> toJson() {
//     return {
//       'keyfieldCode': keyfieldCode,
//       'language': language,
//       'phrase': phrase,
//       'fromWhere': fromWhere.toString().split('.').last, // Convert enum to string
//       'imagePath': imagePath,
//       'soundPath': soundPath,
//       'isPictureVisible': isPictureVisible,
//       'isTextVisible': isTextVisible,
//       'isSoundEnabled': isSoundEnabled,
//       'fontSize': fontSize,
//       'fontColor': fontColor.value,
//       'backgroundColor': backgroundColor.value,
//     };
//   }

//   // Create from JSON (for loading from database)
//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       keyfieldCode: json['keyfieldCode'],
//       language: json['language'],
//       phrase: json['phrase'],
//       fromWhere: FromWhere.values.firstWhere(
//           (e) => e.toString().split('.').last == json['fromWhere']), // Convert string back to enum
//       imagePath: json['imagePath'],
//       soundPath: json['soundPath'],
//       isPictureVisible: json['isPictureVisible'],
//       isTextVisible: json['isTextVisible'],
//       isSoundEnabled: json['isSoundEnabled'],
//       fontSize: json['fontSize'],
//       fontColor: Color(json['fontColor']),
//       backgroundColor: Color(json['backgroundColor']),
//     );
//   }
// }
