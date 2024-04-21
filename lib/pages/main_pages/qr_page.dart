import 'package:business_card/language_constants.dart';
import 'package:business_card/pages/additional_pages/profile_page.dart';
import 'package:business_card/pages/main_pages/search_page.dart' as sp;
import 'package:business_card/styles/colors.dart';
import 'package:business_card/styles/size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

// iOS
// Add the following keys to your Info.plist file, located in NSCameraUsageDescription - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.

// If you want to use the local gallery feature from image_picker NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Usage Description in the visual editor.

// Example,

// <key>NSCameraUsageDescription</key>
// <string>This app needs camera access to scan QR codes</string>

// <key>NSPhotoLibraryUsageDescription</key>
// <string>This app needs photos access to get QR code from photo library</string>

class _QrPageState extends State<QrPage> {
  MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.stop();
  }

  late final Size scanArea = Size(
      RelativeSize(context: context).getScreenWidthPercentage(0.55),
      RelativeSize(context: context).getScreenWidthPercentage(0.55));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: MobileScanner(
            overlay: Center(
              child: Stack(
                children: [
                  ClipPath(
                    clipper:
                        MyCustomClipper(scanArea: scanArea, context: context),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Center(
                      child: CustomPaint(
                    foregroundPainter: BorderPainter(),
                    child: SizedBox(
                      width: scanArea.width + 25,
                      height: scanArea.height + 25,
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: RelativeSize(context: context)
                            .getScreenHeightPercentage(0.075)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              color: Colouring.colorGrey.withOpacity(0.8)),
                          child: IconButton(
                            onPressed: () => controller.toggleTorch(),
                            icon: ValueListenableBuilder(
                                valueListenable: controller.torchState,
                                builder: (context, state, child) {
                                  switch (state) {
                                    case TorchState.off:
                                      return const Icon(
                                        Icons.flash_off_rounded,
                                        color: Colouring.colorLightGrey,
                                      );
                                    case TorchState.on:
                                      return const Icon(
                                        Icons.flash_on_rounded,
                                        color: Colouring.colorLightGrey,
                                      );
                                  }
                                }),
                            iconSize: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.1),
                            highlightColor: Colouring.colorDarkGrey,
                          ),
                        ),
                        SizedBox(
                          width: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.15),
                        ),
                        Container(
                          decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              color: Colouring.colorGrey.withOpacity(0.8)),
                          child: IconButton(
                            onPressed: () => controller.switchCamera(),
                            icon: ValueListenableBuilder(
                                valueListenable: controller.cameraFacingState,
                                builder: (context, state, child) {
                                  return SizedBox(
                                    height: RelativeSize(context: context)
                                        .getScreenWidthPercentage(0.1),
                                    width: RelativeSize(context: context)
                                        .getScreenWidthPercentage(0.1),
                                    child: SvgPicture.asset(
                                      'assets/images/icon_switch_camera.svg',
                                      width: RelativeSize(context: context)
                                          .getScreenWidthPercentage(0.08),
                                      colorFilter: const ColorFilter.mode(
                                          Colouring.colorLightGrey,
                                          BlendMode.srcIn),
                                    ),
                                  );
                                }),
                            iconSize: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.1),
                            highlightColor: Colouring.colorDarkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            scanWindow: Rect.fromCenter(
                center: Offset(
                    RelativeSize(context: context)
                        .getScreenWidthPercentage(0.5),
                    RelativeSize(context: context)
                        .getScreenHeightPercentage(0.484)),
                width: scanArea.width,
                height: scanArea.height),
            controller: controller,
            onDetect: (capture) async {
              final Barcode code = capture.barcodes.first;
              await controller.stop();
              final list = await checkIfValidQr(code.rawValue);
              if (list[0]) {
                final DocumentSnapshot<Map<String, dynamic>>? data = list[1];
                sp.UserInfo userInfo = sp.UserInfo(
                    data!["display_name"], code.rawValue!, data["photoURL"]);
                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .push(_goToProfilePage(userInfo))
                    .then((value) async {
                  await controller.start();
                  setState(() {});
                });
              } else {
                // ignore: use_build_context_synchronously
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                    translatedText(context).qr_screen_close))
                          ],
                          title: Text(translatedText(context).qr_screen_error),
                          content: Text(list[2]),
                        ));
                await controller.start();
              }
            },
          ),
        ));
  }

  Future<List> checkIfValidQr(String? code) async {
    if (code == null ||
        code.length > 128 ||
        !RegExp(r'[0-9a-zA-Z]{27}[0-9]').hasMatch(code)) {
      return [false, null, translatedText(context).qr_screen_error_main];
    }
    if (FirebaseAuth.instance.currentUser!.uid == code) {
      return [
        false,
        null,
        translatedText(context).qr_screen_error_same_profile
      ];
    }
    final data =
        await FirebaseFirestore.instance.collection('users').doc(code).get();
    if (!data.exists) {
      return [
        false,
        null,
        // ignore: use_build_context_synchronously
        translatedText(context).qr_screen_error_main
      ];
    }
    return [true, data];
  }

  Route<Object?> _goToProfilePage(sp.UserInfo userInfo) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfilePage(userInfo: userInfo),
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
}

class MyCustomClipper extends CustomClipper<Path> {
  Size scanArea;
  BuildContext context;

  MyCustomClipper({required this.scanArea, required this.context});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
            (size.width - scanArea.width) / 2,
            (size.height - scanArea.height) / 2,
            scanArea.width,
            scanArea.height),
        Radius.circular(
            RelativeSize(context: context).getScreenWidthPercentage(0.07))));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.15; // desirable value for corners side

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
