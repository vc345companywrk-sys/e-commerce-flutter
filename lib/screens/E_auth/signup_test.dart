// lib/screens/auth/signup_screen.dart - FIX THE LAYOUT
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class SignupTest extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  SignupTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        //SafeArea for better layout
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              //Title outside the scrollable area
              Text(
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              //Expanded with SingleChildScrollView for scrollable content
              Expanded(
                child: SingleChildScrollView(
                  //Makes content scrollable
                  child: Obx(
                    () => Column(
                      children: [
                        // Name Field
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Enter your full name',
                          ),
                        ),
                        SizedBox(height: 16),

                        // Email Field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            hintText: 'example@gmail.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),

                        // Phone Field
                        TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                            hintText: '+1 234 567 8900',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 16),

                        //password Field
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'At least 6 characters',
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 16),

                        //Confirm Password Field
                        TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),

                        //error Message
                        if (authController.errorMessage.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              authController.errorMessage.value,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        SizedBox(height: 20),

                        // sign Up Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authController.isLoading.value
                                ? null
                                : () => _attemptSignup(),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.red,
                            ),
                            child: authController.isLoading.value
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                        SizedBox(height: 10),

                        // login Link
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Already have an account? Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _attemptSignup() {
    // Clear previous errors
    authController.errorMessage('');

    // Basic validation
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      authController.errorMessage('Please fill all required fields');
      return;
    }

    //Simplified email validation
    if (!emailController.text.contains('@')) {
      authController.errorMessage('Please enter a valid email address');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      authController.errorMessage('Passwords do not match');
      return;
    }

    if (passwordController.text.length < 6) {
      authController.errorMessage('Password must be at least 6 characters');
      return;
    }

    authController.signUp(
      emailController.text,
      passwordController.text,
      nameController.text,
      phoneController.text,
    );
  }
}
