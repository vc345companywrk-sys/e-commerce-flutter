import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/screens/Cart/cart_screen.dart';
import 'package:ecommerce_app/screens/B_category/categories_screen.dart';
import 'package:ecommerce_app/screens/A_home/home_screen.dart';
import 'package:ecommerce_app/screens/D_account/update_account/profile_screen.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    //for bottomNavigation Bar
    var navBarItem = [
      // Home Screen
      BottomNavigationBarItem(
        icon: Obx(
          () => Image.asset(
            icHome,
            width: 25,
            color: controller.currentNavIndex.value == 0
                ? redColor
                : darkFontGrey,
          ),
        ),
        label: home,
      ),
      // Category Screen
      BottomNavigationBarItem(
        icon: Obx(
          () => Image.asset(
            icCategories,
            width: 25,
            color: controller.currentNavIndex.value == 1
                ? redColor
                : darkFontGrey,
          ),
        ),
        label: categories,
      ),
      // Cart Screen
      BottomNavigationBarItem(
        icon: Stack(
          children: [
            Obx(
              () => Image.asset(
                icCart,
                width: 25,
                color: controller.currentNavIndex.value == 2
                    ? redColor
                    : darkFontGrey,
              ),
            ),
            Obx(
              () => controller.cartItemsCount.value > 0
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: redColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(minWidth: 16, maxWidth: 16),
                        child: Text(
                          controller.cartItemsCount.value.toString(),
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        label: cart,
      ),
      // Profile Screen
      BottomNavigationBarItem(
        icon: Obx(
          () => Image.asset(
            icProfile,
            width: 25,
            color: controller.currentNavIndex.value == 3
                ? redColor
                : darkFontGrey,
          ),
        ),
        label: account,
      ),
    ];

    var navBody = [
      const HomeScreen(),
      const CategoriesScreen(),
      const CartScreen(),
      //AccountScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: Obx(() => navBody.elementAt(controller.currentNavIndex.value)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value, //after using Obx
          selectedItemColor: redColor,
          unselectedItemColor: darkFontGrey,
          selectedLabelStyle: const TextStyle(fontFamily: semibold),
          unselectedLabelStyle: const TextStyle(fontFamily: regular),
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: navBarItem,
          onTap: (value) {
            //controller.currentNavIndex.value = value;
            controller.currentNavIndex(value);
          },
        ),
      ),
    );
  }
}
