import 'package:flutter/material.dart';
import 'package:project_2/model/user_model.dart';
import 'package:project_2/navigation/bottom.dart';
import 'package:project_2/screens/authenticate/login_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({ Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final UserModelStream? user = Provider.of<UserModelStream?>(context); // Receive from main.dart StreamProvider

    // return either Home or Authenticate widget
    if (user == null) {
      return LoginScreen();
    } else {
      return BotNav();
    }
  }

}