import 'package:flutter/material.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:skyline_template_app/ui/tutor_view.dart';
import 'package:skyline_template_app/ui/admin_view.dart';
import 'package:skyline_template_app/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:flutter_svg/svg.dart';

import '../core/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  bool invalid = false;
  String email, password;
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  String authType;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => locator<HomeViewModel>(),
      child: Consumer<HomeViewModel>(
        builder: (context, model, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xFF313131),
            body: Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget> [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset("assets/blob.svg", width: size.width * 0.35,),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset("assets/blob2.svg", width: size.width * 0.25,),
                  ),
                  SingleChildScrollView(
                    child: Column(
                    children: [
                      Container(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontFamily: 'InterBold', fontSize: 20, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      SvgPicture.asset("assets/login.svg", height: size.height * 0.35),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Visibility(
                          visible: invalid,
                          child: Text(
                            "Invalid email or password.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.red),
                          )),
                      Container(
                        width: size.width * 0.8,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFDFA0),
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: TextField(
                            onChanged: (text) {
                              email = text;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 10),
                      Container(
                        width: size.width * 0.8,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFDFA0),
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: TextField(
                            obscureText: true,
                            onChanged: (text) {
                              password = text;
                            },
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                              onPressed: buttonPress()
                                  ? null
                                  : () async {
                                      setState(() {
                                        showProgress = true;
                                      });
                                      try {
                                        final newuser =
                                            await _auth.signInWithEmailAndPassword(
                                                email: email, password: password);
                                        if (newuser != null) {
                                          final User user = _auth.currentUser;
                                          dbRef
                                              .child(user.uid)
                                              .child("type")
                                              .once()
                                              .then((DataSnapshot data) {
                                            authType = data.value;
                                            if (authType == "admin") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AdminView()),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => TutorView()),
                                              );
                                            }
                                          });

                                          setState(() {
                                            showProgress = false;
                                          });
                                        } else {}
                                      } catch (e) {
                                        invalid = true;
                                      }
                                    },
                              textColor: Colors.black,
                              color: Color(0xFFE7C6FF),
                              disabledColor: kColorSkyLineGrey,
                              child: Text('Log In', style: TextStyle(fontFamily: 'InterReg',), ),
                            ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                    ],
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  buttonPress() {
    if (email == null || password == null) {
      return true;
    } else {
      return false;
    }
  }
}
