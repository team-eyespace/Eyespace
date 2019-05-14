import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:eyespace/middlewares/auth_middleware.dart';
import 'package:eyespace/middlewares/reg_middleware.dart';
import 'package:eyespace/reducers/app_reducer.dart';
import 'package:eyespace/routes.dart';
import 'package:redux/redux.dart';
import 'models/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eyespace/keys/keys.dart';
import 'package:camera/camera.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eyespace/AppLocalizations.dart';

List<CameraDescription> cameras;
DocumentSnapshot raid;
String token;

Future<Null> main() async {
  cameras = await availableCameras();
  FirebaseUser user;
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  try {
    GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user = await _auth.signInWithCredential(credential);
    token = "Bearer " + await user.getIdToken();
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
      AppState initialState = new AppState(isLoading: false, currentUser: raid);
      final store = new Store<AppState>(
        appReducer,
        initialState: initialState ?? new AppState(),
        distinct: true,
        middleware: []
          ..addAll(createAuthMiddleware())
          ..addAll(createRegMiddleware())
          ..add(new LoggingMiddleware.printer()),
      );
      runApp(NewUserApp(
        store: store,
      ));
    } else if (raid.data['uname'] == null || raid.data['uname'] == "") {
      AppState initialState = new AppState(isLoading: false, currentUser: raid);
      final store = new Store<AppState>(
        appReducer,
        initialState: initialState ?? new AppState(),
        distinct: true,
        middleware: []
          ..addAll(createAuthMiddleware())
          ..addAll(createRegMiddleware())
          ..add(new LoggingMiddleware.printer()),
      );
      runApp(NewUserApp(
        store: store,
      ));
    } else {
      // returning user
      AppState initialState = new AppState(isLoading: false, currentUser: raid);
      final store = new Store<AppState>(
        appReducer,
        initialState: initialState ?? new AppState(),
        distinct: true,
        middleware: []
          ..addAll(createAuthMiddleware())
          ..addAll(createRegMiddleware())
          ..add(new LoggingMiddleware.printer()),
      );
      runApp(ReturningUserApp(
        store: store,
      ));
    }
  } catch (error) {
    final store = new Store<AppState>(
      appReducer,
      initialState: new AppState(),
      distinct: true,
      middleware: []
        ..addAll(createAuthMiddleware())
        ..addAll(createRegMiddleware())
        ..add(new LoggingMiddleware.printer()),
    );
    runApp(MainApp(
      store: store,
    ));
  }
}

class MainApp extends StatelessWidget {
  final Store<AppState> store;

  MainApp({this.store});

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('pt', ''),
        ],
        navigatorKey: AppKeys.navKey,
        debugShowCheckedModeBanner: false,
        routes: getRoutes(context, store),
        initialRoute: '/login',
      ),
    );
  }
}

class NewUserApp extends StatelessWidget {
  final Store<AppState> store;

  NewUserApp({this.store});

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('pt', ''),
        ],
        navigatorKey: AppKeys.navKey,
        debugShowCheckedModeBanner: false,
        routes: getRoutes(context, store),
        initialRoute: '/register',
      ),
    );
  }
}

class ReturningUserApp extends StatelessWidget {
  final Store<AppState> store;

  ReturningUserApp({this.store});

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('pt', ''),
        ],
        navigatorKey: AppKeys.navKey,
        debugShowCheckedModeBanner: false,
        routes: getRoutes(context, store),
        initialRoute: '/',
      ),
    );
  }
}
