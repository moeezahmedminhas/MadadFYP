import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../api/apis.dart';
import '../chats.dart';
import '../profile_screen.dart';

class PsyTabsScreen extends StatefulWidget {
  const PsyTabsScreen({super.key});
  @override
  State<PsyTabsScreen> createState() => _PsyTabsScreenState();
}

class _PsyTabsScreenState extends State<PsyTabsScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': const ChatsScreen(),
      'title': 'Chats',
    },
    {
      'page': ProfileScreen(),
      'title': 'Your Profile',
    },
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'] as String),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage, //index will be automatically passed by the flutter
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.shifting,// in this case every tab willl have its own styling so we have to deefine styling for every tab
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: SvgPicture.asset(
              'assets/icons/chat-conversation.svg',
              width: 23,
              color: Colors.white,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 20,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
