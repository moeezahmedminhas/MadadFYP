import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../widgets/widgets.dart';

class AddPsy extends StatefulWidget {
  const AddPsy({super.key});

  @override
  State<AddPsy> createState() => _AddPsyState();
}

class _AddPsyState extends State<AddPsy> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String name = "";
  String gender = '';
  int age = 0;

  List selectGender = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    "Hiring a Psychiatrist",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
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
                    height: 10,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Name Cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Age",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        age = int.parse(val);
                      });
                    },
                    validator: (val) {
                      if (int.parse(val!) == 0) {
                        return "Age Cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
                        "Create The Record",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        login();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future login() async {
    try {
      User user = (await APIs.auth
              .createUserWithEmailAndPassword(email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await APIs.createPsy(
          uid: user.uid,
          name: name,
          profession: "psychologist",
          gender: gender,
          age: age,
        );
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
