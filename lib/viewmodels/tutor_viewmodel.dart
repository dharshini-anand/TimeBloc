import 'package:flutter/material.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class TutorViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  TutorViewModel() {
    setState(ViewState.Busy);
    try {
      print("TutorViewModel Constructor()");
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }

  Color approveColor(bool approved) {
    if (approved) {
      return Color(0xFFC8FFAF);
    } else {
      return Color(0xFFFFA45D);
    }
  }

  void deleteRef(DatabaseReference ref) {
    ref.remove();
  }

  String formatDate(int timestamp) {
    return DateFormat('M/d/yy h:mm aa')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  void buildList(
      BuildContext context, AsyncSnapshot<Event> snapshot, List lists) {
    lists.clear();
    DataSnapshot dataValues = snapshot.data.snapshot;
    Map<dynamic, dynamic> values = dataValues.value;
    if (values != null) {
      values.forEach((key, values) {
        lists.add(values);
      });
    }
  }

  void routeToHomeView() {
    FirebaseAuth.instance.signOut();
    _navigationService.navigateTo(HomeViewRoute);
  }

  void routeToFormView() {
    _navigationService.navigateTo(RequestFormViewRoute);
  }
}
