import 'package:driver_app/functions/traccarCalls/createNotificationTraccar.dart';
import 'package:driver_app/functions/traccarCalls/createUserTraccar.dart';
import 'package:driver_app/functions/traccarCalls/linkNotificationAndUserTraccar.dart';
import 'package:driver_app/functions/trasnporterApis/runTransporterApiPost.dart';

void createTraccarUserAndNotifications(String? token, String? mobileNum) async {
  String? traccarId = tidstorage.read("traccarUserId");
  if (traccarId == null) {
    String? userId = await createUserTraccar(token, mobileNum);
    // if (userId != null) {
    //   List<String?>? id = await createNotificationTraccar();
    //   if (id != []) {
    //     linkNotificationAndUserTraccar(userId, id);
    //   }
    // }
  } else {
    //do nothing
  }
}
