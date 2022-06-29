
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_2/model/user_model.dart';
import 'package:project_2/services/auth.dart';
import 'package:project_2/services/loading.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
 

  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameController = TextEditingController();
  final emailEditingController = TextEditingController();
  final ageController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  Position? position;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //age field
    final ageField = TextFormField(
        autofocus: false,
        controller: ageController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Age cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          ageController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.auto_awesome),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Age (18+)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purpleAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            if (dropdownvalue == 'Select Gender')
              Fluttertoast.showToast(msg: 'Please select gender');
            else if (dropdownvalue2 == 'Select State')
              Fluttertoast.showToast(msg: 'Please select state');
            else if (dropdownvalue3 == 'Select Status')
              Fluttertoast.showToast(msg: 'Please select status');
            else if (dropdownvalue == 'Female' && dropdownvalue3 == 'Married')
              Fluttertoast.showToast(msg: 'Married woman can\'t use this app');
            else if (int.parse(ageController.text) < 18)
              Fluttertoast.showToast(msg: 'Underage can\'t use this app (18+)');
            else if (position == null)
              Fluttertoast.showToast(msg: 'Please Require location');
            else if (pickedFile == null)
              Fluttertoast.showToast(msg: 'Require profile image');
            else {
              showDialog(context: context, builder: (context) => LoadingCustom(text: 'Creating Profile..'));
              await signUp(emailEditingController.text,
                  passwordEditingController.text, context);
              if (mounted) {Navigator.pop(context); Navigator.pop(context);}
            }
          },
          child: Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(   
          child: SingleChildScrollView(
          child: Container(

            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (pickedFile != null)...[
                      Text(pickedFile!.name),
                      Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover
                      )
                    ],
                    ElevatedButton(
                      onPressed: selectFile,
                      child: Text("Select Image", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    nameField,
                    SizedBox(height: 20),
                    ageField,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: DropdownButton(
                            underline: SizedBox(),
                            style: TextStyle(color: Colors.grey.shade700),
                            value: dropdownvalue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: gender.map((String items) {
                              return DropdownMenuItem(
                                enabled: items != 'Select Gender',
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: DropdownButton(
                            style: TextStyle(color: Colors.grey.shade700),
                            value: dropdownvalue3,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            underline: SizedBox(),
                            items: status.map((String items) {
                              return DropdownMenuItem(
                                enabled: items != 'Select Status',
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue3 = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButton(
                        style: TextStyle(color: Colors.grey.shade700),
                        underline: SizedBox(),
                        value: dropdownvalue2,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: state.map((String items) {
                          return DropdownMenuItem(
                            enabled: items != 'Select State',
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue2 = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          position = await _determinePosition();
                          if (mounted) setState(() {});
                        },
                        child: Text('Get Location')),
                    if (position != null) ...[
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Text('Longitude: ${position!.longitude}'),
                              Text('Latitude: ${position!.latitude}'),
                              Text(
                                  'Altitude: ${position!.altitude}, Accuracy: ${position!.accuracy}'),
                            ],
                          )),
                    ],
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    signUpButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String dropdownvalue = 'Select Gender';
  var gender = ['Select Gender', 'Male', 'Female'];

  String dropdownvalue2 = 'Select State';
  var state = [
    'Select State',
    'Perlis',
    'Kedah',
    'Penang',
    'Perak',
    'Selangor',
    'N. Sembilan',
    'Malacca',
    'Johor',
    'Kelantan',
    'Terengganu',
    'Pahang',
    'Sabah',
    'Sarawak',
    'WP Kuala Lumpur',
    'WP Labuan',
    'WP Putrajaya',
  ];

  String dropdownvalue3 = 'Select Status';
  var status = [
    'Select Status',
    'Single',
    'Married',
    'Divorced',
  ];


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> signUp(String email, String password, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await postDetailsToFirestore();
          // User? user = value.user;
          // AuthService().userFromFirebase(user);
          await AuthService().signOut();
        }).catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  Future postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    final path = 'user/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;
    userModel.age = ageController.text;
    userModel.gender = dropdownvalue;
    userModel.state = dropdownvalue2;
    userModel.status = dropdownvalue3;
    userModel.pic = urlDownload;
    userModel.dateTime = DateTime.now();
    userModel.geoPoint = GeoPoint(position!.latitude, position!.longitude);

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully!");

    // Navigator.pushAndRemoveUntil(
    //     (context),
    //     MaterialPageRoute(builder: (context) => BotNav()),
    //     (route) => false);
  }
}
