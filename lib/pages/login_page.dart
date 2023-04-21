// ignore_for_file: prefer_const_constructors
import 'dart:collection';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:business_card/pages/register_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../assets/size.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    this.userSocialMedia,
  }) : super(key: key);
  final dynamic userSocialMedia;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordHidden = true;
  bool isElevated = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late Map<String, dynamic>? userSocialMedia = widget.userSocialMedia;

  Future signInWithEmailAndPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    UserCredential? result;

    try {
      result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        createError('No user found for that email.', ContentType.failure);
        result = null;
      } else if (e.code == 'wrong-password') {
        createError(
            'Wrong password provided for that user.', ContentType.failure);
        result = null;
      }
    } catch (e) {
      createError(e.toString(), ContentType.failure);
      result = null;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (!mounted) return;
    Navigator.of(context).pop();

    if (result != null) {
      if (!mounted) return;
      Navigator.of(context).push(goToHomePage());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double paddingForTextfields = MediaQuery.of(context).size.width * 0.1;
    double paddingForLines =
        ((MediaQuery.of(context).size.width / 2 - paddingForTextfields) * 0.8) /
            MediaQuery.of(context).size.width;

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: const [Color(0xFFCAE9FB), Color(0xFFE5F4FD)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(children: [
                  //welcome back text
                  SizedBox(
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.14),
                  ),
                  Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF707070),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.05),
                  ),
                  //Email Textfield
                  Form(
                    child: Stack(children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.025)),
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.06),
                        width: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.8),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                        .getScreenHeightPercentage(0.005),
                  ),
                  //password field
                  Form(
                    child: Stack(children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.025)),
                          height: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.06),
                          width: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.122),
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
                                  .getScreenWidthPercentage(0.225)),
                          child: TextFormField(
                            obscureText: isPasswordHidden,
                            textAlignVertical: TextAlignVertical.center,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                        .getScreenHeightPercentage(0.005),
                  ),
                  //Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                            color: Color(0xFFBBBBBB),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: RelativeSize(context: context)
                        .getScreenHeightPercentage(0.035),
                  ),
                  //loginButton
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF363DFF)),
                          overlayColor:
                              MaterialStateProperty.all(Color(0xFF0007CF)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          fixedSize: MaterialStateProperty.all(Size(
                              double.infinity,
                              RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.055)))),
                      /**
                       * onPressedLoginButton
                       * 
                       * 
                       * 
                       * 
                       */
                      onPressed: () async {
                        await signInWithEmailAndPassword();
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
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
                  //don't have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).push(_createRoute()),
                        child: Text(
                          " Register now",
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
                        .getScreenHeightPercentage(0.05),
                  ),
                  //or
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          height: 1,
                          width: RelativeSize(context: context)
                              .getScreenWidthPercentage(paddingForLines),
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            RelativeSize(context: context)
                                .getScreenWidthPercentage(0.05),
                            0,
                            0,
                            0),
                        child: Text(
                          "or",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            RelativeSize(context: context)
                                .getScreenWidthPercentage(0.05),
                            0,
                            0,
                            0),
                        child: Container(
                          height: 1,
                          width: RelativeSize(context: context)
                              .getScreenWidthPercentage(paddingForLines),
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                      height: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.06)),
                  //google button
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFDB4437)),
                            overlayColor:
                                MaterialStateProperty.all(Color(0xFFD21100)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            fixedSize: MaterialStateProperty.all(Size(
                                double.infinity,
                                RelativeSize(context: context)
                                    .getScreenHeightPercentage(0.055)))),
                        onPressed: () async {
                          await googleSignIn();
                          if (!mounted) return;
                          Navigator.of(context).push(goToHomePage());
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SvgPicture.asset(
                                'assets/images/icon_google.svg',
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Login with Google",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        )),
                  ),
                  //facebook button
                  SizedBox(
                      height: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.015)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.1)),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF4267B2)),
                            overlayColor:
                                MaterialStateProperty.all(Color(0xFF234996)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            fixedSize: MaterialStateProperty.all(Size(
                                double.infinity,
                                RelativeSize(context: context)
                                    .getScreenHeightPercentage(0.055)))),
                        onPressed: () async {
                          final LoginResult result = await FacebookAuth.instance
                              .login(); // by default we request the email and the public profile
                          // or FacebookAuth.i.login()
                          if (result.status == LoginStatus.success) {
                            // you are logged
                            //if (!mounted) return;
                            try {
                              final OAuthCredential credential =
                                  FacebookAuthProvider.credential(
                                      result.accessToken!.token);
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              if (!mounted) return;
                              Navigator.of(context).push(goToHomePage());
                            } on FirebaseAuthException catch (e) {
                              if (e.code ==
                                  'account-exists-with-different-credential') {
                                createError(
                                    'There is already an account with these credentials. Try using different providers',
                                    ContentType.failure);
                              } else if (e.code == 'invalid-credential') {
                                createError('Invalid credentials. Try again.',
                                    ContentType.failure);
                              }
                            }
                          } else {
                            createError("An error occured. Try again",
                                ContentType.failure);
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SvgPicture.asset(
                                'assets/images/icon_facebook.svg',
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Login with Facebook",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        )),
                  ),
                  //end
                ]),
              ),
            ),
          ),
        ));
  }

  void togglePasswordVisibility() =>
      setState(() => isPasswordHidden = !isPasswordHidden);

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
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

  googleSignIn() async {
    //Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    //Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //create new credentials
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void createError(String message, ContentType contentType) {
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

  Route<Object> goToHomePage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(
              userSocialMedia: userSocialMedia,
              firstConnection: true,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
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

  Future<void> createUserDatabase() async {
    User? user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseDatabase.instance.ref("users");
    //print(user?.uid);
    final event = await ref.get();
    if (user != null) {
      if (event.exists) {
        final ev = await ref.child('${user.uid}/social_media').get();
        print('Not error 1 ');
        if (ev.value != "") {
          print('Not error 2 ');
          userSocialMedia = SplayTreeMap<String, dynamic>.from(
              ev.value as Map<dynamic, dynamic>,
              (key1, key2) => key1.compareTo(key2));
        }
      } else {
        await ref.set({user.uid: "social_media"});
      }
    }
  }
}
