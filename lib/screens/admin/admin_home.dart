import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:madad_final/screens/admin/add_psychologist.dart';
import 'package:madad_final/screens/admin/add_questions.dart';
import 'package:madad_final/screens/admin/remove_psychologist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../auth/login_screen.dart';
import 'add_audio.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MADAD Admin"),
        actions: [
          InkWell(
            child: const Icon(
              Icons.logout,
            ),
            onTap: () async {
              //for showing progress dialog
              Dialogs.showProgressBar(context);

              APIs.updateActiveStatus(false);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              //sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //for hiding progress dialog
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (Route<dynamic> route) => false);
                  APIs.auth = FirebaseAuth.instance;
                });
              });
            },
          ),
        ],
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              hoverColor: Colors.blueGrey,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => AddPsy())));
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add,
                        size: 30,
                      ),
                      Text("Add Psychologist ")
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              hoverColor: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => UserListScreen())));
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add,
                        size: 30,
                      ),
                      Text("Show Psychologists ")
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              hoverColor: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => QuestionnaireScreen())));
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.add),
                      Text("Add Questionaires"),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              hoverColor: Colors.blueGrey,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => AudioUploadScreen())));
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.indigo,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.add),
                      Text(
                        "Upload Audios",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
      // body: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Expanded(
      //           child: InkWell(
      //         onTap: () {

      //         },
      //         child: Container(
      //             child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Icon(Icons.manage_accounts),
      //             Text("Manage Psychiatrists ")
      //           ],
      //         )),
      //       )),
      //       Expanded(
      //           child: InkWell(
      //         onTap: () {},
      //         child: Container(
      //             child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [Icon(Icons.add), Text("Manage Psychiatrists ")],
      //         )),
      //       )),
      //     ]),
    );
  }
}
