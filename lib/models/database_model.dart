import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class MessageModel {
  @HiveField(0)
  final String messageText;

  @HiveField(1)
  final String messageImage;

  @HiveField(2)
  final String messageSound;

  @HiveField(3)
  final String language;

  @HiveField(4)
  final DateTime createdAt;

  MessageModel({
    required this.messageText,
    required this.messageImage,
    required this.messageSound,
    required this.language,
    required this.createdAt,
  });
}
