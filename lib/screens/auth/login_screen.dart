import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:madad_final/helper/dialogs.dart';
import 'package:madad_final/screens/admin/admin_home.dart';
import 'package:madad_final/screens/auth/signup_screen.dart';
import 'package:madad_final/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import '../../api/apis.dart';
import '../../widgets/widgets.dart';
import '../psychologist/psy_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        if (await APIs.userExists()) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
            return const TabsScreen();
          }));
        } else {
          await APIs.createUser().then((value) => Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) {
                return const TabsScreen();
              })));
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log("\nSigin With Google: $e");
      Dialogs.showSnackbar(context, e.toString());
      return null;
    }
    // Trigger the authentication flow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Madad",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Login to Get Your Therapy",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Image.asset("assets/logo.png"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Password must be atleast 6 characters";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        login();
                      },
                    ),
                  ),
                  Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register here",
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            }),
                    ],
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Sign In With Google",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        _handleGoogleBtnClick();
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  login() {
    if (formKey.currentState!.validate()) {
      APIs.auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        APIs.getSelfInfo().then((value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (context.mounted) {
            prefs.setString("role", APIs.me.profession);
            if (APIs.me.profession == "psychologist") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PsyTabsScreen()));
            } else if (APIs.me.profession == "user") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const TabsScreen()));
            } else if (APIs.me.profession == "admin") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AdminHome()));
            }
          }
        });
      });
    }
  }
}
