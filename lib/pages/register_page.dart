// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:business_card/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../assets/colors.dart';
import '../assets/size.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  //final VoidCallback showLoginPage;
  // ignore: use_key_in_widget_constructors
  const RegisterPage({
    Key? key,
    //required this.showLoginPage,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formFieldKey = GlobalKey<FormFieldState>();
  bool isPasswordHidden = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: const [Colouring.colorGradient1, Colouring.colorGradient2],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      )),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Center(
            child: Column(children: [
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.10),
              ),
              Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colouring.colorGrey,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.08),
              ),
              Row(
                children: [
                  //First name
                  Padding(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.06)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.025)),
                      height: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.06),
                      width: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.09),
                            height: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.09),
                            decoration: BoxDecoration(
                                color: Colouring.colorGradient1,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.019)),
                              child: SvgPicture.asset(
                                'assets/images/icon_name.svg',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.02)),
                            child: SizedBox(
                              width: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.26),
                              child: TextFormField(
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                ]),
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colouring.colorTransGrey),
                                    hintText: 'First Name'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Last name
                  Padding(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.08)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.025)),
                      height: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.06),
                      width: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.09),
                            height: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.09),
                            decoration: BoxDecoration(
                                color: Colouring.colorGradient1,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.019)),
                              child: SvgPicture.asset(
                                'assets/images/icon_name.svg',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.02)),
                            child: SizedBox(
                              width: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.26),
                              child: TextFormField(
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                ]),
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colouring.colorTransGrey),
                                    hintText: 'Last name'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.05),
              ),
              //email field

              Form(
                key: _formFieldKey,
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.025)),
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.06),
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.88),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.022),
                        top: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.022)),
                    child: Container(
                      alignment: Alignment.center,
                      width: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.09),
                      height: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.09),
                      decoration: BoxDecoration(
                          color: Colouring.colorGradient1,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.019)),
                        child: SvgPicture.asset(
                          'assets/images/icon_email.svg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.8),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.125),
                          top: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.005)),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          EmailValidator(errorText: 'Enter Valid email id')
                        ]),
                        controller: _emailController,
                        decoration: InputDecoration(
                            counterText: " ",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.014),
                            ),
                            hintStyle:
                                TextStyle(color: Colouring.colorTransGrey),
                            hintText: 'email'),
                      ),
                    ),
                  ),
                ]),
              ),

              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.025),
              ),
              // password field
              Form(
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.025)),
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.06),
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.88),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.022),
                        top: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.022)),
                    child: Container(
                      alignment: Alignment.center,
                      width: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.09),
                      height: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.09),
                      decoration: BoxDecoration(
                          color: Colouring.colorGradient1,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.019)),
                        child: SvgPicture.asset(
                          'assets/images/icon_password.svg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.85),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.125)),
                      child: TextFormField(
                        obscureText: isPasswordHidden,
                        textAlignVertical: TextAlignVertical.center,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(6,
                              errorText:
                                  'Password should be atleast 6 characters')
                        ]),
                        controller: _passwordController,
                        decoration: InputDecoration(
                            counterText: " ",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.014),
                            ),
                            hintStyle:
                                TextStyle(color: Colouring.colorTransGrey),
                            hintText: 'password',
                            suffixIcon: IconButton(
                              alignment: Alignment.centerRight,
                              iconSize: 25,
                              icon: isPasswordHidden
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              color: Colouring.colorTransGrey,
                              onPressed: togglePasswordVisibility,
                            )),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.025),
              ),

              //repeat password
              Form(
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.025)),
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.06),
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.88),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.022),
                        top: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.022)),
                    child: Container(
                      alignment: Alignment.center,
                      width: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.09),
                      height: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.09),
                      decoration: BoxDecoration(
                          color: Colouring.colorGradient1,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.019)),
                        child: SvgPicture.asset(
                          'assets/images/icon_password.svg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.85),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.125)),
                      child: TextFormField(
                        obscureText: isPasswordHidden,
                        textAlignVertical: TextAlignVertical.center,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(6,
                              errorText:
                                  'Password should be atleast 6 characters')
                        ]),
                        controller: _repeatPasswordController,
                        decoration: InputDecoration(
                            counterText: " ",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.014),
                            ),
                            hintStyle:
                                TextStyle(color: Colouring.colorTransGrey),
                            hintText: 'repeat password',
                            suffixIcon: IconButton(
                              alignment: Alignment.centerRight,
                              iconSize: 25,
                              icon: isPasswordHidden
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              color: Colouring.colorTransGrey,
                              onPressed: togglePasswordVisibility,
                            )),
                      ),
                    ),
                  ),
                ]),
              ),
              // Register button
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.015),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.06)),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colouring.colorButtonBlue),
                      overlayColor: MaterialStateProperty.all(
                          Colouring.colorButtonPressedBlue),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      fixedSize: MaterialStateProperty.all(Size(
                          double.infinity,
                          RelativeSize(context: context)
                              .getScreenHeightPercentage(0.055)))),
                  /**
                         * onPressedRegisterButton
                         * 
                         * 
                         * 
                         * 
                         */
                  onPressed: () async {
                    await createUserWithEmailAndPassword();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colouring.colorWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.015),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colouring.colorLightGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(_createRoute()),
                    child: Text(
                      " Login now",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colouring.colorLightBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: RelativeSize(context: context)
                    .getScreenHeightPercentage(0.025),
              ),
            ]),
          ),
        )),
      ),
    );
  }

  void togglePasswordVisibility() =>
      setState(() => isPasswordHidden = !isPasswordHidden);

  Future createUserWithEmailAndPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (_passwordController.text == _repeatPasswordController.text) {
      UserCredential? result;
      try {
        result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        User? user = result.user;
        await user!.updateDisplayName(
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}");
        await user.reload();
        print("Current user ${FirebaseAuth.instance.currentUser}");

        final ref = FirebaseDatabase.instance.ref("users");
        await ref.update({user.uid: "social_media"});
        final map = {
          "email": user.email,
          "display_name":
              "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
          "photoURL": "-1"
        };
        await ref.child(user.uid).update(map);
        //await user?.updateDisplayName(
        //  "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}");
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        if (!mounted) return;
        FocusManager.instance.primaryFocus?.unfocus();
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).push(goToHomePage());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          createErrorMessage(
              "  Your password is too weak. Try again.", ContentType.warning);
          result = null;
        } else if (e.code == 'email-already-in-use') {
          createErrorMessage(
              "  Email is already in use. Try using different one.",
              ContentType.failure);
          result = null;
        } else if (e.code == 'invalid-email') {
          createErrorMessage("Invalid email. Try again.", ContentType.failure);
          result = null;
        }
      } catch (e) {
        createErrorMessage(e.toString(), ContentType.failure);
        result = null;
      }
    } else {
      createErrorMessage("   Passwords don't match.", ContentType.failure);
    }
  }

  void createErrorMessage(String message, ContentType contentType) {
    // ignore: prefer_typing_uninitialized_variables
    var snackBar;
    if (contentType == ContentType.failure) {
      snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: "Error!",
          message: message,
          contentType: contentType,
        ),
      );
    } else if (contentType == ContentType.warning) {
      snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: "Warning!",
          message: message,
          contentType: contentType,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  Route goToHomePage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1, 0);
          const end = Offset.zero;
          var curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
