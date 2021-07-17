import 'package:firebase_auth/firebase_auth.dart';

class Request {
  String uid;
  int startDate;
  int endDate;
  String reason;
  bool approved = false;
  String name;


  Request(DateTime startDate, DateTime endDate, String reason, User user, String name1, String name2) {
    this.uid = user.uid;
    this.name = name1 + " " + name2;
    this.startDate = startDate.millisecondsSinceEpoch;
    this.endDate = endDate.millisecondsSinceEpoch;
    this.reason = reason;
  }
}