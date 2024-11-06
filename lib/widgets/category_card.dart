import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the category data from the Provider
    final category = Provider.of<CategoryModel>(context);

    return Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: Column(
        children: [
          // Container for the category image with error handling
          Container(
            height: 80.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Image.network(
              category.image,
              fit: BoxFit.cover,
              errorBuilder: (context, exception, stackTrace) {
                // Show default image if network image fails
                return Image.asset(
                  'assets/images/logo.jpeg',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          // Display the category name
          Text(
            category.name,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}
