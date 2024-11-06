import 'package:assessment_app/constants/constants.dart';
import 'package:assessment_app/providers/authentication_provider.dart';
import 'package:assessment_app/screens/products_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


// login and Register Screen
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  // Border for Text form field
  final InputBorder _formBorder =
      const UnderlineInputBorder(borderSide: BorderSide(color: seeBlue));

  //form key
  final _registerFormKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();


  bool isLoading = false;
  bool _passwordVisible = true;
  String? errorMessage;
  final textFieldFocusNode = FocusNode();

  // Password section
  void _toggleObscured() {
    setState(() {
      _passwordVisible = !_passwordVisible;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, don't unfocused
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  bool isLogin = false;


  // submit function
  Future<void> submit() async {
    setState(() {
      errorMessage = null;
    });
    final isValid = _registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _registerFormKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        await Provider.of<UserProvider>(context, listen: false)
            .signIn(_emailController.text, _passwordController.text);
      } else {
        await Provider.of<UserProvider>(context, listen: false)
            .signup(_emailController.text, _passwordController.text);
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ProductsScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.toString(); // Ensure errorMessage is a String type
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString(); // Ensure errorMessage is a String type
      });
    } finally {
      _registerFormKey.currentState!.reset();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _registerFormKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 150.h,
                        width: 150.w,
                        child: Image.asset("assets/images/logo.jpeg")),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 330.w,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: _formBorder,
                          enabledBorder: _formBorder,
                          border: _formBorder,
                          hintText: "Your E-mail",
                          hintStyle: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          contentPadding: EdgeInsets.all(8.h),
                        ),
                        validator: (value) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = RegExp(pattern.toString());
                          if (value!.isEmpty) {
                            return 'Enter E-mail';
                          } else if (!regex.hasMatch(value)) {
                            return 'Enter Valid E-mail';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      // height: 50.h,
                      width: 330.w,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _passwordVisible,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: _formBorder,
                          enabledBorder: _formBorder,
                          border: _formBorder,
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          contentPadding: EdgeInsets.all(8.h),
                          suffixIconColor: Colors.white24,
                          suffixIcon: IconButton(
                            icon: _passwordVisible
                                ? Icon(
                                    Icons.lock_outline,
                                    size: 22.sp,
                                  )
                                : Icon(
                                    Icons.lock_open_outlined,
                                    size: 22.sp,
                                  ),
                            onPressed: _toggleObscured,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter password";
                          } else if (value.length < 7) {
                            return "Password length minimum 8 characters";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (!isLogin)
                      SizedBox(
                        // height: 50.h,
                        width: 330.w,
                        child: TextFormField(
                          controller: _cPasswordController,
                          obscureText: _passwordVisible,
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            focusedBorder: _formBorder,
                            enabledBorder: _formBorder,
                            border: _formBorder,
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            fillColor: Colors.transparent,
                            filled: true,
                            contentPadding: EdgeInsets.all(8.h),
                            suffixIconColor: Colors.white24,
                            suffixIcon: IconButton(
                              icon: _passwordVisible
                                  ? Icon(
                                      Icons.lock_outline,
                                      size: 22.sp,
                                    )
                                  : Icon(
                                      Icons.lock_open_outlined,
                                      size: 22.sp,
                                    ),
                              onPressed: _toggleObscured,
                            ),
                          ),
                          validator: (value) {
                            if (!isLogin) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              } else if (value != _passwordController.text) {
                                return "Password Mismatch";
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    SizedBox(
                      height: 15.h,
                    ),
                    if (errorMessage != null)
                      Text(
                        "${errorMessage}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      width: 200.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seeBlue,
                          disabledBackgroundColor: grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        onPressed: submit,
                        child: Center(
                          child: isLoading
                              ? Padding(
                                  padding: EdgeInsets.all(3.h),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isLogin ? "Login" : 'Signup',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      letterSpacing: 0.8),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Don't have account? Signup"
                              : 'Already signed up? Login',
                          style: Theme.of(context).textTheme.titleSmall,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
