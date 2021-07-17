import 'package:flutter/material.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:skyline_template_app/viewmodels/requestform_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../core/utilities/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:skyline_template_app/model/Request.dart';

class RequestFormView extends StatefulWidget {
  @override
  _RequestFormViewState createState() {
    return _RequestFormViewState();
  }
}

class _RequestFormViewState extends State<RequestFormView> {
  final _auth = FirebaseAuth.instance;
  final userDb = FirebaseDatabase.instance.reference().child("Users");
  User user;
  var _name1, _name2;
  Request req;
  DateTime startDate;
  DateTime endDate;
  String reason;
  var worked = false;
  bool button = false;
  void initState() {
    _initMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<RequestFormViewModel>(
      create: (context) => locator<RequestFormViewModel>(),
      child: Consumer<RequestFormViewModel>(
        builder: (context, model, child) => SafeArea(
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Color(0xFF313131),
              body: Container(
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/wave1.png",
                      height: size.height * 0.3,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 0.02 * size.height),
                        Container(
                          width: size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "NEW REQUEST",
                                  style: TextStyle(
                                    fontFamily: 'InterBold',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Color(0xFF313131)),
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  model.routeToTutorView();
                                },
                                textColor: kColorSkylineGreen,
                                color: kColorSkyLineGrey,
                                child: Text('Go Back'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 0.2 * size.height),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: Text("Start Date",style: TextStyle(
                              fontFamily: 'InterReg',
                              fontSize: 18,
                              color: Color(0xFFF2DEFD))),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true, onConfirm: (date) {
                              startDate = date;
                              buttonPress();
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            width: size.width * 0.8,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 18.0,
                                            color: Color(0xFFE8BBFA),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            startDate == null
                                                ? " Choose Date"
                                                : DateFormat('M/d/yy h:mm aa')
                                                    .format(startDate),
                                            style: TextStyle(
                                                color: Color(0xFFE8BBFA),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "  Change",
                                  style: TextStyle(
                                      color: Color(0xFFE8BBFA),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          color: Color(0xFF1D1D1D),
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: startError(),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text("The request must be in the future.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.red)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: Text("End Date",style: TextStyle(
                              fontFamily: 'InterReg',
                              fontSize: 18,
                              color: Color(0xFFF2DEFD))),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true, onConfirm: (date) {
                              endDate = date;
                              buttonPress();
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * 0.8,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 18.0,
                                            color: Color(0xFFE8BBFA),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            endDate == null
                                                ? " Choose Date"
                                                : DateFormat('M/d/yy h:mm aa')
                                                    .format(endDate),
                                            style: TextStyle(
                                                color: Color(0xFFE8BBFA),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "  Change",
                                  style: TextStyle(
                                      color: Color(0xFFE8BBFA),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          color: Color(0xFF1D1D1D),
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: endError(),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                                "The end date has to be after the start date.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.red)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: Text("Reason",style: TextStyle(
                              fontFamily: 'InterReg',
                              fontSize: 18,
                              color: Color(0xFFF2DEFD))),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: size.width * 0.88,
                            child: TextField(
                                onChanged: (text) {
                                  reason = text;
                                  buttonPress();
                                },
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFFE8BBFA), fontWeight: FontWeight.bold)),
                            decoration: BoxDecoration(
                                color: Color(0xFF1D1D1D),
                                borderRadius: BorderRadius.circular(5),)),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              RaisedButton(
                                onPressed: buttonPress()
                                    ? null
                                    : () {
                                        if (reason == null) {
                                          reason = "None given.";
                                        }
                                        req = Request(startDate, endDate, reason, user, _name1, _name2);
                                        model.submitForm(req);
                                        model.routeToTutorView();
                                        setState(() {
                                          worked = !worked;
                                        });
                                        //model.routeToTutorView();
                                      },
                                textColor: kColorSkylineGreen,
                                disabledColor: Color(0xFF242424),
                                color: kColorSkyLineGrey,
                                child:
                                    !worked ? Text('Submit') : Text("Submitted!"),
                              ),
                            ]),
                      ],
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool buttonPress() {
    if (startDate == null || endDate == null) {
      return true;
    }
    if (endError()) {
      return true;
    }
    if (startError()) {
      return true;
    }
    return false;
  }

  startError() {
    if (startDate != null) {
      if (startDate.isBefore(DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  endError() {
    if (startDate != null && endDate != null) {
      if (endDate.isBefore(startDate)) {
        return true;
      }
    }
    return false;
  }

  Future _initMethod() async {
    user = _auth.currentUser;
    print(user);
    userDb.child(user.uid).child("first-name").once().then((DataSnapshot data) {
      print(data.value);
      _name1 = data.value;
    });
    userDb.child(user.uid).child("last-name").once().then((DataSnapshot data) {
      print(data.value);
      _name2 = data.value;
    });
  }
}
