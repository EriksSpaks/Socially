import 'package:business_card/assets/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFDDDDDD),
        body: Column(
          children: [
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.07),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: RelativeSize(context: context)
                      .getScreenWidthPercentage(0.1)),
              child: const Text(
                "Find a profile",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF707070),
                    fontSize: 26),
              ),
            ),
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.02),
            ),
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.055),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: RelativeSize(context: context)
                        .getScreenWidthPercentage(0.05)),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.search),
                      suffixIconColor: Color(0xFFBBBBBB),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Name",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.01),
                          horizontal: RelativeSize(context: context)
                              .getScreenWidthPercentage(0.05)),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFBBBBBB),
                      ),
                      isDense: true),
                ),
              ),
            ),
            SizedBox(
              height: RelativeSize(context: context)
                  .getScreenHeightPercentage(0.05),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)),
                        topRight: Radius.circular(RelativeSize(context: context)
                            .getScreenWidthPercentage(0.13)))),
                width: double.infinity,
              ),
            )
          ],
        ),
      ),
    );
  }
}
