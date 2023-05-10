// import 'dart:convert';
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:madad_final/screens/profile_screen.dart';
// import 'package:madad_final/widgets/chat_user_card.dart';
// import '../main.dart';
// import '../models/user.dart';
// import '../../api/apis.dart';
// import '../widgets/widgets.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List list = [];
//   // for storing searched items
//   final List<UserModel> _searchList = [];
//   // for storing search status
//   bool isSearching = false;
//   @override
//   void initState() {
//     super.initState();
//     APIs.getSelfInfo();

//     //for updating user active status according to lifecycle events
//     //resume -- active or online
//     //pause  -- inactive or offline
//     SystemChannels.lifecycle.setMessageHandler((message) {
//       log('Message: $message');

//       if (APIs.auth.currentUser != null) {
//         if (message.toString().contains('resume')) {
//           APIs.updateActiveStatus(true);
//         }
//         if (message.toString().contains('pause')) {
//           APIs.updateActiveStatus(false);
//         }
//       }

//       return Future.value(message);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Madad"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => ProfileScreen(user: APIs.me)));
//               },
//               icon: const Icon(Icons.more_vert))
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await FirebaseAuth.instance.signOut();
//           await GoogleSignIn().signOut();
//         },
//         child: const Icon(Icons.chat),
//       ),
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.height * 0.01),
//                   height: MediaQuery.of(context).size.height * 0.05,
//                   child: TextField(
//                     decoration: textInputDecoration.copyWith(
//                         labelText: "Search",
//                         suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 isSearching = !isSearching;
//                               });
//                             },
//                             icon: Icon(
//                               isSearching
//                                   ? CupertinoIcons.clear_circled_solid
//                                   : Icons.search,
//                               color: Theme.of(context).primaryColor,
//                             )),
//                         hintText: 'Search'),
//                     keyboardType: TextInputType.text,
//                     autofocus: true,
//                     style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
//                     //when search text changes then updated search list
//                     onChanged: (val) {
//                       //search logic
//                       _searchList.clear();

//                       for (var i in list) {
//                         if (i.name.toLowerCase().contains(val.toLowerCase()) ||
//                             i.email.toLowerCase().contains(val.toLowerCase())) {
//                           _searchList.add(i);
//                           setState(() {
//                             _searchList;
//                           });
//                         }
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.8 -
//                       MediaQuery.of(context).padding.top,
//                   child: StreamBuilder(
//                     stream: APIs.getMyUsersId(),

//                     //get id of only known users
//                     builder: (context, snapshot) {
//                       switch (snapshot.connectionState) {
//                         //if data is loading
//                         case ConnectionState.waiting:
//                         case ConnectionState.none:
//                           return const Center(
//                               child: CircularProgressIndicator());

//                         //if some or all data is loaded then show it
//                         case ConnectionState.active:
//                         case ConnectionState.done:
//                           return StreamBuilder(
//                             stream: APIs.getAllUsers(
//                                 snapshot.data?.docs.map((e) => e.id).toList() ??
//                                     []),

//                             //get only those user, who's ids are provided
//                             builder: (context, snapshot) {
//                               switch (snapshot.connectionState) {
//                                 //if data is loading
//                                 case ConnectionState.waiting:
//                                 case ConnectionState.none:
//                                 // return const Center(
//                                 //     child: CircularProgressIndicator());

//                                 //if some or all data is loaded then show it
//                                 case ConnectionState.active:
//                                 case ConnectionState.done:
//                                   final data = snapshot.data?.docs;
//                                   list = data
//                                           ?.map((e) =>
//                                               UserModel.fromJson(e.data()))
//                                           .toList() ??
//                                       [];

//                                   if (list.isNotEmpty) {
//                                     return ListView.builder(
//                                         itemCount: isSearching
//                                             ? _searchList.length
//                                             : list.length,
//                                         padding: EdgeInsets.only(
//                                             top: mq.height * .01),
//                                         physics: const BouncingScrollPhysics(),
//                                         itemBuilder: (context, index) {
//                                           return ChatUserCard(
//                                               user: isSearching
//                                                   ? _searchList[index]
//                                                   : list[index]);
//                                         });
//                                   } else {
//                                     return const Center(
//                                       child: Text('No Connections Found!',
//                                           style: TextStyle(fontSize: 20)),
//                                     );
//                                   }
//                               }
//                             },
//                           );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:madad_final/screens/getPsy.dart';
import 'package:madad_final/screens/questionnaires.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          InkWell(
            child: buildContainer(
                const Text(
                  "Questionnaires",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                'assets/questions.jpg'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectQuestionnaireScreen()));
            },
          ),
          InkWell(
            child: buildContainer(
                const Text(
                  "Psychiatrists",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                'assets/psychiatrist.jpg'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GetPsy()));
            },
          ),
        ],
      ),
    );
  }

  Widget buildContainer(Widget child, String pic) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: AssetImage(pic), fit: BoxFit.cover),
      ),
      margin: const EdgeInsets.all(10),
      height: 150,
      width: double.infinity,
      child: Center(
        child: child,
      ),
    );
  }
}
