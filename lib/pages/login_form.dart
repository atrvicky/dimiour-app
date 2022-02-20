import 'package:app/components/components.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/helpers/network/network_service.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final Function? onSuccessCallback;

  const LoginForm({
    Key? key,
    this.onSuccessCallback,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isEditing = true;

  bool validUsername = true;
  bool validPassword = true;
  bool validLogin = true;
  bool _isLoggingIn = false;

  late CustomInputField signinUsernameField;
  late CustomInputField signinPasswordField;
  late AppStateManager appState;
  late UserManager userManager;
  late NetworkService _networkService;

  static final GlobalKey loginFormkey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<AppStateManager>(context, listen: false);
    userManager = Provider.of<UserManager>(context, listen: false);
    _networkService = NetworkService(context: context);

    buildInputFields();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFormkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!validUsername)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: const Text(
                "Invalid Email Address",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          signinUsernameField.buildField(),
          const SizedBox(
            height: 25.0,
          ),
          if (!validPassword)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: const Text(
                "Invalid password",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          signinPasswordField.buildField(),
          const SizedBox(
            height: 15.0,
          ),
          if (!validLogin)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                "Login failed",
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Colors.red,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
          _isLoggingIn
              ? const Center(
                  child: Loader(loaderText: ''),
                )
              : MaterialButton(
                  onPressed: _attemptLogin,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _attemptLogin() async {
    setState(() {
      validUsername = true;
      validPassword = true;
    });

    String username = signinUsernameField.textController.text;
    String password = signinPasswordField.textController.text;

    if (username.isEmpty) {
      setState(() {
        validUsername = false;
      });
    } else if (password.isEmpty) {
      setState(() {
        validPassword = false;
      });
    } else {
      String fcmToken = '';
      if (appState.messaging != null) {
        fcmToken = await  appState.messaging!.getToken() ?? '';
      }
      login(username, password, fcmToken);
    }
  }

  void login(String username, String password, String fcmToken) async {
    setState(() {
      _isLoggingIn = true;
    });

    User? _user = await _networkService.doLogin(username, password, fcmToken);

    if (_user.id.isNotEmpty) {
      setState(() {
        validLogin = true;
        _isLoggingIn = false;
      });
      userManager.storeUser(_user);
      userManager.loadUserFromCache(appState);

      if (widget.onSuccessCallback != null) {
        widget.onSuccessCallback!();
      }
    } else {
      setState(() {
        validLogin = false;
        _isLoggingIn = false;
      });
    }
  }

  void buildInputFields() {
    signinPasswordField = CustomInputField(
      inputName: 'signinPasswordField',
      textController: TextEditingController(),
      focusNode: FocusNode(),
      isPassword: true,
      keyboardType: TextInputType.text,
      labelText: 'Password',
      context: context,
      theme: Theme.of(context),
      isEnabled: isEditing,
      nullErrorString: 'Invalid Password',
      invalidInputString: 'Enter Password',
    );

    signinUsernameField = CustomInputField(
      inputName: 'signinUsernameField',
      textController: TextEditingController(),
      focusNode: FocusNode(),
      keyboardType: TextInputType.emailAddress,
      labelText: 'Email',
      context: context,
      theme: Theme.of(context),
      isEnabled: isEditing,
      nextFocus: signinPasswordField.getFocusNode(),
      nullErrorString: 'Invalid Email',
      invalidInputString: 'Enter Email',
    );

    signinUsernameField.textController.text =
        ENV == 'dev' ? 'mk@testmail.com' : '';
    signinPasswordField.textController.text =
        ENV == 'dev' ? 'dm#\$Admin@123' : '';
  }
}
