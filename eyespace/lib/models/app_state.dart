import 'package:cloud_firestore/cloud_firestore.dart';

class AppState {
  final bool isLoading;
  final DocumentSnapshot currentUser;
  final int navigationState;

  AppState(
      {this.isLoading = false, this.currentUser, this.navigationState = 0});

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({bool isLoading}) {
    return new AppState(
        isLoading: isLoading ?? this.isLoading,
        currentUser: currentUser ?? this.currentUser,
        navigationState: navigationState ?? this.navigationState // new
        );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^ currentUser.hashCode ^ navigationState.hashCode;

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          currentUser == other.currentUser &&
          navigationState == other.navigationState;
}
