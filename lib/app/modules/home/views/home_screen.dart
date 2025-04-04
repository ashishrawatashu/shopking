import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopperz/app/modules/auth/controller/auth_controler.dart';
import 'package:shopperz/app/modules/auth/views/sign_in.dart';
import 'package:shopperz/app/modules/category/views/category_wise_product_screen.dart';
import 'package:shopperz/app/modules/filter/controller/filter_controller.dart';
import 'package:shopperz/app/modules/home/controller/brand_controller.dart';
import 'package:shopperz/app/modules/home/controller/category_controller.dart';
import 'package:shopperz/app/modules/home/controller/flash_sale_controller.dart';
import 'package:shopperz/app/modules/home/controller/popular_product_controller.dart';
import 'package:shopperz/app/modules/home/controller/product_section_controller.dart';
import 'package:shopperz/app/modules/home/controller/slider_controller.dart';
import 'package:shopperz/app/modules/home/widgets/category.dart';
import 'package:shopperz/app/modules/home/widgets/multi_promotion_banner.dart';
import 'package:shopperz/app/modules/home/widgets/promotion_banner.dart';
import 'package:shopperz/app/modules/home/widgets/slider.dart';
import 'package:shopperz/app/modules/language/controller/language_controller.dart';
import 'package:shopperz/app/modules/product/widgets/product.dart';
import 'package:shopperz/app/modules/product_details/views/product_details.dart';
import 'package:shopperz/app/modules/profile/controller/profile_controller.dart';
import 'package:shopperz/app/modules/shipping/controller/show_address_controller.dart';
import 'package:shopperz/main.dart';
import 'package:shopperz/utils/svg_icon.dart';
import 'package:shopperz/widgets/custom_text.dart';
import 'package:shopperz/widgets/shimmer/categories_shimmer.dart';
import 'package:shopperz/widgets/shimmer/product_shimmer.dart';
import 'package:shopperz/widgets/shimmer/slider_shimmer.dart';
import 'package:shopperz/widgets/title.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widgets/appbar.dart';
import '../../product/views/product_list_screen.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../../search/views/search_screen.dart';
import '../widgets/see_all_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = AppColor.whiteColor;
  double _searchBarMargin = 0.0; // Margi


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 100) {
          _appBarColor = Colors.white;
          _searchBarMargin = 10.0; // Add margin when scrolled
        } else {
          _appBarColor = AppColor.whiteColor;
          _searchBarMargin = 0.0; // Reset margin
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final sliderController = Get.put(SliderController());
    final categoryController = Get.put(CategoryController());
    final productSectionController = Get.put(ProductSectionController());
    AuthController authController = Get.put(AuthController());
    ProfileController profile = Get.put(ProfileController());
    LanguageController language = Get.put(LanguageController());
    final filterController = Get.put(FilterController());
    final flashSaleController = Get.put(FlashSaleControlelr());
    final showAddressController = Get.put(ShowAddressController());
    final wishListController = Get.put(WishlistController());
    final brandController = Get.put(BrandController());
    final popularProductController = Get.put(PopularProductController());
    categoryController.fetchCategory();
    productSectionController.fetchProductSection();

    sliderController.fetchSlider();
    profile.getPages();
    authController.getCountryCode();
    language.getLanguageData();

    if (box.read('isLogedIn') != false) {
      profile.getAddress();
      profile.getTotalOrdersCount();
      profile.getTotalCompleteOrdersCount();
      profile.getTotalReturnOrdersCount();
      profile.getTotalWalletBalance();
      showAddressController.showAdresses();
    }


    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // SliverAppBar with Logo
            SliverAppBar(
              expandedHeight: 50.0,
              floating: false,
              pinned: false,
              backgroundColor: _appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                title: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: SvgPicture.asset(
                        SvgIcon.logo,
                        height: 30.h,
                        width: 73.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SliverAppBar with Search Bar (Pinned)
            SliverPersistentHeader(
              pinned: true,
              delegate: _FixedSearchBarDelegate(_appBarColor, _searchBarMargin),
            ),

            // Sticky Icon Row (SliverPersistentHeader)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Obx(() {
                        return sliderController.sliderData.value.data == null
                            ? const SliderSectionShimmer()
                            : sliderController.sliderData.value.data!.isNotEmpty
                            ? const SliderWidget()
                            : const SizedBox();
                      }),
                    ),
                    Obx(() {
                      return categoryController.categoryModel.value.data == null
                          ? Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: const CategoriesSectionShimmer(),
                      )
                          : categoryController.categoryModel.value.data!.isNotEmpty
                          ? const CategoryWidget()
                          : const SizedBox();
                    }),
                  ],
                ),
              ),
            ),
          ],
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              PromotionBanner(),
              SizedBox(
                child: Obx(() {
                  return productSectionController
                      .productSection.value.data ==
                      null
                      ? const ProductShimmer()
                      : productSectionController
                      .productSection.value.data!.isNotEmpty
                      ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productSectionController
                          .productSection.value.data?.length,
                      itemBuilder: (context, index) {
                        final section = productSectionController
                            .productSection.value.data;
                        return section![index].products!.isNotEmpty
                            ? Padding(
                          padding:
                          EdgeInsets.only(right: 16.w),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TitleWidget(
                                  text: section[index]
                                      .name
                                      .toString()),
                              SizedBox(height: 12.h),
                              StaggeredGrid.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 16.w,
                                children: [
                                  for (var i = 0;
                                  i <
                                      section[index]
                                          .products!
                                          .length;
                                  i++)
                                    Obx(
                                          () => ProductWidget(
                                        onTap: () {
                                          Get.to(
                                                () => ProductDetailsScreen(
                                                sectionModel:
                                                section[
                                                index],
                                                productModel:
                                                section[index]
                                                    .products![i]),
                                          );
                                        },
                                        favTap: () async {
                                          if (box.read(
                                              'isLogedIn') !=
                                              false) {
                                            if (section[index]
                                                .products![
                                            i]
                                                .wishlist ==
                                                true) {
                                              await wishListController
                                                  .toggleFavoriteFalse(section[
                                              index]
                                                  .products![
                                              i]
                                                  .id!);
                                              wishListController
                                                  .showFavorite(section[
                                              index]
                                                  .products![
                                              i]
                                                  .id!);
                                            }
                                            if (section[index]
                                                .products![
                                            i]
                                                .wishlist ==
                                                false) {
                                              await wishListController
                                                  .toggleFavoriteTrue(section[
                                              index]
                                                  .products![
                                              i]
                                                  .id!);
                                              wishListController
                                                  .showFavorite(section[
                                              index]
                                                  .products![
                                              i]
                                                  .id!);
                                            }
                                          } else {
                                            Get.to(() =>
                                            const SignInScreen());
                                          }
                                        },
                                        wishlist: wishListController
                                            .favList
                                            .contains(section[index]
                                            .products![
                                        i]
                                            .id!) ||
                                            productSectionController
                                                .productSection
                                                .value
                                                .data![
                                            index]
                                                .products![
                                            i]
                                                .wishlist ==
                                                true
                                            ? true
                                            : false,
                                        productImage:
                                        section[index]
                                            .products![i]
                                            .cover!,
                                        title: section[index]
                                            .products![i]
                                            .name,
                                        rating: section[index]
                                            .products![i]
                                            .ratingStar,
                                        currentPrice: section[
                                        index]
                                            .products![i]
                                            .currencyPrice,
                                        discountPrice: section[
                                        index]
                                            .products![i]
                                            .discountedPrice,
                                        textRating: section[
                                        index]
                                            .products![i]
                                            .ratingStarCount,
                                        flashSale:
                                        section[index]
                                            .products![i]
                                            .flashSale!,
                                        isOffer:
                                        section[index]
                                            .products![i]
                                            .isOffer!,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 32.h),
                              MultiPromotionBanner(
                                pIndex: index,
                              ),
                            ],
                          ),
                        )
                            : const SizedBox();
                      })
                      : const SizedBox();
                }),
              ),
              Obx(
                    () => popularProductController.popularModel.value.data ==
                    null
                    ? const ProductShimmer()
                    : popularProductController
                    .popularModel.value.data!.isNotEmpty
                    ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16.w,left: 16.w),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              TitleWidget(text: "Most Popular".tr),
                              SeeAllButton(
                                onTap: () async {
                                  Get.to(
                                        () => const ProductlistScreen(
                                      id: 5,
                                      title: "Most Popular",
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        StaggeredGrid.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.h,
                          children: [
                            for (int index = 0;
                            index <
                                popularProductController
                                    .popularModel
                                    .value
                                    .data!
                                    .length;
                            index++)
                              ProductWidget(
                                onTap: () {
                                  Get.to(() => ProductDetailsScreen(
                                      individualProduct:
                                      popularProductController
                                          .popularModel
                                          .value
                                          .data?[index]));
                                },
                                wishlist: wishListController.favList
                                    .contains(
                                    popularProductController
                                        .popularModel
                                        .value
                                        .data![index]
                                        .id!) ||
                                    popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .wishlist ==
                                        true
                                    ? true
                                    : false,
                                favTap: () async {
                                  if (box.read('isLogedIn') !=
                                      false) {
                                    if (popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .wishlist ==
                                        true) {
                                      await wishListController
                                          .toggleFavoriteFalse(
                                          popularProductController
                                              .popularModel
                                              .value
                                              .data![index]
                                              .id!);

                                      wishListController.showFavorite(
                                          popularProductController
                                              .popularModel
                                              .value
                                              .data![index]
                                              .id!);
                                    }
                                    if (popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .wishlist ==
                                        false) {
                                      await wishListController
                                          .toggleFavoriteTrue(
                                          popularProductController
                                              .popularModel
                                              .value
                                              .data![index]
                                              .id!);

                                      wishListController.showFavorite(
                                          popularProductController
                                              .popularModel
                                              .value
                                              .data![index]
                                              .id!);
                                    }
                                  } else {
                                    Get.to(
                                            () => const SignInScreen());
                                  }
                                },
                                productImage:
                                popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .cover!,
                                title: popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .name,
                                rating: popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .ratingStar
                                    .toString(),
                                currentPrice:
                                popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .currencyPrice,
                                discountPrice:
                                popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .discountedPrice,
                                textRating: popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .ratingStarCount,
                                flashSale: popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .flashSale!,
                                isOffer: popularProductController
                                    .popularModel
                                    .value
                                    .data?[index]
                                    .isOffer!,
                              ),
                          ],
                        ),
                      ],
                    )
                    : const SizedBox(),
              ),
              SizedBox(height: 34.h),
              Obx(
                    () => flashSaleController.flashSaleModel.value.data == null
                    ? const ProductShimmer()
                    : flashSaleController
                    .flashSaleModel.value.data!.isNotEmpty
                    ? Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Obx(
                        () => Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              TitleWidget(text: 'Flash Sale'.tr),
                              SeeAllButton(
                                onTap: () {
                                  Get.to(
                                        () => const ProductlistScreen(
                                      id: 10,
                                      title: "Flash Sale",
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        StaggeredGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          children: [
                            for (int index = 0;
                            index <
                                flashSaleController
                                    .flashSaleModel
                                    .value
                                    .data!
                                    .length;
                            index++)
                              Obx(() {
                                final flashSale =
                                flashSaleController
                                    .flashSaleModel
                                    .value
                                    .data![index];

                                return Obx(
                                      () => ProductWidget(
                                    onTap: () {
                                      Get.to(
                                            () =>
                                            ProductDetailsScreen(
                                              individualProduct:
                                              flashSaleController
                                                  .flashSaleModel
                                                  .value
                                                  .data?[index],
                                            ),
                                      );
                                    },
                                    wishlist: wishListController
                                        .favList
                                        .contains(
                                        flashSale
                                            .id!) ||
                                        flashSale.wishlist ==
                                            true
                                        ? true
                                        : false,
                                    favTap: () async {
                                      if (box.read('isLogedIn') !=
                                          false) {
                                        if (flashSale.wishlist ==
                                            true) {
                                          await wishListController
                                              .toggleFavoriteFalse(
                                              flashSale.id!);
                                          wishListController
                                              .showFavorite(
                                              flashSale.id!);
                                        }
                                        if (flashSale.wishlist ==
                                            false) {
                                          await wishListController
                                              .toggleFavoriteTrue(
                                              flashSale.id!);

                                          wishListController
                                              .showFavorite(
                                              flashSale.id!);
                                        }
                                      } else {
                                        Get.to(() =>
                                        const SignInScreen());
                                      }
                                    },
                                    favColor: wishListController
                                        .favList
                                        .contains(
                                        flashSale.id!)
                                        ? SvgIcon.filledHeart
                                        : SvgIcon.heart,
                                    productImage:
                                    flashSale.cover!,
                                    title: flashSale.name,
                                    rating: flashSale.ratingStar
                                        .toString(),
                                    currentPrice:
                                    flashSale.currencyPrice,
                                    discountPrice:
                                    flashSale.discountedPrice,
                                    textRating:
                                    flashSale.ratingStarCount,
                                    flashSale:
                                    flashSale.flashSale!,
                                    isOffer: flashSale.isOffer!,
                                  ),
                                );
                              }),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    : const SizedBox(),
              ),
              SizedBox(height: 34.h),
              Obx(
                    () => brandController.brandModel.value.data != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleWidget(text: "Popular Brands".tr),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: brandController
                          .brandModel.value.data?.isEmpty ??
                          false
                          ? 0
                          : 100.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: brandController
                            .brandModel.value.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(16.r),
                            onTap: () {
                              filterController.addHomeBrandId(
                                  brandController.brandModel.value
                                      .data![index].id
                                      .toString());

                              Get.to(() => CategoryWiseProductScreen(
                                brandName: brandController
                                    .brandModel
                                    .value
                                    .data?[index]
                                    .name,
                              ));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w),
                              child: Obx(
                                    () => brandController.brandModel.value
                                    .data ==
                                    null ||
                                    brandController.brandModel
                                        .value.data!.isEmpty
                                    ? Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor:
                                  Colors.grey[300]!,
                                  child: Container(
                                    height: 90.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(16.r),
                                        color: Colors.white),
                                  ),
                                )
                                    : Ink(
                                  height: 90,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: AppColor
                                            .borderColor),
                                    borderRadius:
                                    BorderRadius.circular(
                                        16.r),
                                  ),
                                  child: Padding(
                                    padding:
                                    EdgeInsets.all(8.sp),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        CachedNetworkImage(
                                            imageUrl:
                                            brandController
                                                .brandModel
                                                .value
                                                .data![
                                            index]
                                                .cover
                                                .toString(),
                                            fit: BoxFit.cover,
                                            imageBuilder: (context,
                                                imageProvider) =>
                                                Container(
                                                  height: 20.h,
                                                  width: 60.w,
                                                  decoration:
                                                  BoxDecoration(
                                                    image: DecorationImage(
                                                        image:
                                                        imageProvider),
                                                  ),
                                                )),
                                        SizedBox(height: 20.h),
                                        CustomText(
                                          text: brandController
                                              .brandModel
                                              .value
                                              .data?[index]
                                              .name ??
                                              "",
                                          color: AppColor
                                              .textColor,
                                          weight:
                                          FontWeight.w600,
                                          size: 12.sp,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: brandController
                          .brandModel.value.data?.isEmpty ??
                          false
                          ? 0
                          : 100.h,
                    )
                  ],
                )
                    : const SizedBox(),
              ),// Replace Container with SizedBox for efficiency
            ],
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // SliverAppBar with Logo
            SliverAppBar(
              expandedHeight: 50.0,
              floating: false,
              pinned: false,
              backgroundColor: _appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                title: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only( right: 16.w),
                      child: SvgPicture.asset(
                        SvgIcon.logo,
                        height: 30.h,
                        width: 73.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SliverAppBar with Search Bar (Pinned)
            SliverPersistentHeader(
              pinned: true,
              delegate: _FixedSearchBarDelegate(_appBarColor, _searchBarMargin),
            ),

            // Sticky Icon Row (SliverPersistentHeader)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Obx(() {
                        return sliderController.sliderData.value.data == null
                            ? const SliderSectionShimmer()
                            : sliderController
                            .sliderData.value.data!.isNotEmpty
                            ? const SliderWidget()
                            : const SizedBox();
                      }),
                    ),
                    Obx(() {
                      return categoryController.categoryModel.value.data ==
                          null
                          ? Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: const CategoriesSectionShimmer(),
                      )
                          : categoryController
                          .categoryModel.value.data!.isNotEmpty
                          ? const CategoryWidget()
                          : const SizedBox();
                    }),
                  ],
                ),
              ),
            ),

            // my content
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(), // Prevent inner scroll conflicts

                child: Column(
                  children: [
                    PromotionBanner(),
                    SizedBox(
                      child: Obx(() {
                        return productSectionController
                            .productSection.value.data ==
                            null
                            ? const ProductShimmer()
                            : productSectionController
                            .productSection.value.data!.isNotEmpty
                            ? ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productSectionController
                                .productSection.value.data?.length,
                            itemBuilder: (context, index) {
                              final section = productSectionController
                                  .productSection.value.data;
                              return section![index].products!.isNotEmpty
                                  ? Padding(
                                padding:
                                EdgeInsets.only(right: 16.w),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    TitleWidget(
                                        text: section[index]
                                            .name
                                            .toString()),
                                    SizedBox(height: 12.h),
                                    StaggeredGrid.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16.h,
                                      crossAxisSpacing: 16.w,
                                      children: [
                                        for (var i = 0;
                                        i <
                                            section[index]
                                                .products!
                                                .length;
                                        i++)
                                          Obx(
                                                () => ProductWidget(
                                              onTap: () {
                                                Get.to(
                                                      () => ProductDetailsScreen(
                                                      sectionModel:
                                                      section[
                                                      index],
                                                      productModel:
                                                      section[index]
                                                          .products![i]),
                                                );
                                              },
                                              favTap: () async {
                                                if (box.read(
                                                    'isLogedIn') !=
                                                    false) {
                                                  if (section[index]
                                                      .products![
                                                  i]
                                                      .wishlist ==
                                                      true) {
                                                    await wishListController
                                                        .toggleFavoriteFalse(section[
                                                    index]
                                                        .products![
                                                    i]
                                                        .id!);
                                                    wishListController
                                                        .showFavorite(section[
                                                    index]
                                                        .products![
                                                    i]
                                                        .id!);
                                                  }
                                                  if (section[index]
                                                      .products![
                                                  i]
                                                      .wishlist ==
                                                      false) {
                                                    await wishListController
                                                        .toggleFavoriteTrue(section[
                                                    index]
                                                        .products![
                                                    i]
                                                        .id!);
                                                    wishListController
                                                        .showFavorite(section[
                                                    index]
                                                        .products![
                                                    i]
                                                        .id!);
                                                  }
                                                } else {
                                                  Get.to(() =>
                                                  const SignInScreen());
                                                }
                                              },
                                              wishlist: wishListController
                                                  .favList
                                                  .contains(section[index]
                                                  .products![
                                              i]
                                                  .id!) ||
                                                  productSectionController
                                                      .productSection
                                                      .value
                                                      .data![
                                                  index]
                                                      .products![
                                                  i]
                                                      .wishlist ==
                                                      true
                                                  ? true
                                                  : false,
                                              productImage:
                                              section[index]
                                                  .products![i]
                                                  .cover!,
                                              title: section[index]
                                                  .products![i]
                                                  .name,
                                              rating: section[index]
                                                  .products![i]
                                                  .ratingStar,
                                              currentPrice: section[
                                              index]
                                                  .products![i]
                                                  .currencyPrice,
                                              discountPrice: section[
                                              index]
                                                  .products![i]
                                                  .discountedPrice,
                                              textRating: section[
                                              index]
                                                  .products![i]
                                                  .ratingStarCount,
                                              flashSale:
                                              section[index]
                                                  .products![i]
                                                  .flashSale!,
                                              isOffer:
                                              section[index]
                                                  .products![i]
                                                  .isOffer!,
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 32.h),
                                    MultiPromotionBanner(
                                      pIndex: index,
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox();
                            })
                            : const SizedBox();
                      }),
                    ),
                    Obx(
                          () => popularProductController.popularModel.value.data ==
                          null
                          ? const ProductShimmer()
                          : popularProductController
                          .popularModel.value.data!.isNotEmpty
                          ? Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TitleWidget(text: "Most Popular".tr),
                                  SeeAllButton(
                                    onTap: () async {
                                      Get.to(
                                            () => const ProductlistScreen(
                                          id: 5,
                                          title: "Most Popular",
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              children: [
                                for (int index = 0;
                                index <
                                    popularProductController
                                        .popularModel
                                        .value
                                        .data!
                                        .length;
                                index++)
                                  ProductWidget(
                                    onTap: () {
                                      Get.to(() => ProductDetailsScreen(
                                          individualProduct:
                                          popularProductController
                                              .popularModel
                                              .value
                                              .data?[index]));
                                    },
                                    wishlist: wishListController.favList
                                        .contains(
                                        popularProductController
                                            .popularModel
                                            .value
                                            .data![index]
                                            .id!) ||
                                        popularProductController
                                            .popularModel
                                            .value
                                            .data?[index]
                                            .wishlist ==
                                            true
                                        ? true
                                        : false,
                                    favTap: () async {
                                      if (box.read('isLogedIn') !=
                                          false) {
                                        if (popularProductController
                                            .popularModel
                                            .value
                                            .data?[index]
                                            .wishlist ==
                                            true) {
                                          await wishListController
                                              .toggleFavoriteFalse(
                                              popularProductController
                                                  .popularModel
                                                  .value
                                                  .data![index]
                                                  .id!);

                                          wishListController.showFavorite(
                                              popularProductController
                                                  .popularModel
                                                  .value
                                                  .data![index]
                                                  .id!);
                                        }
                                        if (popularProductController
                                            .popularModel
                                            .value
                                            .data?[index]
                                            .wishlist ==
                                            false) {
                                          await wishListController
                                              .toggleFavoriteTrue(
                                              popularProductController
                                                  .popularModel
                                                  .value
                                                  .data![index]
                                                  .id!);

                                          wishListController.showFavorite(
                                              popularProductController
                                                  .popularModel
                                                  .value
                                                  .data![index]
                                                  .id!);
                                        }
                                      } else {
                                        Get.to(
                                                () => const SignInScreen());
                                      }
                                    },
                                    productImage:
                                    popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .cover!,
                                    title: popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .name,
                                    rating: popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .ratingStar
                                        .toString(),
                                    currentPrice:
                                    popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .currencyPrice,
                                    discountPrice:
                                    popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .discountedPrice,
                                    textRating: popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .ratingStarCount,
                                    flashSale: popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .flashSale!,
                                    isOffer: popularProductController
                                        .popularModel
                                        .value
                                        .data?[index]
                                        .isOffer!,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                          : const SizedBox(),
                    ),
                    SizedBox(height: 34.h),
                    Obx(
                          () => flashSaleController.flashSaleModel.value.data == null
                          ? const ProductShimmer()
                          : flashSaleController
                          .flashSaleModel.value.data!.isNotEmpty
                          ? Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Obx(
                              () => Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    TitleWidget(text: 'Flash Sale'.tr),
                                    SeeAllButton(
                                      onTap: () {
                                        Get.to(
                                              () => const ProductlistScreen(
                                            id: 10,
                                            title: "Flash Sale",
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              StaggeredGrid.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 16.w,
                                children: [
                                  for (int index = 0;
                                  index <
                                      flashSaleController
                                          .flashSaleModel
                                          .value
                                          .data!
                                          .length;
                                  index++)
                                    Obx(() {
                                      final flashSale =
                                      flashSaleController
                                          .flashSaleModel
                                          .value
                                          .data![index];

                                      return Obx(
                                            () => ProductWidget(
                                          onTap: () {
                                            Get.to(
                                                  () =>
                                                  ProductDetailsScreen(
                                                    individualProduct:
                                                    flashSaleController
                                                        .flashSaleModel
                                                        .value
                                                        .data?[index],
                                                  ),
                                            );
                                          },
                                          wishlist: wishListController
                                              .favList
                                              .contains(
                                              flashSale
                                                  .id!) ||
                                              flashSale.wishlist ==
                                                  true
                                              ? true
                                              : false,
                                          favTap: () async {
                                            if (box.read('isLogedIn') !=
                                                false) {
                                              if (flashSale.wishlist ==
                                                  true) {
                                                await wishListController
                                                    .toggleFavoriteFalse(
                                                    flashSale.id!);
                                                wishListController
                                                    .showFavorite(
                                                    flashSale.id!);
                                              }
                                              if (flashSale.wishlist ==
                                                  false) {
                                                await wishListController
                                                    .toggleFavoriteTrue(
                                                    flashSale.id!);

                                                wishListController
                                                    .showFavorite(
                                                    flashSale.id!);
                                              }
                                            } else {
                                              Get.to(() =>
                                              const SignInScreen());
                                            }
                                          },
                                          favColor: wishListController
                                              .favList
                                              .contains(
                                              flashSale.id!)
                                              ? SvgIcon.filledHeart
                                              : SvgIcon.heart,
                                          productImage:
                                          flashSale.cover!,
                                          title: flashSale.name,
                                          rating: flashSale.ratingStar
                                              .toString(),
                                          currentPrice:
                                          flashSale.currencyPrice,
                                          discountPrice:
                                          flashSale.discountedPrice,
                                          textRating:
                                          flashSale.ratingStarCount,
                                          flashSale:
                                          flashSale.flashSale!,
                                          isOffer: flashSale.isOffer!,
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                          : const SizedBox(),
                    ),
                    SizedBox(height: 34.h),
                    Obx(
                          () => brandController.brandModel.value.data != null
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(text: "Popular Brands".tr),
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: brandController
                                .brandModel.value.data?.isEmpty ??
                                false
                                ? 0
                                : 100.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: brandController
                                  .brandModel.value.data?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  borderRadius: BorderRadius.circular(16.r),
                                  onTap: () {
                                    filterController.addHomeBrandId(
                                        brandController.brandModel.value
                                            .data![index].id
                                            .toString());

                                    Get.to(() => CategoryWiseProductScreen(
                                      brandName: brandController
                                          .brandModel
                                          .value
                                          .data?[index]
                                          .name,
                                    ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w),
                                    child: Obx(
                                          () => brandController.brandModel.value
                                          .data ==
                                          null ||
                                          brandController.brandModel
                                              .value.data!.isEmpty
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[200]!,
                                        highlightColor:
                                        Colors.grey[300]!,
                                        child: Container(
                                          height: 90.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(16.r),
                                              color: Colors.white),
                                        ),
                                      )
                                          : Ink(
                                        height: 90,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: AppColor
                                                  .borderColor),
                                          borderRadius:
                                          BorderRadius.circular(
                                              16.r),
                                        ),
                                        child: Padding(
                                          padding:
                                          EdgeInsets.all(8.sp),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceAround,
                                            children: [
                                              CachedNetworkImage(
                                                  imageUrl:
                                                  brandController
                                                      .brandModel
                                                      .value
                                                      .data![
                                                  index]
                                                      .cover
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  imageBuilder: (context,
                                                      imageProvider) =>
                                                      Container(
                                                        height: 20.h,
                                                        width: 60.w,
                                                        decoration:
                                                        BoxDecoration(
                                                          image: DecorationImage(
                                                              image:
                                                              imageProvider),
                                                        ),
                                                      )),
                                              SizedBox(height: 20.h),
                                              CustomText(
                                                text: brandController
                                                    .brandModel
                                                    .value
                                                    .data?[index]
                                                    .name ??
                                                    "",
                                                color: AppColor
                                                    .textColor,
                                                weight:
                                                FontWeight.w600,
                                                size: 12.sp,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: brandController
                                .brandModel.value.data?.isEmpty ??
                                false
                                ? 0
                                : 100.h,
                          )
                        ],
                      )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create an icon with a text label
  Widget iconWithLabel(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.black),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   final sliderController = Get.put(SliderController());
  //   final categoryController = Get.put(CategoryController());
  //   final productSectionController = Get.put(ProductSectionController());
  //   AuthController authController = Get.put(AuthController());
  //   ProfileController profile = Get.put(ProfileController());
  //   LanguageController language = Get.put(LanguageController());
  //   final filterController = Get.put(FilterController());
  //   final flashSaleController = Get.put(FlashSaleControlelr());
  //   final showAddressController = Get.put(ShowAddressController());
  //   final wishListController = Get.put(WishlistController());
  //   final brandController = Get.put(BrandController());
  //   final popularProductController = Get.put(PopularProductController());
  //   categoryController.fetchCategory();
  //   productSectionController.fetchProductSection();
  //
  //   sliderController.fetchSlider();
  //   profile.getPages();
  //   authController.getCountryCode();
  //   language.getLanguageData();
  //
  //   if (box.read('isLogedIn') != false) {
  //     profile.getAddress();
  //     profile.getTotalOrdersCount();
  //     profile.getTotalCompleteOrdersCount();
  //     profile.getTotalReturnOrdersCount();
  //     profile.getTotalWalletBalance();
  //     showAddressController.showAdresses();
  //   }
  //
  //   return AnnotatedRegion<SystemUiOverlayStyle>(
  //     value: const SystemUiOverlayStyle(
  //       systemNavigationBarColor: Colors.white,
  //       systemNavigationBarIconBrightness: Brightness.dark,
  //       statusBarIconBrightness: Brightness.dark,
  //       statusBarColor: Colors.transparent,
  //       statusBarBrightness: Brightness.dark,
  //     ),
  //     child: Scaffold(
  //       backgroundColor: AppColor.primaryBackgroundColor,
  //
  //       body: SafeArea(
  //         child: RefreshIndicator(
  //           color: AppColor.primaryColor,
  //           onRefresh: () async {
  //             productSectionController.fetchProductSection();
  //             categoryController.fetchCategory();
  //             brandController.fetchBrands();
  //             sliderController.fetchSlider();
  //             profile.getPages();
  //             authController.getSetting();
  //             authController.getCountryCode();
  //             language.getLanguageData();
  //             if (box.read('isLogedIn') != false) {
  //               profile.getAddress();
  //               profile.getTotalOrdersCount();
  //               profile.getTotalCompleteOrdersCount();
  //               profile.getTotalReturnOrdersCount();
  //               profile.getTotalWalletBalance();
  //             }
  //           },
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 16.w),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   //logo
  //                   Padding(
  //                     padding: EdgeInsets.only( right: 16.w),
  //                     child: SvgPicture.asset(
  //                       SvgIcon.logo,
  //                       height: 30.h,
  //                       width: 73.w,
  //                     ),
  //                   ),
  //                   //search
  //                   InkWell(
  //                     onTap: (){
  //                       Get.to(() => const SearchScreen());
  //                     },
  //                     child: Container(
  //                       height: 42.h,
  //                       width: 328.w,
  //
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10.r),
  //                           color: AppColor.grayColor),
  //                       child: Row(
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.all(10.r),
  //                             child: SvgPicture.asset(
  //                               SvgIcon.search,
  //                               colorFilter:
  //                               const ColorFilter.mode(Colors.grey, BlendMode.dst),
  //                             ),
  //                           ),
  //                           Text("Search")
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   //category
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.only(right: 16.w),
  //                         child: Obx(() {
  //                           return sliderController.sliderData.value.data == null
  //                               ? const SliderSectionShimmer()
  //                               : sliderController
  //                               .sliderData.value.data!.isNotEmpty
  //                               ? const SliderWidget()
  //                               : const SizedBox();
  //                         }),
  //                       ),
  //                       Obx(() {
  //                         return categoryController.categoryModel.value.data ==
  //                             null
  //                             ? Padding(
  //                           padding: EdgeInsets.only(top: 20.h),
  //                           child: const CategoriesSectionShimmer(),
  //                         )
  //                             : categoryController
  //                             .categoryModel.value.data!.isNotEmpty
  //                             ? const CategoryWidget()
  //                             : const SizedBox();
  //                       }),
  //                       PromotionBanner()
  //                     ],
  //                   ),
  //                   // SizedBox(height: 32.h),
  //                   SizedBox(
  //                     child: Obx(() {
  //                       return productSectionController
  //                           .productSection.value.data ==
  //                           null
  //                           ? const ProductShimmer()
  //                           : productSectionController
  //                           .productSection.value.data!.isNotEmpty
  //                           ? ListView.builder(
  //                           shrinkWrap: true,
  //                           padding: EdgeInsets.zero,
  //                           physics: const NeverScrollableScrollPhysics(),
  //                           itemCount: productSectionController
  //                               .productSection.value.data?.length,
  //                           itemBuilder: (context, index) {
  //                             final section = productSectionController
  //                                 .productSection.value.data;
  //                             return section![index].products!.isNotEmpty
  //                                 ? Padding(
  //                               padding:
  //                               EdgeInsets.only(right: 16.w),
  //                               child: Column(
  //                                 crossAxisAlignment:
  //                                 CrossAxisAlignment.start,
  //                                 children: [
  //                                   TitleWidget(
  //                                       text: section[index]
  //                                           .name
  //                                           .toString()),
  //                                   SizedBox(height: 12.h),
  //                                   StaggeredGrid.count(
  //                                     crossAxisCount: 2,
  //                                     mainAxisSpacing: 16.h,
  //                                     crossAxisSpacing: 16.w,
  //                                     children: [
  //                                       for (var i = 0;
  //                                       i <
  //                                           section[index]
  //                                               .products!
  //                                               .length;
  //                                       i++)
  //                                         Obx(
  //                                               () => ProductWidget(
  //                                             onTap: () {
  //                                               Get.to(
  //                                                     () => ProductDetailsScreen(
  //                                                     sectionModel:
  //                                                     section[
  //                                                     index],
  //                                                     productModel:
  //                                                     section[index]
  //                                                         .products![i]),
  //                                               );
  //                                             },
  //                                             favTap: () async {
  //                                               if (box.read(
  //                                                   'isLogedIn') !=
  //                                                   false) {
  //                                                 if (section[index]
  //                                                     .products![
  //                                                 i]
  //                                                     .wishlist ==
  //                                                     true) {
  //                                                   await wishListController
  //                                                       .toggleFavoriteFalse(section[
  //                                                   index]
  //                                                       .products![
  //                                                   i]
  //                                                       .id!);
  //                                                   wishListController
  //                                                       .showFavorite(section[
  //                                                   index]
  //                                                       .products![
  //                                                   i]
  //                                                       .id!);
  //                                                 }
  //                                                 if (section[index]
  //                                                     .products![
  //                                                 i]
  //                                                     .wishlist ==
  //                                                     false) {
  //                                                   await wishListController
  //                                                       .toggleFavoriteTrue(section[
  //                                                   index]
  //                                                       .products![
  //                                                   i]
  //                                                       .id!);
  //                                                   wishListController
  //                                                       .showFavorite(section[
  //                                                   index]
  //                                                       .products![
  //                                                   i]
  //                                                       .id!);
  //                                                 }
  //                                               } else {
  //                                                 Get.to(() =>
  //                                                 const SignInScreen());
  //                                               }
  //                                             },
  //                                             wishlist: wishListController
  //                                                 .favList
  //                                                 .contains(section[index]
  //                                                 .products![
  //                                             i]
  //                                                 .id!) ||
  //                                                 productSectionController
  //                                                     .productSection
  //                                                     .value
  //                                                     .data![
  //                                                 index]
  //                                                     .products![
  //                                                 i]
  //                                                     .wishlist ==
  //                                                     true
  //                                                 ? true
  //                                                 : false,
  //                                             productImage:
  //                                             section[index]
  //                                                 .products![i]
  //                                                 .cover!,
  //                                             title: section[index]
  //                                                 .products![i]
  //                                                 .name,
  //                                             rating: section[index]
  //                                                 .products![i]
  //                                                 .ratingStar,
  //                                             currentPrice: section[
  //                                             index]
  //                                                 .products![i]
  //                                                 .currencyPrice,
  //                                             discountPrice: section[
  //                                             index]
  //                                                 .products![i]
  //                                                 .discountedPrice,
  //                                             textRating: section[
  //                                             index]
  //                                                 .products![i]
  //                                                 .ratingStarCount,
  //                                             flashSale:
  //                                             section[index]
  //                                                 .products![i]
  //                                                 .flashSale!,
  //                                             isOffer:
  //                                             section[index]
  //                                                 .products![i]
  //                                                 .isOffer!,
  //                                           ),
  //                                         ),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 32.h),
  //                                   MultiPromotionBanner(
  //                                     pIndex: index,
  //                                   ),
  //                                 ],
  //                               ),
  //                             )
  //                                 : const SizedBox();
  //                           })
  //                           : const SizedBox();
  //                     }),
  //                   ),
  //                   Obx(
  //                         () => popularProductController.popularModel.value.data ==
  //                         null
  //                         ? const ProductShimmer()
  //                         : popularProductController
  //                         .popularModel.value.data!.isNotEmpty
  //                         ? Padding(
  //                       padding: EdgeInsets.only(right: 16.w),
  //                       child: Column(
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.only(right: 16.w),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 TitleWidget(text: "Most Popular".tr),
  //                                 SeeAllButton(
  //                                   onTap: () async {
  //                                     Get.to(
  //                                           () => const ProductlistScreen(
  //                                         id: 5,
  //                                         title: "Most Popular",
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           SizedBox(height: 16.h),
  //                           StaggeredGrid.count(
  //                             crossAxisCount: 2,
  //                             mainAxisSpacing: 16.h,
  //                             crossAxisSpacing: 16.w,
  //                             children: [
  //                               for (int index = 0;
  //                               index <
  //                                   popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data!
  //                                       .length;
  //                               index++)
  //                                 ProductWidget(
  //                                   onTap: () {
  //                                     Get.to(() => ProductDetailsScreen(
  //                                         individualProduct:
  //                                         popularProductController
  //                                             .popularModel
  //                                             .value
  //                                             .data?[index]));
  //                                   },
  //                                   wishlist: wishListController.favList
  //                                       .contains(
  //                                       popularProductController
  //                                           .popularModel
  //                                           .value
  //                                           .data![index]
  //                                           .id!) ||
  //                                       popularProductController
  //                                           .popularModel
  //                                           .value
  //                                           .data?[index]
  //                                           .wishlist ==
  //                                           true
  //                                       ? true
  //                                       : false,
  //                                   favTap: () async {
  //                                     if (box.read('isLogedIn') !=
  //                                         false) {
  //                                       if (popularProductController
  //                                           .popularModel
  //                                           .value
  //                                           .data?[index]
  //                                           .wishlist ==
  //                                           true) {
  //                                         await wishListController
  //                                             .toggleFavoriteFalse(
  //                                             popularProductController
  //                                                 .popularModel
  //                                                 .value
  //                                                 .data![index]
  //                                                 .id!);
  //
  //                                         wishListController.showFavorite(
  //                                             popularProductController
  //                                                 .popularModel
  //                                                 .value
  //                                                 .data![index]
  //                                                 .id!);
  //                                       }
  //                                       if (popularProductController
  //                                           .popularModel
  //                                           .value
  //                                           .data?[index]
  //                                           .wishlist ==
  //                                           false) {
  //                                         await wishListController
  //                                             .toggleFavoriteTrue(
  //                                             popularProductController
  //                                                 .popularModel
  //                                                 .value
  //                                                 .data![index]
  //                                                 .id!);
  //
  //                                         wishListController.showFavorite(
  //                                             popularProductController
  //                                                 .popularModel
  //                                                 .value
  //                                                 .data![index]
  //                                                 .id!);
  //                                       }
  //                                     } else {
  //                                       Get.to(
  //                                               () => const SignInScreen());
  //                                     }
  //                                   },
  //                                   productImage:
  //                                   popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .cover!,
  //                                   title: popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .name,
  //                                   rating: popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .ratingStar
  //                                       .toString(),
  //                                   currentPrice:
  //                                   popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .currencyPrice,
  //                                   discountPrice:
  //                                   popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .discountedPrice,
  //                                   textRating: popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .ratingStarCount,
  //                                   flashSale: popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .flashSale!,
  //                                   isOffer: popularProductController
  //                                       .popularModel
  //                                       .value
  //                                       .data?[index]
  //                                       .isOffer!,
  //                                 ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                         : const SizedBox(),
  //                   ),
  //                   SizedBox(height: 34.h),
  //                   Obx(
  //                         () => flashSaleController.flashSaleModel.value.data == null
  //                         ? const ProductShimmer()
  //                         : flashSaleController
  //                         .flashSaleModel.value.data!.isNotEmpty
  //                         ? Padding(
  //                       padding: EdgeInsets.only(right: 16.w),
  //                       child: Obx(
  //                             () => Column(
  //                           children: [
  //                             Padding(
  //                               padding: EdgeInsets.only(right: 16.w),
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   TitleWidget(text: 'Flash Sale'.tr),
  //                                   SeeAllButton(
  //                                     onTap: () {
  //                                       Get.to(
  //                                             () => const ProductlistScreen(
  //                                           id: 10,
  //                                           title: "Flash Sale",
  //                                         ),
  //                                       );
  //                                     },
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(height: 16.h),
  //                             StaggeredGrid.count(
  //                               crossAxisCount: 2,
  //                               mainAxisSpacing: 16.h,
  //                               crossAxisSpacing: 16.w,
  //                               children: [
  //                                 for (int index = 0;
  //                                 index <
  //                                     flashSaleController
  //                                         .flashSaleModel
  //                                         .value
  //                                         .data!
  //                                         .length;
  //                                 index++)
  //                                   Obx(() {
  //                                     final flashSale =
  //                                     flashSaleController
  //                                         .flashSaleModel
  //                                         .value
  //                                         .data![index];
  //
  //                                     return Obx(
  //                                           () => ProductWidget(
  //                                         onTap: () {
  //                                           Get.to(
  //                                                 () =>
  //                                                 ProductDetailsScreen(
  //                                                   individualProduct:
  //                                                   flashSaleController
  //                                                       .flashSaleModel
  //                                                       .value
  //                                                       .data?[index],
  //                                                 ),
  //                                           );
  //                                         },
  //                                         wishlist: wishListController
  //                                             .favList
  //                                             .contains(
  //                                             flashSale
  //                                                 .id!) ||
  //                                             flashSale.wishlist ==
  //                                                 true
  //                                             ? true
  //                                             : false,
  //                                         favTap: () async {
  //                                           if (box.read('isLogedIn') !=
  //                                               false) {
  //                                             if (flashSale.wishlist ==
  //                                                 true) {
  //                                               await wishListController
  //                                                   .toggleFavoriteFalse(
  //                                                   flashSale.id!);
  //                                               wishListController
  //                                                   .showFavorite(
  //                                                   flashSale.id!);
  //                                             }
  //                                             if (flashSale.wishlist ==
  //                                                 false) {
  //                                               await wishListController
  //                                                   .toggleFavoriteTrue(
  //                                                   flashSale.id!);
  //
  //                                               wishListController
  //                                                   .showFavorite(
  //                                                   flashSale.id!);
  //                                             }
  //                                           } else {
  //                                             Get.to(() =>
  //                                             const SignInScreen());
  //                                           }
  //                                         },
  //                                         favColor: wishListController
  //                                             .favList
  //                                             .contains(
  //                                             flashSale.id!)
  //                                             ? SvgIcon.filledHeart
  //                                             : SvgIcon.heart,
  //                                         productImage:
  //                                         flashSale.cover!,
  //                                         title: flashSale.name,
  //                                         rating: flashSale.ratingStar
  //                                             .toString(),
  //                                         currentPrice:
  //                                         flashSale.currencyPrice,
  //                                         discountPrice:
  //                                         flashSale.discountedPrice,
  //                                         textRating:
  //                                         flashSale.ratingStarCount,
  //                                         flashSale:
  //                                         flashSale.flashSale!,
  //                                         isOffer: flashSale.isOffer!,
  //                                       ),
  //                                     );
  //                                   }),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     )
  //                         : const SizedBox(),
  //                   ),
  //                   SizedBox(height: 34.h),
  //                   Obx(
  //                         () => brandController.brandModel.value.data != null
  //                         ? Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         TitleWidget(text: "Popular Brands".tr),
  //                         SizedBox(height: 16.h),
  //                         SizedBox(
  //                           height: brandController
  //                               .brandModel.value.data?.isEmpty ??
  //                               false
  //                               ? 0
  //                               : 100.h,
  //                           child: ListView.builder(
  //                             scrollDirection: Axis.horizontal,
  //                             shrinkWrap: true,
  //                             itemCount: brandController
  //                                 .brandModel.value.data?.length,
  //                             itemBuilder: (context, index) {
  //                               return InkWell(
  //                                 borderRadius: BorderRadius.circular(16.r),
  //                                 onTap: () {
  //                                   filterController.addHomeBrandId(
  //                                       brandController.brandModel.value
  //                                           .data![index].id
  //                                           .toString());
  //
  //                                   Get.to(() => CategoryWiseProductScreen(
  //                                     brandName: brandController
  //                                         .brandModel
  //                                         .value
  //                                         .data?[index]
  //                                         .name,
  //                                   ));
  //                                 },
  //                                 child: Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 4.w),
  //                                   child: Obx(
  //                                         () => brandController.brandModel.value
  //                                         .data ==
  //                                         null ||
  //                                         brandController.brandModel
  //                                             .value.data!.isEmpty
  //                                         ? Shimmer.fromColors(
  //                                       baseColor: Colors.grey[200]!,
  //                                       highlightColor:
  //                                       Colors.grey[300]!,
  //                                       child: Container(
  //                                         height: 90.h,
  //                                         width: 100.w,
  //                                         decoration: BoxDecoration(
  //                                             borderRadius:
  //                                             BorderRadius
  //                                                 .circular(16.r),
  //                                             color: Colors.white),
  //                                       ),
  //                                     )
  //                                         : Ink(
  //                                       height: 90,
  //                                       width: 100,
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         border: Border.all(
  //                                             color: AppColor
  //                                                 .borderColor),
  //                                         borderRadius:
  //                                         BorderRadius.circular(
  //                                             16.r),
  //                                       ),
  //                                       child: Padding(
  //                                         padding:
  //                                         EdgeInsets.all(8.sp),
  //                                         child: Column(
  //                                           mainAxisAlignment:
  //                                           MainAxisAlignment
  //                                               .spaceAround,
  //                                           children: [
  //                                             CachedNetworkImage(
  //                                                 imageUrl:
  //                                                 brandController
  //                                                     .brandModel
  //                                                     .value
  //                                                     .data![
  //                                                 index]
  //                                                     .cover
  //                                                     .toString(),
  //                                                 fit: BoxFit.cover,
  //                                                 imageBuilder: (context,
  //                                                     imageProvider) =>
  //                                                     Container(
  //                                                       height: 20.h,
  //                                                       width: 60.w,
  //                                                       decoration:
  //                                                       BoxDecoration(
  //                                                         image: DecorationImage(
  //                                                             image:
  //                                                             imageProvider),
  //                                                       ),
  //                                                     )),
  //                                             SizedBox(height: 20.h),
  //                                             CustomText(
  //                                               text: brandController
  //                                                   .brandModel
  //                                                   .value
  //                                                   .data?[index]
  //                                                   .name ??
  //                                                   "",
  //                                               color: AppColor
  //                                                   .textColor,
  //                                               weight:
  //                                               FontWeight.w600,
  //                                               size: 12.sp,
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: brandController
  //                               .brandModel.value.data?.isEmpty ??
  //                               false
  //                               ? 0
  //                               : 100.h,
  //                         )
  //                       ],
  //                     )
  //                         : const SizedBox(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}



// Fixed Height Search Bar Delegate
class _FixedSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final double margin;

  _FixedSearchBarDelegate(this.backgroundColor, this.margin);

  @override
  double get minExtent => 60.0; // Fixed height
  @override
  double get maxExtent => 60.0; // Fixed height

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: margin), // Dynamic margin
      alignment: Alignment.center,
      child: SizedBox(
        height: 40, // Ensuring fixed height for search bar
        child: InkWell(
          onTap: (){
            Get.to(() => const SearchScreen());
          },
          child: Container(
            height: 42.h,
            width: 328.w,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColor.grayColor),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.r),
                  child: SvgPicture.asset(
                    SvgIcon.search,
                    colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.dst),
                  ),
                ),
                Text("Search")
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

// StickyHeaderDelegate for SliverPersistentHeader
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 80.0;
  @override
  double get maxExtent => 80.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
