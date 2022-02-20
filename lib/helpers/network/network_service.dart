import 'package:app/helpers/constants.dart';
import 'package:app/helpers/network/url_helper.dart';
import 'package:app/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../misc_helper.dart';

class NetworkService {
  final BuildContext context;
  final AppStateManager appStateManager;
  final Options defaultAuthOptions;

  // if set to [true] this flag controls the network state of the stateManager
  bool _handleState = true;

  NetworkService({required this.context})
      : appStateManager = Provider.of<AppStateManager>(context, listen: false),
        defaultAuthOptions = Options(
          followRedirects: false,
          headers: {
            "Authorization":
                Provider.of<UserManager>(context, listen: false).accessToken,
          },
        );

  void setHandleState(bool shouldHandle) {
    _handleState = shouldHandle;
  }

  void setNetworkLoading() {
    if (_handleState) {
      appStateManager.setNetworkState(NetworkState.Loading);
    }
  }

  bool handleSuccessResponse(Response response) {
    if (_handleState) {
      if (response.data['status'] == SUCCESS) {
        appStateManager.setNetworkState(NetworkState.Idle);
      } else {
        appStateManager.setNetworkState(NetworkState.Error);
      }
    }

    return response.data['status'] == SUCCESS;
  }

  void handleError(e) {
    String errorText = 'Error loading data: ${e.toString()}.';
    if (e is DioError) {
      if (e.response?.statusCode == 404) {
        appStateManager.updatePage(OOPS_PATH);
        errorText = 'Requested data cannot be loaded: ${e.error}';
      } else if (e.response?.statusCode == 401) {
        errorText = 'Unauthorized access: ${e.error}';
        if (!Provider.of<UserManager>(context, listen: false).isLoggedOut) {
          appStateManager.updatePage(OOPS_PATH);
          Provider.of<UserManager>(context, listen: false)
              .logout(appStateManager, false);
        } else {
          errorText = 'You need to be logged in: ${e.error}';
          Provider.of<UserManager>(context, listen: false)
              .logout(appStateManager, true);
        }
      } else {
        errorText =
            'Error: ${e.response?.data['msg'] ?? 'Something went wrong!'}';
      }
    }

    appStateManager.displaySnackbar(
      context: context,
      message: errorText,
      type: ToastType.Error,
    );
    if (_handleState) appStateManager.setNetworkState(NetworkState.Error);
  }

// ---------------- API are written below this line --------------------

  // *** Auth APIs ***
  Future<bool> doSignup(
      String username, String password, String email, String phone) async {
    setNetworkLoading();
    try {
      Response response = await Dio().post(
        signupURL,
        data: {
          'name': username,
          'password': password,
          'email': email,
          'phone': phone,
        },
      );

      if (handleSuccessResponse(response)) {
        return true;
      }
      return false;
    } catch (e) {
      handleError(e);
      return false;
    }
  }

  Future<User> doLogin(
      String username, String password, String fcmToken) async {
    setNetworkLoading();
    try {
      Response response = await Dio().post(
        loginURL,
        data: {
          'userID': username,
          'password': password,
          'fcmID': fcmToken,
        },
      );

      if (handleSuccessResponse(response)) {
        User loggedInUser = User.fromJson(response.data['data']);

        // manually inject the userType and the username
        loggedInUser.userType =
            MiscHelper.getUserTypeFromString(loggedInUser.apiUserType);
        return loggedInUser;
      }
      return User();
    } catch (e) {
      handleError(e);
      return User();
    }
  }

  // *** Timeline API ***

  Future<UserTimeline> getUserTimeline(String userID) async {
    setNetworkLoading();
    try {
      Response response = await Dio().get(
        getUserTimelineURL,
        queryParameters: {
          'userID': userID,
        },
        options: defaultAuthOptions,
      );

      if (handleSuccessResponse(response)) {
        return UserTimeline.fromJson(response.data['data']);
      }
      return UserTimeline();
    } catch (e) {
      handleError(e);
      return UserTimeline();
    }
  }

  // *** messaging APIs ***
  Future<bool> updateFCMID(String userID, String fcmID) async {
    setNetworkLoading();
    try {
      Response response = await Dio().post(
        updateFCMIDURL,
        data: {
          'userID': userID,
          'fcmID': fcmID,
        },
      );

      if (handleSuccessResponse(response)) {
        return true;
      }
      return false;
    } catch (e) {
      handleError(e);
      return false;
    }
  }
}
