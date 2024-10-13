import 'package:aacimple/common/responsive.dart';
import 'package:aacimple/constant.dart';
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

  Widget buildTextField(String label, IconData icon,
      TextEditingController controller, BuildContext context,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        onChanged: (_) => validateForm(),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontSize: Responsive.isMobile(context)
                ? mBodyTextSize.toDouble()
                : tBodyTextSize.toDouble(),
          ),
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF010080)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow(bool isFormValid, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: Get.width * 0.4, // Set width to 60% of the screen width
          child: ElevatedButton(
            onPressed: () => registerUser(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFormValid ? const Color(0xFF010080) : Colors.grey,
            ),
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: Responsive.isMobile(context)
                    ? mBodyTextSize.toDouble()
                    : tBodyTextSize.toDouble(),
                color: isFormValid ? Colors.white : const Color(0xFF010080),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLicenseDetails(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: Get.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                // Link to PayPal for license payment
              },
              child: Text(
                'Pay License via PayPal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.isMobile(context)
                      ? mBodyTextSize.toDouble()
                      : tBodyTextSize.toDouble(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF010080)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Wrong license number? Try again or contact: sesses@cytanet.com.cy',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: Responsive.isMobile(context)
                  ? mBodyTextSize.toDouble()
                  : tBodyTextSize.toDouble(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildErrorText(String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget buildDeveloperDetails(BuildContext context) {
    return Column(
      children: [
        //SizedBox(height: 20),
        Divider(),
        Text(
          'Developers: SESAT Ltd, Cyprus',
          style: TextStyle(
            fontSize: Responsive.isMobile(context)
                ? mBodyTextSize.toDouble()
                : tBodyTextSize.toDouble(),
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          'Email: sesses@cytanet.com.cy',
          style: TextStyle(
            fontSize: Responsive.isMobile(context)
                ? mBodyTextSize.toDouble()
                : tBodyTextSize.toDouble(),
          ),
        ),
        Text(
          'Version: 1.0, All rights reserved',
          style: TextStyle(
            fontSize: Responsive.isMobile(context)
                ? mBodyTextSize.toDouble()
                : tBodyTextSize.toDouble(),
          ),
        ),
        Text(
          'Website: www.sesarab.com',
          style: TextStyle(
            fontSize: Responsive.isMobile(context)
                ? mBodyTextSize.toDouble()
                : tBodyTextSize.toDouble(),
          ),
        ),
      ],
    );
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
        'Please fill up the form correctly.',
        snackPosition: SnackPosition.TOP,
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
