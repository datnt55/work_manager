import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:work_manager_app/repository/EventRepository.dart';

import 'database/database_helper.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DatabaseProvider.databaseProvider);
  locator.registerLazySingleton<EventRepository>(() => EventRepository());
}

//void setupLocatorWithContext(BuildContext context) {
//  locator.allowReassignment = true;
//  locator.registerLazySingleton(() => Language.of(context));
//}