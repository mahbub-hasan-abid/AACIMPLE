import 'package:aacimple/constant.dart';
import 'package:aacimple/models/home_screen_button_model.dart';
import 'package:aacimple/views/acrivity_page.dart';
import 'package:aacimple/views/create_new_message_page.dart';
import 'package:aacimple/views/database_page.dart';

import 'package:aacimple/views/registration_page.dart';
import 'package:aacimple/views/settings_pages.dart';
import 'package:aacimple/views/utils/home_button_cointainer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

import 'package:hive/hive.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: mainBgColor.value,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double containerWidth = constraints.maxWidth / 3 - 16;
            double containerHeight = containerWidth * 0.6;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: containerWidth / containerHeight,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => GeneralSettingsPage());
                    },
                    child: HomeButtonContainer(
                      homeButtonModel: HomeButtonModel(
                        icon: const Icon(Icons.settings),
                        label: "Settings",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RegistratationPage());
                    },
                    child: HomeButtonContainer(
                      homeButtonModel: HomeButtonModel(
                        icon: const Icon(Icons.app_registration),
                        label: "Registration and Licence",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => MessageInputPage());
                    },
                    child: HomeButtonContainer(
                      homeButtonModel: HomeButtonModel(
                        icon: const Icon(Icons.message_rounded),
                        label: "Create New Message ",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => DatabaseManagementPage());
                    },
                    child: HomeButtonContainer(
                      homeButtonModel: HomeButtonModel(
                        icon: const Icon(Icons.data_saver_off_outlined),
                        label: "Database Management",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ActivityPage());
                    },
                    child: HomeButtonContainer(
                      homeButtonModel: HomeButtonModel(
                        icon: const Icon(Icons.attractions_rounded),
                        label: " Activity",
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
