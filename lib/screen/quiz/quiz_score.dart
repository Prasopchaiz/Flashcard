import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/question_controller.dart';
import 'package:get/get.dart';
import '../welcome_screen/homepage.dart';
import 'package:flutter_application_1/model/score.dart';
import 'package:intl/intl.dart';

Score score = Score(
  username: '',
  topic: '',
  date: '',
  full_score: 0,
  user_score: 0,
);

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH.mm');
    final String formatted = formatter.format(now);

    score.username = profile.username;
    score.topic = 'EM';
    score.date = formatted;
    score.full_score = _qnController.questions.length;
    score.user_score = _qnController.NumOfCorrectAns;

    FirebaseFirestore.instance
        .collection('Score')
        .doc('${score.date} ${score.username}')
        .set({
          "username": score.username,
          "topic": score.topic,
          "date": score.date,
          "score_full": score.full_score,
         "score_user": score.user_score,
        });
        
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Spacer(),
              Text("Score",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(color: Colors.black)),
              Spacer(),
              Text(
                "${_qnController.NumOfCorrectAns}/${_qnController.questions.length}",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.black),
              ),
              Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    child: Text("กลับสู่หน้าหลัก"),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: ((context) {
                        return HomeScreen();
                      })));
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
