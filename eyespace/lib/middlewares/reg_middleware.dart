import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyespace/actions/reg_actions.dart';
import 'package:eyespace/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:eyespace/keys/keys.dart';

List<Middleware<AppState>> createRegMiddleware() {
  final update = _createUpdateMiddleware();
  return [
    new TypedMiddleware<AppState, UpdateDB>(update),
  ];
}

Middleware<AppState> _createUpdateMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    final Firestore _db = Firestore.instance;
    final navigatorKey = AppKeys.navKey;
    if (action is UpdateDB) {
      try {
        DocumentReference mydb = _db.collection('users').document(action.uid);
        Map<String, String> data = <String, String>{
          "uname": action.uname,
          "city": action.city,
          "stt": action.stt,
          "country": action.country,
          "number": action.number,
          "econtact": action.econtact,
        };
        await mydb.updateData(data);
        DocumentSnapshot user = await mydb.get();
        store.dispatch(new RunUpdateReducer(user: user));
        navigatorKey.currentState.pushReplacementNamed("/");
      } catch (error) {
        print(error);
      }
    }
  };
}
