import 'package:ecommerce_app/common_widgets/bg_auth.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/screens/B_category/details_item.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({super.key, required this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return bgAuth(
      child: Scaffold(
        appBar: AppBar(
          title: title!.text.white.size(18).fontFamily(semibold).make(),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 0),
          child: SafeArea(
            child: Column(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      7,
                      (index) => "BabyDolls".text
                          .size(10)
                          .fontFamily(semibold)
                          .makeCentered()
                          .box
                          .rounded
                          .size(130, 60)
                          .margin(const EdgeInsets.symmetric(horizontal: 7))
                          .white
                          .make(),
                    ),
                  ),
                ),
                /*
                10.heightBox,
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(50),
                    color: Color(0xFFE62E05),
                  ).box.size(context.screenWidth.length.toDouble(), 10).make(),
                ),*/
                10.heightBox,
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 12, left: 12),
                    color: lightGrey,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            10.heightBox,
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 8,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 7,
                                    crossAxisSpacing: 7,
                                    mainAxisExtent: 220,
                                  ),
                              itemBuilder: (context, index) =>
                                  Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            imgP3,
                                            height: 120,
                                            width: 200,
                                          ),
                                          const Spacer(),
                                          "Laptop-1TB".text.make(),
                                          5.heightBox,
                                          "\$700".text.color(redColor).make(),
                                        ],
                                      ).box.white
                                      .margin(const EdgeInsets.all(4))
                                      .padding(const EdgeInsets.all(15))
                                      .rounded
                                      .outerShadowSm
                                      .make()
                                      .onTap(
                                        () => Get.to(
                                          () => DetailsItem(
                                            title: "Dummy title list",
                                          ),
                                        ),
                                      ),
                            ),
                            10.heightBox,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
