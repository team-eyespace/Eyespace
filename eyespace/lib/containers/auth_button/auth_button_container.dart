import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:eyespace/actions/auth_actions.dart';
import 'package:eyespace/models/app_state.dart';
import 'package:eyespace/containers/auth_button/google_auth_button.dart';
import 'package:redux/redux.dart';

class GoogleAuthButtonContainer extends StatelessWidget {
  GoogleAuthButtonContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return new GoogleAuthButton(
          buttonText: vm.buttonText,
          onPressedCallback: () => vm.onPressedCallback(context),
        );
      },
    );
  }
}

class _ViewModel {
  final String buttonText;
  final Function onPressedCallback;

  _ViewModel({this.onPressedCallback, this.buttonText});

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      buttonText:
          store.state.currentUser != null ? 'Sign Out' : 'Sign in with Google',
      onPressedCallback: (context) {
        if (store.state.currentUser != null) {
          store.dispatch(new LogOut());
        } else {
          store.dispatch(new LogIn());
        }
      },
    );
  }
}
