import 'package:aacimple/views/Activity/four_message_page.dart';
import 'package:aacimple/views/Activity/one_message_page.dart';
import 'package:aacimple/views/Activity/six_b_message_page.dart';
import 'package:aacimple/views/Activity/six_message_page.dart';
import 'package:aacimple/views/Activity/three_message_page.dart';
import 'package:aacimple/views/Activity/twelve_message_page.dart';
import 'package:aacimple/views/Activity/two_message_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 300),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              int crossAxisCount = 4; // Responsive grid

              return Padding(
                padding:
                    const EdgeInsets.all(10), // Ensure const where applicable
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        crossAxisCount, // Set this dynamically elsewhere
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1, // Keeps grid items square
                  ),
                  itemCount: 8, // Number of grid items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() =>
                                OneMessagePage()); // Ensure OneMessagePage exists
                            break;
                          case 1:
                            Get.to(() =>
                                TwoMessagePage()); // Ensure TwoMessagePage exists
                            break;
                          case 2:
                            Get.to(() =>
                                ThreeMessagePage()); // Navigate to another page or perform another action
                            break;
                          case 3:
                            Get.to(() => FourMessagePage()); // Another case
                            break;
                          case 4:
                            Get.to(
                                () => SixMessagePage()); // Handle other cases
                            break;
                          case 5:
                            Get.to(
                                () => SixBMessagePage()); // Handle other cases
                            break;
                          case 6:
                            Get.to(() =>
                                TwelveMessagePage()); // Handle other cases
                            break;
                          case 7:
                            Get.back(); // Handle other cases
                            break;

                          default:
                            break;
                        }
                      },
                      child: GridItem(
                        text: getGridItemText(
                            index), // Custom widget to show grid item text
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Text to display in each grid item
  String getGridItemText(int index) {
    switch (index) {
      case 0:
        return '1';
      case 1:
        return '2';
      case 2:
        return '3';
      case 3:
        return '4';
      case 4:
        return '6';
      case 5:
        return '6B';
      case 6:
        return '12';
      case 7:
        return 'Back';
      default:
        return '';
    }
  }
}

class GridItem extends StatelessWidget {
  final String text;

  const GridItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
