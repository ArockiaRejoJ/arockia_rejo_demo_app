import 'package:assessment_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final int? indexValue;
  const ProductCard({this.indexValue, super.key});

  @override
  Widget build(BuildContext context) {
    // Access the product data from the Provider
    final product = Provider.of<ProductModel>(context);

    return Container(
      height: 165.h,
      width: 241.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white60,
            Colors.black45,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF353F54),
                Color(0xFF222834),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.w, 7.h, 10.w, 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display favorite icon based on product index
                Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(indexValue!.isOdd
                      ? "assets/icons/favourite.svg"
                      : "assets/icons/Outline.svg"),
                ),
                SizedBox(height: 7.h),
                // Display product image with error handling
                Center(
                  child: SizedBox(
                    height: 88.57.h,
                    width: 121.w,
                    child: Image.network(
                      product.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrace) {
                        return Image.asset(
                          'assets/images/logo.jpeg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Display product title
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                // Display product price
                Text(
                  "\$ ${product.price}.00",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
