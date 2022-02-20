// ignore_for_file: constant_identifier_names

import 'package:app/helpers/constants.dart';
import 'package:app/models/models.dart';
import 'package:app/pages/pages_barell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _PageState { Login, Signup }

class LoginPage extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
      name: LOGIN_PATH,
      key: ValueKey(LOGIN_PATH),
      child: LoginPage(),
    );
  }

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserManager _userManager;
  late AppStateManager _appStateManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userManager = Provider.of<UserManager>(context);
    _appStateManager = Provider.of<AppStateManager>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // IMAGE LOGO GOES HERE
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 500,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Dimiour',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your virtual life balancer',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: buildLoginBody(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget buildLoginBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        LoginForm(
          onSuccessCallback: () {
            if (_userManager.userType == UserType.User) {
              _appStateManager.updatePage(TIMELINE_PATH);
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
