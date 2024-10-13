import 'package:aacimple/common/responsive.dart';
import 'package:aacimple/constant.dart';
import 'package:aacimple/controllers/registration_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistratationPage extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  RegistratationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile
                  ? mTapBarTextSize.toDouble()
                  : tTapBarTextSize.toDouble(),
            )),
        backgroundColor: const Color(0xFF010080),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.buildTextField(
                  'Name', Icons.person, controller.nameController, context),
              controller.buildTextField('Surname', Icons.person_outline,
                  controller.surnameController, context),
              controller.buildTextField('Username', Icons.account_circle,
                  controller.usernameController, context),
              controller.buildTextField('Password', Icons.lock,
                  controller.passwordController, context,
                  isPassword: true),
              controller.buildTextField('Retype Password', Icons.lock_outline,
                  controller.retypePasswordController, context,
                  isPassword: true),
              Obx(() => controller.isPasswordMatch.value
                  ? Container()
                  : controller.buildErrorText('Passwords do not match')),
              controller.buildTextField('Mobile (Optional)', Icons.phone,
                  controller.mobileController, context),
              controller.buildTextField(
                  'Email', Icons.email, controller.emailController, context),
              controller.buildTextField('License Code', Icons.vpn_key,
                  controller.licenseCodeController, context),
              const SizedBox(height: 20),
              Obx(() => controller.buildButtonRow(
                  controller.isFormValid.value, context)),
              controller.buildLicenseDetails(context),
              const SizedBox(height: 30),
              controller.buildDeveloperDetails(context),
            ],
          ),
        ),
      ),
    );
  }
}
