import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:madad_final/screens/auth/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/user.dart';
import '../../api/apis.dart';
import '../widgets/widgets.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  late UserModel user;

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List list = [];
  List selectGender = ["Male", "Female", "Other"];
  String? _image;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    widget.user = APIs.me;
    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.6),
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        //for showing progress dialog
                        Dialogs.showProgressBar(context);

                        await APIs.updateActiveStatus(false);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();

                        //sign out from app
                        await APIs.auth.signOut().then((value) async {
                          await GoogleSignIn().signOut().then((value) {
                            //for hiding progress dialog
                            Navigator.pop(context);

                            APIs.auth = FirebaseAuth.instance;

                            //replacing home screen with login screen
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                                (Route<dynamic> route) => false);
                          });
                        });
                      },
                      icon: Icon(Icons.exit_to_app),
                      label: const Text("Logout"),
                    ),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.1),
                              child: Image.file(
                                File(_image!),
                                width: MediaQuery.of(context).size.height * .2,
                                fit: BoxFit.fill,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.1),
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.height * .2,
                                fit: BoxFit.fill,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                imageUrl: widget.user.image,
                                // placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: Icon(Icons.edit,
                              color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  Text(widget.user.email),
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Full Name",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'e.g Attique Minhas'),
                    keyboardType: TextInputType.text,
                    initialValue: widget.user.name,
                    onSaved: (val) {
                      setState(() {
                        APIs.me.name = val ?? "";
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Age",
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'e.g 18'),
                    keyboardType: TextInputType.number,
                    initialValue: widget.user.age.toString(),
                    validator: (value) {
                      if (int.parse(value!) < 13) {
                        return "You are too Young";
                      } else if (int.parse(value) > 120) {
                        return "Invalid age";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        APIs.me.age = val as int;
                      });
                    },
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "About",
                        prefixIcon: Icon(
                          Icons.info,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'e.g Attique Minhas'),
                    keyboardType: TextInputType.text,
                    initialValue: widget.user.about,
                    onSaved: (val) {
                      setState(() {
                        APIs.me.about = val ?? "";
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DropdownButtonFormField(
                    // Initial Value
                    decoration: textInputDecoration.copyWith(
                      labelText: "Gender",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    hint: const Text("Select Gender"),

                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.deepOrangeAccent,
                    ),

                    // Array list of items
                    items: selectGender.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),

                    onChanged: (newValue) {
                      setState(() {
                        APIs.me.gender = newValue.toString();
                      });
                    },
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Updated Successfully!');
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Save"),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  (!checkGoogle())
                      ? FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen()));
                          },
                          icon: const Icon(Icons.password),
                          label: const Text("Change Password"),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkGoogle() {
    for (final UserInfo userInfo in APIs.user.providerData) {
      if (userInfo.providerId == GoogleAuthProvider.PROVIDER_ID) {
        print('User is signed in with Google');
        return true;
      }
    }
    return false;
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
