import 'package:app/helpers/constants.dart';
import 'package:app/models/models.dart';
import 'package:app/pages/work_time_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OopsScreen extends StatelessWidget {
  const OopsScreen({Key? key}) : super(key: key);

  static MaterialPage page() => const MaterialPage(
        key: ValueKey(OOPS_PATH),
        name: OOPS_PATH,
        child: OopsScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: WorkTimeInputWidget(),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MaterialButton(
            onPressed: () {
              Provider.of<UserManager>(context, listen: false).logout(
                  Provider.of<AppStateManager>(context, listen: false), true);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.power_settings_new_rounded),
                SizedBox(
                  width: 10,
                ),
                Text('Log Out'),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Pages {}
