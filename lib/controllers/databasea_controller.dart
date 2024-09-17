import 'package:aacimple/models/database_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class DatabaseController extends GetxController {
  // Declare the boxes
  late Box<MessageModel> mainDatabase;
  late Box<MessageModel> oldMessagesDatabase;

  // Observables for the messages
  RxList<MessageModel> mainDatabaseMessages = <MessageModel>[].obs;
  RxList<MessageModel> oldDatabaseMessages = <MessageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase(); // Call async method without await in onInit
  }

  // Initialize the database asynchronously
  Future<void> _initializeDatabase() async {
    try {
      mainDatabase = await Hive.openBox<MessageModel>('maindatabase');
      oldMessagesDatabase =
          await Hive.openBox<MessageModel>('oldmessagesdatabase');

      // Add default messages if mainDatabase is empty
      if (mainDatabase.isEmpty) {
        _addDefaultMessages();
      }

      // Load messages into the observable lists
      loadMainDatabaseMessages();
      loadOldDatabaseMessages();
    } catch (e) {
      // Error handling
      print('Error initializing the database: $e');
    }
  }

  // Add default messages if the mainDatabase is empty
  void _addDefaultMessages() {
    List<MessageModel> defaultMessages = [
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'Adelfi',
        messageImage: 'assets/images/αγαπώ.png',
        messageSound: 'assets/sounds/adelfi.mp3',
        language: Language.English, // Using the Language enum
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'adelfos',
        messageImage: 'assets/images/αγκαλιά.png',
        messageSound: 'assets/sounds/adelfos.mp3',
        language: Language.English,
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'agapo',
        messageImage: 'assets/images/αδeρφή.png',
        messageSound: 'assets/sounds/agapo.mp3',
        language: Language.English,
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'Adelfi',
        messageImage: 'assets/images/αγαπώ.png',
        messageSound: 'assets/sounds/adelfi.mp3',
        language: Language.English, // Using the Language enum
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'adelfos',
        messageImage: 'assets/images/αγκαλιά.png',
        messageSound: 'assets/sounds/adelfos.mp3',
        language: Language.English,
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'agapo',
        messageImage: 'assets/images/αδeρφή.png',
        messageSound: 'assets/sounds/agapo.mp3',
        language: Language.English,
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'Adelfi',
        messageImage: 'assets/images/αγαπώ.png',
        messageSound: 'assets/sounds/adelfi.mp3',
        language: Language.English, // Using the Language enum
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'adelfos',
        messageImage: 'assets/images/αγκαλιά.png',
        messageSound: 'assets/sounds/adelfos.mp3',
        language: Language.English,
      ),
      MessageModel(
        keyfieldCode: MessageModel.generateKeyfieldCode(mainDatabase.length),
        messageText: 'agapo',
        messageImage: 'assets/images/αδeρφή.png',
        messageSound: 'assets/sounds/agapo.mp3',
        language: Language.English,
      ),
    ];

    for (var message in defaultMessages) {
      mainDatabase.add(message);
    }
  }

  // Load messages from the main database
  void loadMainDatabaseMessages() {
    mainDatabaseMessages.assignAll(mainDatabase.values.toList());
  }

  // Load messages from the old messages database
  void loadOldDatabaseMessages() {
    oldDatabaseMessages.assignAll(oldMessagesDatabase.values.toList());
  }

  // Add a new message to the main database
  void addMessageToMain(MessageModel message) {
    message = message.copyWith(
      keyfieldCode: MessageModel.generateKeyfieldCode(
          mainDatabase.length), // Assign keyfield code
    );
    mainDatabase.add(message);
    loadMainDatabaseMessages(); // Refresh the list
  }

  // Delete a message from the main database and move it to the old messages database
  void deleteMessageFromMain(int index) {
    final message = mainDatabase.getAt(index);
    if (message != null) {
      oldMessagesDatabase.add(message);
      mainDatabase.deleteAt(index);
      loadMainDatabaseMessages();
      loadOldDatabaseMessages();
    }
  }

  // Restore a message from the old database to the main database
  void restoreMessageToMain(int index) {
    final message = oldMessagesDatabase.getAt(index);
    if (message != null) {
      mainDatabase.add(message);
      oldMessagesDatabase.deleteAt(index);
      loadMainDatabaseMessages();
      loadOldDatabaseMessages();
    }
  }

  // Update a message in the main database
  void updateMessageInMain(int index, MessageModel message) {
    mainDatabase.putAt(index, message);
    loadMainDatabaseMessages();
  }
}
