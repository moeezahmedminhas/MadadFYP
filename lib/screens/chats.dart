import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madad_final/models/user.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../widgets/chat_user_card.dart';
import 'profile_screen.dart';

//home screen -- where all available contacts are shown
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // for storing all users
  List<UserModel> _list = [];

  // for storing searched items
  final List<UserModel> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //floating button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                child: const Icon(Icons.add_comment_rounded)),
          ),

          //body
          body: SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFee7b64), width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFee7b64), width: 2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFee7b64), width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: 'Search',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                if (_isSearching == true) {
                                  _searchList.clear();
                                }
                                _isSearching = !_isSearching;
                              },
                            );
                          },
                          icon: Icon(_isSearching
                              ? CupertinoIcons.clear_circled_solid
                              : Icons.search),
                        ),
                      ),

                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      //when search text changes then updated search list
                      onChanged: (val) {
                        String temp = val;
                        if (temp.isEmpty) {
                          setState(
                            () {
                              _isSearching = false;
                            },
                          );
                        } else {
                          setState(
                            () {
                              _isSearching = true;
                            },
                          );
                        }

                        //search logic
                        _searchList.clear();

                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                            setState(() {
                              _searchList;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .6,
                    child: StreamBuilder(
                      stream: APIs.getMyUsersId(),

                      //get id of only known users
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                                child: CircularProgressIndicator());

                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            return StreamBuilder(
                              stream: APIs.getAllUsers(snapshot.data?.docs
                                      .map((e) => e.id)
                                      .toList() ??
                                  []),

                              //get only those user, who's ids are provided
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  //if data is loading
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                  // return const Center(
                                  //     child: CircularProgressIndicator());

                                  //if some or all data is loaded then show it
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    final data = snapshot.data?.docs;
                                    _list = data
                                            ?.map((e) =>
                                                UserModel.fromJson(e.data()))
                                            .toList() ??
                                        [];
                                    if (_list.isNotEmpty) {
                                      return ListView.builder(
                                          itemCount: _isSearching
                                              ? _searchList.length
                                              : _list.length,
                                          padding: EdgeInsets.only(
                                              top: mq.height * .01),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return ChatUserCard(
                                                user: _isSearching
                                                    ? _searchList[index]
                                                    : _list[index]);
                                          });
                                    } else {
                                      return const Center(
                                        child: Text('No Connections Found!',
                                            style: TextStyle(fontSize: 20)),
                                      );
                                    }
                                }
                              },
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
