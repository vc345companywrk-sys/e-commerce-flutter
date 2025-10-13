// lib/controllers/cart_controller.dart
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.0.obs;
  var totalItems = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  void loadCartItems() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 1), () {
      cartItems.assignAll([
        CartItem(
          product: Product(
            id: '1',
            name: 'MacBook Pro M2',
            price: 1299.99,
            image: imgP1,
            category: 'Laptops',
            description: 'Apple MacBook Pro with M2 chip, 13-inch',
            inStock: true,
          ),
          quantity: 1,
        ),
        CartItem(
          product: Product(
            id: '2',
            name: 'Wireless Headphones',
            price: 199.99,
            image: imgP2,
            category: 'Audio',
            description: 'Noise cancelling wireless headphones',
            inStock: true,
          ),
          quantity: 2,
        ),
      ]);
      calculateTotals();
      isLoading.value = false;
    });
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Create new list with updated item to trigger reactivity
      final updatedItems = List<CartItem>.from(cartItems);
      updatedItems[existingItemIndex] = CartItem(
        product: product,
        quantity: updatedItems[existingItemIndex].quantity + quantity,
      );
      cartItems.value = updatedItems;
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }

    calculateTotals();
    updateHomeCartCount();
    Get.snackbar(
      'Added to Cart',
      '${product.name} added to your cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeFromCart(String productId) {
    //cartItems.removeWhere((item) => item.product.id == productId);
    calculateTotals();
    updateHomeCartCount();
    _showRemoveDialog(productId);
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = cartItems.indexWhere(
      (item) => item.product.id == productId,
    );
    if (itemIndex >= 0) {
      // Create new list with updated item to trigger reactivity
      final updatedItems = List<CartItem>.from(cartItems);
      updatedItems[itemIndex] = CartItem(
        product: updatedItems[itemIndex].product,
        quantity: newQuantity,
      );
      cartItems.value = updatedItems;
      calculateTotals();
      updateHomeCartCount();
    }
  }

  void increaseQuantity(String productId) {
    final itemIndex = cartItems.indexWhere(
      (item) => item.product.id == productId,
    );
    if (itemIndex >= 0) {
      // Create new list with updated item to trigger reactivity
      final updatedItems = List<CartItem>.from(cartItems);
      updatedItems[itemIndex] = CartItem(
        product: updatedItems[itemIndex].product,
        quantity: updatedItems[itemIndex].quantity + 1,
      );
      cartItems.value = updatedItems;
      calculateTotals();
      updateHomeCartCount();
    }
  }

  void decreaseQuantity(String productId) {
    final itemIndex = cartItems.indexWhere(
      (item) => item.product.id == productId,
    );
    if (itemIndex >= 0) {
      if (cartItems[itemIndex].quantity > 1) {
        // Create new list with updated item to trigger reactivity
        final updatedItems = List<CartItem>.from(cartItems);
        updatedItems[itemIndex] = CartItem(
          product: updatedItems[itemIndex].product,
          quantity: updatedItems[itemIndex].quantity - 1,
        );
        cartItems.value = updatedItems;
        calculateTotals();
        updateHomeCartCount();
      } else {
        _showRemoveDialog(productId);
      }
    }
  }

  void calculateTotals() {
    totalAmount.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    totalItems.value = cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void updateHomeCartCount() {
    final homeController = Get.find<HomeController>();
    homeController.updateCartCount(totalItems.value);
  }

  void clearCart() {
    cartItems.clear();
    calculateTotals();
    updateHomeCartCount();
    Get.back();
  }

  void applyCoupon(String code) {
    Get.snackbar(
      'Coupon Applied',
      'Discount applied successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool get isCartEmpty => cartItems.isEmpty;

  int getItemCount(String productId) {
    final item = cartItems.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: Product(
          id: '',
          name: '',
          price: 0,
          image: '',
          category: '',
          description: '',
          inStock: true,
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  void _showRemoveDialog(String productId) {
    Get.dialog(
      AlertDialog(
        title: Text('Remove Item'),
        content: Text(
          'Are you sure you want to remove this item from your cart?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              cartItems.removeWhere((item) => item.product.id == productId);
              //removeFromCart(productId);
              Get.back();
            },
            child: "Remove".text
                .color(redColor)
                .fontFamily(regular)
                .size(15)
                .make(),
          ),
        ],
      ),
    );
  }

  void showClearCartDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Clear Cart'),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              cartItems.clear();
              calculateTotals();
              updateHomeCartCount();
              Get.back();
              Get.snackbar('Cart Cleared', 'All items removed from cart');
            },
            child: Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
