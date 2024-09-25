import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:aacimple/models/database_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseController extends GetxController {
  // Declare the boxes
  late Rx<Box<DatabaseModel>> mainHiveDatabase;
  late Rx<Box<DatabaseModel>> oldHiveDatabase;

  // Observables for the messages
  RxList<DatabaseModel> mainHiveDatabaseMessages = <DatabaseModel>[].obs;
  RxList<DatabaseModel> oldHiveDatabaseMessages = <DatabaseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase(); // Call async method without await in onInit
  }

  // Initialize the database asynchronously
  Future<void> _initializeDatabase() async {
    try {
      mainHiveDatabase =
          (await Hive.openBox<DatabaseModel>('mainHiveDatabase')).obs;
      oldHiveDatabase =
          (await Hive.openBox<DatabaseModel>('oldHiveDatabase')).obs;

      // Add default messages if mainHiveDatabase is empty
      if (mainHiveDatabase.value.isEmpty) {
        _addDefaultMessages();
      }

      // Load messages into the observable lists
      loadmainHiveDatabaseMessages();
      loadoldHiveDatabaseMessages();
    } catch (e) {
      print('Error initializing the database: $e');
    }
  }

  // Add default messages if the mainHiveDatabase is empty
  Future<void> _addDefaultMessages() async {
    List<DatabaseModel> defaultMessages = [
      DatabaseModel(
        keyfieldCode:
            DatabaseModel.generateKeyfieldCode(mainHiveDatabase.value.length),
        messageText: 'Adelfi', fromWhere: FromWhere.assets,
        messageImage: await storeAssetImageToHive('assets/images/αγαπώ.png'),
        messageSound: 'assets/audios/adelfi.mp3',
        language: Language.English, // Using the Language enum
      ),
      DatabaseModel(
        keyfieldCode:
            DatabaseModel.generateKeyfieldCode(mainHiveDatabase.value.length),
        messageText: 'adelfos',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetImageToHive('assets/images/αγκαλιά.png'),
        messageSound: 'assets/audios/adelfos.mp3',
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode:
            DatabaseModel.generateKeyfieldCode(mainHiveDatabase.value.length),
        messageText: 'agapo',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetImageToHive('assets/images/αδeρφή.png'),
        messageSound: 'assets/audios/agapo.mp3',
        language: Language.English,
      ),
    ];

    for (var message in defaultMessages) {
      addMessageToMain(message);
    }
  }

  Future<String> saveImageFromAssets(String assetPath) async {
    // var imageFilePath = ''.obs;
    final ByteData data = await rootBundle.load(assetPath);
    final buffer = data.buffer;

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = join(appDocDir.path, 'image.jpg');
    //saveMedia(filePath, 'image');
    File(filePath).writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return filePath;
    // saveMedia(filePath, 'image');
    // mediaFiles.add({'path': filePath, 'type': 'image'});
    // mediaBox.put('mediaFiles', mediaFiles.toList());

    // mediaBox.put('mediaFiles', filePath);
    // imageFilePath.value = filePath;
  }

  // Load messages from the main database
  void loadmainHiveDatabaseMessages() {
    mainHiveDatabaseMessages.assignAll(mainHiveDatabase.value.values.toList());
  }

  // Load messages from the old messages database
  void loadoldHiveDatabaseMessages() {
    oldHiveDatabaseMessages.assignAll(oldHiveDatabase.value.values.toList());
  }

  Future<String> saveImageToHive(String path) async {
    final savedPath = await saveToLocalStorage(path);
    return savedPath;
    // mediaFiles.add({'path': savedPath, 'type': type});
    // mediaBox.put('mediaFiles', mediaFiles.toList());
  }

  Future<String> storeAssetImageToHive(String assetImagePath) async {
    try {
      // Get the application's documents directory to store the image
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${assetImagePath.split('/').last}';

      // Load the image as a byte array from assets
      ByteData data = await rootBundle.load(assetImagePath);
      List<int> bytes = data.buffer.asUint8List();

      // Store the byte data as a file
      File file = File(path);
      await file.writeAsBytes(bytes);

      // Open a Hive box and store the image file path
      var box = await Hive.openBox('imageBox');
      await box.put('assetImage', path);

      // Return the stored image file path
      return path;
    } catch (e) {
      print('Error storing image: $e');
      return '';
    }
  }

  // Save to local storage
  Future<String> saveToLocalStorage(String path) async {
    final file = File(path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = file.path.split('/').last;
    final localFile = await file.copy('${appDir.path}/$fileName');
    return localFile.path;
  }

  // Add a new message to the main database
  void addMessageToMain(DatabaseModel message) {
    message = message.copyWith(
      keyfieldCode: DatabaseModel.generateKeyfieldCode(
          mainHiveDatabase.value.length), // Assign keyfield code
    );

    mainHiveDatabase.value.add(message);
  }

  // Delete a message from the main database and move it to the old messages database
  void deleteMessageFromMain(int index) {
    final message = mainHiveDatabase.value.getAt(index);
    if (message != null) {
      oldHiveDatabase.value.add(message);
      mainHiveDatabase.value.deleteAt(index);
      loadmainHiveDatabaseMessages();
      loadoldHiveDatabaseMessages();
    }
  }

  // Function to download image and store its path in Hive
  Future<String> downloadAndStoreImageInHive(String imageUrl) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fileName = imageUrl.split('/').last; // Get the image name from URL
      String filePath = '$appDocPath/$fileName';

      // Download the image
      http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        var box = await Hive.openBox('imageBox');
        await box.put('imagePath', filePath);

        // Return the local path
        return filePath;
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  // Function to retrieve the stored image path from Hive
  Future<String?> getImagePathFromHive() async {
    var box = await Hive.openBox('imageBox');
    return box.get('imagePath');
  }

  // Restore a message from the old database to the main database
  void restoreMessageToMain(int index) {
    final message = oldHiveDatabase.value.getAt(index);
    if (message != null) {
      mainHiveDatabase.value.add(message);
      oldHiveDatabase.value.deleteAt(index);
      loadmainHiveDatabaseMessages();
      loadoldHiveDatabaseMessages();
    }
  }

  // Update a message in the main database
  void updateMessageInMain(int index, DatabaseModel message) {
    mainHiveDatabase.value.putAt(index, message);
    loadmainHiveDatabaseMessages();
  }
}
