import 'package:business_card/pages/additional_pages/profile_page.dart';
import 'package:business_card/pages/main_pages/search_page.dart' as us;
import 'package:business_card/styles/colors.dart';
import 'package:business_card/styles/size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SavedUsers extends StatefulWidget {
  const SavedUsers({super.key});

  @override
  State<SavedUsers> createState() => _SavedUsersState();
}

class _SavedUsersState extends State<SavedUsers> {
  final TextEditingController _textController = TextEditingController();
  late final future;
  List savedUsers = [];

  Future<void> _getSavedUsers() async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = query.data() as Map<String, dynamic>;
    savedUsers = data['savedUsers'] as List;
    print(savedUsers);
  }

  Route<Object> _goToProfilePage(us.UserInfo userInfo) {
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    future = _getSavedUsers();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<void>(
    //     future: future,
    //     builder: (context, snapshot) {
    //       return Scaffold(
    //         backgroundColor: Colouring.colorLightLightGrey,
    //         resizeToAvoidBottomInset: false,
    //         body: SafeArea(
    //             child: Column(
    //           children: [
    //             SizedBox(
    //               height: RelativeSize(context: context)
    //                   .getScreenHeightPercentage(0.07),
    //             ),
    //             Container(
    //               alignment: Alignment.centerLeft,
    //               padding: EdgeInsets.only(
    //                   left: RelativeSize(context: context)
    //                       .getScreenWidthPercentage(0.1)),
    //               child: const Text(
    //                 "Saved users",
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.w600,
    //                     color: Colouring.colorGrey,
    //                     fontSize: 26),
    //               ),
    //             ),
    //             SizedBox(
    //               height: RelativeSize(context: context)
    //                   .getScreenHeightPercentage(0.02),
    //             ),
    //             SizedBox(
    //               height: RelativeSize(context: context)
    //                   .getScreenHeightPercentage(0.055),
    //               child: Padding(
    //                 padding: EdgeInsets.symmetric(
    //                     horizontal: RelativeSize(context: context)
    //                         .getScreenWidthPercentage(0.05)),
    //                 child: TextField(
    //                   controller: _textController,
    //                   onChanged: (value) => setState(() {}),
    //                   textAlignVertical: TextAlignVertical.center,
    //                   decoration: InputDecoration(
    //                       filled: true,
    //                       fillColor: Colors.white,
    //                       suffixIcon: const Icon(Icons.search),
    //                       suffixIconColor: Colouring.colorLightGrey,
    //                       border: OutlineInputBorder(
    //                           borderSide: BorderSide.none,
    //                           borderRadius: BorderRadius.circular(30)),
    //                       hintText: "Name",
    //                       contentPadding: EdgeInsets.symmetric(
    //                           vertical: RelativeSize(context: context)
    //                               .getScreenWidthPercentage(0.01),
    //                           horizontal: RelativeSize(context: context)
    //                               .getScreenWidthPercentage(0.05)),
    //                       hintStyle: const TextStyle(
    //                         fontWeight: FontWeight.w600,
    //                         color: Colouring.colorLightGrey,
    //                       ),
    //                       isDense: true),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: RelativeSize(context: context)
    //                   .getScreenHeightPercentage(0.05),
    //             ),
    //             Expanded(
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     color: Colouring.colorAlmostWhite,
    //                     borderRadius: BorderRadius.only(
    //                         topLeft: Radius.circular(
    //                             RelativeSize(context: context)
    //                                 .getScreenWidthPercentage(0.13)),
    //                         topRight: Radius.circular(
    //                             RelativeSize(context: context)
    //                                 .getScreenWidthPercentage(0.13)))),
    //                 width: double.infinity,
    //                 child: FirestorePagination(
    //                   query: FirebaseFirestore.instance
    //                       .collection("users")
    //                       .where(FieldPath.documentId, whereIn: savedUsers)
    //                       .orderBy(FieldPath.documentId),
    //                   itemBuilder: (context, documentSnapshot, index) {
    //                     final data =
    //                         documentSnapshot.data() as Map<dynamic, dynamic>;
    //                     final user = us.UserInfo(data["display_name"],
    //                         data["email"], data["photoURL"]);
    //                     if (user.displayName
    //                             .toLowerCase()
    //                             .contains(_textController.text.toLowerCase()) ||
    //                         user.email
    //                             .toLowerCase()
    //                             .contains(_textController.text.toLowerCase())) {
    //                       return GestureDetector(
    //                         onTap: () => Navigator.of(context)
    //                             .push(_goToProfilePage(user)),
    //                         child: ListTile(
    //                           title: Text(user.displayName),
    //                           subtitle: Text(user.email),
    //                           leading: user.photoURL == "-1"
    //                               ? SvgPicture.asset(
    //                                   'assets/images/icon_profile.svg',
    //                                   width: RelativeSize(context: context)
    //                                       .getScreenWidthPercentage(0.125),
    //                                 )
    //                               : CircleAvatar(
    //                                   backgroundImage:
    //                                       CachedNetworkImageProvider(
    //                                           user.photoURL),
    //                                   radius: RelativeSize(context: context)
    //                                       .getScreenWidthPercentage(0.0625),
    //                                 ),
    //                           contentPadding: EdgeInsets.symmetric(
    //                               vertical: RelativeSize(context: context)
    //                                   .getScreenHeightPercentage(0.01),
    //                               horizontal: RelativeSize(context: context)
    //                                   .getScreenWidthPercentage(0.1)),
    //                         ),
    //                       );
    //                     }
    //                     return const SizedBox(
    //                       height: 0,
    //                       width: 0,
    //                     );
    //                   },
    //                 ),
    //               ),
    //             )
    //           ],
    //         )),
    //       );
    //     });
    return Scaffold(
      backgroundColor: const Color(0xFFEED3E9),
      appBar: AppBar(
        title: Text('Complex Background'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.0,
            colors: [
              const Color(0xFFFCE8F9),
              const Color(0xFFF7C3D5),
              const Color(0xFFED9BB5),
              const Color(0xFFE87296),
            ],
            stops: [0.2, 0.4, 0.6, 0.8],
          ),
        ),
        child: Center(
          child: Text(
            'Complex Background',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
