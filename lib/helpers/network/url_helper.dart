import '../constants.dart';

String loginURL = _getCompleteURL("/api/users/auth/login");
String signupURL = _getCompleteURL("/api/candidates/auth/signup");
String getCandidateProfileURL = _getCompleteURL("/api/candidates/getProfile");
String updateFCMIDURL = _getCompleteURL("/api/users/updateFCMID");
String getUserTimelineURL = _getCompleteURL("/api/users/timeline/getAll");

String _getCompleteURL(accessor) => baseURL + accessor;
