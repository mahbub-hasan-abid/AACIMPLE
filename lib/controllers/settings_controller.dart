import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  var durationForPresentation = 3.0.obs;
  var showPictures = true.obs;
  var showText = true.obs;
  var listenToSound = true.obs;
  var fontColor = Colors.white.obs;
  var backgroundColor = Color(0xFF010080).obs; // Navy Blue
  var fontSize = 18.0.obs;
  var fontFamily = 'Tahoma'.obs;

  var randomize = false.obs;

  void updateDurationForPresentation(double duration) =>
      durationForPresentation.value = duration;
  void updateShowPictures(bool value) => showPictures.value = value;
  void updateShowText(bool value) => showText.value = value;
  void updateListenToSound(bool value) => listenToSound.value = value;
  void updateFontColor(Color color) => fontColor.value = color;
  void updateBackgroundColor(Color color) => backgroundColor.value = color;
  void updateFontSize(double size) => fontSize.value = size;
  void updateFontFamily(String family) => fontFamily.value = family;

  void updateRandomize(bool value) => randomize.value = value;
}
