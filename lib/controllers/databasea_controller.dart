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
  Future<void> onInit() async {
    super.onInit();
    await _initializeDatabase();

    print('controller----------------------------------');
    print(mainHiveDatabaseMessages
        .value.length); // Call async method without await in onInit
  }

  // Initialize the database asynchronously
  Future<void> _initializeDatabase() async {
    try {
      mainHiveDatabase =
          (await Hive.openBox<DatabaseModel>('mainHiveDatabase')).obs;
      oldHiveDatabase =
          (await Hive.openBox<DatabaseModel>('oldHiveDatabase')).obs;

      // mainHiveDatabase.value.clear();
      // mainHiveDatabase.value.deleteFromDisk();
      // mainHiveDatabase.value.clear;

      // Add default messages if mainHiveDatabase is empty
      if (mainHiveDatabase.value.isEmpty) {
        await _addDefaultMessages();
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
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'αγαπώ',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/αγαπώ.png'),
        messageSound: await storeAssetFileToHive('assets/audios/agapo.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'αγκαλιά',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/αγκαλιά.png'),
        messageSound: await storeAssetFileToHive('assets/audios/agkalia.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'αδελφή',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/αδeρφή.PNG'),
        messageSound: await storeAssetFileToHive('assets/audios/adelfi.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'αδέλφια',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/αδέρφια.png'),
        messageSound: await storeAssetFileToHive('assets/audios/adelfia.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'αδελφός',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/αδερφός.PNG'),
        messageSound: await storeAssetFileToHive('assets/audios/adelfos.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'άλλο',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/άλλο.png'),
        messageSound: await storeAssetFileToHive('assets/audios/allo.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'βόλτα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/βόλτα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/volta.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'γάλα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/γάλα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/gala.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'γεια σου',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/γεια σου.png'),
        messageSound: await storeAssetFileToHive('assets/audios/geiasou.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'γλυκό',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/γλυκό.png'),
        messageSound: await storeAssetFileToHive('assets/audios/gliko.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'δάσκαλοι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/δάσκαλοι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/daskala.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'διάβασμα',
        fromWhere: FromWhere.assets,
        messageImage:
            await storeAssetFileToHive('assets/images/διάβασμαpng.png'),
        messageSound: await storeAssetFileToHive('assets/audios/diavasma.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'εγώ',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/εγώ.png'),
        messageSound: await storeAssetFileToHive('assets/audios/ego.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'θάλασσα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/θάλασσα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/thalassa.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'θέλω',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/θέλω.png'),
        messageSound: await storeAssetFileToHive('assets/audios/thelo.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'θεραπείες',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/θεραπείες.png'),
        messageSound: await storeAssetFileToHive('assets/audios/thepapies.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'θυμός',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/θυμός.png'),
        messageSound: await storeAssetFileToHive('assets/audios/thimo.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'κεφάλι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/κεφάλι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/kefali.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'κινητό',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/κινητό.png'),
        messageSound: await storeAssetFileToHive('assets/audios/kinito.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'κοιλιά',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/κοιλιά.png'),
        messageSound: await storeAssetFileToHive('assets/audios/kilia.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'κοντά',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/κοντα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/konta.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'λίγο',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/λίγο.png'),
        messageSound: await storeAssetFileToHive('assets/audios/ligo.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'λύπη',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/λύπη.png'),
        messageSound: await storeAssetFileToHive('assets/audios/lipi.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μακαρόνια',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μακαρόνια.png'),
        messageSound: await storeAssetFileToHive('assets/audios/makaronia.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μακριά',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μακριά.png'),
        messageSound: await storeAssetFileToHive('assets/audios/makria.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μαμά',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μαμά.png'),
        messageSound: await storeAssetFileToHive('assets/audios/mama.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μάτι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μάτι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/mati.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μέρα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μέρα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/mera.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μέσα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μέσα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/mesa.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μου αρέσει',
        fromWhere: FromWhere.assets,
        messageImage:
            await storeAssetFileToHive('assets/images/μου αρέσει.png'),
        messageSound: await storeAssetFileToHive('assets/audios/mouaresei.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μπαμπάς',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μπαμπάς.png'),
        messageSound: await storeAssetFileToHive('assets/audios/mpampas.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'μπάνιο',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/μπάνιο.png'),
        messageSound: await storeAssetFileToHive('assets/audios/mpanio.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'ναι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/ναι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/nai.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'νερό',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/νερό.png'),
        messageSound: await storeAssetFileToHive('assets/audios/nero.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'νιώθω',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/νιώθω.png'),
        messageSound: await storeAssetFileToHive('assets/audios/niotho.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'όχι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/όχι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/ohi.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'παιχνίδια',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/παιχνίδια.png'),
        messageSound:
            await storeAssetFileToHive('assets/audios/pehnidiamou.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πάνω',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πάνω.png'),
        messageSound: await storeAssetFileToHive('assets/audios/pano.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'παππούδες',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/παππούδες.png'),
        messageSound: await storeAssetFileToHive('assets/audios/pappoudes.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πατάτες',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πατάτες.png'),
        messageSound: await storeAssetFileToHive('assets/audios/patates.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πάω',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πάω.png'),
        messageSound: await storeAssetFileToHive('assets/audios/pao.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πίνω',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πίνω.png'),
        messageSound: await storeAssetFileToHive('assets/audios/pino.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πίτσα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πίτσα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/pitsa.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πόδι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πόδι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/podi.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πολύ',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πολύ.png'),
        messageSound: await storeAssetFileToHive('assets/audios/poli.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πονώ',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πονώ.png'),
        messageSound: await storeAssetFileToHive('assets/audios/pono.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'πότε',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/πότε.png'),
        messageSound: await storeAssetFileToHive('assets/audios/pote.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'σάντουιτς',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/σάντουιτς.png'),
        messageSound: await storeAssetFileToHive('assets/audios/santouits.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'σουβλάκια',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/σουβλάκια.png'),
        messageSound: await storeAssetFileToHive('assets/audios/souvlakia.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'σπίτι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/σπίτι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/spiti.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'σχολείο',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/σχολείο.png'),
        messageSound: await storeAssetFileToHive('assets/audios/sholio.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'τηλεόραση',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/τηλεόραση.png'),
        messageSound: await storeAssetFileToHive('assets/audios/tileorasi.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'τηλεφώνησε',
        fromWhere: FromWhere.assets,
        messageImage:
            await storeAssetFileToHive('assets/images/τηλεφώνησε.png'),
        messageSound:
            await storeAssetFileToHive('assets/audios/tilefonise.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'τουαλέτα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/τουαλέτα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/toualeta.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'τρώω',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/τρώω.png'),
        messageSound: await storeAssetFileToHive('assets/audios/troo.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'υπνοδωμάτιο',
        fromWhere: FromWhere.assets,
        messageImage:
            await storeAssetFileToHive('assets/images/υπνοδωμάτιο.png'),
        messageSound:
            await storeAssetFileToHive('assets/audios/ypnodomatio.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'φίλοι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/φίλοι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/filoi.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'φόβος',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/φόβος.png'),
        messageSound: await storeAssetFileToHive('assets/audios/fovos.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'χαρά',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/χαρά.png'),
        messageSound: await storeAssetFileToHive('assets/audios/hara.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'χέρι',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/χέρι.png'),
        messageSound: await storeAssetFileToHive('assets/audios/heri.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'χυμός',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/χυμός.png'),
        messageSound: await storeAssetFileToHive('assets/audios/himo.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'ψωμί',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/ψωμί.png'),
        messageSound: await storeAssetFileToHive('assets/audios/psomi.mp3'),
        language: Language.English,
      ),
      DatabaseModel(
        keyfieldCode: DatabaseModel.generateKeyfieldCode(
            mainHiveDatabase.value.length.toInt() +
                oldHiveDatabase.value.length.toInt()),
        messageText: 'ώρα',
        fromWhere: FromWhere.assets,
        messageImage: await storeAssetFileToHive('assets/images/ώρα.png'),
        messageSound: await storeAssetFileToHive('assets/audios/ora.mp3'),
        language: Language.English,
      ),
    ];

    for (var message in defaultMessages) {
      addMessageToMain(message);
    }
    update();
  }

  Future<String> saveImageFromAssets(String assetPath) async {
    // var imageFilePath = ''.obs;
    final ByteData data = await rootBundle.load(assetPath);
    final buffer = data.buffer;

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = join(appDocDir.path, 'image.jpg');

    File(filePath).writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return filePath;
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

  Future<String> storeAssetFileToHive(String assetImagePath) async {
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
          mainHiveDatabase.value.length.toInt() +
              oldHiveDatabase.value.length.toInt().toInt() +
              oldHiveDatabase.value.length.toInt()), // Assign keyfield code
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
  Future<void> updateMessageInMain(int index, DatabaseModel message) async {
    await mainHiveDatabase.value.putAt(index, message);
    loadmainHiveDatabaseMessages();
  }
}
