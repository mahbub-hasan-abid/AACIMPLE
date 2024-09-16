import 'package:aacimple/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:aacimple/views/home_screen.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// var aaa= getApplicationDocumentsDirectory();

  // Initialize Hive and open boxes
  // final appDocumentDirectory = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDirectory.path);
  await initHive();

  // Lock device orientation to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  // Run the app
  runApp(const MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();

  // Ensure that the box is opened only once
  // if (!Hive.isBoxOpen('mainDatabase')) {
  //   await Hive.openBox('mainDatabase');
  // }

  // if (!Hive.isBoxOpen('oldMessagesDatabase')) {
  //   await Hive.openBox('oldMessagesDatabase');
  // }
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
