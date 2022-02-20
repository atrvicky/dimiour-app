import 'package:flutter/material.dart';

class CustomInputField {
  final String inputName;
  final TextEditingController textController;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final TextInputType keyboardType;
  final String labelText;
  final String nullErrorString;
  final String hasErrors;
  final String invalidInputString;
  final RegExp? validatorExpression;
  final ThemeData theme;
  final BuildContext context;
  final Function? onEditCallback;
  final bool autoFocus;
  final bool isPassword;

  bool isEnabled;
  bool isValid;

  CustomInputField({
    required this.inputName,
    required this.textController,
    required this.focusNode,
    required this.keyboardType,
    required this.labelText,
    required this.context,
    required this.theme,
    this.autoFocus = false,
    this.onEditCallback,
    this.isEnabled = true,
    this.isValid = true,
    this.isPassword = false,
    this.nullErrorString = 'Field cannot be empty',
    this.invalidInputString = 'Invalid input',
    this.hasErrors = '',
    this.validatorExpression,
    this.nextFocus,
  });

  String getText() => textController.text;
  bool isEmpty() => textController.text.isNotEmpty;
  bool isInputValid() => isValid;
  FocusNode getFocusNode() => focusNode;

  void setEnabled(bool enable) {
    isEnabled = enable;
  }

  void setText(String val) {
    textController.text = val;
  }

  void focus() {
    focusNode.requestFocus();
  }

  TextFormField buildField() => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textController,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isPassword,
        enabled: isEnabled,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
          ),
          labelText: labelText,
          labelStyle: theme.textTheme.caption,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onFieldSubmitted: (String value) {
          if (validatorExpression != null) {
            if (value.length > 2 && value.contains(validatorExpression!)) {
              FocusScope.of(context).requestFocus(nextFocus);
            }
          }
        },
        onChanged: (String value) {
          if (onEditCallback != null) onEditCallback!(value);
        },
        onSaved: (value) {},
        style: theme.textTheme.bodyText1,
      );
}
