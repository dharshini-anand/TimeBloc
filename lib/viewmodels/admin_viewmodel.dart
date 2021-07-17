import 'package:flutter/material.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/locator.dart';
//import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AdminViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final dbRefInit = FirebaseDatabase.instance
      .reference()
      .child("Requests")
      .orderByChild("approved")
      .equalTo(false);

  AdminViewModel() {
    setState(ViewState.Busy);
    try {
      print("TutorViewModel Constructor()");
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }

  void buildList(
      BuildContext context, AsyncSnapshot<Event> snapshot, List lists) {
    lists.clear();
    DataSnapshot dataValues = snapshot.data.snapshot;
    Map<dynamic, dynamic> values = dataValues.value;
    //print(values);
    if (values != null) {
      values.forEach((key, values) {
        lists.add(values);
      });
    }
  }

  String formatDate(int timestamp) {
    return DateFormat('M/d/yy h:mm aa')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  void deleteRef(DatabaseReference ref) {
    ref.remove();
  }

  void updateRef(DatabaseReference ref) {
    ref.child("approved").set(true);
  }

  void routeToHomeView() {
    FirebaseAuth.instance.signOut();
    _navigationService.navigateTo(HomeViewRoute);
  }
}
