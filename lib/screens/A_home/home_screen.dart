// import 'package:ecommerce_app/common_widgets/featured_buttons.dart';
// import 'package:ecommerce_app/common_widgets/home_brand_buttons.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/screens/B_category/category_details.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
    //final homeController = Get.find<HomeController>();

    return Container(
      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
      color: lightGrey,
      child: SafeArea(
        child: Column(
          children: [
            // Enhanced Header with User Greeting
            _buildHeader(homeController),

            27.heightBox,

            Expanded(
              child: Obx(
                () => homeController.isSearching.value
                    ? _buildSearchResults(homeController)
                    : _buildHomeContent(homeController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Container(
      //height: 100,
      color: lightGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Welcome Message
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Hello,".text.gray500.size(15).make(),
                    5.heightBox,
                    "Welcome to VBazzar".text.size(18).fontFamily(bold).make(),
                  ],
                ),
              ),
              5.heightBox,
              // Cart Icon with Badge
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 26,
                      color: darkFontGrey,
                    ),
                    onPressed: () => controller.changeNavIndex(2),
                  ),
                  Obx(
                    () => controller.cartItemsCount.value > 0
                        ? Positioned(
                            right: 3,
                            top: 3,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: redColor,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
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
            ],
          ),
          10.heightBox,

          // Search Bar
          Container(
            //color: Colors.transparent,
            alignment: Alignment.center,
            height: 45,
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: whiteColor,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: searchAnything,
                hintStyle: TextStyle(color: fontGrey),
                prefixIcon: Icon(Icons.search, color: darkFontGrey),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_list, color: darkFontGrey),
                  onPressed: () {},
                ),
              ),
              onTap: () => null, //controller.toggleSearch(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(HomeController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          10.heightBox,
          // Promotional Banner
          VxSwiper.builder(
            aspectRatio: 20 / 9,
            autoPlay: true,
            height: 150,
            enlargeCenterPage: true,
            itemCount: swiperBrandList.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      swiperBrandList[index],
                      fit: BoxFit.cover,
                    ),
                  ).onTap(() {
                    // Handle banner tap
                    Get.snackbar('Promotion', 'Special offer tapped!');
                  }),
            ),
          ),
          20.heightBox,

          // Quick Actions Grid
          _buildQuickActions(),
          20.heightBox,

          // Featured Products
          _buildFeaturedProducts(controller),
          20.heightBox,

          // Categories Section
          _buildCategoriesSection(),
          20.heightBox,

          // Latest Products Grid
          _buildProductsGrid(controller),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.8,
      children: List.generate(4, (index) {
        // List<String> icons = [
        //   icTodaysDeal,
        //   icFlashDeal,
        //   icTopCategories,
        //   icBrands,
        // ];
        // List<String> titles = [todayDeal, flashSale, topCategories, brand];
        icons;
        titles;
        return Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: whiteColor,
              child: Image.asset(icons[index % icons.length], width: 30),
            ),
            8.heightBox,
            titles[index % titles.length].text
                .size(12)
                .center
                .color(darkFontGrey)
                .make(),
          ],
        ).onTap(() {
          Get.snackbar('Feature', '${titles[index % titles.length]} tapped!');
        });
      }),
    );
  }

  Widget _buildFeaturedProducts(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "Featured Products".text.size(18).fontFamily(bold).make(),
            "See All".text.color(redColor).make().onTap(() {
              // Navigate to all products
            }),
          ],
        ),
        15.heightBox,
        SizedBox(
          height: 250,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.featuredProducts.length,
              itemBuilder: (context, index) {
                final product = controller.featuredProducts[index];
                return _buildProductCard(product, controller);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product, HomeController controller) {
    var cartController = Get.put(CartController());
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      product.image,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 13,
                    right: 13,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.black54,
                      size: 27,
                    ),
                  ),
                  if (!product.inStock)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        color: Colors.red.withOpacity(0.8),
                        child: "Out of Stock".text.white
                            .size(10)
                            .makeCentered(),
                      ),
                    ),
                ],
              ),

              // Product Details
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                    5.heightBox,
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: redColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    8.heightBox,
                    ElevatedButton(
                      onPressed: product.inStock
                          ? () => cartController.addToCart(product)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redColor,
                        minimumSize: Size(double.infinity, 36),
                      ),
                      child: "Add to Cart".text.white.size(12).make(),
                    ),
                  ],
                ),
              ),
            ],
          ).onTap(() {
            // Navigate to product details
            Get.to(() => ProductDetailScreen(product: product));
          }),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Shop by Category".text.size(18).fontFamily(bold).make(),
        15.heightBox,
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.only(right: 12),
                child:
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: whiteColor,
                          backgroundImage: AssetImage(categoryImage[index]),
                        ),
                        8.heightBox,
                        // categoryList[index].text.size(12).make(),
                        SizedBox(
                          width: 90,
                          height: 32,
                          child: AutoSizeText(
                            categoryList[index],
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            minFontSize: 8,
                          ),
                        ),
                      ],
                    ).onTap(() {
                      Get.to(() => CategoryDetails(title: categoryList[index]));
                    }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsGrid(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Latest Products".text.size(18).fontFamily(bold).make(),
        15.heightBox,
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: controller.featuredProducts.length,
          itemBuilder: (context, index) {
            final product = controller.featuredProducts[index];
            return _buildProductGridItem(product, controller);
          },
        ),
      ],
    );
  }

  Widget _buildProductGridItem(Product product, HomeController controller) {
    var cartController = Get.put(CartController());
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                    5.heightBox,
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: redColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    8.heightBox,
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: product.inStock
                            ? () => cartController.addToCart(product)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          padding: EdgeInsets.zero,
                        ),
                        child: "Add".text.white.size(12).make(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).onTap(() {
            Get.to(() => ProductDetailScreen(product: product));
          }),
    );
  }

  Widget _buildSearchResults(HomeController controller) {
    // Implement search functionality
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          20.heightBox,
          "Search for products".text.color(fontGrey).make(),
        ],
      ),
    );
  }
}

// You'll need to create these screens
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Center(child: Text('Details for ${product.name}')),
    );
  }
}
