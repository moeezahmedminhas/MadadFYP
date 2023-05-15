import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:madad_final/api/apis.dart';
import 'package:madad_final/screens/auth/login_screen.dart';
import 'package:madad_final/screens/home_screen.dart';
import 'package:madad_final/screens/psychologist/psy_home.dart';
import 'package:madad_final/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'admin/admin_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer and assign it to the variable
    _timer = Timer(const Duration(milliseconds: 1500), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String stringValue = prefs.getString('role') ?? "";
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      if (context.mounted) {
        if (stringValue != "") {
          log("\nUSER:${FirebaseAuth.instance.currentUser}");
          final user = APIs.auth.currentUser;
          if (user != null) {
            // Use the variable to cancel the timer before navigating
            _timer?.cancel();
            APIs.getSelfInfo().then((value) {
              stringValue = APIs.me.profession;
              if (stringValue == "psychologist") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PsyTabsScreen()));
              } else if (stringValue == "user") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TabsScreen()));
              } else if (stringValue == "admin") {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const AdminHome()));
              }
            });
          }
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png"),
                    const Text(
                      "Madad",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Get Your Therapy",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
