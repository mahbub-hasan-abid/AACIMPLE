import 'package:aacimple/controllers/registration_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistratationPage extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  RegistratationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF010080),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.buildTextField(
                  'Name', Icons.person, controller.nameController),
              controller.buildTextField('Surname', Icons.person_outline,
                  controller.surnameController),
              controller.buildTextField('Username', Icons.account_circle,
                  controller.usernameController),
              controller.buildTextField(
                  'Password', Icons.lock, controller.passwordController,
                  isPassword: true),
              controller.buildTextField('Retype Password', Icons.lock_outline,
                  controller.retypePasswordController,
                  isPassword: true),
              Obx(() => controller.isPasswordMatch.value
                  ? Container()
                  : controller.buildErrorText('Passwords do not match')),
              controller.buildTextField('Mobile (Optional)', Icons.phone,
                  controller.mobileController),
              controller.buildTextField(
                  'Email', Icons.email, controller.emailController),
              controller.buildTextField('License Code', Icons.vpn_key,
                  controller.licenseCodeController),
              const SizedBox(height: 20),
              Obx(() =>
                  controller.buildButtonRow(controller.isFormValid.value)),
              controller.buildLicenseDetails(),
              const SizedBox(height: 30),
              controller.buildDeveloperDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
