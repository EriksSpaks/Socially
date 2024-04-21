import 'package:business_card/language_constants.dart';
import 'package:business_card/styles/colors.dart';
import 'package:business_card/styles/size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

class EditProfileNamePage extends StatefulWidget {
  const EditProfileNamePage({super.key});

  @override
  State<EditProfileNamePage> createState() => _EditProfileNamePageState();
}

class _EditProfileNamePageState extends State<EditProfileNamePage> {
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colouring.colorDarkBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  right: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.05),
                  top: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.01)),
              alignment: Alignment.topRight,
              child: IconButton(
                  highlightColor: const Color.fromARGB(255, 115, 143, 159),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation(
                                      Colouring.colorLightBlue),
                                ),
                              ),
                            );
                          });
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(
                              _textEditingController.text.trim());
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "display_name": _textEditingController.text.trim()
                      });

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    Icons.check_rounded,
                    size: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.12),
                    color: Colouring.colorAlmostWhite,
                  )),
            ),
            Column(
              children: [
                SizedBox(
                  height: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.07),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/icon_edit_profile.svg',
                      width: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.1),
                      colorFilter: const ColorFilter.mode(
                          Colouring.colorAlmostWhite, BlendMode.srcIn),
                    ),
                    SizedBox(
                      width: RelativeSize(context: context)
                          .getScreenWidthPercentage(0.03),
                    ),
                    Text(
                      translatedText(context).edit_profile_name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colouring.colorAlmostWhite,
                          fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(
                  height: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.02),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(double.infinity),
                      ),
                      height: RelativeSize(context: context)
                          .getScreenHeightPercentage(0.061),
                      padding: EdgeInsets.symmetric(
                          horizontal: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.05)),
                    ),
                    SizedBox(
                      // height: RelativeSize(context: context)
                      //     .getScreenHeightPercentage(0.055),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.05)),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _textEditingController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: translatedText(context)
                                      .finish_sm_screen_error_required_field),
                              PatternValidator(
                                  r'^(([a-zA-Z\u00C0-\u017e\u0400-\u04FF]+\s)*[a-zA-Z\u00C0-\u017e\u0400-\u04FF]){6,64}$',
                                  errorText:
                                      translatedText(context).error_text_64)
                            ]).call,
                            //controller: _textController,
                            onChanged: (_) => setState(() {}),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: const Icon(Icons.search),
                                suffixIconColor: Colouring.colorLightGrey,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30)),
                                hintText: translatedText(context)
                                    .search_screen_hintText_name,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: RelativeSize(context: context)
                                        .getScreenWidthPercentage(0.01),
                                    horizontal: RelativeSize(context: context)
                                        .getScreenWidthPercentage(0.05)),
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colouring.colorLightGrey,
                                ),
                                isDense: true),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: RelativeSize(context: context)
                      .getScreenHeightPercentage(0.02),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Colouring.colorBlueGradient3,
                              Colouring.colorBlueGradient2
                            ],
                            stops: [
                              0.0,
                              1.0
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.13)),
                            topRight: Radius.circular(
                                RelativeSize(context: context)
                                    .getScreenWidthPercentage(0.13)))),
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: RelativeSize(context: context)
                                .getScreenWidthPercentage(0.1),
                            top: RelativeSize(context: context)
                                .getScreenHeightPercentage(0.03)),
                        child: Text(
                          translatedText(context).edit_profile_name_page_text,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colouring.colorLightLightGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
