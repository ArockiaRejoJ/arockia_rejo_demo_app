import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/firebase_options.dart';
import 'package:assessment_app/providers/authentication_provider.dart';
import 'package:assessment_app/providers/category_provider.dart';
import 'package:assessment_app/providers/products_provider.dart';
import 'package:assessment_app/screens/authentication_screen.dart';
import 'package:assessment_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensures widgets are initialized before Firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Main widget that builds the app UI
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for user authentication state
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        // Proxy provider for managing categories data
        ChangeNotifierProxyProvider(
          create: (_) => CategoryProvider(
            [],
          ),
          update: (context, auth, previousData) => CategoryProvider(
            previousData == null ? [] : previousData.categoryList,
          ),
        ),
        // Proxy provider for managing products data
        ChangeNotifierProxyProvider(
          create: (_) => ProductsProvider(
            [],
          ),
          update: (context, auth, previousData) => ProductsProvider(
            previousData == null ? [] : previousData.productsList,
          ),
        ),
      ],
      child: ScreenUtilInit(
        // Initializes screen size for responsive UI
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (_, child) {
          return Consumer<UserProvider>(
            // Main MaterialApp with authentication check
            builder: (context, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Arockia Rejo - Demo Application',
              theme: ThemeData(
                scaffoldBackgroundColor: bgColor,
                fontFamily: GoogleFonts.poppins().fontFamily,
                colorScheme: ColorScheme.fromSeed(seedColor: bgColor),
                useMaterial3: true,
                // Sets the default text theme for the app
                textTheme: TextTheme(
                  headlineMedium: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  headlineSmall: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  titleSmall: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
              ),
              // Determines if the user is authenticated
              home: auth.isAuth
                  ? const SplashScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, authResultSnapshot) =>
                          const AuthenticationScreen(),
                    ),
            ),
          );
        },
      ),
    );
  }
}
