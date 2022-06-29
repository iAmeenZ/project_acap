import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingCustom extends StatelessWidget {
  final String text;
  const LoadingCustom({ Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitFadingCube(
                  color: Colors.purpleAccent,
                  size: 50.0,
                ),
                SizedBox(height: 30),
                Text(text, style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 20))
              ],
            ),
          ),
        ),
      ),
    );
  }
}