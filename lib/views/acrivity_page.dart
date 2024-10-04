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
  final List<Map<String, dynamic>> activityItems = [
    {'text': '1', 'page': OneMessagePage()},
    {'text': '2', 'page': TwoMessagePage()},
    {'text': '3', 'page': ThreeMessagePage()},
    {'text': '4', 'page': FourMessagePage()},
    {'text': '6', 'page': SixMessagePage()},
    {'text': '6B', 'page': SixBMessagePage()},
    {'text': '12', 'page': TwelveMessagePage()},
    {'text': 'Back', 'page': null}, // Back button doesn't have a page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the grid
          child: LayoutBuilder(
            builder: (context, constraints) {
              double boxWidth = (constraints.maxWidth / 4) - 10;
              double boxHeight =
                  (constraints.maxHeight / 2) - 20; // Calculate box size
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center vertically
                  children: [
                    for (int i = 0; i < 2; i++) // Create two rows
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center horizontally
                        children: List.generate(4, (index) {
                          // Four items in each row
                          int itemIndex =
                              i * 4 + index; // Calculate the item index
                          if (itemIndex >= activityItems.length)
                            return Container(); // Prevent overflow

                          String text = activityItems[itemIndex]['text'];
                          Widget? page = activityItems[itemIndex]['page'];

                          return GestureDetector(
                            onTap: () {
                              if (text == 'Back') {
                                Get.back(); // Navigate back on 'Back' text
                              } else {
                                Get.to(() => page!); // Ensure page is not null
                              }
                            },
                            child: GridItem(
                              text: text,
                              height: boxHeight,
                              width: boxWidth,
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String text;
  final double height;
  final double width; // Added size parameter

  const GridItem(
      {Key? key, required this.text, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height, // Set height equal to width for a square
      margin: const EdgeInsets.symmetric(
          horizontal: 5, vertical: 5), // Add margin around items
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
