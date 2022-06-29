import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_2/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_2/navigation/wrapper.dart';
import 'package:provider/provider.dart';

import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // STATUS BAR
    statusBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
    // iOS only
    statusBarBrightness: Brightness.dark,
    // Android only
    statusBarIconBrightness: Brightness.dark,
    
    // // BOTTOM NAVIGATION
    // systemNavigationBarColor: Colors.transparent,
    // // systemNavigationBarDividerColor: Colors.transparent, // DON'T USE THIS (CAUSING statusBarText can't change)
    // systemNavigationBarIconBrightness: Brightness.dark,
    // systemNavigationBarContrastEnforced: false
  ));
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider.value(initialData: null, value: AuthService().user),
          ChangeNotifierProvider<UserModel>.value(value: UserModel())
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.purple
          ),
          scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        ));
  }
}