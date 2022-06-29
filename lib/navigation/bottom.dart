import 'package:flutter/material.dart';
import 'package:project_2/screens/home/home_screen.dart';
import 'package:project_2/screens/profile/profile.dart';

class BotNav extends StatefulWidget {
  const BotNav({ Key? key}) : super(key: key);

  @override
  _BotNavState createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  int _currentIndex = 0;
  final botNav = [
    const HomeScreen(),
    const Profile()
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.purple.shade200,
          body: botNav[_currentIndex],
          bottomNavigationBar: SizedBox(
            height: 50,
            child: Column(
              children: [
                NavigationBarTheme(
                  data: NavigationBarThemeData(
                    indicatorColor: Colors.transparent,
                    labelTextStyle: MaterialStateProperty.all(
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                    )
                  ),
                  child: NavigationBar(
                    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                    animationDuration: const Duration(seconds: 1),
                    backgroundColor: Colors.transparent,
                    height: 50,
                    selectedIndex: _currentIndex,
                    onDestinationSelected:  (e) {
                      _currentIndex = e;
                      setState(() {});
                    },
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: "Home",
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: "Profile",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}