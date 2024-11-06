import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/providers/category_provider.dart';
import 'package:assessment_app/providers/products_provider.dart';
import 'package:assessment_app/screens/authentication_screen.dart';
import 'package:assessment_app/screens/product_overview_screen.dart';
import 'package:assessment_app/widgets/category_card.dart';
import 'package:assessment_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future? categoryFuture; // Future to fetch categories asynchronously
  Future? productsFuture; // Future to fetch products asynchronously

  // Method to fetch categories from the provider
  Future getCategories() async {
    return Provider.of<CategoryProvider>(context, listen: false)
        .getCategories();
  }

  // Method to fetch products from the provider
  Future getProducts() async {
    return Provider.of<ProductsProvider>(context, listen: false).getProducts();
  }

  @override
  void initState() {
    super.initState();
    categoryFuture = getCategories(); // Initialize category data fetching
    productsFuture = getProducts(); // Initialize product data fetching
  }

  @override
  Widget build(BuildContext context) {
    // Get category and product lists from their respective providers
    final categoriesData = Provider.of<CategoryProvider>(context).categoryList;
    final productsData = Provider.of<ProductsProvider>(context).productsList;

    return PopScope(
      // Disabling the back navigation (canPop: false)
      canPop: false,
      onPopInvoked: (bool values) {
        // Show a dialog to confirm whether the user wants to exit the app
        showDialog<bool>(
          context: context,
          barrierDismissible:
              false, // Prevent dismissing by tapping outside the dialog
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.r), // Circular border for the dialog
                ),
              ),
              backgroundColor: bgColor, // Set background color of the dialog
              content: Text(
                "Are you sure you want to exit?", // The message in the dialog
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600),
              ),
              actions: <Widget>[
                // 'No' button to cancel the exit action
                TextButton(
                  child: Text(
                    "No", // Button text
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Close dialog without exiting
                  },
                ),
                // 'Yes, Exit' button to close the app
                TextButton(
                  child: Text(
                    "Yes, Exit", // Button text
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    SystemNavigator.pop(); // Close the app
                  },
                ),
              ],
            );
          },
        );
        // Return false to prevent the default pop behavior (going back)
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Choose your product',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 30.h,
                fontSize: 20.sp),
          ),
          actions: [
            // Search icon with gradient background in AppBar
            Container(
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
                "assets/icons/search.svg",
                fit: BoxFit.cover,
              )),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.transparent, Colors.transparent, seeBlue, violet],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Displaying categories in a horizontal ListView with FutureBuilder
                SizedBox(
                  height: 120.h,
                  width: 390.w,
                  child: FutureBuilder(
                    future: categoryFuture, // Future to fetch categories
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show loader while waiting
                      } else if (snapshot.hasError) {
                        // Show error message if fetching fails
                        return Center(
                          child: Text(
                            "Failed to load categories: ${snapshot.error}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        );
                      } else {
                        // Display categories or empty message if no categories found
                        return categoriesData.isEmpty
                            ? Center(
                                child: Text(
                                  "No Category found",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(left: 15.w),
                                itemCount: categoriesData.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    ChangeNotifierProvider.value(
                                        value: categoriesData[index],
                                        child: const CategoryCard()),
                              );
                      }
                    },
                  ),
                ),
                // Displaying products in a grid layout with FutureBuilder
                Expanded(
                  child: FutureBuilder(
                    future: productsFuture, // Future to fetch products
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show loader while waiting
                      } else if (snapshot.hasError) {
                        // Show error message if fetching fails
                        return Center(
                          child: Text(
                            "Failed to load products: ${snapshot.error}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        );
                      } else {
                        // Display products or empty message if no products found
                        return productsData.isEmpty
                            ? Center(
                                child: Text(
                                  "No Products found",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 230.h,
                                        crossAxisSpacing: 20.w,
                                        mainAxisSpacing: 25.h),
                                itemCount: productsData.length,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                itemBuilder: (context, index) =>
                                    ChangeNotifierProvider.value(
                                  value: productsData[index],
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      // Navigate to ProductOverviewScreen on tap
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider.value(
                                            value: productsData[index],
                                            child:
                                                const ProductOverviewScreen(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProductCard(
                                      indexValue: index, // Display product card
                                    ),
                                  ),
                                ),
                              );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom navigation bar with icons
        bottomNavigationBar: Container(
          height: 70.h,
          width: 390.w,
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [violet, grey],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Navigation icons with SVG assets
              Container(
                height: 44.h,
                width: 60.w,
                margin: EdgeInsets.only(right: 20.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.h, color: Colors.white10),
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
                  "assets/icons/bicycle.svg",
                  fit: BoxFit.cover,
                )),
              ),
              SvgPicture.asset(
                "assets/icons/map.svg",
                fit: BoxFit.cover,
              ),
              SvgPicture.asset(
                "assets/icons/cart.svg",
                fit: BoxFit.cover,
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _logout(context);
                },
                child: SvgPicture.asset(
                  "assets/icons/person.svg",
                  fit: BoxFit.cover,
                ),
              ),
              SvgPicture.asset(
                "assets/icons/doc.svg",
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Logout popup dialog
  _logout(BuildContext context) {
    // Fetch the UserProvider instance for handling the logout action
    final auth = Provider.of<UserProvider>(context, listen: false);

    // Show the logout confirmation dialog
    return showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent the dialog from closing if tapped outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25.r), // Set a rounded border for the dialog
            ),
          ),
          backgroundColor: Colors.white, // Background color of the dialog
          content: Text(
            'Are you sure you want to logout?', // Message inside the dialog
            style: TextStyle(
              fontWeight: FontWeight.w400, // Font weight for the text
              fontFamily: GoogleFonts.poppins().fontFamily, // Font family
              fontSize: 14.sp, // Font size of the text
              color: Colors.black, // Color of the text
            ),
          ),
          actions: <Widget>[
            // 'No' button to cancel the logout
            TextButton(
              child: Text(
                "No", // Text for the button
                style: TextStyle(
                  color: Colors.green, // Color of the 'No' button text
                  fontSize: 12, // Font size of the text
                  fontFamily: GoogleFonts.poppins().fontFamily, // Font family
                  fontWeight: FontWeight.w600, // Font weight
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog and don't log out
              },
            ),
            // 'Yes, Logout' button to confirm logout
            TextButton(
              child: Text(
                "Yes, Logout", // Text for the button
                style: TextStyle(
                  color: Colors.red, // Color of the 'Yes, Logout' button text
                  fontSize: 12, // Font size of the text
                  fontFamily: GoogleFonts.poppins().fontFamily, // Font family
                  fontWeight: FontWeight.w600, // Font weight
                ),
              ),
              onPressed: () {
                auth.logout(); // Log out the user by calling the logout method
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AuthenticationScreen(), // Navigate to Authentication screen after logout
                  ),
                  ModalRoute.withName(
                      '/'), // Remove all previous routes to prevent navigating back
                );
              },
            ),
          ],
        );
      },
    );
  }
}
