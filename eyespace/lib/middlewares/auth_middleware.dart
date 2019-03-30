import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eyespace/actions/auth_actions.dart';
import 'package:eyespace/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:eyespace/keys/keys.dart';
import 'package:eyespace/main.dart';

List<Middleware<AppState>> createAuthMiddleware() {
  final logIn = _createLogInMiddleware();
  final logOut = _createLogOutMiddleware();
  return [
    new TypedMiddleware<AppState, LogIn>(logIn),
    new TypedMiddleware<AppState, LogOut>(logOut),
  ];
}

Middleware<AppState> _createLogInMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    FirebaseUser user;
    final Firestore _db = Firestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final navigatorKey = AppKeys.navKey;
    if (action is LogIn) {
      navigatorKey.currentState.pushReplacementNamed('/loading');
      try {
        GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        user = await _auth.signInWithCredential(credential);
        DocumentReference mydb = _db.collection('users').document(user.uid);
        raid = await mydb.get();
        if (!raid.exists) {
          Map<String, String> data = <String, String>{
            "displayName": user.displayName,
            "email": user.email,
            "number": user.phoneNumber,
            "photoURL": user.photoUrl,
            "uid": user.uid
          };
          await mydb.setData(data);
          raid = await mydb.get();
          store.dispatch(new LogInSuccessful(user: raid));
          navigatorKey.currentState.pushReplacementNamed('/register');
        } else if (raid.data['uname'] == null || raid.data['uname'] == "") {
          // returning user
          store.dispatch(new LogInSuccessful(user: raid));
          navigatorKey.currentState.pushReplacementNamed('/register');
        } else if (raid.data['uname'] != null) {
          store.dispatch(new LogInSuccessful(user: raid));
          navigatorKey.currentState.pushReplacementNamed('/');
        }
      } catch (error) {
        store.dispatch(new LogInFail(error));
        navigatorKey.currentState.pushReplacementNamed('/login');
      }
    }
  };
}

Middleware<AppState> _createLogOutMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final navigatorKey = AppKeys.navKey;
    if (action is LogOut) {
      try {
        navigatorKey.currentState.pushReplacementNamed('/login');
        await _auth.signOut();
        await _googleSignIn.isSignedIn().then((u) => _googleSignIn.signOut());
        store.dispatch(new LogOutSuccessful());
      } catch (error) {
        store.dispatch(new LogOutFail(error));
      }
    }
  };
}
