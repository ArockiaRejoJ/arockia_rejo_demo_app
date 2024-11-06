import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/models/product_model.dart';
import 'package:assessment_app/widgets/carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart' as gusto;
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  int count = 0; // Cart item count

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context); // Access product data

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop(); // Navigate back
                    },
                    child: Container(
                      height: 44.h,
                      width: 44.w,
                      margin: EdgeInsets.only(right: 20.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.h,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF34C8E8),
                            Color(0xFF4E4AF2),
                          ],
                        ),
                      ),
                      child: Center(
                          child: SvgPicture.asset(
                        "assets/icons/chevron-down.svg",
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      product.title, // Display product title
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            Carousal(
              images: product.images,
            ), // Display multiple images as Slider
            SizedBox(height: 30.h),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF353F54),
                      Color(0xFF222834),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 32.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicButton(
                          height: 43.h,
                          width: 133.w,
                          borderRadius: 12,
                          bottomRightShadowBlurRadius: 5,
                          bottomRightShadowSpreadRadius: 1,
                          borderWidth: 2,
                          backgroundColor: const Color(0xFF353F54),
                          topLeftShadowBlurRadius: 5,
                          topLeftShadowSpreadRadius: 1,
                          topLeftShadowColor: seeBlue.withOpacity(0.1),
                          bottomRightShadowColor: Colors.black26,
                          padding: const EdgeInsets.all(5),
                          bottomRightOffset: const Offset(2, 2),
                          topLeftOffset: const Offset(-2, -2),
                          onTap: () {}, // Button tap action
                          child: Center(
                            child: Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: seeBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w),
                        gusto.Neumorphic(
                          style: gusto.NeumorphicStyle(
                            disableDepth: true,
                            depth: 5,
                            oppositeShadowLightSource: true,
                            color: const Color(0xFF353F54),
                            shape: gusto.NeumorphicShape.convex,
                            boxShape: gusto.NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10.r)),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Specifications',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 29.h, 30.w, 10.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.title, // Product title section
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0.h, 30.w, 10.h),
                      child: Text(
                        product.description, // Display product description
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white54,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400),
                        maxLines: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 104.h,
                      width: 390.w,
                      padding: EdgeInsets.fromLTRB(35.w, 30.h, 35.w, 30.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.r),
                              topRight: Radius.circular(50.r)),
                          color: const Color(0xFF262E3D),
                          border: Border.all(width: 0.5, color: Colors.black26),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(-2, -2),
                                color: Colors.black12,
                                blurRadius: 0.1,
                                spreadRadius: 1)
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$ ${product.price}.99", // Display product price
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.normal,
                                color: seeBlue),
                          ),
                          count == 0
                              ? InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      count++; // Increment item count
                                    });
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: 160.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF55D0EC),
                                              Color(0xFF615DF3)
                                            ])),
                                    child: Container(
                                      margin: EdgeInsets.all(1.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                              width: 0.2,
                                              color: Colors.black26),
                                          gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [seeBlue, violet])),
                                      child: Center(
                                        child: Text(
                                          'Add to cart',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 44.h,
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF55D0EC),
                                            Color(0xFF615DF3)
                                          ])),
                                  child: Container(
                                      margin: EdgeInsets.all(1.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                              width: 0.2,
                                              color: Colors.black26),
                                          gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [seeBlue, violet])),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  count--; // Decrement item count
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 20,
                                              )),
                                          SizedBox(width: 20.w),
                                          Text(
                                            '$count', // Display item count
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white),
                                          ),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  count++; // Increment item count
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              )),
                                        ],
                                      )),
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
