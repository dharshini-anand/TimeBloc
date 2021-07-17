import 'package:flutter/material.dart';
import 'package:skyline_template_app/viewmodels/admin_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
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
    return ChangeNotifierProvider<AdminViewModel>(
        create: (context) => locator<AdminViewModel>(),
        child: Consumer<AdminViewModel>(
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
                        child: Image.asset(
                          "assets/wave1.png",
                          height: size.height * 0.4,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            child: Text(
                              "PENDING REQUESTS",
                              style: TextStyle(
                                  fontFamily: 'InterBold',
                                  fontSize: 30,
                                  color: Color(0xFF313131)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                              stream: dbRefInit.onValue,
                              builder:
                                  (context, AsyncSnapshot<Event> snapshot) {
                                if (snapshot.hasData) {
                                  DataSnapshot dataValues =
                                      snapshot.data.snapshot;
                                  model.buildList(context, snapshot, lists);
                                  if (lists.length > 0) {
                                    return Container(
                                        height: size.height * 0.75,
                                        width: size.width * 0.9,
                                        child: new ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: lists.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Card(
                                                color: Color(0xFF1D1D1D),
                                                child: Container(
                                                  color: Color(0xFF1D1D1D),
                                                  margin:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  padding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: size.width *
                                                              0.5,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: <
                                                                Widget>[
                                                              Text(
                                                                lists[index]
                                                                ["name"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    24, color: Color(0xFFFFFFFF),),
                                                              ),
                                                              Divider(
                                                                  color: Colors
                                                                      .white),
                                                              Text(
                                                                model.formatDate(
                                                                    lists[index]
                                                                    [
                                                                    "start-date"]) +
                                                                    " -\n" +
                                                                    model.formatDate(
                                                                        lists[index]
                                                                        [
                                                                        "end-date"]),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    18, color: Color(0xFFFFFFFF),),
                                                              ),
                                                              Divider(
                                                                  color: Colors
                                                                      .white),
                                                              Text("Reason: " +
                                                                  lists[index]
                                                                  [
                                                                  "reason"], style: TextStyle(
                                                                color: Color(0xFFFFFFFF),) ),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            ButtonTheme(
                                                              minWidth: 36,
                                                              height: 36,
                                                              child:
                                                              RaisedButton(
                                                                onPressed:
                                                                    () {
                                                                  model.updateRef(FirebaseDatabase.instance.reference().child("Requests")
                                                                      .child(dataValues.value.keys.elementAt(index)));
                                                                },
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                            ButtonTheme(
                                                              minWidth: 36,
                                                              height: 36,
                                                              child:
                                                              RaisedButton(
                                                                onPressed:
                                                                    () {
                                                                  model.deleteRef(FirebaseDatabase.instance.reference().child("Requests")
                                                                      .child(dataValues.value.keys.elementAt(index)));
                                                                },
                                                                color: Colors
                                                                    .red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                              );
                                            })
                                    );
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
                            ],
                          ),
                        ],
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future _initMethod() async {
    final User user = _auth.currentUser;

    dbRefInit = FirebaseDatabase.instance.reference().child("Requests").orderByChild("approved").equalTo(false);

  }
}
