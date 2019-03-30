import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyespace/actions/auth_actions.dart';
import 'package:eyespace/actions/reg_actions.dart';
import 'package:redux/redux.dart';

final updateReducer = combineReducers<DocumentSnapshot>([
  new TypedReducer<DocumentSnapshot, LogInSuccessful>(_logIn),
  new TypedReducer<DocumentSnapshot, LogOutSuccessful>(_logOut),
  new TypedReducer<DocumentSnapshot, RunUpdateReducer>(_updateFields),
]);

DocumentSnapshot _logIn(DocumentSnapshot user, action) {
  return action.user;
}

DocumentSnapshot _updateFields(DocumentSnapshot user, action) {
  return action.user;
}

Null _logOut(DocumentSnapshot user, action) {
  return null;
}
