import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  var durationForPresentation = 3.0.obs;
  var showOnlyPictures = false.obs;
  var showOnlyText = false.obs;
  var listenToSound = true.obs;
  var fontColor = Colors.white.obs;
  var backgroundColor = Color(0xFF010080).obs; // Navy Blue
  var fontSize = 12.0.obs;
  var fontFamily = 'Tahoma'.obs;
  var showNothing = false.obs;
  var randomize = false.obs;
  var seeNothing = false.obs;

  void updateDurationForPresentation(double duration) =>
      durationForPresentation.value = duration;
  void updateShowPictures(bool value) => showOnlyPictures.value = value;
  void updateShowText(bool value) => showOnlyText.value = value;
  void updateListenToSound(bool value) => listenToSound.value = value;
  void updateFontColor(Color color) => fontColor.value = color;
  void updateBackgroundColor(Color color) => backgroundColor.value = color;
  void updateFontSize(double size) => fontSize.value = size;
  void updateFontFamily(String family) => fontFamily.value = family;
  void updateShowNothing(bool value) => showNothing.value = value;
  void updateRandomize(bool value) => randomize.value = value;
  void updateSeeNothing(bool value) => seeNothing.value = value;
}
