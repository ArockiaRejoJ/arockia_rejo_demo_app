import 'package:assessment_app/constants/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Carousal extends StatefulWidget {
  final List<String>? images; // List of image URLs for the carousel
  const Carousal({this.images, super.key});

  @override
  State<Carousal> createState() => _CarousalState();
}

class _CarousalState extends State<Carousal> {
  int activeIndex = 0; // Index to track the current active slide

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Carousel slider displaying images
          SizedBox(
            height: 222.h,
            width: 287.w,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                viewportFraction: 1,
                aspectRatio: 2,
                initialPage: 1,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) => setState(
                      () => activeIndex = index, // Update active index on change
                ),
              ),
              items: widget.images!.map(
                    (data) {
                  return Builder(
                    builder: (BuildContext context) {
                      // Display each image in a container
                      return Container(
                        height: 222.h,
                        width: 287.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: bgColor, width: 0.1),
                        ),
                        child: Image.network(
                          data,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                height: 30.h,
                                width: 30.h,
                                child: const CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, exception, stackTrace) {
                            // Fallback image in case of loading error
                            return Image.asset(
                              'assets/images/logo.jpeg',
                              fit: BoxFit.fitWidth,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
          ),
          SizedBox(height: 15.h),
          // Smooth indicator for carousel position
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: widget.images!.length,
            effect: JumpingDotEffect(
              dotWidth: 6.w,
              dotHeight: 6.h,
              activeDotColor: Colors.white,
              dotColor: grey,
              paintStyle: PaintingStyle.stroke,
            ),
          ),
        ],
      ),
    );
  }
}
