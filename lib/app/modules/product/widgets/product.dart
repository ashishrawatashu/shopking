import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shopperz/widgets/textwidget.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/textwidget_with_currency.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    this.title,
    this.textRating,
    this.discountPrice,
    this.currentPrice,
    this.rating,
    this.productImage,
    this.onTap,
    this.favTap,
    this.flashSale,
    this.isOffer,
    this.favColor,
    this.wishlist,
    this.reviews,
  });
  final String? productImage;
  final String? title;
  final int? textRating;
  final String? reviews;
  final String? discountPrice;
  final String? currentPrice;
  final String? rating;
  final void Function()? onTap;
  final void Function()? favTap;

  final bool? flashSale;
  final bool? isOffer;
  final String? favColor;
  final bool? wishlist;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 156.w,
        decoration: BoxDecoration(
          // color: AppColor.whiteColor,
          // borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            // BoxShadow(
            //     color: Colors.black.withOpacity(0.04),
            //     offset: const Offset(0, 0),
            //     blurRadius: 7.r,
            //     spreadRadius: 0),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: productImage.toString(),
                    imageBuilder: (context, imageProvider) => Container(
                      height: 160.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0, // Remove left padding to center it properly
                    right: 0, // Remove right padding to center it properly
                    bottom: 6.h, // Move it to the bottom
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColor.whiteColor
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(SvgIcon.cart2,
                              height: 20.h,
                              width: 20.w,),
                            SizedBox(width: 5.w,),
                            CustomText(
                              text: "Add".tr,
                              size: 16.sp,
                              weight: FontWeight.w700,
                              color: AppColor.blackColor,
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 6.w,
                    right: 6.w,
                    top: 6.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        flashSale == true
                            ? Container(
                          height: 18.h,
                          width: 57.w,
                          decoration: BoxDecoration(
                            color: AppColor.blueColor,
                            borderRadius: BorderRadius.circular(9.r),
                          ),
                          child: Center(
                            child: TextWidget(
                              text: 'Flash Sale'.tr,
                              color: AppColor.whiteColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                            : const SizedBox(),
                        wishlist == false
                            ? InkWell(
                          onTap: favTap,
                          child: Container(
                            height: 18.r,
                            width: 18.r,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                SvgIcon.heart,
                                height: 12.h,
                                width: 12.w,
                              ),
                            ),
                          ),
                        )
                            : InkWell(
                          onTap: favTap,
                          child: Container(
                            height: 18.r,
                            width: 18.r,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                SvgIcon.filledHeart,
                                height: 12.h,
                                width: 12.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                child: TextWidget(
                  text: title ?? '',
                  color: AppColor.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              RatingBarIndicator(
                rating: double.parse(rating.toString() == 'null'
                    ? '0'
                    : (double.parse(rating.toString()) / textRating!.toInt())
                        .toString()),
                itemSize: 10.h,
                unratedColor: AppColor.inactiveColor,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: SvgPicture.asset(
                    SvgIcon.star,
                    colorFilter: const ColorFilter.mode(
                        AppColor.yellowColor, BlendMode.srcIn),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              TextWidget(
                text:
                    "${rating.toString() == 'null' ? '0' : double.parse(rating.toString()) / textRating!.toInt()} (${textRating ?? 0} ${' Reviews'.tr})",
                color: AppColor.textColor1,
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 12.h,
              ),
              FittedBox(
                child: Row(
                  children: [
                    TextWidgetWithCurrency(
                      text: discountPrice ?? '0',
                      color: AppColor.textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    isOffer == true
                        ? TextWidgetWithCurrency(
                            text: currentPrice ?? '0',
                            color: AppColor.redColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.lineThrough,
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
