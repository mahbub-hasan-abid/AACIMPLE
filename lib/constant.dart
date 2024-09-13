import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Rx width = Get.width.obs;
Rx height = Get.height.obs;
// Rx measure = width.value > height.value ? width : height;
Rx mainBgColor = Color(0xFF434261).obs;

///
final primaryColor = Color(0xFF010080);
