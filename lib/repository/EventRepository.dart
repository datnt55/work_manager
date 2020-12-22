
import 'package:work_manager_app/database/data_base_helper.dart';
import 'package:work_manager_app/database/event.dart';

import '../locator.dart';

class EventRepository{
  DatabaseProvider databaseProvider = locator<DatabaseProvider>();

  Future<int> addFavorite(Event event) {
    return databaseProvider.addEvent(event);
  }

  Future<List<Event>> getEvents() {
    return databaseProvider.getEvents();
  }


}