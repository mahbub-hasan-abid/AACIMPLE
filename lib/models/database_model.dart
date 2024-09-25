import 'package:hive/hive.dart';
part 'database_model.g.dart';

// Enum for determining the source of image/sound
@HiveType(typeId: 2) // Assign a new typeId for this enum
enum FromWhere {
  @HiveField(0)
  assets,
  @HiveField(1)
  user,
}

// Register the adapter for DatabaseModel
@HiveType(typeId: 0)
class DatabaseModel {
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

  @HiveField(11)
  final FromWhere fromWhere; // New field for image source

  // New field for sound source

  DatabaseModel(
      {required this.keyfieldCode,
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
      required this.fromWhere // Default source is user
      });

  // Implement the copyWith method
  DatabaseModel copyWith({
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
    FromWhere? fromWhere, // Include the new field in copyWith
  }) {
    return DatabaseModel(
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
      fromWhere: fromWhere ?? this.fromWhere, // Default to existing source
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
