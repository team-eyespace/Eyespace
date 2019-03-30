import 'package:eyespace/actions/navigation_actions.dart';

int navigationReducer(int navigationState, action) {
  if (action is SetCurrentPage) {
    return action.page;
  } else
    return 0;
}
