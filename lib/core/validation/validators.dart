import 'package:flutter/material.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';

class Validators {
  static String? fullName(
    BuildContext context,
    String? value,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.fullNameRequired;
    }

    if (value.trim().length < 3) {
      return l10n.fullNameRequired;
    }

    return null;
  }

  static String? email(
    BuildContext context,
    String? value,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return l10n.errorInvalidEmail;
    }

    return null;
  }

  static String? password(
    BuildContext context,
    String? value,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.invalidPassword;
    }

    if (value.length < 8) {
      return l10n.errorInvalidPassword;
    }

    return null;
  }

  static String? confirmPassword(
    BuildContext context,
    String? value,
    String password,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.confirmPassword;
    }

    if (value != password) {
      return l10n.errorPasswordMismatch;
    }

    return null;
  }

  static String? phone(
    BuildContext context,
    String? value,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.phoneNumberRequired;
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return l10n.phoneNumber;
    }

    return null;
  }
}