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
              _buildTextField('Name', Icons.person, controller.nameController),
              _buildTextField('Surname', Icons.person_outline,
                  controller.surnameController),
              _buildTextField('Username', Icons.account_circle,
                  controller.usernameController),
              _buildTextField(
                  'Password', Icons.lock, controller.passwordController,
                  isPassword: true),
              _buildTextField('Retype Password', Icons.lock_outline,
                  controller.retypePasswordController,
                  isPassword: true),
              Obx(() => controller.isPasswordMatch.value
                  ? Container()
                  : _buildErrorText('Passwords do not match')),
              _buildTextField('Mobile (Optional)', Icons.phone,
                  controller.mobileController),
              _buildTextField('Email', Icons.email, controller.emailController),
              _buildTextField('License Code', Icons.vpn_key,
                  controller.licenseCodeController),
              const SizedBox(height: 20),
              Obx(() => _buildButtonRow(controller.isFormValid.value)),
              // _buildForgotPassword(),
              // _buildChangeUsername(),
              // _buildChangePassword(),
              _buildLicenseDetails(),
              const SizedBox(height: 30),
              _buildDeveloperDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        onChanged: (_) => this.controller.validateForm(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF010080)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(bool isFormValid) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: Get.width * 0.4, // Set width to 60% of the screen width
          child: ElevatedButton(
            onPressed: () => controller.registerUser(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFormValid ? const Color(0xFF010080) : Colors.grey,
            ),
            child: Text(
              'Register',
              style: TextStyle(
                color: isFormValid ? Colors.white : const Color(0xFF010080),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildForgotPassword() {
  //   return Column(
  //     children: [
  //       SizedBox(height: 20),
  //       TextButton(
  //         onPressed: () {
  //           // Forgot password logic
  //         },
  //         child: Text('Forgot Password?',
  //             style: TextStyle(color: Color(0xFF010080))),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildChangePassword() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildTextField(
  //           'New Password', Icons.lock, controller.passwordController,
  //           isPassword: true),
  //       _buildTextField('Confirm Password', Icons.lock_outline,
  //           controller.retypePasswordController,
  //           isPassword: true),
  //       SizedBox(height: 20),
  //       ElevatedButton(
  //         onPressed: () {
  //           // Change password logic
  //         },
  //         child: Text('Change Password'),
  //         style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF010080)),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildChangeUsername() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildTextField('New Username', Icons.account_circle,
  //           controller.usernameController),
  //       _buildTextField('Confirm Username', Icons.account_circle_outlined,
  //           controller.usernameController),
  //       SizedBox(height: 20),
  //       ElevatedButton(
  //         onPressed: () {
  //           // Change username logic
  //         },
  //         child: Text('Change Username'),
  //         style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF010080)),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLicenseDetails() {
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
              child: const Text(
                'Pay License via PayPal',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF010080)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Wrong license number? Try again or contact: sesses@cytanet.com.cy',
            style: TextStyle(color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorText(String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildDeveloperDetails() {
    return const Column(
      children: [
        //SizedBox(height: 20),
        Divider(),
        Text(
          'Developers: SESAT Ltd, Cyprus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // Text(
        //   'J',
        //   style: TextStyle(fontFamily: 'ARIAL'),
        // ),
        // Text(
        //   'J',
        //   style: TextStyle(fontFamily: 'Tahoma'),
        // ),
        // Text(
        //   'J',
        //   style: TextStyle(fontFamily: 'calibri'),
        // ),
        Text('Email: sesses@cytanet.com.cy'),
        Text('Version: 1.0, All rights reserved'),
        Text('Website: www.sesarab.com'),
      ],
    );
  }
}
