//categories_screen.dart
import 'package:ecommerce_app/common_widgets/bg_auth.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/screens/B_category/category_details.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bgAuth(
      child: Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
          backgroundColor: redColor,
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {
          //       // Implement search
          //     },
          //   ),
          // ],
        ),
        body: Column(
          children: [
            // Search and Filter Bar
            Container(
              padding: EdgeInsets.all(12),
              color: whiteColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search categories...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  10.widthBox,
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      _showFilterDialog();
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: lightGrey,
                child: GridView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: categoryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 180,
                  ),
                  itemBuilder: (context, index) => _buildCategoryCard(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(int index) {
    return Card(
      elevation: 2,
      child:
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.asset(
                    categoryImage[index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      categoryList[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    5.heightBox,
                    Text(
                      '${index + 15} products',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ).onTap(() {
            Get.to(() => CategoryDetails(title: categoryList[index]));
          }),
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Filter Categories"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Sort by Name"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: Text("Sort by Popularity"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
          TextButton(onPressed: () => Get.back(), child: Text("Apply")),
        ],
      ),
    );
  }
}
