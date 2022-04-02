import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/Registration_and_login/register.dart';
import 'package:get/get.dart';
import '../constant/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/model/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../welcome_screen/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile =
      Profile(id: '', email: '', password: '', bio: '', DOB: '', username: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

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
            backgroundColor: Colors.green,
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    alignment: Alignment.center,
                    width: 500,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: [
                          verticalSpaceLarge,
                          Text(
                            "LOGIN",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(color: Colors.green),
                          ),
                          verticalSpaceMedium,
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              icon: Icon(Icons.email_outlined),
                              hintText: "",
                              labelText: "Email ID",
                            ),
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "กรุณาป้อนชื่อผู้ใช้"),
                              EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              profile.email = email.toString();
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              icon: Icon(Icons.lock_outlined),
                              hintText: "",
                              labelText: "Password",
                            ),
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนรหัสผ่าน"),
                            obscureText: true,
                            onSaved: (String? password) {
                              profile.password = password.toString();
                            },
                          ),
                          verticalSpaceMedium,
                          SizedBox(
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                SizedBox(
                                  child: ElevatedButton(
                                    child: Text("ลงชื่อเข้าใช้",
                                        style: TextStyle(fontSize: 16)),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password)
                                              .then((value) {
                                            formKey.currentState!.reset();
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: ((context) {
                                              return HomeScreen();
                                            })));
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.message!,
                                              gravity: ToastGravity.TOP);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                horizontalSpaceTiny,
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => RegisterScreen());
                                  },
                                  child: Text("สมัครสมาชิก"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
        ));
      },
    );
  }
}
