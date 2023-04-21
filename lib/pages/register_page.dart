// ignore_for_file: prefer_const_constructors

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:business_card/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

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
        colors: const [Color(0xFFCAE9FB), Color(0xFFE5F4FD)],
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
                  color: Color(0xFF707070),
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
                                color: Color(0xFFCAE9FB),
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
                                    hintStyle:
                                        TextStyle(color: Color(0x55707070)),
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
                                color: Color(0xFFCAE9FB),
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
                                    hintStyle:
                                        TextStyle(color: Color(0x55707070)),
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
                          color: Color(0xFFCAE9FB),
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
                            hintStyle: TextStyle(color: Color(0x55707070)),
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
                          color: Color(0xFFCAE9FB),
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
                            hintStyle: TextStyle(color: Color(0x55707070)),
                            hintText: 'password',
                            suffixIcon: IconButton(
                              alignment: Alignment.centerRight,
                              iconSize: 25,
                              icon: isPasswordHidden
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              color: Color(0x55707070),
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
                          color: Color(0xFFCAE9FB),
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
                            hintStyle: TextStyle(color: Color(0x55707070)),
                            hintText: 'repeat password',
                            suffixIcon: IconButton(
                              alignment: Alignment.centerRight,
                              iconSize: 25,
                              icon: isPasswordHidden
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              color: Color(0x55707070),
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
                          MaterialStateProperty.all(Color(0xFF363DFF)),
                      overlayColor:
                          MaterialStateProperty.all(Color(0xFF0007CF)),
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
                  onPressed: () {
                    createUserWithEmailAndPassword();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
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
                      color: Color(0xFFBBBBBB),
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
                        color: Color(0xFF51A0D5),
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
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
        final ref = FirebaseDatabase.instance.ref("users");
        ref.set({userCredential.user!.uid: "social_media"});
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

      if (result != null) {
        User? user = result.user;
        await user?.updateDisplayName(
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}");
        if (!mounted) return;
        Navigator.of(context).push(goToHomePage());
      }
      FocusManager.instance.primaryFocus?.unfocus();
      if (!mounted) return;
      Navigator.of(context).pop();
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
