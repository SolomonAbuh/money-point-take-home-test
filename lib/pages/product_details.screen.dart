import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_point_take_home_assignment/constants/app_assets.dart';
import 'package:money_point_take_home_assignment/models/product_model.dart';
import 'package:money_point_take_home_assignment/models/selection_model.dart';
import 'package:money_point_take_home_assignment/widgets/app_spacer.dart';
import 'package:sizer/sizer.dart';

import '../widgets/about_items.dart';
import '../widgets/bottom_summary.dart';
import '../widgets/product_details_tab_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel model;
  const ProductDetailsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  List<SelectionModel> pictureSelections = [];
  String mainPicture = '';

  void addPictures(List<String> imageList) {
    for (var i = 0; i < imageList.length; i++) {
      pictureSelections
          .add(SelectionModel(imageList[i], i == 0 ? true : false));
    }
  }

  void getMainPic(List<SelectionModel> imageList) {
    for (var element in imageList) {
      if (element.active == true) {
        mainPicture = element.title;
      }
    }
  }

  @override
  void initState() {
    addPictures(widget.model.images);
    getMainPic(pictureSelections);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          const Icon(Icons.favorite_outline_rounded),
          spaceH(4.w),
          const Icon(Icons.share),
          spaceH(4.w),
          SvgPicture.asset(AppAssets.shoppingBagIcon),
          spaceH(4.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 40.h,
                            child: Image.asset(mainPicture),
                          )
                              .animate()
                              .slideY(
                                  begin: 10,
                                  duration: const Duration(
                                    milliseconds: 800,
                                  ),
                                  curve: Curves.easeOut)
                              .fadeIn(
                                begin: 0.1,
                                delay: const Duration(milliseconds: 600),
                              )
                              .moveX(end: 30),
                        ),
                        Column(
                          children: List.generate(
                            widget.model.images.length,
                            (index) => Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      for (var element in pictureSelections) {
                                        element.active = false;
                                      }
                                      mainPicture =
                                          pictureSelections[index].title;
                                      pictureSelections[index].active = true;
                                    });
                                  },
                                  child: Container(
                                    height: 6.h,
                                    width: 6.h,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(0, 10),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: pictureSelections[index].active
                                            ? Colors.teal
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      child: Image.asset(
                                        pictureSelections[index].title,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                spaceV(2.h),
                              ],
                            )
                                .animate()
                                .fadeIn(
                                  delay: Duration(milliseconds: 300 * index),
                                )
                                .scale(),
                          ),
                        )
                      ],
                    ),
                    spaceV(2.h),
                    vendor(widget: widget)
                        .animate()
                        .fade(duration: const Duration(milliseconds: 800))
                        .slideX(),
                    spaceV(1.h),
                    Text(
                      widget.model.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                        .animate(delay: const Duration(milliseconds: 800))
                        .fade(duration: const Duration(milliseconds: 800)),
                    spaceV(3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16.sp,
                            ),
                            spaceH(2.w),
                            Text(
                              '${widget.model.rating} Ratings',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          '2.9k + Reviews',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          '2.3k + Sold',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    spaceV(3.h),
                    const ProductDetailsTabBar(),
                    spaceV(3.h),
                    AboutItems(
                      model: widget.model,
                    )
                  ],
                ),
              ),
            ),
          ),
          const BottomSummary()
        ],
      ),
    );
  }
}

class vendor extends StatelessWidget {
  const vendor({
    super.key,
    required this.widget,
  });

  final ProductDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.shopIcon,
          color: Colors.grey.shade400,
        ),
        spaceH(2.w),
        Text(
          widget.model.productCategory,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
