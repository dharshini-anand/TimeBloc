import 'package:skyline_template_app/model/Request.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:skyline_template_app/model/Request.dart';

class RequestFormViewModel extends BaseViewModel {
  final  _navigationService = locator<NavigationService>();
  final dbRef = FirebaseDatabase.instance.reference().child("Requests");
  var submitted = false;
  String space = " ";
  var _name1, _name2;


  RequestFormViewModel() {
    setState(ViewState.Busy);
    try {
      submitted = false;
      _initMethod();
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }

  void _initMethod(){
    for (int i = 0; i < 2; i++) {
      print("HomeViewModel Init() function called printing $i iteration of my for loop");
    }
  }

  void submitForm(Request req){
    dbRef.push().set({
      "tutor-id": req.uid,
      "name": req.name,
      "start-date": req.startDate,
      "end-date": req.endDate,
      "reason": req.reason,
      "approved": req.approved,
    }).then((_) {
      submitted = true;
    }).catchError((onError) {
      print(onError);
    });
  }

  void routeToTutorView() {
    _navigationService.navigateTo(TutorViewRoute);
  }
}