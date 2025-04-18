// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/home/controller/promotion_controller.dart';
import 'package:shopperz/app/modules/promotion/views/promotion_wise_product_screen.dart';
import 'package:shopperz/config/theme/app_color.dart';
import 'package:shopperz/widgets/shimmer/promotion_banner_shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PromotionBanner extends StatelessWidget {
   PromotionBanner({
    super.key,
    this.image,
    this.width,
    this.pIndex,
  });

  final String? image;
  final double? width;
  final int? pIndex;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final promotionController = Get.put(PromotionalController());

    return Obx(() {
      return promotionController.isLoading.value
          ? Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: SizedBox(
                  height: 142.h,
                  child: PromotionBannerShimmer(
                    width: 280.w,
                  )),
            )
          : promotionController.promotionModel.value.data?.isNotEmpty ?? false
              ? SizedBox(
                height: 200.h,
                child: Stack(
                  children: [
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount:
                    //       promotionController.promotionModel.value.data!.length,
                    //   itemBuilder: (context, index) {
                    //     final promotion =
                    //         promotionController.promotionModel.value.data;
                    //
                    //     return GestureDetector(
                    //       onTap: () {
                    //         Get.to(() => PromotionWiseProductScreen(
                    //             promotion: promotion[index]));
                    //       },
                    //       child: Padding(
                    //         padding: EdgeInsets.only(right: 16.w),
                    //         child: Container(
                    //           width: promotion![index].status == 10
                    //               ? 280.w
                    //               : 240.w,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8.r),
                    //           ),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(8.r),
                    //             child: Image.network(
                    //               promotion[index].cover.toString(),
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount:  promotionController.promotionModel.value.data!.length,
                            itemBuilder: (context, index) {
                              final promotion =
                                  promotionController.promotionModel.value.data;
                              return InkWell(
                                onTap: (){
                                          Get.to(() => PromotionWiseProductScreen(
                                              promotion: promotion[index]));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(promotion![0].cover.toString()),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              : const SizedBox();
    });
  }
}
