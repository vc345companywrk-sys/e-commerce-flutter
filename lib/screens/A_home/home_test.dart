// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class HomeTest extends StatelessWidget {
  HomeTest({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 20),
            Text(
              'Authentication Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Obx(() => Text('Logged in as: ${authController.userEmail.value}')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.snackbar('Info', 'Products feature coming soon!');
              },
              child: Text('View Products'),
            ),
          ],
        ),
      ),
    );
  }
}
