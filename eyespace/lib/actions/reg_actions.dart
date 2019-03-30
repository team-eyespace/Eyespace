import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateDB {
  String uid;
  String uname;
  String city;
  String stt;
  String country;
  String number;
  String econtact;

  UpdateDB(
      {@required this.uid,
      @required this.uname,
      @required this.city,
      @required this.stt,
      @required this.country,
      @required this.number,
      @required this.econtact});
}

class RunUpdateReducer {
  final DocumentSnapshot user;

  RunUpdateReducer({@required this.user});
}
