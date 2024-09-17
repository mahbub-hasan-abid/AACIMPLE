import 'package:hive/hive.dart';

// Register the adapter for MessageModel
// Make sure to add this line

@HiveType(typeId: 0)
class MessageModel {
  @HiveField(0)
  final String keyfieldCode;

  @HiveField(1)
  final String messageText;

  @HiveField(2)
  final String messageImage;

  @HiveField(3)
  final String messageSound;

  @HiveField(4)
  final Language language; // Enum for language

  @HiveField(5)
  final bool isPictureVisible;

  @HiveField(6)
  final bool isTextVisible;

  @HiveField(7)
  final bool isSoundEnabled;

  @HiveField(8)
  final int fontSize;

  @HiveField(9)
  final String fontColor;

  @HiveField(10)
  final String backgroundColor;

  MessageModel({
    required this.keyfieldCode,
    required this.messageText,
    required this.messageImage,
    required this.messageSound,
    required this.language,
    this.isPictureVisible = true, // Default ON
    this.isTextVisible = true, // Default ON
    this.isSoundEnabled = true, // Default ON
    this.fontSize = 12, // Default font size
    this.fontColor = 'White', // Default font color
    this.backgroundColor = 'Dark Blue', // Default background color
  });

  // Implement the copyWith method
  MessageModel copyWith({
    String? keyfieldCode,
    String? messageText,
    String? messageImage,
    String? messageSound,
    Language? language,
    bool? isPictureVisible,
    bool? isTextVisible,
    bool? isSoundEnabled,
    int? fontSize,
    String? fontColor,
    String? backgroundColor,
  }) {
    return MessageModel(
      keyfieldCode: keyfieldCode ?? this.keyfieldCode,
      messageText: messageText ?? this.messageText,
      messageImage: messageImage ?? this.messageImage,
      messageSound: messageSound ?? this.messageSound,
      language: language ?? this.language,
      isPictureVisible: isPictureVisible ?? this.isPictureVisible,
      isTextVisible: isTextVisible ?? this.isTextVisible,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      fontSize: fontSize ?? this.fontSize,
      fontColor: fontColor ?? this.fontColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  // Method to generate keyfield code based on the index
  static String generateKeyfieldCode(int index) {
    return (index + 1).toString().padLeft(3, '0'); // Generates 001, 002, etc.
  }
}

// Enum for the languages
@HiveType(typeId: 1)
enum Language {
  @HiveField(0)
  English,
  @HiveField(1)
  Greek,
  @HiveField(2)
  Italian,
}
