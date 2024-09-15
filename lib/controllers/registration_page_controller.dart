import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  // Controllers for each field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController licenseCodeController = TextEditingController();

  // Observable variables for form validation
  RxBool isPasswordMatch = true.obs;
  RxBool isFormValid = false.obs;

  // Validate form fields
  void validateForm() {
    bool isEmailValid = GetUtils.isEmail(emailController.text.trim());
    bool isPasswordSame =
        passwordController.text == retypePasswordController.text;

    isPasswordMatch.value = isPasswordSame;

    isFormValid.value = nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        retypePasswordController.text.isNotEmpty &&
        isEmailValid &&
        isPasswordSame;
  }

  // Register button action
  void registerUser() {
    if (isFormValid.value) {
      // Here, integrate the backend registration logic
      Get.snackbar(
        'Success',
        'User registration successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Error',
        'Please correct the errors in the form.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Function to validate license code
  void validateLicenseCode() {
    // Add logic to verify license code here
    Get.snackbar(
      'License Verified',
      'License code is valid!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    // Dispose of controllers
    nameController.dispose();
    surnameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    mobileController.dispose();
    emailController.dispose();
    licenseCodeController.dispose();
    super.onClose();
  }
}
