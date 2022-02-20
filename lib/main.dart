import 'package:app/helpers/constants.dart';
import 'package:app/helpers/network/network_service.dart';
import 'package:app/helpers/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';
import 'helpers/navigation/app_router.dart';
import 'models/models.dart';

void main() {
  runApp(const DimiourApp());
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  flutterLocalNotificationsPlugin.show(
      1,
      message.data['type'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // other properties...
        ),
      ));
}

class DimiourApp extends StatefulWidget {
  const DimiourApp({Key? key}) : super(key: key);

  @override
  State<DimiourApp> createState() => _DimiourAppState();
}

class _DimiourAppState extends State<DimiourApp> {
  final _screenManager = AppStateManager();
  final _userManager = UserManager();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late AppRouter _appRouter;
  late NetworkService networkService;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  @override
  void initState() {
    _initNotifications();
    super.initState();
    _appRouter = AppRouter(
      screenManager: _screenManager,
      userManager: _userManager,
    );
    _userManager.loadUserFromCache(_screenManager);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _screenManager),
        ChangeNotifierProvider(create: (context) => _userManager),
      ],
      child: Consumer<UserManager>(
        builder: (context, _userManager, child) {
          ThemeData theme;
          if (_userManager.isDarkMode) {
            theme = DimiourTheme.dark();
          } else {
            theme = DimiourTheme.light();
          }
          if (_userManager.isInitialized) return buildMainBody(context, theme);
          return buildLoader(context, theme);
        },
      ),
    );
  }

  MaterialApp buildLoader(BuildContext context, ThemeData theme) => MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: ENV == 'dev',
        title: 'Dimiour',
        home: Scaffold(
          backgroundColor: theme.backgroundColor,
          resizeToAvoidBottomInset: false,
          body: const SafeArea(
            child: Center(
              child: Loader(loaderText: 'Loading. Please wait...'),
            ),
          ),
        ),
      );

  MaterialApp buildMainBody(BuildContext context, ThemeData theme) {
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: ENV == 'dev',
      title: 'Dimiour',
      home: Consumer<AppStateManager>(
        builder: (context, screenManager, child) => Scaffold(
          backgroundColor: theme.backgroundColor,
          resizeToAvoidBottomInset: true,
          drawer: null,
          appBar: null,
          bottomNavigationBar: screenManager.showNavBar
              ? BottomNavigationBar(
                  onTap: (index) {
                    screenManager.gotoScreen(index, context);
                  },
                  currentIndex: screenManager.activeScreenIndex,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.timeline,
                        color: screenManager.activeScreenIndex == 0
                            ? Colors.blue
                            : _userManager.isDarkMode
                                ? Colors.white
                                : Colors.black,
                      ),
                      label: 'Timeline',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.kitchen,
                        color: screenManager.activeScreenIndex == 1
                            ? Colors.blue
                            : _userManager.isDarkMode
                                ? Colors.white
                                : Colors.black,
                      ),
                      label: 'Configs',
                    ),
                  ],
                )
              : null,
          body: SafeArea(
            child: Router(
              routerDelegate: _appRouter,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          ),
        ),
      ),
    );
  }

  void _initNotifications() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _screenManager.messaging = _messaging;
    _messaging.onTokenRefresh.listen(saveToken);
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotification(message);
      });

      checkForInitialMessage();
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  void _handleNotification(RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    flutterLocalNotificationsPlugin.show(
        1,
        message.data['type'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            // other properties...
          ),
        ));
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotification(initialMessage);
    }
  }

  Future<void> saveToken(String token) async {
    if (_userManager.id != null && _userManager.id!.isNotEmpty) {
      await networkService.updateFCMID(
          _userManager.id!, await _messaging.getToken() ?? '');
    }
    return;
  }
}
