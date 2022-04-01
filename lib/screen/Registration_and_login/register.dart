import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../constant/ui_helper.dart';
import '../welcome_screen/login_screen.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile =
      Profile(id: '', email: '', password: '', bio: '', username: '', DOB: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final CollectionReference _userData =
      FirebaseFirestore.instance.collection("_userData");
  TextEditingController dateCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("สร้างบัญชีผู้ใช้"),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpaceRegular,
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: "ใช้สำหรับแสดงผลภายในแอพ",
                              labelText: "ชื่อผู้ใช้",
                              filled: true,
                            ),
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนชื่อผู้ใช้"),
                            onSaved: (String? username) {
                              profile.username = username.toString();
                            },
                          ),
                          verticalSpaceSmall,
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email_outlined),
                              hintText: "กรุณากรอกอีเมลของคุณ",
                              labelText: "อีเมล",
                              filled: true,
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "กรุณาป้อนอีเมล"),
                              EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              profile.email = email.toString();
                            },
                          ),
                          verticalSpaceSmall,
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "ความยาวอย่างน้อย 6 ตัวอักษร",
                              labelText: "รหัสผ่าน",
                              filled: true,
                            ),
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนรหัสผ่าน"),
                            obscureText: true,
                            onSaved: (String? password) {
                              profile.password = password.toString();
                            },
                          ),
                          verticalSpaceSmall,
                          /*TextFormField(
                            decoration: const InputDecoration(
                              hintText: "กรุณาป้อนรหัสผ่านอีกครั้ง",
                              labelText: "ยืนยันรหัสผ่าน",
                              filled: true,
                            ),
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนรหัสผ่าน"),
                            obscureText: true,
                            onSaved: (String? passwordCheck) {
                              passwordCheck = passwordCheck.toString();
                            },
                          ),*/
                          verticalSpaceMedium,
                          TextFormField(
                            readOnly: true,
                            controller: dateCtl,
                            decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              border: const OutlineInputBorder(),
                              labelText: "วันเกิด",
                              hintText: "เช่น 27 ธันวาคม 2514",
                            ),
                            onTap: () async {
                              DateTime date_of_birth = DateTime(1900);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              date_of_birth = (await showDatePicker(
                                  initialDatePickerMode: DatePickerMode.day,
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2030)))!;

                              dateCtl.text =
                                  date_of_birth.toString().split(' ')[0];
                            },
                            onSaved: (String? date_of_birth) {
                              profile.DOB = date_of_birth.toString();
                            },
                          ),
                          verticalSpaceMedium,
                          TextFormField(
                            decoration: const InputDecoration(
                              border: const OutlineInputBorder(),
                              helperText:
                                  "แนะนำตัวให้เรารู้จัก (เพื่อให้เรารู้จักกันมาขึ้น)",
                              labelText: "เรื่องราวชีวิต",
                            ),
                            maxLines: 2,
                            onSaved: (String? bio) {
                              profile.bio = bio.toString();
                            },
                          ),
                          verticalSpaceMedium,
                          SizedBox(
                            child: ElevatedButton(
                              child: Text("ลงทะเบียน",
                                  style: TextStyle(fontSize: 18)),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: profile.email,
                                            password: profile.password)
                                        .then((value) {
                                      _userData.doc("${FirebaseAuth.instance.currentUser?.uid}").set({
                                        "id": FirebaseAuth.instance.currentUser?.uid,
                                        "username": profile.username,
                                        "email": profile.email,
                                        "password": profile.password,
                                        "date_of_birth": profile.DOB,
                                        "bio": profile.bio,
                                      });
                                      formKey.currentState!.reset();
                                      Fluttertoast.showToast(
                                          msg: "สร้างบัญชีผู้ใช้เสร็จสิ้น",
                                          gravity: ToastGravity.TOP);
                                      Get.to(() => LoginScreen());
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    print(e.code);
                                    String RegisterStatus;
                                    if (e.code == 'email-already-in-use') {
                                      RegisterStatus =
                                          'มีอีเมลนีั้ในระบบแล้ว กรุณาใช้อีเมลล์อื่น';
                                    } else if (e.code == 'weak-password') {
                                      RegisterStatus =
                                          'รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป';
                                    } else {
                                      RegisterStatus = e.message!;
                                    }
                                    Fluttertoast.showToast(
                                        msg: RegisterStatus,
                                        gravity: ToastGravity.TOP);
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
