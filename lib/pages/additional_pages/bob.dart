import 'package:business_card/language_constants.dart';
import 'package:business_card/pages/home_page.dart';
import 'package:business_card/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:rive/rive.dart';

import '../../styles/size.dart';

class BOB extends StatefulWidget {
  const BOB({super.key});

  @override
  State<BOB> createState() => _BOBState();
}

class _BOBState extends State<BOB> with TickerProviderStateMixin {
  User? user;
  final _formKey = GlobalKey<FormState>();

  final focusNodeForCompleteRegistration = FocusNode();
  final focusNodeForCompleteRegistration2 = FocusNode();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _animationControllerForOTP;
  late Animation<Offset> _slideAnimationForOTP;
  late AnimationController _animationControllerForCompletingRegistration;
  late Animation<Offset> _slideAnimationForCompletingRegistration;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late double paddingForLines =
      ((MediaQuery.of(context).size.width / 2 - paddingForTextfields) * 0.8) /
          MediaQuery.of(context).size.width;
  late double paddingForTextfields = MediaQuery.of(context).size.width * 0.1;
  late RiveAnimationController _btnAnimationController;

  bool isSignInDialogShown = false;
  bool isConfirmationWidgetShown = false;
  bool isCompleteRegistrationWidgetShown = false;
  bool isDown = false;
  bool isWidgetVisible = false;
  bool isShowLoading = false;

