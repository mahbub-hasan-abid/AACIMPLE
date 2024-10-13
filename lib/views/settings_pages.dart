import 'package:aacimple/common/responsive.dart';
import 'package:aacimple/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:aacimple/controllers/settings_controller.dart';

class GeneralSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final SettingsController controller =
        Get.put<SettingsController>(SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'General Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile
                ? mTapBarTextSize.toDouble()
                : tTapBarTextSize.toDouble(),
          ),
        ),
        backgroundColor: Color(0xFF010080),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Display Settings', context),
              _buildSettingSwitch(
                  'See Pictures on the Message Boxes',
                  Icons.image,
                  controller.showPictures,
                  controller.updateShowPictures,
                  context),
              _buildSettingSwitch(
                  'See Text on the Message Boxes',
                  Icons.text_fields,
                  controller.showText,
                  controller.updateShowText,
                  context),
              _buildSettingSwitch('Randomize Message Boxes', Icons.shuffle,
                  controller.randomize, controller.updateRandomize, context),
              SizedBox(height: 32),
              _buildSectionTitle('Audio Settings', context),
              _buildSettingSwitch(
                  'Listen to Sound from Message Boxes',
                  Icons.volume_up,
                  controller.listenToSound,
                  controller.updateListenToSound,
                  context),
              SizedBox(height: 32),
              _buildSectionTitle('Appearance Settings', context),
              _buildColorPicker(
                  'Color of Font Text on Message Boxes',
                  Icons.format_color_text,
                  controller.fontColor,
                  controller.updateFontColor,
                  context),
              _buildColorPicker(
                  'Color Background of Message Boxes',
                  Icons.format_paint,
                  controller.backgroundColor,
                  controller.updateBackgroundColor,
                  context),
              _buildFontFamilyPicker(
                'Font Family Selection',
                Icons.font_download,
                controller.fontFamily,
                controller.updateFontFamily,
              ),
              _buildSlider(
                'Size of Fonts',
                Icons.text_fields,
                controller.fontSize,
                controller.updateFontSize,
                min: 12.0,
                max: 28.0,
              ),
              _buildSlider(
                'Duration for Presentation',
                Icons.access_time,
                controller.durationForPresentation,
                controller.updateDurationForPresentation,
                min: 1.0,
                max: 60.0,
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.isMobile(context)
              ? mHeadingTextSize.toDouble()
              : tHeadingTextSize.toDouble(),
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(String title, IconData icon, RxBool observable,
      ValueChanged<bool> onChanged, BuildContext context) {
    return Obx(() => Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(icon, color: const Color(0xFF010080)),
              title: Text(
                title,
                style: TextStyle(
                    fontSize: Responsive.isMobile(context)
                        ? mBodyTextSize
                        : tBodyTextSize,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: observable.value,
                onChanged: (bool value) {
                  observable.value = value;
                  onChanged(value);
                  Get.snackbar(
                    'Setting Changed',
                    '$title has been ${value ? "enabled" : "disabled"}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blueAccent,
                    colorText: const Color.fromARGB(255, 37, 37, 37),
                    duration: Duration(seconds: 2),
                  );
                },
                activeColor: Color(0xFF010080),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey[300],
              ),
            ),
          ),
        ));
  }

  Widget _buildColorPicker(String title, IconData icon, Rx<Color> observable,
      ValueChanged<Color> onChanged, BuildContext context) {
    return Obx(() => Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(icon, color: Color(0xFF010080)),
            title: Text(title,
                style: TextStyle(
                    fontSize: Responsive.isMobile(context)
                        ? mBodyTextSize
                        : tBodyTextSize)),
            trailing: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: observable.value,
                  border: Border.all(color: Color(0xFF010080))),
              width: 40,
              height: 40,
            ),
            onTap: () async {
              Color? selectedColor =
                  await _selectColor(Get.context!, observable.value);
              if (selectedColor != null) {
                onChanged(selectedColor);
                Get.snackbar(
                  'Color Changed',
                  '$title has been updated',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.blueAccent,
                  colorText: Colors.white,
                  duration: Duration(seconds: 2),
                );
              }
            },
          ),
        ));
  }

  Future<Color?> _selectColor(BuildContext context, Color initialColor) async {
    Color selectedColor = initialColor;

    return await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Select Color',
              style: TextStyle(
                  fontSize: Responsive.isMobile(context)
                      ? mBodyTextSize
                      : tBodyTextSize,
                  fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  hexInputBar: true,
                  colorPickerWidth: Get.width * 0.3,
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    selectedColor = color;
                  },
                  enableAlpha: true,
                  displayThumbColor: true,
                  pickerAreaHeightPercent: 0.6,
                ),
                SizedBox(height: 20),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(selectedColor),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlider(String title, IconData icon, RxDouble observable,
      ValueChanged<double> onChanged,
      {double min = 0.0,
      double max = 100.0,
      Color activeColor = const Color(0xFF010080),
      Color inactiveColor = Colors.grey}) {
    return Obx(() => Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(icon, color: Color(0xFF010080)),
              title: Text('$title: ${observable.value.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              trailing: SizedBox(
                width: Get.width * 0.3,
                child: FlutterSlider(
                  values: [observable.value],
                  max: max,
                  min: min,
                  handler: FlutterSliderHandler(
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  trackBar: FlutterSliderTrackBar(
                    activeTrackBar: BoxDecoration(color: activeColor),
                    inactiveTrackBar: BoxDecoration(color: inactiveColor),
                  ),
                  tooltip: FlutterSliderTooltip(
                    textStyle: TextStyle(fontSize: 17),
                  ),
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    observable.value = lowerValue;
                    onChanged(lowerValue);
                    // Get.snackbar(
                    //   'Setting Updated',
                    //   '$title set to ${lowerValue.toStringAsFixed(1)}',
                    //   snackPosition: SnackPosition.BOTTOM,
                    //   backgroundColor: Colors.blueAccent,
                    //   colorText: Colors.white,
                    //   duration: Duration(seconds: 2),
                    // );
                  },
                ),
              ),
            ),
          ),
        ));
  }

  _buildFontFamilyPicker(String title, IconData icon, RxString observable,
      ValueChanged<String> onChanged) {
    List<String> fontFamilies = ['Tahoma', 'Calibri', 'Arial'];
    return Obx(() => Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(icon, color: Color(0xFF010080)),
            title: Text(title, style: TextStyle(fontSize: 16)),
            subtitle: Text('Selected Font: ${observable.value}',
                style: TextStyle(color: Colors.grey)),
            trailing: DropdownButton<String>(
              value: observable.value,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                  Get.snackbar(
                    'Font Changed',
                    'Font Family has been updated to $value',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blueAccent,
                    colorText: Colors.white,
                    duration: Duration(seconds: 2),
                  );
                }
              },
              items: fontFamilies.map((font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
