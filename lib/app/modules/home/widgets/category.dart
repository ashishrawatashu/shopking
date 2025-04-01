import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/category/views/category_wise_product_screen.dart';
import 'package:shopperz/app/modules/home/controller/category_controller.dart';
import 'package:shopperz/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return Container(

      height: 60.h,
      width: double.infinity,
      color: AppColor.whiteColor, // white hobe
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categoryController.categoryModel.value.data!.length,
          itemBuilder: (context, index) {
            final category = categoryController.categoryModel.value.data!;
            return Center(
              child: Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => CategoryWiseProductScreen(
                          categoryModel: category[index]),
                    );
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.w,
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            offset: const Offset(0, 0),
                            blurRadius: 32.r,
                            spreadRadius: 0)
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.r), // White padding
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // White padding color
                            border: Border.all(color: Colors.black, width: 2), // Outer black ring
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: category[index].thumb.toString(),
                              imageBuilder: (context, imageProvider) => Container(
                                height: 30.h,
                                width: 30.h, // Ensure it remains circular
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  ,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
