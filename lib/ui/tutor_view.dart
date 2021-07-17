import 'package:flutter/material.dart';
import 'package:skyline_template_app/viewmodels/tutor_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TutorView extends StatefulWidget {
  @override
  _TutorViewState createState() => _TutorViewState();
}

class _TutorViewState extends State<TutorView> {
  List<Map<dynamic, dynamic>> lists = [];
  final _auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  var dbRefInit;
  @override
  void initState() {
    _initMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<TutorViewModel>(
      create: (context) => locator<TutorViewModel>(),
      child: Consumer<TutorViewModel>(
        builder: (context, model, child) => SafeArea(
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Color(0xFF313131),
              body: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Image.asset("assets/wave.png", height: size.height * 0.4,),
                    ),
                    Column(
                      children: [
                        Container(
                          //margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "YOUR REQUESTS",
                                style: TextStyle(
                                    fontFamily: 'InterBold',
                                    fontSize: 30,
                                    color: Color(0xFF313131)),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  model.routeToFormView();
                                },
                                textColor: kColorSkylineGreen,
                                color: Color(0xFFF2DEFD),
                                child: Text('+', style: TextStyle(
                                    fontFamily: 'InterBold',
                                    fontSize: 30,
                                    color: Color(0xFF472400)),),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                            stream: dbRefInit.onValue,
                            builder: (context, AsyncSnapshot<Event> snapshot) {
                              if (snapshot.hasData) {
                                DataSnapshot dataValues = snapshot.data.snapshot;
                                model.buildList(context, snapshot, lists);
                                if (lists.length > 0) {
                                  return Container(
                                      height: size.height * 0.75,
                                      width: size.width * 0.9,
                                      child: new ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: lists.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return Card(
                                              elevation: 100,
                                              color: model.approveColor(
                                                  lists[index]["approved"]),
                                              child: Container(
                                                margin:
                                                EdgeInsets.symmetric(vertical: 10),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 5),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: size.width * 0.6,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(
                                                              model.formatDate(lists[
                                                              index]
                                                              ["start-date"]) +
                                                                  " -\n" +
                                                                  model.formatDate(
                                                                      lists[index]
                                                                      ["end-date"]),
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            Divider(
                                                                color: Colors.black),
                                                            Text("Reason: " +
                                                                lists[index]["reason"]),
                                                            Text(lists[index]
                                                            ["approved"] ==
                                                                true
                                                                ? "Approved"
                                                                : "Pending"),
                                                          ],
                                                        ),
                                                      ),
                                                      ButtonTheme(
                                                        minWidth: 36,
                                                        height: 36,
                                                        child: RaisedButton(
                                                          onPressed: () {
                                                            model.deleteRef(
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child("Requests")
                                                                    .child(dataValues
                                                                    .value.keys
                                                                    .elementAt(
                                                                    index)));
                                                          },
                                                          color: Color(0xFFA51313),
                                                          child: Text("X",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  'InterBold',
                                                                  fontSize: 15,
                                                                  color: Colors.white)),
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            );
                                          }));
                                } else {
                                  return Container(
                                    height: size.height * 0.75,
                                    width: size.width * 0.9,
                                    child:
                                    Center(
                                      child: Text(
                                        "All clear for now!",
                                        style: TextStyle(
                                            fontFamily: 'InterBold',
                                            fontSize: 30,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    ),
                                  );
                                }

                              }
                              return CircularProgressIndicator();
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                model.routeToHomeView();
                              },
                              textColor: kColorSkylineGreen,
                              color: kColorSkyLineGrey,
                              child: Text('Log Out'),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  //mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _initMethod() async {
    final User user = _auth.currentUser;

    dbRefInit = FirebaseDatabase.instance.reference().child("Requests").orderByChild("tutor-id").equalTo(user.uid);

    print("pls work");
  }
}
