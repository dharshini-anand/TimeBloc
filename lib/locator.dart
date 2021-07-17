import 'package:skyline_template_app/viewmodels/home_viewmodel.dart';
import 'package:skyline_template_app/viewmodels/admin_viewmodel.dart';
import 'package:skyline_template_app/viewmodels/tutor_viewmodel.dart';
import 'package:skyline_template_app/viewmodels/requestform_viewmodel.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'viewmodels/home_viewmodel.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  _setupViewModels();
  _setupServices();
}


  Future _setupViewModels() async {
    locator.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
    locator.registerLazySingleton<AdminViewModel>(() => AdminViewModel());
    locator.registerLazySingleton<TutorViewModel>(() => TutorViewModel());
    locator.registerLazySingleton<RequestFormViewModel>(() => RequestFormViewModel());
}
Future _setupServices() async {
  locator.registerLazySingleton<NavigationService>(() => NavigationServiceImpl());
}