import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

// splash screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AnimatedSplashScreen(
            backgroundColor: Colors.black,
            pageTransitionType: PageTransitionType.fade,
            duration: 3500,
            splashIconSize: 300,
            splash: SizedBox(
                height: 690.h,
                width: 360.w,
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  fit: BoxFit.cover,
                )),
            nextScreen: const ProductsScreen()),
      ),
    );
  }
}
