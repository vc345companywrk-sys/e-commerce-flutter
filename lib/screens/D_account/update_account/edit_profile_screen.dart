import 'dart:io';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/screens/A_home/home.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final RxString _selectedImagePath = ''.obs;
  final RxBool _isImageChanged = false.obs;
  final RxBool _removeImageRequested = false.obs;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: authController.userName.value,
    );
    _phoneController = TextEditingController(
      text: authController.userPhone.value,
    );
    _selectedImagePath.value = authController.profileImageUrl.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      await authController.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        imagePath: _isImageChanged.value && !_removeImageRequested.value
            ? _selectedImagePath.value
            : null,
        removeImage: _removeImageRequested.value,
      );

      // Force refresh the profile data
      await authController.loadUserProfile();
      //Get.back();
      Get.to(() => Home()); // Go back to profile screen after successful update
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePath = await authController.pickImage(source);
      if (imagePath != null) {
        _selectedImagePath.value = imagePath;
        _isImageChanged.value = true;
        _removeImageRequested.value =
            false; // Reset removal if new image selected
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  void _removeImage() {
    Get.dialog(
      AlertDialog(
        title: Text("Remove Profile Image"),
        content: Text(
          "This will permanently delete your profile image from our servers. This action cannot be undone.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              _selectedImagePath.value = '';
              _isImageChanged.value = true;
              _removeImageRequested.value = true;

              Get.snackbar(
                'Image Removal',
                'Image will be permanently deleted from data when you update profile',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Permanently Delete"),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: redColor),
              title: Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: redColor),
              title: Text('Take Photo'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            if (authController.profileImageUrl.isNotEmpty ||
                _selectedImagePath.value.isNotEmpty)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Remove Current Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  _removeImage();
                },
              ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.grey),
              title: Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider<Object> _getProfileImage() {
    if (_removeImageRequested.value) {
      return AssetImage('assets/images/default_avatar.png');
    }

    if (_selectedImagePath.value.isNotEmpty) {
      if (_selectedImagePath.value.startsWith('http')) {
        return NetworkImage(_selectedImagePath.value);
      } else {
        return FileImage(File(_selectedImagePath.value));
      }
    }

    if (authController.profileImageUrl.isNotEmpty) {
      return NetworkImage(authController.profileImageUrl.value);
    }

    return AssetImage('assets/images/default_avatar.png');
  }

  String _getImageStatusText() {
    if (_removeImageRequested.value) {
      return 'Image will be removed - tap Update to save changes';
    }
    if (_isImageChanged.value && _selectedImagePath.value.isNotEmpty) {
      return 'New image selected - tap Update to save changes';
    }
    if (_isImageChanged.value && _selectedImagePath.value.isEmpty) {
      return 'No image selected - tap Update to save changes';
    }
    return 'Tap to change profile picture';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: "Edit Profile".text.color(darkFontGrey).make(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkFontGrey),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Picture Section
                    GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Stack(
                        children: [
                          Obx(
                            () => CircleAvatar(
                              radius: 50,
                              backgroundColor: lightgolden,
                              backgroundImage: _getProfileImage(),
                              child:
                                  _selectedImagePath.isEmpty &&
                                      authController.profileImageUrl.isEmpty &&
                                      !_removeImageRequested.value
                                  ? Icon(
                                      Icons.person,
                                      size: 40,
                                      color: darkFontGrey,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: redColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,
                    Obx(
                      () => _getImageStatusText().text
                          .color(
                            _isImageChanged.value ? Colors.green : Colors.grey,
                          )
                          .size(12)
                          .make(),
                    ),

                    30.heightBox,

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: whiteColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    20.heightBox,

                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        filled: true,
                        fillColor: whiteColor,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    30.heightBox,

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? CircularProgressIndicator(
                                color: whiteColor,
                                strokeWidth: 2,
                              )
                            : "Update Profile".text.white
                                  .size(16)
                                  .fontFamily(bold)
                                  .make(),
                      ),
                    ),
                    20.heightBox,

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: redColor),
                        ),
                        child: "Cancel".text.color(redColor).size(16).make(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
