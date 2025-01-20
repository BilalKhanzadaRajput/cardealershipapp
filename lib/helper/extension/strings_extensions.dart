import 'package:flutter/material.dart';
import '../constants/string_resources.dart';

extension TextFormFieldExtensions on String {
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return StringResources.VALIDATE_EMAIL_ERROR;
    } else if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
        .hasMatch(value)) {
      return StringResources.VALIDATE_EMAIL_FORMAT_ERROR;
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return StringResources.VALIDATE_PASSWORD_ERROR;
    } else if (value.length < 6) {
      return StringResources.VALIDATE_PASSWORD_LENGTH_ERROR;
    }
    return null;
  }

  String? validateNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIC cannot be empty';
    } else if (value.length != 13) {
      return 'NIC must be exactly 13 digits';
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'NIC must contain only numeric digits';
    }
    return null; // Return null if validation passes
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    } else if (value.length != 11) {
      return 'Phone number must be exactly 11 digits';
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number must contain only numeric digits';
    }
    return null; // Return null if validation passes
  }

  String? validateConfirmPassword(String value, {String? password}) {
    if (value.isEmpty) {
      return StringResources.VALIDATE_PASSWORD_ERROR;
    } else if (value.length < 6) {
      return StringResources.VALIDATE_PASSWORD_LENGTH_ERROR;
    } else if (password != null && value != password) {
      return StringResources.PASSWORD_MISMATCH_ERROR;
    }
    return null;
  }

  // New method to show the string as a Snackbar
  void showAsSnackbar(BuildContext context,
      {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(this),
        duration: duration,
      ),
    );
  }
}