  TextEditingController controller = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String _verificationCode = '';
  String _fullPhoneNum = '';
  Country _selectedCountry =
      countries.firstWhere((country) => country.name == "United States");
  Offset currentPos = const Offset(0, -0.96);
  FocusNode myFocusNode = FocusNode();

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? smController =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(smController!);
    return smController;
  }

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_animationController);

    _animationControllerForOTP = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animationControllerForCompletingRegistration = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _slideAnimationForOTP = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(_animationControllerForOTP);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationControllerForOTP.dispose();
    _animationControllerForCompletingRegistration.dispose();
    _btnAnimationController.dispose();
    controller.dispose();
    myFocusNode.dispose();
    focusNodeForCompleteRegistration.dispose();
    focusNodeForCompleteRegistration2.dispose();
    super.dispose();
  }

  Route<Object> goToHomePage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(
              firstConnection: true,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
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

  void _slideLeft() async {
    setState(() {
      _slideAnimation = Tween<Offset>(
        begin: currentPos,
        end: Offset(currentPos.dx - 1, currentPos.dy),
      ).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));

      _slideAnimationForOTP = Tween<Offset>(
              begin: Offset(currentPos.dx + 1, currentPos.dy), end: currentPos)
          .animate(CurvedAnimation(
              parent: _animationControllerForOTP, curve: Curves.easeInOut));
      _slideAnimationForCompletingRegistration = Tween<Offset>(
              begin: Offset(currentPos.dx + 2, currentPos.dy),
              end: Offset(currentPos.dx + 1, currentPos.dy))
          .animate(CurvedAnimation(
              parent: _animationControllerForCompletingRegistration,
              curve: Curves.easeInOut));
    });
    _animationController.forward(from: 0);
    _animationControllerForOTP.forward(from: 0);
    _animationControllerForCompletingRegistration.forward(from: 0);
    currentPos = Offset(currentPos.dx - 1, currentPos.dy);
    myFocusNode.unfocus();
    await Future.delayed(const Duration(milliseconds: 250));
  }

  void _slideRight(double to) async {
    setState(() {
      _slideAnimation = Tween<Offset>(
        begin: currentPos,
        end: Offset(to + 1, currentPos.dy),
      ).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));

      _slideAnimationForOTP = Tween<Offset>(
              begin: Offset(currentPos.dx + 1, currentPos.dy),
              end: Offset(to + 2, currentPos.dy))
          .animate(CurvedAnimation(
              parent: _animationControllerForOTP, curve: Curves.easeInOut));
      _slideAnimationForCompletingRegistration = Tween<Offset>(
              begin: Offset(currentPos.dx + 2, currentPos.dy),
              end: Offset(to + 3, currentPos.dy))
          .animate(CurvedAnimation(
              parent: _animationControllerForCompletingRegistration,
              curve: Curves.easeInOut));
    });

    _animationController.forward(from: 0);
    _animationControllerForOTP.forward(from: 0);
    _animationControllerForCompletingRegistration.forward(from: 0);
    currentPos = Offset(to + 1, currentPos.dy);
    await Future.delayed(const Duration(milliseconds: 250));
  }

  void _slideDown() {
    setState(() {
      _slideAnimation = Tween<Offset>(
        begin: currentPos,
        end: Offset(currentPos.dx, currentPos.dy + 1),
      ).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));
      isDown = true;
    });
    _animationController.forward(from: 0);
    currentPos = Offset(currentPos.dx, currentPos.dy + 1);
  }

  void _slideUp() async {
    setState(() {
      _slideAnimation = Tween<Offset>(
        begin: currentPos,
        end: Offset(currentPos.dx, currentPos.dy - 1),
      ).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));
      isDown = false;
      _animationController.forward(from: 0);
    });
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      isWidgetVisible = false;
    });
    currentPos = Offset(currentPos.dx, currentPos.dy - 1);
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    final auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          //automatic verification, only on Android
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(translatedText(context).qr_screen_close))
                    ],
                    title: Text(translatedText(context).qr_screen_error),
                    content: Text(e.message.toString()),
                  ));
        },
        codeSent: (String verificationID, int? resendToken) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
              width: RelativeSize(context: context).getScreenWidthPercentage(1),
              height:
                  RelativeSize(context: context).getScreenHeightPercentage(1),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background_dark.jpg'),
                      fit: BoxFit.cover)),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 240),
                    top: isSignInDialogShown
                        ? RelativeSize(context: context)
                            .getScreenHeightPercentage(-0.06)
                        : 0,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: RelativeSize(context: context)
                                    .getScreenHeightPercentage(0.2),
                                right: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.2)),
                            child: RichText(
                              text: const TextSpan(
                                  text: 'S',
                                  style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.w600,
                                      color: Colouring.colorAlmostWhite),
                                  children: [
                                    TextSpan(
                                      text: 'ocially',
                                      style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w600,
                                          color: Colouring.colorAlmostWhite),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.04),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.08)),
                            child: Text(
                              translatedText(context).main_screen_text,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Colouring.colorLightLightGrey),
                            ),
                          ),
                          SizedBox(
                            height: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.3),
                          ),
                          AnimatedBtn(
                            btnAnimationController: _btnAnimationController,
                            press: () {
                              _btnAnimationController.isActive = true;
                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                setState(() {
                                  if (isSignInDialogShown == false) {
                                    _slideDown();
                                  }
                                  isSignInDialogShown = true;
                                  isWidgetVisible = true;
                                });
                                // customSignInDialog(context, onClosed: (_) {
                                //   setState(() {
                                //     isSignInDialogShown = false;
                                //   });
                                // });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isWidgetVisible) signInScreen(),
                  if (isConfirmationWidgetShown)
                    Positioned.fill(
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: Colors.transparent,
                        body: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: double.infinity,
                          child: SlideTransition(
                            position: _slideAnimationForOTP,
                            child: SizedBox(
                              height: RelativeSize(context: context)
                                  .getScreenHeightPercentage(0.75),
                              child: Center(
                                child: Container(
                                  height: RelativeSize(context: context)
                                      .getScreenHeightPercentage(0.80),
                                  width: RelativeSize(context: context)
                                      .getScreenWidthPercentage(0.875),
                                  color: Colors.transparent,
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(
                                        bottom: RelativeSize(context: context)
                                            .getScreenHeightPercentage(0.05)),
                                    height: RelativeSize(context: context)
                                        .getScreenHeightPercentage(0.75),
                                    width: RelativeSize(context: context)
                                        .getScreenWidthPercentage(0.875),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF7F7F7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                RelativeSize(context: context)
                                                    .getScreenWidthPercentage(
                                                        0.12)))),
                                    child: Scaffold(
                                      resizeToAvoidBottomInset: false,
                                      backgroundColor: Colors.transparent,
                                      body: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: IconButton(
                                                    padding: EdgeInsets.only(
                                                        top: RelativeSize(
                                                                context:
                                                                    context)
                                                            .getScreenWidthPercentage(
                                                                0.04),
                                                        left: RelativeSize(
                                                                context:
                                                                    context)
                                                            .getScreenWidthPercentage(
                                                                0.04)),
                                                    onPressed: () =>
                                                        setState(() {
                                                          isShowLoading = false;

                                                          _slideRight(
                                                              currentPos.dx);
                                                          isConfirmationWidgetShown =
                                                              false;
                                                        }),
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      size: RelativeSize(
                                                              context: context)
                                                          .getScreenWidthPercentage(
                                                              0.08),
                                                    )),
                                              ),
                                              Text(
                                                translatedText(context)
                                                    .main_screen_verification,
                                                style: const TextStyle(
                                                    fontSize: 35,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: RelativeSize(
                                                        context: context)
                                                    .getScreenHeightPercentage(
                                                        0.035),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  translatedText(context)
                                                      .main_screen_verification_text,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colouring
                                                          .colorLightGrey),
                                                ),
                                              ),
                                              SizedBox(
                                                height: RelativeSize(
                                                        context: context)
                                                    .getScreenHeightPercentage(
                                                        0.035),
                                              ),
                                              SizedBox(
                                                height: RelativeSize(
                                                        context: context)
                                                    .getScreenHeightPercentage(
                                                        0.065),
                                                width: double.infinity,
                                                child: Pinput(
                                                    length: 6,
                                                    focusedPinTheme: PinTheme(
                                                      width: RelativeSize(
                                                              context: context)
                                                          .getScreenWidthPercentage(
                                                              0.121),
                                                      height: RelativeSize(
                                                              context: context)
                                                          .getScreenHeightPercentage(
                                                              0.0726),
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colouring
                                                                .colorGrey),
                                                        borderRadius: BorderRadius
                                                            .circular(RelativeSize(
                                                                    context:
                                                                        context)
                                                                .getScreenWidthPercentage(
                                                                    0.03)),
                                                      ),
                                                    ),
                                                    defaultPinTheme: PinTheme(
                                                      width: RelativeSize(
                                                              context: context)
                                                          .getScreenWidthPercentage(
                                                              0.11),
                                                      height: RelativeSize(
                                                              context: context)
                                                          .getScreenHeightPercentage(
                                                              0.066),
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colouring
                                                                .colorLightGrey),
                                                        borderRadius: BorderRadius
                                                            .circular(RelativeSize(
                                                                    context:
                                                                        context)
                                                                .getScreenWidthPercentage(
                                                                    0.03)),
                                                      ),
                                                    ),
                                                    onCompleted: (pin) async {
                                                      try {
                                                        final us = PhoneAuthProvider
                                                            .credential(
                                                                verificationId:
                                                                    _verificationCode,
                                                                smsCode: pin);
                                                        await FirebaseAuth
                                                            .instance
                                                            .signInWithCredential(
                                                                us);

                                                        user = FirebaseAuth
                                                            .instance
                                                            .currentUser;
                                                        if (user != null) {
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 1));
                                                          check.fire();
                                                          await Future.delayed(
                                                              const Duration(
                                                                  seconds: 2));
                                                          _slideLeft();
                                                          setState(() {
                                                            isShowLoading =
                                                                false;

                                                            if (FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.displayName ==
                                                                null) {
                                                              isConfirmationWidgetShown =
                                                                  false;
                                                              isCompleteRegistrationWidgetShown =
                                                                  true;
                                                            } else {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      goToHomePage());
                                                            }
                                                          });
                                                        } else {
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 1));
                                                          error.fire();
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 2),
                                                              () {
                                                            setState(() {
                                                              isShowLoading =
                                                                  false;
                                                            });
                                                          });
                                                        }
                                                      } on FirebaseAuthException catch (_) {
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 1));
                                                        error.fire();
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 2),
                                                            () {
                                                          setState(() {
                                                            isShowLoading =
                                                                false;
                                                          });
                                                        });
                                                      }
                                                    },
                                                    onChanged: (pin) async {
                                                      setState(() {
                                                        isShowLoading = true;
                                                      });
                                                    }),
                                              )
                                            ],
                                          ),
                                          if (isShowLoading)
                                            CustomPositioned(
                                              child: RiveAnimation.asset(
                                                'assets/anim/check.riv',
                                                onInit: (artboard) {
                                                  StateMachineController
                                                      smController =
                                                      getRiveController(
                                                          artboard);
                                                  check = smController.findSMI(
                                                      "Check") as SMITrigger;
                                                  error = smController.findSMI(
                                                      "Error") as SMITrigger;
                                                  reset = smController.findSMI(
                                                      "Reset") as SMITrigger;
                                                },
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isCompleteRegistrationWidgetShown)
                    completeRegistrationScreen()
                ],
              )),
        ),
      ),
    );
  }

  Widget completeRegistrationScreen() {
    return AnimatedPositioned(
      curve: Curves.easeInOutCirc,
      duration: const Duration(milliseconds: 180),
      top: focusNodeForCompleteRegistration.hasFocus
          ? 0
          : RelativeSize(context: context).getScreenHeightPercentage(0.1),
      left: RelativeSize(context: context).getScreenWidthPercentage(0.0625),
      child: Center(
        child: SlideTransition(
          position: _slideAnimationForCompletingRegistration,
          child: Container(
            height:
                RelativeSize(context: context).getScreenHeightPercentage(0.75),
            width:
                RelativeSize(context: context).getScreenWidthPercentage(0.875),
            decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.all(Radius.circular(
                    RelativeSize(context: context)
                        .getScreenWidthPercentage(0.12)))),
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            padding: EdgeInsets.only(
                                top: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.04),
                                left: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.04)),
                            onPressed: () => setState(() {
                                  FirebaseAuth.instance.signOut;
                                  isConfirmationWidgetShown = false;
                                  isCompleteRegistrationWidgetShown = false;

                                  _slideRight(currentPos.dx + 1);
                                }),
                            icon: Icon(
                              Icons.arrow_back,
                              size: RelativeSize(context: context)
                                  .getScreenWidthPercentage(0.08),
                            )),
                      ),
                      Text(
                        translatedText(context)
                            .main_screen_complete_registration,
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.035),
                      ),
                      Center(
                        /*alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: RelativeSize(context: context)
                                                    .getScreenWidthPercentage(0.075)),*/
                        child: Text(
                          translatedText(context)
                              .main_screen_complete_registration_text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, color: Colouring.colorLightGrey),
                        ),
                      ),
                      SizedBox(
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.035),
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.04),
                                bottom: 2),
                            alignment: Alignment.center,
                            height: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.08),
                            width: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.75),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.065)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.1)),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: translatedText(context)
                                        .finish_sm_screen_error_required_field),
                                PatternValidator(
                                    r'^[a-zA-Z\u00C0-\u017e\u0400-\u04FF ]{1,32}$',
                                    errorText: translatedText(context)
                                        .main_screen_error_text)
                              ]).call,
                              focusNode: focusNodeForCompleteRegistration2,
                              onTap: () {
                                setState(() {
                                  focusNodeForCompleteRegistration2
                                      .requestFocus();
                                });
                              },
                              onTapOutside: (_) {
                                setState(() {
                                  focusNodeForCompleteRegistration2.unfocus();
                                });
                              },
                              onEditingComplete: () {
                                setState(() {
                                  focusNodeForCompleteRegistration2.unfocus();
                                });
                              },
                              controller: nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: const TextStyle(
                                      color: Colouring.colorTransGrey,
                                      fontSize: 21),
                                  hintText: translatedText(context)
                                      .main_screen_hintText_name),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 21),
                            ),
                          ),
                          //),
                        ],
                      ),
                      SizedBox(
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.03),
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.04),
                                bottom: 2),
                            alignment: Alignment.center,
                            height: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.08),
                            width: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.75),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.065)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.1)),
                            child: TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: translatedText(context)
                                        .finish_sm_screen_error_required_field),
                                PatternValidator(
                                    r'^[a-zA-Z\u00C0-\u017e\u0400-\u04FF ]{1,32}$',
                                    errorText: translatedText(context)
                                        .main_screen_error_text)
                              ]).call,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: lastnameController,
                              focusNode: focusNodeForCompleteRegistration,
                              onTap: () {
                                setState(() {
                                  focusNodeForCompleteRegistration
                                      .requestFocus();
                                });
                              },
                              onTapOutside: (_) {
                                setState(() {
                                  focusNodeForCompleteRegistration.unfocus();
                                });
                              },
                              onEditingComplete: () {
                                setState(() {
                                  focusNodeForCompleteRegistration.unfocus();
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: const TextStyle(
                                      color: Colouring.colorTransGrey,
                                      fontSize: 21),
                                  hintText: translatedText(context)
                                      .main_screen_hintText_surname),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 21),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.03),
                      ),
                      SizedBox(
                        width: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.75),
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User user = FirebaseAuth.instance.currentUser!;
                                await user.updateDisplayName(
                                    "${nameController.text.trim()} ${lastnameController.text.trim()}");
                                final firestoreDatabase =
                                    FirebaseFirestore.instance;
                                await firestoreDatabase
                                    .collection("users")
                                    .doc(user.uid)
                                    .set({
                                  "display_name":
                                      "${nameController.text.trim()} ${lastnameController.text.trim()}",
                                  "photoURL": "-1",
                                  "social_media": {}
                                }, SetOptions(merge: true));
                                if (!mounted) return;
                                Navigator.of(context).push(goToHomePage());
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colouring.colorBlueGradient1),
                                overlayColor: MaterialStateProperty.all(
                                    Colouring.colorDarkDarkBlue),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(RelativeSize(context: context)
                                            .getScreenWidthPercentage(0.025)),
                                        topRight: Radius.circular(RelativeSize(
                                                context: context)
                                            .getScreenWidthPercentage(0.065)),
                                        bottomLeft: Radius.circular(RelativeSize(context: context).getScreenWidthPercentage(0.065)),
                                        bottomRight: Radius.circular(RelativeSize(context: context).getScreenWidthPercentage(0.065))))),
                                fixedSize: MaterialStateProperty.all(Size(double.infinity, RelativeSize(context: context).getScreenWidthPercentage(0.16)))),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                translatedText(context).main_screen_continue,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      ),
                    ],
                  ),
                  if (isShowLoading)
                    CustomPositioned(
                      child: RiveAnimation.asset(
                        'assets/anim/check.riv',
                        onInit: (artboard) {
                          StateMachineController smController =
                              getRiveController(artboard);
                          check = smController.findSMI("Check") as SMITrigger;
                          error = smController.findSMI("Error") as SMITrigger;
                          reset = smController.findSMI("Reset") as SMITrigger;
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signInScreen() {
    // return Positioned.fill(
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.only(
            top:
                RelativeSize(context: context).getScreenHeightPercentage(0.08)),
        color: Colors.black54,
        width: double.infinity,
        height: double.infinity,
        child: SlideTransition(
          position: _slideAnimation,
          child: SizedBox(
            height:
                RelativeSize(context: context).getScreenHeightPercentage(0.75),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.80),
                  width: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.875),
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(
                            bottom: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.025)),
                        height: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.75),
                        width: RelativeSize(context: context)
                            .getScreenWidthPercentage(0.875),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.all(Radius.circular(
                                RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.1)))),
                        child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Colors.transparent,
                          body: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Scaffold(
                                resizeToAvoidBottomInset: false,
                                backgroundColor: Colors.transparent,
                                body: Column(
                                  children: [
                                    SizedBox(
                                      height: RelativeSize(context: context)
                                          .getScreenHeightPercentage(0.045),
                                    ),
                                    Text(
                                      translatedText(context).main_screen_login,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: RelativeSize(context: context)
                                          .getScreenHeightPercentage(0.01),
                                    ),
                                    SizedBox(
                                      width: RelativeSize(context: context)
                                          .getScreenWidthPercentage(0.7),
                                      child: Text(
                                        translatedText(context)
                                            .main_screen_login_text,
                                        style: const TextStyle(
                                            color: Colouring.colorLightGrey,
                                            fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      height: RelativeSize(context: context)
                                          .getScreenHeightPercentage(0.03),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: RelativeSize(
                                                  context: context)
                                              .getScreenWidthPercentage(0.05)),
                                      child: IntlPhoneField(
                                        validator: (p0) {
                                          if (p0!.number.isNotEmpty) {
                                            RegExp regExp = RegExp(r'^\d+$');
                                            if (!regExp.hasMatch(p0.number)) {
                                              return translatedText(context)
                                                  .error_text_invalid_phone_number;
                                            }
                                          }
                                          return null;
                                        },
                                        invalidNumberMessage: translatedText(
                                                context)
                                            .error_text_invalid_phone_number,
                                        languageCode:
                                            translatedText(context).localeName,
                                        controller: controller,
                                        onChanged: (value) => setState(() {
                                          _fullPhoneNum = value.completeNumber;
                                        }),
                                        focusNode: myFocusNode,
                                        dropdownIcon: Icon(
                                          Icons.arrow_drop_down,
                                          color: myFocusNode.hasPrimaryFocus &&
                                                  controller.text.isNotEmpty
                                              ? Colors.pink.shade200
                                              : Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          labelStyle: myFocusNode
                                                      .hasPrimaryFocus &&
                                                  controller.text.isNotEmpty
                                              ? TextStyle(
                                                  color: Colors.pink.shade200)
                                              : const TextStyle(
                                                  color:
                                                      Colouring.colorLightGrey),
                                          labelText: translatedText(context)
                                              .main_screen_login_phone_num,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    Colouring.colorLightGrey),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    Colouring.colorLightGrey),
                                          ),
                                        ),
                                        initialCountryCode: 'US',
                                        onCountryChanged: (country) {
                                          _selectedCountry = country;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: RelativeSize(context: context)
                                          .getScreenHeightPercentage(0.025),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: RelativeSize(
                                                  context: context)
                                              .getScreenWidthPercentage(0.05)),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (_fullPhoneNum.length ==
                                                    _selectedCountry.maxLength +
                                                        _selectedCountry
                                                            .dialCode.length +
                                                        1 &&
                                                RegExp(r'^[+]\d+$')
                                                    .hasMatch(_fullPhoneNum)) {
                                              setState(() {
                                                _slideLeft();
                                                isConfirmationWidgetShown =
                                                    true;
                                                _verifyPhoneNumber(
                                                    _fullPhoneNum);
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                  Colouring.colorBlueGradient1),
                                              overlayColor: MaterialStateProperty.all(
                                                  Colouring.colorDarkDarkBlue),
                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          RelativeSize(context: context)
                                                              .getScreenWidthPercentage(
                                                                  0.025)),
                                                      topRight: Radius.circular(
                                                          RelativeSize(context: context).getScreenWidthPercentage(0.065)),
                                                      bottomLeft: Radius.circular(RelativeSize(context: context).getScreenWidthPercentage(0.065)),
                                                      bottomRight: Radius.circular(RelativeSize(context: context).getScreenWidthPercentage(0.065))))),
                                              fixedSize: MaterialStateProperty.all(Size(double.infinity, RelativeSize(context: context).getScreenWidthPercentage(0.16)))),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              translatedText(context)
                                                  .main_screen_continue,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: RelativeSize(context: context)
                                          .getScreenHeightPercentage(0.04),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 1,
                                          width: RelativeSize(context: context)
                                              .getScreenWidthPercentage(
                                                  paddingForLines),
                                          color: Colouring.colorLightGrey,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: RelativeSize(context: context)
                                                .getScreenWidthPercentage(0.05),
                                          ),
                                          child: Text(
                                            translatedText(context)
                                                .main_screen_or,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colouring.colorLightGrey,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: RelativeSize(context: context)
                                                .getScreenWidthPercentage(0.05),
                                          ),
                                          child: Container(
                                            height: 1,
                                            width:
                                                RelativeSize(context: context)
                                                    .getScreenWidthPercentage(
                                                        paddingForLines),
                                            color: Colouring.colorLightGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: RelativeSize(context: context)
                                          .getScreenHeightPercentage(0.04),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: RelativeSize(
                                                  context: context)
                                              .getScreenWidthPercentage(0.05)),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xFFDB4437)),
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xFFD21100)),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15))),
                                              fixedSize: MaterialStateProperty.all(Size(
                                                  double.infinity,
                                                  RelativeSize(context: context)
                                                      .getScreenHeightPercentage(0.07)))),
                                          onPressed: () async {
                                            await googleSignIn();
                                            if (!mounted) return;
                                            Navigator.of(context)
                                                .push(goToHomePage());
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
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: RelativeSize(
                                                              context: context)
                                                          .getScreenWidthPercentage(
                                                              0.06)),
                                                  child: Text(
                                                    translatedText(context)
                                                        .main_screen_login_with_google,
                                                    style: const TextStyle(
                                                        color: Colouring
                                                            .colorWhite,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                        height: RelativeSize(context: context)
                                            .getScreenHeightPercentage(0.03)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: RelativeSize(
                                                  context: context)
                                              .getScreenWidthPercentage(0.05)),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xFF4267B2)),
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      const Color(0xFF234996)),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15))),
                                              fixedSize: MaterialStateProperty.all(Size(
                                                  double.infinity,
                                                  RelativeSize(context: context)
                                                      .getScreenHeightPercentage(0.07)))),
                                          onPressed: () async {
                                            final LoginResult result =
                                                await FacebookAuth.instance
                                                    .login(); // by default we request the email and the public profile
                                            // or FacebookAuth.i.login()
                                            if (result.status ==
                                                LoginStatus.success) {
                                              // you are logged
                                              //if (!mounted) return;
                                              try {
                                                final OAuthCredential
                                                    credential =
                                                    FacebookAuthProvider
                                                        .credential(result
                                                            .accessToken!
                                                            .token);
                                                final cred = await FirebaseAuth
                                                    .instance
                                                    .signInWithCredential(
                                                        credential);
                                                if (cred.additionalUserInfo!
                                                    .isNewUser) {
                                                  User user = FirebaseAuth
                                                      .instance.currentUser!;
                                                  final firestoreDatabase =
                                                      FirebaseFirestore
                                                          .instance;
                                                  await firestoreDatabase
                                                      .collection("users")
                                                      .doc(user.uid)
                                                      .set({
                                                    "display_name":
                                                        user.displayName,
                                                    "photoURL": "-1",
                                                    "social_media": {}
                                                  }, SetOptions(merge: true));
                                                }

                                                if (!mounted) return;
                                                Navigator.of(context)
                                                    .push(goToHomePage());
                                              } on FirebaseAuthException catch (e) {
                                                if (e.code ==
                                                    'account-exists-with-different-credential') {
                                                  createError(
                                                      // ignore: use_build_context_synchronously
                                                      translatedText(context)
                                                          .facebook_auth_error_existing_account);
                                                } else if (e.code ==
                                                    'invalid-credential') {
                                                  createError(
                                                      // ignore: use_build_context_synchronously
                                                      translatedText(context)
                                                          .facebook_auth_error_invalid_credentials);
                                                } else {
                                                  createError(
                                                      // ignore: use_build_context_synchronously
                                                      translatedText(context)
                                                          .facebook_auth_error_unexpected);
                                                }
                                              }
                                            } else {
                                              createError(
                                                // ignore: use_build_context_synchronously
                                                translatedText(context)
                                                    .facebook_auth_error_unexpected,
                                              );
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
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: RelativeSize(
                                                              context: context)
                                                          .getScreenWidthPercentage(
                                                              0.06)),
                                                  child: Text(
                                                    translatedText(context)
                                                        .main_screen_login_with_facebook,
                                                    style: const TextStyle(
                                                        color: Colouring
                                                            .colorWhite,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: RelativeSize(context: context)
                              .getScreenHeightPercentage(0.0275),
                          left: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.05),
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isSignInDialogShown = false;
                                });
                                _slideUp();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  Future<void> googleSignIn() async {
    //Trigger the authentication flow
    try {
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
      final UserCredential cred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      ///////

      if (cred.additionalUserInfo!.isNewUser) {
        User user = FirebaseAuth.instance.currentUser!;
        final firestoreDatabase = FirebaseFirestore.instance;
        await firestoreDatabase.collection("users").doc(user.uid).set({
          "display_name": user.displayName,
          "photoURL": "-1",
          "social_media": {}
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        createError(
            // ignore: use_build_context_synchronously
            translatedText(context).facebook_auth_error_existing_account);
      } else if (e.code == 'invalid-credential') {
        createError(
            // ignore: use_build_context_synchronously
            translatedText(context).facebook_auth_error_invalid_credentials);
      } else {
        createError(
            // ignore: use_build_context_synchronously
            translatedText(context).facebook_auth_error_unexpected);
      }
    }
  }

  Future<void> createError(String code) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(translatedText(context).qr_screen_close))
              ],
              title: Text(translatedText(context).qr_screen_error),
              content: Text(code),
            ));
  }
}

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  }) : _btnAnimationController = btnAnimationController;

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.only(
            right:
                RelativeSize(context: context).getScreenWidthPercentage(0.075)),
        child: SizedBox(
          width: RelativeSize(context: context).getScreenWidthPercentage(0.6),
          height: RelativeSize(context: context)
              .getScreenHeightPercentage(16 / 211),
          child: Stack(children: [
            RiveAnimation.asset(
              'assets/anim/button.riv',
              controllers: [_btnAnimationController],
            ),
            Positioned.fill(
              top: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.005),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 30,
                  ),
                  SizedBox(
                    width: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.01),
                  ),
                  Text(
                    translatedText(context).main_screen_button,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Column(
      children: [
        const Spacer(),
        SizedBox(
            width:
                RelativeSize(context: context).getScreenHeightPercentage(0.1),
            height:
                RelativeSize(context: context).getScreenHeightPercentage(0.1),
            child: child),
        const Spacer(
          flex: 1,
        )
      ],
    ));
  }
}
