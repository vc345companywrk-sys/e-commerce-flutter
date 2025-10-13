import 'package:ecommerce_app/common_widgets/update_account/build_action_tile.dart';
import 'package:ecommerce_app/common_widgets/update_account/build_info_tile.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/screens/D_account/update_account/edit_profile_screen.dart';
import 'package:ecommerce_app/screens/D_account/update_account/logout_dialog.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/consts/consts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.loadUserProfile();
    });
  }

  void _showLogoutDialog() {
    showAppDialog(
      context: context,
      title: "Logout",
      message: "Are you sure you want to logout?",
      confirmText: "Logout",
      onConfirm: () async {
        await authController.signOut();
      },
    );
  }

  String _getFormattedJoinDate() {
    if (authController.createdAt.value == null) return 'Unknown';
    final date = authController.createdAt.value!;
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: "My Profile".text.color(darkFontGrey).make(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: redColor),
            onPressed: () {
              Get.to(() => EditProfileScreen());
            },
          ),
        ],
      ),
      body: Obx(() {
        return authController.isLoading.value
            ? Center(child: CircularProgressIndicator(color: redColor))
            : SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Profile Header
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Profile Image with fallback
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: lightGrey,
                                  backgroundImage:
                                      authController.profileImageUrl.isNotEmpty
                                      ? NetworkImage(
                                          authController.profileImageUrl.value,
                                        )
                                      : null,
                                  child: authController.profileImageUrl.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 40,
                                          color: darkFontGrey,
                                        )
                                      : null,
                                ),
                                if (authController.profileImageUrl.isNotEmpty)
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
                                        Icons.check_circle,
                                        size: 16,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            20.widthBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authController.userName.value.isNotEmpty
                                      ? authController.userName.value.text
                                            .size(18)
                                            .fontFamily(bold)
                                            .color(darkFontGrey)
                                            .make()
                                      : "No Name".text
                                            .size(18)
                                            .fontFamily(bold)
                                            .color(Colors.grey)
                                            .make(),
                                  5.heightBox,
                                  authController.userEmail.value.isNotEmpty
                                      ? authController.userEmail.value.text
                                            .color(darkFontGrey)
                                            .make()
                                      : "No Email".text
                                            .color(Colors.grey)
                                            .make(),
                                  10.heightBox,
                                  authController.userPhone.value.isNotEmpty
                                      ? authController.userPhone.value.text
                                            .color(darkFontGrey)
                                            .make()
                                      : "No Phone Number".text
                                            .color(Colors.grey)
                                            .make(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      20.heightBox,

                      // Account Information Section
                      "Account Information".text
                          .size(16)
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .make()
                          .box
                          .alignTopLeft
                          .make(),
                      15.heightBox,

                      Column(
                        children: [
                          buildInfoTile(
                            "Member Since",
                            _getFormattedJoinDate(),
                          ),
                          Divider(height: 1),
                          buildInfoTile(
                            "Account Age",
                            authController.getAccountAge(),
                          ),
                          Divider(height: 1),
                          buildInfoTile(
                            "Account Status",
                            "Active",
                            valueColor: Colors.green,
                          ),
                        ],
                      ).box.white.shadowXs.roundedSM.make(),
                      20.heightBox,

                      // Actions Section
                      Column(
                        children: [
                          buildActionTile(Icons.shopping_bag, "My Orders", () {
                            //Get.to(() => OrdersScreen());
                          }),
                          Divider(height: 1),
                          buildActionTile(
                            Icons.location_on,
                            "My Addresses",
                            () {
                              //Get.to(() => AddressScreen());
                            },
                          ),
                          Divider(height: 1),
                          buildActionTile(Icons.favorite, "My Wishlist", () {
                            //Get.to(() => WishlistScreen());
                          }),
                          Divider(height: 1),
                          buildActionTile(Icons.settings, "Settings", () {
                            //Get.to(() => SettingsScreen());
                          }),
                          Divider(height: 1),
                          buildActionTile(Icons.lock, "Change Password", () {
                            _showChangePasswordDialog();
                          }),
                        ],
                      ).box.white.roundedSM.shadowXs.make(),

                      30.heightBox,

                      // Logout Button
                      SizedBox(
                        width: context.screenWidth - 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redColor,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _showLogoutDialog,
                          child: "Logout".text.white
                              .size(16)
                              .fontFamily(bold)
                              .make(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  void _showChangePasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: "Change Password".text.color(darkFontGrey).make(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
            ),
            10.heightBox,
            TextField(
              controller: newController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
            ),
            10.heightBox,
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: "Cancel".text.color(darkFontGrey).make(),
          ),
          ElevatedButton(
            onPressed: () async {
              await authController.changePassword(
                currentPassword: currentController.text,
                newPassword: newController.text,
                confirmPassword: confirmController.text,
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: redColor),
            child: "Update Password".text.white.make(),
          ),
        ],
      ),
    );
  }

  // In your ProfileScreen class, add this method
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when screen becomes visible again
    authController.loadUserProfile();
  }

  // // Or use this approach with GetX lifecycle
  // @override
  // void onReady() {
  //   super.onReady();
  //   // Refresh when screen is ready
  //   authController.loadUserProfile();
  // }
}
