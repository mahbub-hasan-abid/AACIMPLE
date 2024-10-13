import 'package:aacimple/models/database_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:aacimple/views/home_screen.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  // Register the adapters
  Hive.registerAdapter(DatabaseModelAdapter());
  Hive.registerAdapter(LanguageAdapter());
  Hive.registerAdapter(FromWhereAdapter());
  // await Hive.openBox('mainhivedatabase');
  // await Hive.openBox('oldhivedatabase');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the SettingsController
    final SettingsController settingsController = Get.put(SettingsController());

    return Obx(() {
      return GetMaterialApp(
        title: 'AACIMPLE',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF010080),
            foregroundColor: Colors.white,
          ),
          fontFamily: settingsController.fontFamily.value,
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: settingsController.fontSize.value),
          ),
        ),
        home: HomePage(),
      );
    });
  }
}
