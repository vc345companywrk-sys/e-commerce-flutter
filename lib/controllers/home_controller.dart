// lib/controllers/home_controller.dart
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentNavIndex = 0.obs;
  var cartItemsCount = 0.obs; // This should sync with CartController
  var searchQuery = ''.obs;
  var isSearching = false.obs;
  var featuredProducts = <Product>[].obs;
  // Remove this duplicate cart - we'll use CartController instead
  // var cartItems = <Product>[].obs;
  // var totalCartValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeaturedProducts();
    // Sync with CartController when home loads
    ever(Get.find<CartController>().totalItems, (count) {
      cartItemsCount.value = count;
    });
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
  }

  void loadFeaturedProducts() {
    // Mock data - replace with API call
    featuredProducts.assignAll([
      Product(
        id: '1',
        name: 'MacBook Pro M2',
        price: 1299.99,
        image: imgP1,
        category: 'Laptops',
        description: 'Apple MacBook Pro with M2 chip',
        inStock: true,
      ),
      Product(
        id: '2',
        name: 'Wireless Headphones',
        price: 199.99,
        image: imgP2,
        category: 'Audio',
        description: 'Noise cancelling wireless headphones',
        inStock: true,
      ),
      Product(
        id: '3',
        name: 'Wireless Headphones',
        price: 199.99,
        image: imgP3,
        category: 'Audio',
        description: 'Noise cancelling wireless headphones',
        inStock: true,
      ),
      Product(
        id: '4',
        name: 'Wireless Headphones',
        price: 199.99,
        image: imgP4,
        category: 'Audio',
        description: 'Noise cancelling wireless headphones',
        inStock: true,
      ),
      // Add more products...
    ]);
  }

  // Update to use CartController instead of local cart
  void addToCart(Product product) {
    final cartController = Get.find<CartController>();
    cartController.addToCart(product);
    // The cartItemsCount will update automatically via the ever() listener above
  }

  void updateCartCount(int count) {
    cartItemsCount.value = count;
  }

  // Remove duplicate cart methods - use CartController instead
  // void removeFromCart(Product product) { ... }
  // void calculateTotal() { ... }
  // void clearCart() { ... }
  // void loadCartItems() { ... }
}
