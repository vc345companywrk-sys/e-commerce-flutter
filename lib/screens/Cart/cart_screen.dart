// lib/screens/Cart/cart_screen.dart
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/screens/Cart/checkout_screnn.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: "My Cart".text.color(darkFontGrey).fontFamily(bold).make(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkFontGrey),
          onPressed: () {
            // Check if we can pop the current route
            if (Navigator.of(context).canPop()) {
              Get.back();
            } else {
              // If cannot pop, navigate to home tab
              Get.find<HomeController>().changeNavIndex(0);
            }
          },
        ),
        actions: [
          Obx(
            () => cartController.cartItems.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.delete_sweep, color: darkFontGrey),
                    onPressed: () => cartController.showClearCartDialog(),
                    tooltip: 'Clear Cart',
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return _buildLoadingState();
        } else if (cartController.isCartEmpty) {
          return _buildEmptyCartState(cartController);
        } else {
          return _buildCartWithItems(cartController);
        }
      }),
      bottomNavigationBar: Obx(
        () => cartController.cartItems.isNotEmpty
            ? _buildCheckoutSection(cartController)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: redColor),
          20.heightBox,
          "Loading your cart...".text.color(darkFontGrey).make(),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState(CartController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_cart_outlined,
          size: 120,
          color: Colors.grey.withOpacity(0.5),
        ),
        30.heightBox,
        "Your cart is empty".text
            .size(22)
            .color(darkFontGrey)
            .fontFamily(bold)
            .make(),
        15.heightBox,
        "Looks like you haven't added any items to your cart yet.".text
            .color(fontGrey)
            .align(TextAlign.center)
            .make()
            .box
            .padding(EdgeInsets.symmetric(horizontal: 40))
            .make(),
        40.heightBox,
        ElevatedButton(
          onPressed: () {
            Get.find<HomeController>().changeNavIndex(0);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: redColor,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: "Start Shopping".text.white.fontFamily(bold).size(16).make(),
        ),
        20.heightBox,
        TextButton(
          onPressed: () => controller.loadCartItems(),
          child: "Reload Cart".text.color(redColor).make(),
        ),
      ],
    );
  }

  Widget _buildCartWithItems(CartController controller) {
    return Column(
      children: [
        // Location Selector
        _buildLocationSelector(controller),

        // Cart Items List
        Expanded(child: _buildCartItemsList(controller)),
      ],
    );
  }

  Widget _buildLocationSelector(CartController controller) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: redColor, size: 20),
                8.widthBox,
                "Delivery Location".text.fontFamily(bold).make(),
              ],
            ),
            8.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Home".text.color(darkFontGrey).make(),
                      4.heightBox,
                      "123 Main Street, City, State 12345".text
                          .color(fontGrey)
                          .size(12)
                          .make(),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showLocationDialog(controller);
                  },
                  child: "Change".text.color(redColor).make(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemsList(CartController controller) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: controller.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = controller.cartItems[index];
          return _buildCartItemCard(cartItem, controller);
        },
      ),
    );
  }

  Widget _buildCartItemCard(CartItem cartItem, CartController controller) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                cartItem.product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            12.widthBox,

            // Product Details - Maded this Expanded to take available space
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.heightBox,

                  Text(
                    cartItem.product.category,
                    style: TextStyle(color: fontGrey, fontSize: 12),
                  ),
                  8.heightBox,

                  // Price and Quantity Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price - Made flexible
                      Flexible(
                        child: Text(
                          '₹${cartItem.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: redColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      8.widthBox, // Added spacing
                      // Quantity Controls - Made compact
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 120,
                        ), // Limit width
                        decoration: BoxDecoration(
                          border: Border.all(color: lightGrey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrease Button
                            IconButton(
                              icon: Icon(Icons.remove, size: 14),
                              onPressed: () => controller.decreaseQuantity(
                                cartItem.product.id,
                              ),
                              padding: EdgeInsets.all(1),
                              constraints: BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              iconSize: 12,
                            ),

                            // Quantity Display
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              constraints: BoxConstraints(minWidth: 12),
                              child: Text(
                                cartItem.quantity.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                            // Increase Button
                            IconButton(
                              icon: Icon(Icons.add, size: 14),
                              onPressed: () => controller.increaseQuantity(
                                cartItem.product.id,
                              ),
                              padding: EdgeInsets.all(1),
                              constraints: BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              iconSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  1.heightBox,

                  // Item Total - Made to fit in one line
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Total:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: darkFontGrey,
                          fontSize: 14,
                        ),
                      ),
                      7.widthBox,
                      Text(
                        '₹${(cartItem.totalPrice).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: redColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove Button - Made smaller and properly spaced
            Padding(
              padding: EdgeInsets.only(left: 8), // Added spacing
              child: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 30,
                ), // Smaller icon
                onPressed: () => controller.removeFromCart(cartItem.product.id),
                padding: EdgeInsets.all(4), // Reduced padding
                constraints: BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Amount Only (Removed detailed breakdown)
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Total Amount".text
                      .color(darkFontGrey)
                      .fontFamily(bold)
                      .size(16)
                      .make(),
                  "₹${controller.totalAmount.value.toStringAsFixed(2)}".text
                      .color(redColor)
                      .fontFamily(bold)
                      .size(18)
                      .make(),
                ],
              ),
            ),

            16.heightBox,

            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => CheckoutScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, color: whiteColor),
                    10.widthBox,
                    "Proceed to Checkout".text.white
                        .fontFamily(bold)
                        .size(16)
                        .make(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationDialog(CartController controller) {
    Get.dialog(
      AlertDialog(
        title: Text("Select Delivery Location"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildLocationOption(
                "Home",
                "123 Main Street, City, State 12345",
                Icons.home,
              ),
              _buildLocationOption(
                "Office",
                "456 Business Ave, City, State 12345",
                Icons.work,
              ),
              _buildLocationOption(
                "Other",
                "Add new delivery address",
                Icons.add_location,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
        ],
      ),
    );
  }

  Widget _buildLocationOption(String title, String address, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: redColor),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(address),
      onTap: () {
        Get.back();
        Get.snackbar('Location Updated', 'Delivery location set to $title');
      },
    );
  }
}
