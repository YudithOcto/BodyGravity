import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/custom_text_field_title.dart';
import 'package:flutter/material.dart';

import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "Trainer A");
  final TextEditingController _emailController =
      TextEditingController(text: "Trainer@gmail.com");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white900,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.white900,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Text("Akun",
                style: CustomTextStyle.headline4
                    .copyWith(color: AppColors.blueGray800)),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: const Icon(Icons.logout, color: AppColors.red600),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.blueGray400, width: 3.0)),
                      padding: const EdgeInsets.all(4.0),
                      child: const Image(
                        image:
                            AssetImage("assets/images/ic_default_profile.png"),
                        width: 60.0,
                        height: 60.0,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(20, -30),
                      // Adjust these values to position the badge
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary900,
                          // Choose your desired color for the badge background
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                CustomTextFieldTitle(
                    title: "Nama",
                    textFieldWidget: CustomTextField(
                      textEditingController: _nameController,
                    )),
                const SizedBox(height: 8.0),
                CustomTextFieldTitle(
                    title: "Email",
                    textFieldWidget: CustomTextField(
                      textEditingController: _emailController,
                    )),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
