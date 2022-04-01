import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Contact/contact_page.dart';
import 'package:flutter_application_1/screen/constant/ui_helper.dart';
import 'package:flutter_application_1/screen/welcome_screen/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Flashcard/cardcontent.dart';
import '../quiz/quiz_home.dart';
import '../constant/style.dart';
import 'package:flutter_application_1/model/local_profile.dart';

LocalProfile profile = LocalProfile(id: '', username: '', bio: '');

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('_userData')
        .doc(userid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        profile.id = documentSnapshot["id"];
        profile.username = documentSnapshot["username"];
        profile.bio = documentSnapshot["bio"];
      } else {
        print("Document does not exist on the database");
      }
    });

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: kcPrimaryColor,
            ),
          ),
          SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.center,
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.logout_outlined),
                      ),
                    ),*/
                    ListTile(
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => <PopupMenuItem<String>>[
                          PopupMenuItem(
                            child: Text("ออกจากระบบ"),
                            onTap: () {
                              auth.signOut().then(((value) {
                                Get.to(() => LoginScreen());
                                Fluttertoast.showToast(msg: "ออกจากระบบเสร็จสมบูรณ์");
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Welcome, \n${profile.username}",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    verticalSpaceLarge,
                    Expanded(
                        child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.green, width: 1.5),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 17),
                                  blurRadius: 17,
                                  spreadRadius: -23,
                                  color: kcMediumGreyColor,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => CardContent());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Icon(Icons.photo_filter_outlined,
                                          size: 72),
                                      Spacer(),
                                      Text(
                                        "การ์ดความรู้",
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.green, width: 1.5),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 17),
                                  blurRadius: 17,
                                  spreadRadius: -23,
                                  color: kcMediumGreyColor,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => homeQuizScreen());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Icon(
                                        Icons.quiz_outlined,
                                        size: 72,
                                      ),
                                      Spacer(),
                                      Text(
                                        "คำถาม",
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.5),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 17),
                                  blurRadius: 17,
                                  spreadRadius: -23,
                                  color: kcMediumGreyColor,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => ContactPage());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Icon(
                                        Icons.contact_support_outlined,
                                        size: 72,
                                      ),
                                      Spacer(),
                                      Text(
                                        "Support",
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                      ],
                    )),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
