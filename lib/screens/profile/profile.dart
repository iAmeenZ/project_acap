import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_2/model/user_model.dart';
import 'package:project_2/screens/authenticate/login_screen.dart';
import 'package:project_2/services/auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  

  // Stream<UserModel> getUserModel() async* {
  //   UserModel usermodel;
  //   final data = await FirebaseFirestore.instance.collection("users").doc(user!.uid).snapshots();
  //   usermodel = UserModel.fromMap(data.data());
  //   yield usermodel;
  // }

  Future<void> logout(BuildContext context) async {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'fcm': null});
    await AuthService().signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<UserModel> getUserModel2() async {
    UserModel usermodel;
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    usermodel = UserModel.fromMap(data.data());
    return usermodel;
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    pickedFile = result.files.first;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final path = 'user/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update({
          'pic' : urlDownload
        });
    Fluttertoast.showToast(msg: "Photo Updated!");
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else if (snapshot.connectionState == ConnectionState.active) {
            final Map data = (snapshot.data as DocumentSnapshot).data()
                as Map<String, dynamic>;
            String? name = data['name'];
            String? state = data['state'];
            String? age = data['age'];
            String? pic = data['pic'];
            String? biodata = data['bio'];
            String? interest1 = data['interest1'];
            String? interest2 = data['interest2'];
            String? interest3 = data['interest3'];
            GeoPoint? geoPoint = data['geoPoint'];
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () { 
                                      logout(context);
                                    },
                                    child: Text('Sign Out')
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                selectFile();
                              },
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: NetworkImage(pic ?? ''),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(name ?? 'You dont have name',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("$age years old"),
                    Text(state ?? ''),
                    SizedBox(height: 20),
                    Text('Latitude : ${geoPoint!.latitude}'),
                    Text('Longitude : ${geoPoint.longitude}'),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Biodata',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => ChangeBio(biodata: biodata));
                            })
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 20),
                        child: Text(biodata ?? "Inert your biodata")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Interest',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => ChangeInterest(
                                      interest1: interest1,
                                      interest2: interest2,
                                      interest3: interest3));
                            })
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        interest1 ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        interest2 ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        interest3 ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else
            return Container();
        });
  }
}


class ChangeBio extends StatefulWidget {
  final String? biodata;

  const ChangeBio({Key? key, required this.biodata})
      : super(key: key);

  @override
  State<ChangeBio> createState() => _ChangeBioState();
}

class _ChangeBioState extends State<ChangeBio> {
  User? user = FirebaseAuth.instance.currentUser;

  String biodata = 'Write your biodata';

  @override
  void initState() {
    super.initState();
    biodata = widget.biodata ?? biodata;
  }

  final bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final bioField = TextFormField(
    autofocus: false,
    controller: bioController,
    keyboardType: TextInputType.name,
    onSaved: (value) {
      bioController.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.book),
      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "Your Biography",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));

    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            bioField,
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .update({'bio': bioController.text});
              },
              child: Text('Save')
            )
          ],
        ),
      ),
    );
  }
}


class ChangeInterest extends StatefulWidget {
  final String? interest1;
  final String? interest2;
  final String? interest3;
  const ChangeInterest(
      {Key? key,
      required this.interest1,
      required this.interest2,
      required this.interest3})
      : super(key: key);

  @override
  State<ChangeInterest> createState() => _ChangeInterestState();
}

class _ChangeInterestState extends State<ChangeInterest> {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> interest = [
    'Select Interest',
    'Music',
    'Anime',
    'Workout',
    'Sport',
    'Sleep',
    'Gaming',
    'Hiking'
  ];
  String interest1 = 'Select Interest';
  String interest2 = 'Select Interest';
  String interest3 = 'Select Interest';

  @override
  void initState() {
    super.initState();
    interest1 = widget.interest1 ?? interest1;
    interest2 = widget.interest2 ?? interest2;
    interest3 = widget.interest3 ?? interest3;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton(
              style: TextStyle(color: Colors.grey.shade700),
              value: interest1,
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: SizedBox(),
              items: interest.map((String interest) {
                return DropdownMenuItem(
                  enabled: interest != 'Select Interest',
                  value: interest,
                  child: Text(interest),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  interest1 = newValue!;
                });
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .update({'interest1': interest1});
              },
            ),
            DropdownButton(
              style: TextStyle(color: Colors.grey.shade700),
              value: interest2,
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: SizedBox(),
              items: interest.map((String interest) {
                return DropdownMenuItem(
                  enabled: interest != 'Select Interest',
                  value: interest,
                  child: Text(interest),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  interest2 = newValue!;
                });
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .update({'interest2': interest2});
              },
            ),
            DropdownButton(
              style: TextStyle(color: Colors.grey.shade700),
              value: interest3,
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: SizedBox(),
              items: interest.map((String interest) {
                return DropdownMenuItem(
                  enabled: interest != 'Select Interest',
                  value: interest,
                  child: Text(interest),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  interest3 = newValue!;
                });
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .update({'interest3': interest3});
              },
            ),
          ],
        ),
      ),
    );
  }
}
