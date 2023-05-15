import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madad_final/screens/auth/login_screen.dart';

import '../../api/apis.dart';
import '../../widgets/widgets.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String fullName = "";
  String password = "";
  int age = 0;
  String gender = "";
  List selectGender = ["Male", "Female", "Other"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Madad",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Login to Get Your Therapy",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Image.asset("assets/logo.png"),
                        ),
                        const SizedBox(
                          height: 20,
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
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password must be atleast 6 characters";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              fullName = (val);
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
                          height: 10,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Age",
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              age = int.parse(val);
                            });
                          },
                          validator: (value) {
                            if (int.parse(value!) < 13) {
                              return "You are too Young";
                            } else if (int.parse(value) > 120) {
                              return "Invalid age";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
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
                              gender = newValue.toString();
                            });
                          },
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
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Login here",
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginScreen());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        User user = (await APIs.auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user!;

        if (user != null) {
          await APIs.createPsy(
            uid: user.uid,
            name: fullName,
            profession: "user",
            gender: gender,
            age: age,
          );
          setState(() {
            _isLoading = false;
          });
          return true;
        }
      } on FirebaseAuthException catch (e) {
        return e.message;
      }
    }
  }
}
