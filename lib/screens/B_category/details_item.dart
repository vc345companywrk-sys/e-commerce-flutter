import 'package:ecommerce_app/common_widgets/button_auth.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem({super.key, required this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: title!.text.size(20).make(),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.heightBox,
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 290,
                      itemCount: 3,
                      itemBuilder: (context, index) => Container(
                        child: Image.asset(imgPi1, fit: BoxFit.fill).box.rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .shadowSm
                            .make(),
                      ),
                    ),
                    10.heightBox,
                    Container(
                      color: whiteColor,
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title!.text.fontFamily(semibold).size(18).make(),
                          5.heightBox,
                          VxRating(
                            onRatingUpdate: (value) {},
                            normalColor: textfieldGrey,
                            selectionColor: golden,
                            count: 5,
                            size: 25,
                            stepInt: true,
                          ),
                          5.heightBox,
                          "\$7000".text.color(redColor).make(),
                          10.heightBox,

                          // Seller row
                          Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "Seller".text.size(13).make(),
                                      2.heightBox,
                                      "In House Brands".text.size(13).make(),
                                    ],
                                  ),
                                  const Spacer(),
                                  //*****NEW*******
                                  const CircleAvatar(
                                    backgroundColor: whiteColor,
                                    child: Icon(
                                      Icons.message_rounded,
                                      color: darkFontGrey,
                                    ),
                                  ),
                                ],
                              ).box
                              .color(textfieldGrey)
                              .padding(const EdgeInsets.all(10))
                              .height(60)
                              .make(),

                          10.heightBox,

                          // Attributes section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Color row
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "Color".text
                                        .color(textfieldGrey)
                                        .make(),
                                  ),
                                  Row(
                                    children: List.generate(
                                      3,
                                      (index) => VxBox()
                                          .size(40, 40)
                                          .color(Vx.randomPrimaryColor)
                                          .margin(const EdgeInsets.all(8))
                                          .roundedFull
                                          .make(),
                                    ),
                                  ),
                                ],
                              ).box.padding(const EdgeInsets.all(8)).make(),

                              // Quantity row (fixed)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "Quantity".text
                                        .color(textfieldGrey)
                                        .make(),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {},
                                      ),
                                      "0".text.make(),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {},
                                      ),
                                      5.widthBox,
                                      "0 available".text
                                          .color(textfieldGrey)
                                          .make(),
                                    ],
                                  ),
                                ],
                              ).box.padding(const EdgeInsets.all(8)).make(),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "Total".text
                                        .color(textfieldGrey)
                                        .make(),
                                  ),
                                  "\$0".text.color(redColor).make(),
                                ],
                              ).box.padding(const EdgeInsets.all(8)).make(),
                            ],
                          ),
                          // Divider(
                          //   thickness: 3,
                          //   indent: 0,
                          //   endIndent: 0,
                          //   color: lightGrey,
                          // ),
                          // "Description".text
                          //     .size(15)
                          //     .color(darkFontGrey)
                          //     .fontFamily(semibold)
                          //     .make(),
                          // 5.heightBox,
                          // "It is Dummy description about product!".text
                          //     .color(darkFontGrey)
                          //     .make(),
                        ],
                      ),
                    ),
                    5.heightBox,
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: context.screenWidth,
                      color: whiteColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Description".text
                              .size(15)
                              .color(darkFontGrey)
                              .fontFamily(semibold)
                              .make(),
                          5.heightBox,
                          "It is a Dummy description about product!".text
                              .color(darkFontGrey)
                              .make(),
                          5.heightBox,
                          Divider(thickness: 3, color: lightGrey),
                          5.heightBox,
                          ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                              descripList.length,
                              (index) => ListTile(
                                title: descripList[index].text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                trailing: Icon(Icons.arrow_forward),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,
                    Container(
                      color: whiteColor,
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productMayAlsoLike.text
                              .fontFamily(bold)
                              .color(darkFontGrey)
                              .size(15)
                              .make(),
                          7.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                6,
                                (index) =>
                                    Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(imgP1, width: 100),
                                            5.heightBox,
                                            "Laptop-8GB/514GB".text
                                                .fontFamily(semibold)
                                                .color(fontGrey)
                                                .size(12)
                                                .make(),
                                            5.heightBox,
                                            "\$700".text
                                                .color(redColor)
                                                .fontFamily(bold)
                                                .make(),
                                          ],
                                        ).box.white.roundedSM
                                        .padding(const EdgeInsets.all(15))
                                        .margin(const EdgeInsets.all(5))
                                        .shadowSm
                                        .make(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: buttonAuth(
                color: redColor,
                title: 'Add to Cart',
                textColor: whiteColor,
                onPress: () {},
              ),
            ),
            5.heightBox,
          ],
        ),
      ),
    );
  }
}
