import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:aacimple/controllers/settings_controller.dart';
import 'package:aacimple/views/message%20_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import your details page

class DatabaseManagementPage extends StatelessWidget {
  final DatabaseController controller = Get.put(DatabaseController());
  final SettingsController settingController = Get.find<SettingsController>();

  DatabaseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust crossAxisCount based on screen width
    int crossAxisCount =
        screenWidth < 600 ? 2 : 4; // 2 items on small screens, 4 on larger

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Database Management'),
          bottom: const TabBar(
            labelColor: Colors.white, // Color for selected tab
            unselectedLabelColor: Colors.white, // Color for unselected tabs
            labelStyle: TextStyle(
              fontSize: 16.0, // Custom font size for selected tab
              fontWeight:
                  FontWeight.bold, // Custom font weight for selected tab
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0, // Custom font size for unselected tabs
            ),
            tabs: [
              Tab(text: 'Main Database'),
              Tab(
                text: 'Old Messages Database',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Main Database Tab
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: controller.mainDatabaseMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No records available',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              crossAxisCount, // Responsive cross-axis count
                          mainAxisSpacing: 16.0, // Spacing between rows
                          crossAxisSpacing: 16.0, // Spacing between columns
                          childAspectRatio:
                              1.5, // Adjust the aspect ratio for container size
                        ),
                        itemCount: controller.mainDatabaseMessages.length,
                        itemBuilder: (context, index) {
                          final message =
                              controller.mainDatabaseMessages[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to Details Page when clicked
                              // Get.to(
                              //     () => MessageDetailsPage(message: message));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: settingController.backgroundColor.value,
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                message.messageImage,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            // Old Messages Database Tab
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(16.0),
                child: controller.oldDatabaseMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No records available',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              crossAxisCount, // Responsive cross-axis count
                          mainAxisSpacing: 16.0, // Spacing between rows
                          crossAxisSpacing: 16.0, // Spacing between columns
                          childAspectRatio:
                              1.5, // Adjust the aspect ratio for container size
                        ),
                        itemCount: controller.oldDatabaseMessages.length,
                        itemBuilder: (context, index) {
                          final message = controller.oldDatabaseMessages[index];
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
                              child: Image.asset(
                                message.messageImage,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
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
