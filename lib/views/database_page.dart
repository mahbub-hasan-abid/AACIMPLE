import 'package:aacimple/controllers/databasea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatabaseManagementPage extends StatelessWidget {
  final DatabaseController controller = Get.put(DatabaseController());

  DatabaseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.loadMainDatabaseMessages,
                    child: const Text('Main Database'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.loadOldDatabaseMessages,
                    child: const Text('Old Messages Database'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.mainDatabaseMessages.length,
                  itemBuilder: (context, index) {
                    final message = controller.mainDatabaseMessages[index];
                    return ListTile(
                      title: Text(message.messageText),
                      subtitle: Text(message.language),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(message.messageImage),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Edit functionality here
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              controller.deleteMessageFromMain(index);
                            },
                          ),
                        ],
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
