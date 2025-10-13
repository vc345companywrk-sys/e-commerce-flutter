// lib/controllers/auth_controller.dart
import 'dart:io';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/screens/A_home/home.dart';
import 'package:ecommerce_app/screens/E_auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isLoggedIn = false.obs;
  final userEmail = ''.obs;
  final userName = ''.obs;
  final userPhone = ''.obs;
  final profileImageUrl = ''.obs;
  final createdAt = Rx<DateTime?>(null);
  final updatedAt = Rx<DateTime?>(null);

  // Proper Supabase client reference
  SupabaseClient get supabase => Supabase.instance.client;
  bool _isProcessingAuth = false; // Add this flag

  @override
  void onInit() {
    super.onInit();
    print('AuthController initialized');
    //checkCurrentUser();
    //setupAuthListener();
    _initializeAuth();
  }

  // Initialize authentication with proper state handling
  Future<void> _initializeAuth() async {
    try {
      isLoading(true);

      // Wait for Supabase to initialize
      await Future.delayed(Duration(milliseconds: 500));

      await checkCurrentUser();
      setupAuthListener();
    } catch (e) {
      print('Auth initialization error: $e');
    } finally {
      isLoading(false);
    }
  }

  //ENHANCED: Auth state listener
  void setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((AuthState data) {
      if (_isProcessingAuth || _isSigningUp) {
        print('Skipping auth state change during manual process');
        return;
      }

      print('Auth state changed: ${data.event}');

      if (data.event == AuthChangeEvent.signedIn) {
        _handleSuccessfulSignIn();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _handleSignOut();
      } else if (data.event == AuthChangeEvent.tokenRefreshed) {
        print('Token refreshed');
      } else if (data.event == AuthChangeEvent.userUpdated) {
        print('User updated');
      }
    });
  }

  void _handleSuccessfulSignIn() {
    isLoggedIn(true);
    final currentUser = supabase.auth.currentUser;
    userEmail(currentUser?.email ?? '');
    print('User signed in: ${userEmail.value}');

    // Load profile and navigate
    loadUserProfile().then((_) {
      if (Get.currentRoute != '/home') {
        Get.offAllNamed('/home');
      }
    });
  }

  void _handleSignOut() {
    isLoggedIn(false);
    userEmail('');
    userName('');
    userPhone('');
    profileImageUrl('');
    createdAt(null);
    updatedAt(null);

    print('User signed out');

    if (Get.currentRoute != '/login') {
      Get.offAllNamed('/login');
    }
  }

  // ADD THIS METHOD TO YOUR AUTH CONTROLLER
  void navigateBasedOnAuthState() {
    if (isLoggedIn.value) {
      // Ensure we're not already on home screen
      if (Get.currentRoute != '/home') {
        print('Navigating to HomeScreen');
        Get.offAll(() => Home());
      }
    } else {
      // Ensure we're not already on login screen
      if (Get.currentRoute != '/login') {
        print('Navigating to LoginScreen');
        Get.offAll(() => LoginScreen());
      }
    }
  }

  // Sign in with proper navigation
  Future<bool> signIn(String email, String password) async {
    _isProcessingAuth = true;
    isLoading(true);
    errorMessage('');

    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Please enter both email and password');
      }

      if (!email.contains('@')) {
        throw Exception('Please enter a valid email address');
      }

      print('Attempting login for: $email');

      final response = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user != null) {
        print('Login successful for: $email');

        // Update local state first
        isLoggedIn(true);
        userEmail(response.user!.email ?? '');

        //Load profile data
        await loadUserProfile();

        navigateBasedOnAuthState();

        //Clear any previous routes and navigate to home
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => Home());
        });

        Get.snackbar('Success', 'Welcome back!');
        return true;
      } else {
        throw Exception('Login failed - no user returned');
      }
    } catch (e) {
      print('Login error: $e');
      handleError(e);
      return false;
    } finally {
      isLoading(false);
      _isProcessingAuth = false;
    }
  }

  //Check current user with better error handling
  Future<void> checkCurrentUser() async {
    try {
      final currentUser = supabase.auth.currentUser;
      print('Checking current user: ${currentUser?.email}');

      if (currentUser != null) {
        isLoggedIn(true);
        userEmail(currentUser.email ?? '');
        print('User already logged in: ${userEmail.value}');

        // Load user profile data
        await loadUserProfile();

        // Navigate to home if not already there
        if (Get.currentRoute != '/home') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/home');
          });
        }
      } else {
        print('No user logged in');
        isLoggedIn(false);

        // Navigate to login if not already there
        if (Get.currentRoute != '/login') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/login');
          });
        }
      }
    } catch (e) {
      print('Error checking current user: $e');
      isLoggedIn(false);
    }
  }

  bool _isSigningUp = false;

  Future<void> signUp(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    _isSigningUp = true;
    isLoading(true);
    errorMessage('');

    try {
      if (email.isEmpty) {
        throw Exception('Please enter an email address');
      }

      if (!email.contains('@')) {
        throw Exception('Email must contain @ symbol');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      if (name.isEmpty) {
        throw Exception('Please enter your name');
      }

      print('📝 Attempting sign up for: $email');

      final authResponse = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      if (authResponse.user != null) {
        print('Auth user created for: $email');

        await createUserProfile(
          userId: authResponse.user!.id,
          name: name.trim(),
          phone: phone.trim(),
          email: email.trim(),
        );

        print('User profile created with name and phone');

        Get.snackbar(
          'Success',
          'Account created successfully! Please check your email to verify.',
        );

        //Get.offAllNamed('/home');
        Get.offAll(() => Home());
      } else {
        throw Exception('User creation failed');
      }
    } catch (e) {
      print('Sign up error: $e');
      handleError(e);
    } finally {
      isLoading(false);
      _isSigningUp = false;
    }
  }

  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      print('Attempting to create profile for user: $userId');

      // final response = await supabase.from('user_profiles').upsert({
      //   'id': userId,
      //   'name': name,
      //   'phone': phone,
      //   'email': email,
      // });
      await supabase.from('user_profiles').upsert({
        'id': userId,
        'name': name,
        'phone': phone,
        'email': email,
      });

      print('User profile upsert completed');

      final verifyResponse = await supabase
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (verifyResponse != null) {
        print('🎉 Profile verified successfully: ${verifyResponse['name']}');
      } else {
        print('Profile verification failed');
      }
    } catch (e) {
      print('Profile creation error: $e');
      if (e.toString().contains('duplicate key')) {
        print('Profile already exists - this is expected during signup');
        return;
      }
      throw Exception('Failed to create user profile: $e');
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return;

      final response = await supabase
          .from('user_profiles')
          .select(
            'name, phone, email, profile_image_url, created_at, updated_at',
          )
          .eq('id', currentUser.id)
          .maybeSingle();

      if (response != null) {
        userName(response['name'] ?? '');
        userPhone(response['phone'] ?? '');
        userEmail(response['email'] ?? currentUser.email ?? '');
        profileImageUrl(response['profile_image_url'] ?? '');

        // Parse dates
        if (response['created_at'] != null) {
          createdAt(DateTime.parse(response['created_at']));
        }
        if (response['updated_at'] != null) {
          updatedAt(DateTime.parse(response['updated_at']));
        }

        print('User profile loaded: ${userName.value}');
      } else {
        print('No user profile exists yet for this user');
        await createProfileForExistingUser(currentUser);
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> createProfileForExistingUser(User user) async {
    try {
      await supabase.from('user_profiles').insert({
        'id': user.id,
        'name': 'User',
        'phone': '',
        'email': user.email ?? '',
      });
      print('Created default profile for existing user');
    } catch (e) {
      print('Error creating default profile: $e');
    }
  }

  Future<void> signOut() async {
    try {
      print('Attempting sign out');
      await supabase.auth.signOut();
      Get.snackbar('Success', 'Logged out successfully!');
    } catch (e) {
      print('Sign out error: $e');
      Get.snackbar('Error', 'Logout failed: ${e.toString()}');
    }
  }

  // UPDATE PROFILE METHOD WITH IMAGE REMOVAL SUPPORT
  Future<void> updateProfile({
    required String name,
    required String phone,
    String? imagePath,
    bool removeImage = false,
  }) async {
    try {
      isLoading(true);
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      Map<String, dynamic> updateData = {
        'id': currentUser.id,
        'name': name.trim(),
        'phone': phone.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Handle image removal (delete from storage + database)
      if (removeImage) {
        await deleteProfileImageFromStorage(); // Delete from storage
        updateData['profile_image_url'] = null; // Remove from database
        profileImageUrl(''); // Clear local state
      }
      // Handle new image upload (delete old ones first)
      else if (imagePath != null && imagePath.isNotEmpty) {
        // Delete existing images before uploading new one
        await deleteProfileImageFromStorage();

        print('Starting new image upload...');
        final uploadedImageUrl = await uploadProfileImage(imagePath);
        updateData['profile_image_url'] = uploadedImageUrl;
        profileImageUrl(uploadedImageUrl); // Update local state
      }

      // Update profile in database
      await supabase.from('user_profiles').upsert(updateData);

      // Update other local states
      userName(name);
      userPhone(phone);

      Get.snackbar(
        'Success',
        removeImage
            ? 'Profile image removed completely!'
            : 'Profile updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Profile update error: $e');
      handleError(e);
    } finally {
      isLoading(false);
    }
  }

  //UPLOAD METHOD WITH USER FOLDER
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }

      // Create user-specific folder structure: user_id/timestamp.jpg
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${currentUser.id}/$fileName';

      // Upload to Supabase Storage
      await supabase.storage
          .from('profile-images')
          .upload(filePath, file, fileOptions: FileOptions(upsert: false));

      // Get public URL
      final String imageUrl = supabase.storage
          .from('profile-images')
          .getPublicUrl(filePath);

      print('Image uploaded to: $filePath');
      print('Public URL: $imageUrl');

      return imageUrl;
    } catch (e) {
      print('Image upload error: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  // Add to your AuthController class
  File? get profileImageFile {
    if (profileImageUrl.value.isEmpty) return null;
    if (profileImageUrl.value.startsWith('http')) return null;
    return File(profileImageUrl.value);
  }

  // Enhanced image picker method
  Future<String?> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        return image.path;
      }
      return null;
    } catch (e) {
      print('Image pick error: $e');
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
      return null;
    }
  }

  //GET ALL PROFILE IMAGES FOR CURRENT USER (to find files to delete)
  Future<List<String>> getUserProfileImages() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return [];

      // List all files in the user's folder
      final files = await supabase.storage
          .from('profile-images')
          .list(path: currentUser.id);

      return files.map((file) => file.name).toList();
    } catch (e) {
      print('Error listing user images: $e');
      return [];
    }
  }

  // DELETE PROFILE IMAGE FROM STORAGE BUCKET
  Future<void> deleteProfileImageFromStorage() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      // Get all images for this user
      final userImages = await getUserProfileImages();

      if (userImages.isEmpty) {
        print('No profile images found to delete');
        return;
      }

      // Delete all images in the user's folder
      for (final imageName in userImages) {
        final filePath = '${currentUser.id}/$imageName';
        await supabase.storage.from('profile-images').remove([filePath]);
        print('Deleted image: $filePath');
      }

      print('All profile images deleted from storage');
    } catch (e) {
      print('Error deleting images from storage: $e');
      // Don't throw here - we still want to remove the database reference
    }
  }

  // REMOVE PROFILE IMAGE
  Future<void> removeProfileImage() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      // 1. First, delete the actual image files from storage
      await deleteProfileImageFromStorage();

      // 2. Then update database to remove profile image URL
      await supabase.from('user_profiles').upsert({
        'id': currentUser.id,
        'profile_image_url': null,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // 3. Update local state
      profileImageUrl('');

      print('Profile image completely removed (database + storage)');
    } catch (e) {
      print('Error removing profile image: $e');
      throw Exception('Failed to remove profile image: $e');
    }
  }

  //CHANGE PASSWORD
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      // Validation
      if (newPassword != confirmPassword) {
        throw Exception('New passwords do not match');
      }

      if (newPassword.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // For Supabase, we need to re-authenticate then update password
      final currentUser = supabase.auth.currentUser;
      if (currentUser?.email == null) {
        throw Exception('User not found');
      }

      // Re-authenticate with current password
      final authResponse = await supabase.auth.signInWithPassword(
        email: currentUser!.email!,
        password: currentPassword,
      );

      if (authResponse.user != null) {
        // Update password
        await supabase.auth.updateUser(UserAttributes(password: newPassword));

        Get.snackbar('Success', 'Password updated successfully!');
      } else {
        throw Exception('Current password is incorrect');
      }
    } catch (e) {
      print('Password change error: $e');
      handleError(e);
    }
  }

  //GET USER CREATION INFO
  String getAccountAge() {
    if (createdAt.value == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(createdAt.value!);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else {
      return 'Today';
    }
  }

  void handleError(dynamic e) {
    String errorMessage = e.toString();

    if (e is AuthException) {
      errorMessage = e.message;
    } else if (errorMessage.contains('invalid_credentials')) {
      errorMessage = 'Invalid email or password';
    } else if (errorMessage.contains('User already registered')) {
      errorMessage = 'This email is already registered';
    } else if (errorMessage.contains('email_address_invalid')) {
      errorMessage = 'Please enter a valid email address';
    }

    this.errorMessage(errorMessage.replaceAll('Exception: ', ''));
    Get.snackbar('Error', this.errorMessage.value);
  }
}
