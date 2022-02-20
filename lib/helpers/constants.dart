// ignore_for_file: constant_identifier_names, non_constant_identifier_names

const String APP_NAME = 'Mindleap User Portal';

// general actionState
enum NetworkState {
  Loading,
  Idle,
  Error,
}

// snackbar message types
enum ToastType { Warning, Success, Error }

enum Network { Online, Offline }

enum Language { English, Tamil }

// choice of user type
enum UserType { SuperAdmin, Admin, User }

// user state
enum UserState { LoggedIn, LoggedOut }

enum DioState { Connecting, Idle, Err, OK }

enum NotificationType {
  WorkBreakLong,
  WorkResume,
  WorkBreakShort,
  WaterBreak,
  FoodBreak,
  Posture,
  Quote,
}

// server response codes
const int FAILED = 000;
const int UNAUTHORIZED = 401;
const int NO_MATCH_FOUND = 100;
const int SUCCESS = 200;
const int SUCCESS_BUT_ERR = 201;
const int INTERNAL_ERROR = 300;
const int QUERY_ERROR = 400;

const String LOGIN_PATH = '/signin';
const String OOPS_PATH = '/oops';
const String TIMELINE_PATH = '/timeline';
const String SETTINGS_PATH = '/settings';

const String EXPORT_FORMAT_PDF = 'pdf';
const String EXPORT_FORMAT_CSV = 'csv';

final RegExp PATTERN_MATCH_ONLY_DIGITS = RegExp(r'^[0-9]+$');
final RegExp PATTERN_MATCH_ONLY_ALPHA_NUMERIC = RegExp(r'^[a-zA-Z0-9_]+$');
final RegExp PATTERN_MATCH_ONLY_YEAR_RANGE = RegExp(r'^[0-9]{4}-[0-9]{4}');
final RegExp PATTERN_MATCH_ONLY_DECIMAL_DIGITS = RegExp(r'^\d+\\.?\d{0,2}$');

// can be 'dev', 'prod'
const String ENV = 'dev';

// local IP
const String baseURL =
    ENV == 'dev' ? "http://192.168.1.99:8080" : "https://api.dimiour.in";
