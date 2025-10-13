// lib/screens/checkout/checkout_screen.dart
import 'package:ecommerce_app/common_widgets/bg_auth.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/screens/A_home/home.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return bgAuth(
      child: Scaffold(
        appBar: AppBar(
          title: "Checkout".text.color(darkFontGrey).fontFamily(bold).make(),
          backgroundColor: lightGrey,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: darkFontGrey),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Section
              _buildOrderSummarySection(),

              20.heightBox,

              // Delivery Address Section
              _buildDeliveryAddressSection(),

              20.heightBox,

              // Payment Method Section
              _buildPaymentMethodSection(),

              20.heightBox,

              // Price Breakdown Section
              _buildPriceBreakdownSection(),
            ],
          ),
        ),
        bottomNavigationBar: _buildPlaceOrderButton(),
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Order Summary".text.size(18).fontFamily(bold).make(),
            16.heightBox,
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset(
                      item.product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.product.name,
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text(
                      '\₹${(item.totalPrice).toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddressSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Delivery Address".text.size(18).fontFamily(bold).make(),
                TextButton(
                  onPressed: () {
                    // Navigate to address selection
                  },
                  child: "Change".text.color(redColor).make(),
                ),
              ],
            ),
            12.heightBox,
            Row(
              children: [
                Icon(Icons.location_on, color: redColor, size: 20),
                8.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Home".text.color(darkFontGrey).make(),
                      4.heightBox,
                      "123 Main Street, City, State 12345".text
                          .color(fontGrey)
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Payment Method".text.size(18).fontFamily(bold).make(),
                TextButton(
                  onPressed: () {
                    // Navigate to payment method selection
                  },
                  child: "Change".text.color(redColor).make(),
                ),
              ],
            ),
            12.heightBox,
            Row(
              children: [
                Icon(Icons.credit_card, color: redColor, size: 20),
                8.widthBox,
                Text(
                  "Credit Card ending in 1234",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            "Price Breakdown".text.size(18).fontFamily(bold).make(),
            16.heightBox,
            Obx(
              () => Column(
                children: [
                  _buildPriceRow('Subtotal', cartController.totalAmount.value),
                  _buildPriceRow('Shipping', 9.99),
                  _buildPriceRow('Tax', cartController.totalAmount.value * 0.1),
                  Divider(thickness: 1),
                  _buildPriceRow(
                    'Total Amount',
                    cartController.totalAmount.value +
                        9.99 +
                        (cartController.totalAmount.value * 0.1),
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? darkFontGrey : fontGrey,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '\₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isTotal ? redColor : darkFontGrey,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
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
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              _placeOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: "Place Order".text.white.fontFamily(bold).size(16).make(),
          ),
        ),
      ),
    );
  }

  void _placeOrder() {
    // Implement order placement logic
    Get.dialog(
      AlertDialog(
        title: Text("Confirm Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag, size: 50, color: Colors.green),
            16.heightBox,
            "Are you sure you want to place this order?".text
                .align(TextAlign.center)
                .make(),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAll(() => OrderConfirmationScreen());
            },
            style: ElevatedButton.styleFrom(backgroundColor: redColor),
            child: "Place Order".text.white.make(),
          ),
        ],
      ),
    );
  }
}

// Simple Order Confirmation Screen
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var cartController = Get.put(CartController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.off(() => Home());
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: lightGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            20.heightBox,
            "Order Placed Successfully!".text.size(24).fontFamily(bold).make(),
            10.heightBox,
            "Thank you for your purchase".text.color(fontGrey).make(),
            30.heightBox,
            ElevatedButton(
              onPressed: () {
                //Get.offAll(() => Home());
                //Get.find<CartController>().clearCart();
                cartController.clearCart();
                //Get.offAllNamed('/home');
                Get.offAll(() => Home());
              },
              child: "Continue Shopping".text.make(),
            ),
          ],
        ),
      ),
    );
  }
}
