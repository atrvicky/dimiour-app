import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String loaderText;

  const Loader({
    Key? key,
    required this.loaderText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 12.0,
          height: 12.0,
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            loaderText,
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }
}
