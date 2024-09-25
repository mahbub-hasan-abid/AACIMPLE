import 'dart:io';

import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:aacimple/models/database_model.dart';
import 'package:aacimple/views/message%20_details_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatabaseManagementPage extends StatelessWidget {
  final DatabaseController controller = Get.put(DatabaseController());
  final SettingsController settingController = Get.find<SettingsController>();

  DatabaseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust crossAxisCount based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : 4;

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Database Management'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0,
            ),
            tabs: [
              Tab(text: 'Main Database'),
              Tab(text: 'Old Messages Database'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Main Database Tab
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: controller.mainHiveDatabaseMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No records available',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: controller.mainHiveDatabaseMessages.length,
                        itemBuilder: (context, index) {
                          final message =
                              controller.mainHiveDatabaseMessages[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to Details Page when clicked
                              Get.to(
                                  () => MessageDetailsPage(message: message));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      settingController.backgroundColor.value,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Image.file(
                                  File(message.messageImage),
                                  fit: BoxFit.scaleDown,
                                )),
                          );
                        },
                      ),
              ),
            ),
            // Old Messages Database Tab
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(16.0),
                child: controller.oldHiveDatabaseMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No records available',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: controller.oldHiveDatabaseMessages.length,
                        itemBuilder: (context, index) {
                          final message =
                              controller.oldHiveDatabaseMessages[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to Details Page when clicked
                              Get.to(
                                  () => MessageDetailsPage(message: message));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Image.file(
                                  File(message.messageImage),
                                  fit: BoxFit.scaleDown,
                                )),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
