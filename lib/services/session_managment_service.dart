import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:redux/redux.dart';

//get
String getLoggedInUserId(Store<AppState> store) {
  return store.state.authState.currentUserId;
}

//set
void updateLoggedInUserProfile(
    Store<AppState> store, ProfileEntity loggedInUserProfile) {
  store.dispatch(SetLoggedInUserProfile(loggedInUserProfile));
}

void updateAuthState(Store<AppState> store,
    {String userName = '',
    String email = '',
    bool isArchived = false,
    bool isAdmin = false,
    bool setProfileCompleted = false,
    bool isEmailVerified = false,
    String currentUserId = ''}) {
  store.dispatch(UpdateAuthStateAction(
      currentUserName: userName,
      email: email,
      isArchived: isArchived,
      isAdmin: isAdmin,
      setProfileCompleted: setProfileCompleted,
      isEmailVerified: isEmailVerified,
      currentUserId: currentUserId));
}

//store.state.user.id (this is from user state it was being used as session to get loggedIn user id but the issue is it gets replaced its id from mock data on refresh)

bool isAdmin(AppState state) => state.authState.isAdmin;

bool isAuthenticated(AppState state) => state.authState.isAuthenticated;

bool isGuestUser(AppState state) => !isAuthenticated(state) || state.userCompany.permissions.isEmpty;

bool isEmailVerified(AppState state) =>
    state.authState.isAuthenticated && state.authState.isEmailVerified;
