import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:eyespace/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyespace/constants/colors.dart';
import 'package:eyespace/actions/reg_actions.dart';
import 'package:eyespace/keys/keys.dart';

class RegFormContainer extends StatelessWidget {
  RegFormContainer({Key key}) : super(key: key);
  final navigatorKey = AppKeys.navKey;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          return new Container(
            child: Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextField(
                    controller: vm.usernameController,
                    onChanged: (text) {
                      vm.unameCheck(text);
                    },
                    decoration: new InputDecoration(
                      hintText: "Username",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.home),
                  title: new TextField(
                    controller: vm.cityController,
                    decoration: new InputDecoration(
                      hintText: "City",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.home),
                  title: new TextField(
                    controller: vm.stateController,
                    decoration: new InputDecoration(
                      hintText: "State",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.home),
                  title: new TextField(
                    controller: vm.countryController,
                    decoration: new InputDecoration(
                      hintText: "Country",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.phone),
                  title: new TextField(
                    keyboardType: TextInputType.number,
                    controller: vm.phoneController,
                    decoration: new InputDecoration(
                      hintText: "Phone Number",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.error),
                  title: new TextField(
                    keyboardType: TextInputType.number,
                    controller: vm.emergencyController,
                    decoration: new InputDecoration(
                      hintText: "Emergency Contact",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(
                    builder: (context) {
                      return RaisedButton(
                        onPressed: () {
                          vm.update(
                              vm.currentUser.data['uid'],
                              vm.usernameController.text,
                              vm.cityController.text,
                              vm.stateController.text,
                              vm.countryController.text,
                              vm.phoneController.text,
                              vm.emergencyController.text);
                        },
                        color: MeSuiteColors.blue,
                        child: Text('Submit'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final DocumentSnapshot currentUser;
  final Function(String) unameCheck;
  final Function(String, String, String, String, String, String, String) update;
  final TextEditingController usernameController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final TextEditingController phoneController;
  final TextEditingController emergencyController;

  _ViewModel(
      {@required this.currentUser,
      this.unameCheck,
      this.usernameController,
      this.cityController,
      this.stateController,
      this.countryController,
      this.phoneController,
      this.emergencyController,
      this.update});

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
        unameCheck: (String unamecheck) async {
          final Firestore _db = Firestore.instance;
          QuerySnapshot check = await _db
              .collection('users')
              .where("uname", isEqualTo: unamecheck)
              .getDocuments();
          if (unamecheck == null || unamecheck == "") {
            print("enter something");
          } else if (check.documents.isEmpty ||
              check.documents.single.data['uname'] ==
                  store.state.currentUser.data['uname']) {
            print("available");
          } else {
            print("taken");
          }
        },
        update: (String uid, String uname, String city, String stt,
            String country, String number, String econtact) {
          store.dispatch(UpdateDB(
              uid: uid,
              uname: uname,
              city: city,
              stt: stt,
              country: country,
              number: number,
              econtact: econtact));
        },
        currentUser: store.state.currentUser,
        usernameController: new TextEditingController.fromValue(new TextEditingValue(
            text: store.state.currentUser.data['uname'] ?? "",
            selection: new TextSelection.collapsed(
                offset: store.state.currentUser.data['uname']?.length ?? 0))),
        cityController: new TextEditingController.fromValue(new TextEditingValue(
            text: store.state.currentUser.data['city'] ?? "",
            selection: new TextSelection.collapsed(
                offset: store.state.currentUser.data['city']?.length ?? 0))),
        stateController: new TextEditingController.fromValue(
            new TextEditingValue(
                text: store.state.currentUser.data['stt'] ?? "",
                selection: new TextSelection.collapsed(
                    offset: store.state.currentUser.data['stt']?.length ?? 0))),
        countryController: new TextEditingController.fromValue(new TextEditingValue(
            text: store.state.currentUser.data['country'] ?? "",
            selection: new TextSelection.collapsed(offset: store.state.currentUser.data['country']?.length ?? 0))),
        phoneController: new TextEditingController.fromValue(new TextEditingValue(text: store.state.currentUser.data['number'] ?? "", selection: new TextSelection.collapsed(offset: store.state.currentUser.data['number']?.length ?? 0))),
        emergencyController: new TextEditingController.fromValue(new TextEditingValue(text: store.state.currentUser.data['econtact'] ?? "", selection: new TextSelection.collapsed(offset: store.state.currentUser.data['econtact']?.length ?? 0))));
  }
}
