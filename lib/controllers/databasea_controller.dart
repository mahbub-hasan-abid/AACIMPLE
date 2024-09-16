import 'package:aacimple/models/database_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class DatabaseController extends GetxController {
  // Declare the boxes, but don't initialize them yet
  late Box<MessageModel> mainDatabase;
  late Box<MessageModel> oldMessagesDatabase;

  RxList<MessageModel> mainDatabaseMessages = <MessageModel>[].obs;
  RxList<MessageModel> oldDatabaseMessages = <MessageModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await _initializeDatabase();
    loadMainDatabaseMessages();
    loadOldDatabaseMessages();
  }

  Future<void> _initializeDatabase() async {
    // Open the boxes asynchronously
    mainDatabase = await Hive.openBox<MessageModel>('maindatabase');
    oldMessagesDatabase =
        await Hive.openBox<MessageModel>('oldmessagesdatabase');

    // If the main database is empty, add default messages
    if (mainDatabase.isEmpty) {
      List<MessageModel> defaultMessages = [
        MessageModel(
          messageText: 'Welcome to Language Learning',
          messageImage: 'assets/images/αγαπώ.png',
          messageSound: 'assets/sounds/welcome.mp3',
          language: 'English',
          createdAt: DateTime.now(),
        ),
        MessageModel(
          messageText: 'Hello',
          messageImage: 'assets/images/hello.png',
          messageSound: 'assets/sounds/hello.mp3',
          language: 'English',
          createdAt: DateTime.now(),
        ),
        MessageModel(
          messageText: 'Goodbye',
          messageImage: 'assets/images/goodbye.png',
          messageSound: 'assets/sounds/goodbye.mp3',
          language: 'English',
          createdAt: DateTime.now(),
        ),
      ];

      // Add default messages to the main database
      for (var message in defaultMessages) {
        mainDatabase.add(message);
      }
    }
  }

  void loadMainDatabaseMessages() {
    mainDatabaseMessages.assignAll(mainDatabase.values.toList());
  }

  void loadOldDatabaseMessages() {
    oldDatabaseMessages.assignAll(oldMessagesDatabase.values.toList());
  }

  void addMessageToMain(MessageModel message) {
    mainDatabase.add(message);
    loadMainDatabaseMessages();
  }

  void deleteMessageFromMain(int index) {
    final message = mainDatabase.getAt(index);
    if (message != null) {
      oldMessagesDatabase.add(message);
      mainDatabase.deleteAt(index);
      loadMainDatabaseMessages();
      loadOldDatabaseMessages();
    }
  }

  void restoreMessageToMain(int index) {
    final message = oldMessagesDatabase.getAt(index);
    if (message != null) {
      mainDatabase.add(message);
      oldMessagesDatabase.deleteAt(index);
      loadMainDatabaseMessages();
      loadOldDatabaseMessages();
    }
  }

  void updateMessageInMain(int index, MessageModel message) {
    mainDatabase.putAt(index, message);
    loadMainDatabaseMessages();
  }
}
